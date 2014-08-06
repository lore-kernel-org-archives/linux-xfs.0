Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B567E7F63
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 03:56:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2FC78F8035
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 01:56:28 -0700 (PDT)
Received: from mail-we0-f181.google.com (mail-we0-f181.google.com
	[74.125.82.181]) by cuda.sgi.com with ESMTP id w2VN4aD0cx55anXM
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Aug 2014 01:56:23 -0700 (PDT)
Received: by mail-we0-f181.google.com with SMTP id k48so2336065wev.12
	for <xfs@oss.sgi.com>; Wed, 06 Aug 2014 01:56:22 -0700 (PDT)
Message-ID: <9A75EE5EE1C3431EAB982257E1CBDC4D@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <20131226230018.GJ20579@dastard>	<A0A556BD24EC45CEADAA07870B3E6205@alyakaslap>	<20140113030230.GF3469@dastard>	<CAOcd+r0B-4SPjzim=68w3L8Y9FxwBD-C5HkkeO58C6t9nfgbhw@mail.gmail.com>	<20140113204314.GJ3469@dastard>	<CAOcd+r22FirPMHjdxQyTmXOAM72ND-t0=njK9nEmesSV5=Ec=Q@mail.gmail.com>	<20140115014503.GQ3469@dastard>	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>	<20140119231745.GF18112@dastard>	<4B2A412C75324EE9880358513C069476@alyakaslap>	<20140701215626.GE9508@dastard>
	<D8356F34DAF14CF5AC6D204541C261B3@alyakaslap>
	<53DFCDA4.9000605@sandeen.net>
In-Reply-To: <53DFCDA4.9000605@sandeen.net>
Subject: Re: xfs_growfs_data_private memory leak
Date: Wed, 6 Aug 2014 11:56:25 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Hi Eric,
What I was trying to achieve is to allow aborting XFS resize in the middle. 
I am not sure whether a typical user needs this feature, but for my use case 
it is needed.

So XFS resize is performed in two steps:
1) Initialize the newly-added AGs (AGFL, BNO btree, CNT btree etc)
2) Commit this by updating the primary superblock
3) Update all the existing secondary superblocks, and initialize all the 
newly-added secondary superblocks

So I added a custom IOCTL, which can tell this sequence to abort gracefully 
(just checking a flag on each loop iteration).

Aborting during step 1 works perfectly (apart from the memory leak that I 
discovered and fixed). Since the primary superblock has not been updated, 
XFS doesn't know about the newly-added AGs, so it doesn't care what's 
written there. Resize can be restarted, and XFS will redo this step from the 
beginning.
Aborting during step 3 can leave some of the secondary superblocks totally 
uninitialized. However, from XFS standpoint, the resize has been committed 
already. That's where my question came from. I realize that kernel can crash 
during step 3, leading to same results as with my code that aborts this 
step.

Anyways, since I was not sure about these secondary superblocks, I did not 
add an exit point at this step. (Again, realize that we can crash during 
this step anyways).

Thanks,
Alex.



-----Original Message----- 
From: Eric Sandeen
Sent: 04 August, 2014 9:15 PM
To: Alex Lyakas ; Dave Chinner
Cc: xfs@oss.sgi.com
Subject: Re: xfs_growfs_data_private memory leak

On 7/2/14, 7:27 AM, Alex Lyakas wrote:
> Hi Dave,
> Thank you for your comments.
>
> I realize that secondary superblocks are needed mostly for repairing

s/mostly/only/

> a broken filesystem. However, I don't see that they get updated
> regularly, i.e., during normal operation they don't seem to get
> updated at all. I put a print in xfs_sb_write_verify, and it gets
> called only with: bp->b_bn==XFS_SB_DADDR.

See the comments above verify_sb(): not everything is validated, so
not everything needs to be constantly updated.  It's just the basic
fs geometry, not counters, etc.

/*
* verify a superblock -- does not verify root inode #
*      can only check that geometry info is internally
*      consistent.  because of growfs, that's no guarantee
*      of correctness (e.g. geometry may have changed)
*
* fields verified or consistency checked:
*
*                      sb_magicnum
*
*                      sb_versionnum
*
*                      sb_inprogress
*
*                      sb_blocksize    (as a group)
*                      sb_blocklog
*
* geometry info -      sb_dblocks      (as a group)
*                      sb_agcount
*                      sb_agblocks
*                      sb_agblklog
*
* inode info -         sb_inodesize    (x-checked with geo info)
*                      sb_inopblock
*
* sector size info -
*                      sb_sectsize
*                      sb_sectlog
*                      sb_logsectsize
*                      sb_logsectlog
*
* not checked here -
*                      sb_rootino
*                      sb_fname
*                      sb_fpack
*                      sb_logstart
*                      sb_uuid
*
*                      ALL real-time fields
*                      final 4 summary counters
*/


> So do I understand correctly (also from comments in
> xfs_growfs_data_private), that it is safe to operate a filesystem
> while having broken secondary superblocks? For me, it appears to
> mount properly, and all the data seems to be there, but xfs_check
> complains like:

> bad sb magic # 0xc2a4baf2 in ag 6144
> bad sb version # 0x4b5d in ag 6144
> blocks 6144/65536..2192631388 out of range
> blocks 6144/65536..2192631388 claimed by block 6144/0
> bad sb magic # 0xb20f3079 in ag 6145
> bad sb version # 0x6505 in ag 6145
> blocks 6145/65536..3530010017 out of range
> blocks 6145/65536..3530010017 claimed by block 6145/0
> ...

some of that looks more serious than "just" bad backup sb's.
But the bad secondaries shouldn't cause runtime problems AFAIK.

> Also, if secondary superblocks do not get updated regularly, and
> there is no way to ask an operational XFS to update them, then during
> repair we may not find a good secondary superblock.

You seem to have 6144 (!) allocation groups; one would hope that a
majority of those supers would be "good" and the others will be
properly corrected by an xfs_repair.

> As for the patch, I cannot post a patch against the upstream kernel,
> because I am running an older kernel. Unfortunately, I cannot qualify
> an upstream patch properly in a reasonable time. Is there a value in
> posting a patch against 3.8.13? Otherwise, it's fine by me if
> somebody else posts it and takes the credit.

If the patch applies cleanly to both kernels, probably fine to
go ahead and post it, with that caveat.

-Eric

> Thanks,
> Alex.
>
>
>
> -----Original Message----- From: Dave Chinner
> Sent: 02 July, 2014 12:56 AM
> To: Alex Lyakas
> Cc: xfs@oss.sgi.com
> Subject: Re: xfs_growfs_data_private memory leak
>
> On Tue, Jul 01, 2014 at 06:06:38PM +0300, Alex Lyakas wrote:
>> Greetings,
>>
>> It appears that if xfs_growfs_data_private fails during the "new AG
>> headers" loop, it does not free all the per-AG structures for the
>> new AGs. When XFS is unmounted later, they are not freed as well,
>> because xfs_growfs_data_private did not update the "sb_agcount"
>> field, so xfs_free_perag will not free them. This happens on 3.8.13,
>> but looking at the latest master branch, it seems to have the same
>> issue.
>>
>> Code like [1] in xfs_growfs_data, seems to fix the issue.
>
> Why not just do this in the appropriate error stack, like is
> done inside xfs_initialize_perag() on error?
>
>        for (i = oagcount; i < nagcount; i++) {
>                pag = radix_tree_delete(&mp->m_perag_tree, index);
>                kmem_free(pag);
>        }
>
> (though it might need RCU freeing)
>
> When you have a fix, can you send a proper patch with a sign-off on
> it?
>
>> A follow-up question: if xfs_grows_data_private fails during the
>> loop that updates all the secondary superblocks, what is the
>> consequence? (I am aware that in the latest master branch, the loop
>> is not broken on first error, but attempts to initialize whatever
>> possible). When these secondary superblocks will get updated? Is
>> there a way to force-update them? Otherwise, what can be the
>> consequence of leaving them not updated?
>
> The consequence is documented in mainline tree - if we don't update
> them all, then repair will do the wrong thing.  Repair requires a
> majority iof identical secondaries to determine if the primary is
> correct or out of date. The old behaviour of not updating after the
> first error meant that the majority were old superblocks and so at
> some time in the future repair could decide your filesystem is
> smaller than it really is and hence truncate away the grown section
> of the filesystem. i.e. trigger catastrophic, unrecoverable data
> loss.
>
> Hence it's far better to write every seconday we can than to leave
> a majority in a bad state....
>
> Cheers,
>
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
