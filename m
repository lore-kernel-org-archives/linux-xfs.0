Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38692 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725724AbeKHFAs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Nov 2018 00:00:48 -0500
Date: Wed, 7 Nov 2018 14:29:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC] xfs: save buffer offset when verifiers fail
Message-ID: <20181107192900.GB50224@bfoster>
References: <f2695097-0728-e525-43a5-d9f183ecba3e@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2695097-0728-e525-43a5-d9f183ecba3e@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 07, 2018 at 11:49:31AM -0600, Eric Sandeen wrote:
> I'd like to propose an addition to our current metadata verifier error reporting that I believe will allow us to more quickly identify, and more efficiently classify, metadata validation errors when they occur.
> 
> This is a long email, but:
> 
> tl;dr:
> 
> I'd like to add "detected in $TYPE offset $OFFSET" to our corruption messages.
> 
> "Metadata corruption detected in xfs_agfl offset 0x16 ..."  
> 
> This will allow us to more quickly triage classes of metadata corruption bugs.
> 
> 
> Longer rationale and proposals for implementation:
> 
> Today, we have corruption messages like:
> 
> XFS (dm-1): Metadata corruption detected at xfs_inode_buf_verify+0x6e/0xf0 [xfs], xfs_inode block 0x5a48d610
> XFS (dm-1): Unmount and run xfs_repair 
> XFS (dm-1): First 64 bytes of corrupted metadata buffer:
> ffff9cb8cc428000: dc 70 f3 22 07 71 ab 49 6c a6 5c 23 c9 b1 31 37  .p.".q.Il.\#..17
> ffff9cb8cc428010: 3f db 62 33 54 87 4d 7d 1e 09 cc 4b fb 2c b0 22  ?.b3T.M}...K.,."
> ffff9cb8cc428020: a9 54 91 1a 41 40 fe e1 16 7e 82 e1 56 b4 a8 9a  .T..A@...~..V...
> ffff9cb8cc428030: 29 67 de c0 75 01 75 77 3a 1b af 5a 60 1c 4c c7  )g..u.uw:..Z`.L.
> 
> which tell us the type (metadata or CRC error), the verifier that failed and the code offset within that verifier for the running kernel, the type of block (xfs_inode), and the block number on disk.
> We also get a hexdump of "a few" bytes of the buffer.
> 
> I see 2 areas where this falls short:
> 
> 1) The code location varies by kernel, so we don't get repeatable
>    messages for similar corruptions.
> 
> 2) The hexdump size is ~fixed, so it may not contain the erroneous
>    bytes of the buffer at all.
> 
> I propose that it would be useful to capture information about the offset within the buffer that failed the verifier, and add this information to the report, something like:
> 
> XFS (dm-1): Metadata corruption detected in xfs_inode offset 0x16 at xfs_inode_buf_verify+0x6e/0xf0 [xfs], block 0x5a48d610
> 
> I see this as useful for 3 reasons:
> 
> 1) It allows us to more quickly identify the location of the corruption,
>    without needing to obtain debug binaries and/or source for the kernel
>    which generated the report.  (While this is possible, finding a debug
>    binary and disassembling it just to identify which failure occurred
>    can be slow going).
> 

Agreed. I think there is definite value to reporting these errors in a
way that is more self contained than the current approach. I know we
discussed stringify'ing all of the checks originally, but that turned
into a bloated mess. Having to go off and build some different kernel to
decode the report is rather tedious. Though often times whatever
development kernel I have lying around will detect the same corruption
if a metadump is available.

> 2) It allows us to start to gather frequency of specific failures.  Today,
>    a search for "xfs_inode_buf_verify+0x6e/0xf0" will turn up hits only
>    for a specific kernel or range of kernels.  Searching instead for
>    "Metadata corruption detected in xfs_inode offset 0x16" would match
>    across all kernels, regardless of compiler, config, distro, etc.
>    This would greatly aid bug triage as time goes by.
> 
> 3) It would allow us to ensure that the hexdump actually contains the
>    region where the corruption was discovered.
> 

Yep, though I still think the "first 64 bytes" or whatever of a
particular buffer is useful to help establish sanity (i.e., is the magic
sane? is the whole buffer zeroed out? etc.).

> (NB: I am aware that there are some verifier tests which can't necessarily report a specific offset for the error.  This is fine.  Many/most tests can be related to a buffer offset.)
> 
> In concept, it is simple to do this - we add an "int b_error_offset;" or similar into struct xfs_buf, set the value in the verifiers, and add this info to the verifier failure message.
> 
> So, instead of i.e.
> 
>         if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
>                 return __this_address;
> 
> we could do:
> 
>         if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid)) {
>                 bp->b_error_offset = offsetof(struct agfl, agfl_uuid);
>                 return __this_address;
>         }
> 

Did we consider some kind of error context structure in the past? I
don't recall if there were unrelated issues with that, but that seems
slightly more elegant than an xfs_buf field. Otherwise, the high level
approach seems reasonable.

> If we hesitate to add ~2 more boilerplate lines to each of these individual tests, we could do something similar to the existing XFS_WANT_CORRUPTED_RETURN macro:
> 
>         if (!uuid_equal(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid))
>                 XFS_VERIFIER_FAIL_RETURN(struct xfs_agf, agf_uuid); 
> 
> which would populate bp->b_error_offset and return __this__address.
> 
> 
> This gets a little more involved when we have compound tests like:
> 
>         if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC) &&
>               XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)) &&
>               be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length) &&
>               be32_to_cpu(agf->agf_flfirst) < xfs_agfl_size(mp) &&
>               be32_to_cpu(agf->agf_fllast) < xfs_agfl_size(mp) &&
>               be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
>                 return __this_address;
> 
> but breaking them into individual tests wouldn't be too bad:
> 
>         if (!(agf->agf_magicnum == cpu_to_be32(XFS_AGF_MAGIC)))
>                 ...
>         if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
>                 ...
>         if (!(be32_to_cpu(agf->agf_freeblks) <= be32_to_cpu(agf->agf_length)))
>                 ...
> 

The above usage of a macro seems reasonable to me. It mostly just hides
repetitive error tracking cruft.

> We /could/ even go so far as to macrify tests like this, and do:
> 
>         XFS_VALIDATE_EQ(agf, agf_magicnum, XFS_AGF_MAGIC);
>         if (!XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)))
>                 XFS_VERIFIER_FAIL_RETURN(struct xfs_agf, agf_versionnum);
>         XFS_VALIDATE_EQ(agf, agf_versionnum, XFS_AGF_VERSION);
>         ...
> 

This one makes my eyes cross a bit. ;) Though I think it's because now I
have to wonder a bit about what each macro does. I wouldn't be against
something like this if we could condense it into something more generic
and straightforward. For example:

	XFS_VERIFY(agf->agf_magicnum == XFS_AGF_MAGIC,
		   offsetof(struct xfs_agf, agf_magicnum));
	XFS_VERIFY(XFS_AGF_GOOD_VERSION(be32_to_cpu(agf->agf_versionnum)),
		   offsetof(struct xfs_agf, agf_versionnum));
	...

I guess you'd need to stick the buffer or whatever stores the bad offset
value in there somewhere as well, but seeing the explicit logic makes
this easier to read than following it into a macro. Just my .02.

Brian

> but I know we get twitchy about macros, particularly those that hide returns.  OTOH,
> avoiding hundreds of lines of duplicated boiler plate code is kinda what macros are for....
> 
> I'm sending this RFC as prose rather than patch because it'd be a lot of lines of change,
> and I'd like to get a sense of what will or won't fly style-wise before I go do it.
> 
> I /really/ think that consistent message strings for similar corruption cases would have a lot of value.  Unless people strongly disagree with this goal, I guess my main question is how to go about saving the offset info in the verifiers - i.e. how much macro-fu would make people too freaked out.
> 
> Thanks,
> -Eric
