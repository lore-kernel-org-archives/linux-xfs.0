Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF660C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B65E360ED4
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 19:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhG1TEv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 15:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhG1TEv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 15:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8902360ED4;
        Wed, 28 Jul 2021 19:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627499089;
        bh=wjSVEnqChJbQ1Ra0px34gzO6gej0MAAG4VFXjl8PKNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RKIxZ+QdiYqds91knQq/si8PIQjdtu0hYq7CyPvVn1nHWvfaZ/hg8fwW2GrC0KAii
         4Vtl56ltqt5wzuTWIGyVTbtwTIjxeHcw24/0Z/qXW1LmSvXbCTKBeeNxSGXY6m1a+B
         iiP8l93h1BMSUpZE8WUxf/e7BJ82kUpxyASmF54We+zSUvAXBZy+FP+Y4N9GJbMmVs
         j0uJAddE9xU03Y2ioyY9Po3EpEi149FU53gdE+3obBKRcbNPDrLhn+Kx1DMtYuXSpT
         c2P671PbqLaBRiJLKsPVBEeWhnC+rpC3eDNaMGhHCsNoN6d+p7LJiJaQT/Au+cx4M6
         fQ5Jj+ZeUyfdA==
Date:   Wed, 28 Jul 2021 12:04:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 07/12] xfs: Rename inode's extent counter fields based
 on their width
Message-ID: <20210728190449.GA3601466@magnolia>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-8-chandanrlinux@gmail.com>
 <20210727225006.GR559212@magnolia>
 <877dhbvviw.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877dhbvviw.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 28, 2021 at 11:18:23AM +0530, Chandan Babu R wrote:
> On 28 Jul 2021 at 04:20, Darrick J. Wong wrote:
> > On Mon, Jul 26, 2021 at 05:15:36PM +0530, Chandan Babu R wrote:
> >> This commit renames extent counter fields in "struct xfs_dinode" and "struct
> >> xfs_log_dinode" based on the width of the fields. As of this commit, the
> >> 32-bit field will be used to count data fork extents and the 16-bit field will
> >> be used to count attr fork extents.
> >
> > I totally had the preconceived notion that you were going to make the
> > existing fields the 'lo' bits and then add six bytes of 'hi' field to
> > the ondisk inode for the space you need.
> >
> > Instead, I see that in the new scheme, the the space where di_anextents
> > is becomes unused, the space where di_nextents is now becomes the attr
> > fork extent count, and you allocate another 8 bytes at the end of the
> > ondisk inode for the data fork extent count.
> >
> 
> To be precise, the patch allocates 8 bytes for data fork extent counter from
> xfs_dinode->di_pad2[].

<Nod>

> > Hm.  That /is/ clever in that we don't have to split bits between
> 
> This method was originally suggested by Dave. Please see the discussion at
> https://lore.kernel.org/linux-xfs/20200903225145.GG12131@dread.disaster.area/.
> Also, I do agree with his suggestion since the space freed by the old 16-bit
> attr fork extent counter can be reused by a new feature.

Ah, ok, this was a direct request from Dave, who doesn't want us to
split fields in the inode core.  All right, that's a fair request (side
eye at still unfixed ext4 bit splitting timestamp mess).

I don't like the di_nextents{16,32,64} naming though -- that tells us
about the size of the field, which we already know from the type.
However, I don't know if tagged anonymous union structs are the answer?

	__be32		di_extsize;
	union {
		struct {
			/* classic data/attr extent counts */
			__be32	di_nextents;
			__be16	di_naextents;
		};
		struct {
			/* attr extents under NREXT64 */
			__be32	di_naextents_nr64;
			__be16	di_pad3;
		};
	};
	__u8		di_forkoff;
	...
	__be64		di_nextents_nr64;

This is nice in the sense that it makes reviewing code easier:

	if (xfs_sb_version_hasnrext64(mp))
		fubar = be64_to_cpu(dip->di_nextents_nr64);
	else
		fubar = be32_to_cpu(dip->di_nextents);

OTOH you've already done all the work to encapsulate this particular
detail for upper levels of XFS, which means that outside of
xfs_inode_buf.c everyone else will just do:

	fubar = xfs_dfork_nrextents(dip, XFS_DATA_FORK);

Yeah, ok.  I'm convinced this is acceptable.

> > fields, but the downside is that if you want to upgrade existing
> > filesystems, you'd either have to rewrite every inode in the entire
> > filesystem, or introduce a di_flags2 bit to signal that this inode
> > actually has the extended counters.  It also uses 8 bytes at the end of
> > the ondisk inode structure.
> 
> IMHO, I don't think it is possible to upgrade existing filesystems. Increasing
> per-inode extent counter values has the following cascading effect,
> 1. The maximum height of a BMBT tree increases.
> 2. Log reservation calculations which are a function of maximum BMBT height
>    will see an increase in their values.
> 3. This might cause log space on existing filesystem instances to be small
>    enough to make it impossible for new XFS driver to mount them.
> 
> Please correct me if my understanding is wrong.

It's possible to check the log size prior to upgrading the filesystem:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=upgrade-older-features

See the first parts of check_new_v5_geometry().

We have to decide now if the initial design for this feature should
include an inode flag to tell us how to switch on the fields, because
that's the critical piece needed to enable upgrading.

Do people care about the ability to upgrade to nrext64?  This isn't
quite like y2038 support where we have a hard requirement to upgrade
old filesystems.  Thoughts?  Anyone?

--D

> 
> >
> > I think if we adjust the design a little bit we can enable the upgrade
> > use case and reuse existing empty space in the ondisk inode.  Notice
> > that there are six bytes of di_pad available in the middle of the inode
> > record?  What do you think about putting the upper fields there?  The
> > middle of the struct then looks like this:
> >
> > 	__be32		di_nextentshi;	/* upper 32-bits of di_nextents */
> > 	__be16		di_naextentshi;	/* upper 16-bits of di_naextents */
> > 	__be16		di_flushiter;	/* incremented on flush */
> > 	xfs_timestamp_t	di_atime;	/* time last accessed */
> > 	xfs_timestamp_t	di_mtime;	/* time last modified */
> > 	xfs_timestamp_t	di_ctime;	/* time created/inode modified */
> > 	__be64		di_size;	/* number of bytes in file */
> > 	__be64		di_nblocks;	/* # of direct & btree blocks used */
> > 	__be32		di_extsize;	/* basic/minimum extent size for file */
> > 	__be32		di_nextentslo;	/* number of extents in data fork */
> > 	__be16		di_anextentslo;	/* number of extents in attribute fork*/
> >
> > And your xfs_dfork_extents function looks like:
> >
> > 	case XFS_DATA_FORK:
> > 		return (xfs_extnum_t)be32_to_cpu(dip->di_nextentshi) << 32 |
> > 				     be32_to_cpu(dip->di_nextentslo);
> > 	case XFS_ATTR_FORK:
> > 		return (xfs_extnum_t)be16_to_cpu(dip->di_naextentshi) << 16 |
> > 				     be16_to_cpu(dip->di_naextentslo);
> >
> > The pad fields are supposed to be zero, and upgrading now is no more
> > effort than tapping into the existing xfs_repair upgrader code to add
> > the EXTCOUNT64 feature flag.
> >
> > --D
> >
> >>
> >> This change is done to enable a future commit to introduce a new 64-bit extent
> >> counter field.
> >>
> >> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> >> ---
> >>  fs/xfs/libxfs/xfs_format.h      |  4 ++--
> >>  fs/xfs/libxfs/xfs_inode_buf.c   |  8 ++++----
> >>  fs/xfs/libxfs/xfs_log_format.h  |  4 ++--
> >>  fs/xfs/scrub/inode_repair.c     |  4 ++--
> >>  fs/xfs/scrub/trace.h            | 14 +++++++-------
> >>  fs/xfs/xfs_inode_item.c         |  4 ++--
> >>  fs/xfs/xfs_inode_item_recover.c |  8 ++++----
> >>  7 files changed, 23 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> >> index 001a4077a7c6..2362cc005cc6 100644
> >> --- a/fs/xfs/libxfs/xfs_format.h
> >> +++ b/fs/xfs/libxfs/xfs_format.h
> >> @@ -1039,8 +1039,8 @@ typedef struct xfs_dinode {
> >>  	__be64		di_size;	/* number of bytes in file */
> >>  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >>  	__be32		di_extsize;	/* basic/minimum extent size for file */
> >> -	__be32		di_nextents;	/* number of extents in data fork */
> >> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> >> +	__be32		di_nextents32;	/* number of extents in data fork */
> >> +	__be16		di_nextents16;	/* number of extents in attribute fork*/
> >>  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >>  	__s8		di_aformat;	/* format of attr fork's data */
> >>  	__be32		di_dmevmask;	/* DMIG event mask */
> >> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> >> index 9ed04da2e2b1..65d753e16007 100644
> >> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> >> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> >> @@ -313,8 +313,8 @@ xfs_inode_to_disk(
> >>  	to->di_size = cpu_to_be64(ip->i_disk_size);
> >>  	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
> >>  	to->di_extsize = cpu_to_be32(ip->i_extsize);
> >> -	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> >> -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> >> +	to->di_nextents32 = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
> >> +	to->di_nextents16 = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> >
> > /me wonders if these should get their own static inline conversion
> > helpers to set the appropriate fields, like I did for timestamps?
> >
> >>  	to->di_forkoff = ip->i_forkoff;
> >>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> >>  	to->di_flags = cpu_to_be16(ip->i_diflags);
> >> @@ -389,11 +389,11 @@ xfs_dfork_nextents(
> >>
> >>  	switch (whichfork) {
> >>  	case XFS_DATA_FORK:
> >> -		*nextents = be32_to_cpu(dip->di_nextents);
> >> +		*nextents = be32_to_cpu(dip->di_nextents32);
> >>  		break;
> >>
> >>  	case XFS_ATTR_FORK:
> >> -		*nextents = be16_to_cpu(dip->di_anextents);
> >> +		*nextents = be16_to_cpu(dip->di_nextents16);
> >>  		break;
> >>
> >>  	default:
> >> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> >> index 0c888f92184e..ca8e4ad8312a 100644
> >> --- a/fs/xfs/libxfs/xfs_log_format.h
> >> +++ b/fs/xfs/libxfs/xfs_log_format.h
> >> @@ -402,8 +402,8 @@ struct xfs_log_dinode {
> >>  	xfs_fsize_t	di_size;	/* number of bytes in file */
> >>  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
> >>  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> >> -	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
> >> -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> >> +	uint32_t	di_nextents32;	/* number of extents in data fork */
> >> +	uint16_t	di_nextents16;	/* number of extents in attribute fork*/
> >>  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >>  	int8_t		di_aformat;	/* format of attr fork's data */
> >>  	uint32_t	di_dmevmask;	/* DMIG event mask */
> >> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> >> index 521c8df00990..4d773a16f886 100644
> >> --- a/fs/xfs/scrub/inode_repair.c
> >> +++ b/fs/xfs/scrub/inode_repair.c
> >> @@ -736,7 +736,7 @@ xrep_dinode_zap_dfork(
> >>  {
> >>  	trace_xrep_dinode_zap_dfork(sc, dip);
> >>
> >> -	dip->di_nextents = 0;
> >> +	dip->di_nextents32 = 0;
> >>
> >>  	/* Special files always get reset to DEV */
> >>  	switch (mode & S_IFMT) {
> >> @@ -823,7 +823,7 @@ xrep_dinode_zap_afork(
> >>  	trace_xrep_dinode_zap_afork(sc, dip);
> >>
> >>  	dip->di_aformat = XFS_DINODE_FMT_EXTENTS;
> >> -	dip->di_anextents = 0;
> >> +	dip->di_nextents16 = 0;
> >>
> >>  	dip->di_forkoff = 0;
> >>  	dip->di_mode = cpu_to_be16(mode & ~0777);
> >> diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
> >> index fd03685b1f6b..a0303f692e52 100644
> >> --- a/fs/xfs/scrub/trace.h
> >> +++ b/fs/xfs/scrub/trace.h
> >> @@ -1209,8 +1209,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
> >>  		__field(uint64_t, size)
> >>  		__field(uint64_t, nblocks)
> >>  		__field(uint32_t, extsize)
> >> -		__field(uint32_t, nextents)
> >> -		__field(uint16_t, anextents)
> >> +		__field(uint32_t, nextents32)
> >> +		__field(uint16_t, nextents16)
> >>  		__field(uint8_t, forkoff)
> >>  		__field(uint8_t, aformat)
> >>  		__field(uint16_t, flags)
> >> @@ -1229,8 +1229,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
> >>  		__entry->size = be64_to_cpu(dip->di_size);
> >>  		__entry->nblocks = be64_to_cpu(dip->di_nblocks);
> >>  		__entry->extsize = be32_to_cpu(dip->di_extsize);
> >> -		__entry->nextents = be32_to_cpu(dip->di_nextents);
> >> -		__entry->anextents = be16_to_cpu(dip->di_anextents);
> >> +		__entry->nextents32 = be32_to_cpu(dip->di_nextents32);
> >> +		__entry->nextents16 = be16_to_cpu(dip->di_nextents16);
> >>  		__entry->forkoff = dip->di_forkoff;
> >>  		__entry->aformat = dip->di_aformat;
> >>  		__entry->flags = be16_to_cpu(dip->di_flags);
> >> @@ -1238,7 +1238,7 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
> >>  		__entry->flags2 = be64_to_cpu(dip->di_flags2);
> >>  		__entry->cowextsize = be32_to_cpu(dip->di_cowextsize);
> >>  	),
> >> -	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u size %llu nblocks %llu extsize %u nextents %u anextents %u forkoff %u aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
> >> +	TP_printk("dev %d:%d ino 0x%llx mode 0x%x version %u format %u uid %u gid %u size %llu nblocks %llu extsize %u nextents32 %u nextents16 %u forkoff %u aformat %u flags 0x%x gen 0x%x flags2 0x%llx cowextsize %u",
> >>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >>  		  __entry->ino,
> >>  		  __entry->mode,
> >> @@ -1249,8 +1249,8 @@ DECLARE_EVENT_CLASS(xrep_dinode_class,
> >>  		  __entry->size,
> >>  		  __entry->nblocks,
> >>  		  __entry->extsize,
> >> -		  __entry->nextents,
> >> -		  __entry->anextents,
> >> +		  __entry->nextents32,
> >> +		  __entry->nextents16,
> >>  		  __entry->forkoff,
> >>  		  __entry->aformat,
> >>  		  __entry->flags,
> >> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> >> index 35de30849fcc..f54ce7468ba1 100644
> >> --- a/fs/xfs/xfs_inode_item.c
> >> +++ b/fs/xfs/xfs_inode_item.c
> >> @@ -385,8 +385,8 @@ xfs_inode_to_log_dinode(
> >>  	to->di_size = ip->i_disk_size;
> >>  	to->di_nblocks = ip->i_nblocks;
> >>  	to->di_extsize = ip->i_extsize;
> >> -	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
> >> -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> >> +	to->di_nextents32 = xfs_ifork_nextents(&ip->i_df);
> >> +	to->di_nextents16 = xfs_ifork_nextents(ip->i_afp);
> >>  	to->di_forkoff = ip->i_forkoff;
> >>  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> >>  	to->di_flags = ip->i_diflags;
> >> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> >> index 7b79518b6c20..40af9d1265c7 100644
> >> --- a/fs/xfs/xfs_inode_item_recover.c
> >> +++ b/fs/xfs/xfs_inode_item_recover.c
> >> @@ -166,8 +166,8 @@ xfs_log_dinode_to_disk(
> >>  	to->di_size = cpu_to_be64(from->di_size);
> >>  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> >>  	to->di_extsize = cpu_to_be32(from->di_extsize);
> >> -	to->di_nextents = cpu_to_be32(from->di_nextents);
> >> -	to->di_anextents = cpu_to_be16(from->di_anextents);
> >> +	to->di_nextents32 = cpu_to_be32(from->di_nextents32);
> >> +	to->di_nextents16 = cpu_to_be16(from->di_nextents16);
> >>  	to->di_forkoff = from->di_forkoff;
> >>  	to->di_aformat = from->di_aformat;
> >>  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> >> @@ -332,7 +332,7 @@ xlog_recover_inode_commit_pass2(
> >>  			goto out_release;
> >>  		}
> >>  	}
> >> -	if (unlikely(ldip->di_nextents + ldip->di_anextents > ldip->di_nblocks)){
> >> +	if (unlikely(ldip->di_nextents32 + ldip->di_nextents16 > ldip->di_nblocks)) {
> >>  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> >>  				     XFS_ERRLEVEL_LOW, mp, ldip,
> >>  				     sizeof(*ldip));
> >> @@ -340,7 +340,7 @@ xlog_recover_inode_commit_pass2(
> >>  	"%s: Bad inode log record, rec ptr "PTR_FMT", dino ptr "PTR_FMT", "
> >>  	"dino bp "PTR_FMT", ino %Ld, total extents = %d, nblocks = %Ld",
> >>  			__func__, item, dip, bp, in_f->ilf_ino,
> >> -			ldip->di_nextents + ldip->di_anextents,
> >> +			ldip->di_nextents32 + ldip->di_nextents16,
> >>  			ldip->di_nblocks);
> >>  		error = -EFSCORRUPTED;
> >>  		goto out_release;
> >> --
> >> 2.30.2
> >>
> 
> 
> --
> chandan
