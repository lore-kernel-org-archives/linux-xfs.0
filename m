Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KCrt60020938 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 07:53:55 -0500
Subject: Re: [PATCH] xfs:negative_icount.patch
Mime-Version: 1.0 (Apple Message framework v1081)
From: Stuart Brodsky <sbrodsky@sgi.com>
In-Reply-To: <20100719231150.GE32635@dastard>
Date: Tue, 20 Jul 2010 07:56:50 -0500
Message-Id: <BA25A2BF-1F48-4AF5-A895-4BDAE40425D6@sgi.com>
References: <1279306421.17689.38.camel@superior.americas.sgi.com>
	<20100719001403.GC23223@dastard>
	<ECC25D18-BB9D-4EC7-A73C-139A688CE1C2@sgi.com>
	<20100719231150.GE32635@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>

Thanks for the feedback.  I will have an updated patch shortly.  There is a slight problem in that f_ffree is an unsigned 64 so that it does not see something going negative but that is easy to work around.  I'll send out the tested patch in a bit.

Thanks,

---
Stuart Brodsky
2750 Blue Water Road
Eagan, MN. 55121
651-683-7910
sbrodsky@sgi.com




On Jul 19, 2010, at 6:11 PM, Dave Chinner wrote:

> Hi Stuart, 
> 
> A couple of minor list-etiquette comments first:
> 
> 	- please don't top post when replying as it makes it
> 	  really hard to understand what you are replying to
> 	  because there is no context to your reply.
> 
> 	- don't remove the mailing list from the CC list while
> 	  discussing a patch as there are plenty more people than
> 	  just the person who sent the email that might want to put
> 	  their 2c worth in...
> 
> I've rearranged your reply and re-added the mailing list to the CC
> list....
> 
> On Mon, Jul 19, 2010 at 07:11:55AM -0500, Stuart Brodsky wrote:
>> On Jul 18, 2010, at 7:14 PM, Dave Chinner wrote:
>>> On Fri, Jul 16, 2010 at 01:53:41PM -0500, Stuart Brodsky wrote:
>>>> This patch fixes the stat -f icount field going negative.  The use of
>>>> lazy counts means that the super block field sb_icount is not updated
>>>> correctly and will allow over allocation of inodes above maxicount.
> .....
>>>> Index: a/fs/xfs/xfs_trans.c
>>>> ===================================================================
>>>> --- a/fs/xfs/xfs_trans.c.orig	2010-07-16 10:12:02.000000000 -0500
>>>> +++ b/fs/xfs/xfs_trans.c	2010-07-16 10:22:47.690249548 -0500
>>>> @@ -805,6 +805,7 @@
>>>> 	switch (field) {
>>>> 	case XFS_TRANS_SB_ICOUNT:
>>>> 		tp->t_icount_delta += delta;
>>>> +		atomic64_add(delta,&tp->t_mountp->m_inodesinuse);
>>>> 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
>>>> 			flags &= ~XFS_TRANS_SB_DIRTY;
>>>> 		break;
>>> 
>>> This is still racy. It may fix your specific reproducer but I can't see how
>>> changing the in use inode count from late in xfs_trans_commit() to early in
>>> xfs_trans_commit() solves the problem: if we look at it
>>> like this:
> ....
>>> Realistically, there is nothing wrong with XFS exceeding mp->m_maxicount by a
>>> small amount - it's just an arbitrary limit that we use to prevent all the
>>> filesytem space from being taken up by inodes.  I think the problem is just a
>>> reporting problem here in xfs_fs_statfs():
>>> 
>>> 1245         fakeinos = statp->f_bfree << sbp->sb_inopblog;
>>> 1246         statp->f_files =
>>> 1247             MIN(sbp->sb_icount + fakeinos, (__uint64_t)XFS_MAXINUMBER);
>>> 1248         if (mp->m_maxicount)
>>> 1249                 statp->f_files = min_t(typeof(statp->f_files),
>>> 1250                                         statp->f_files,
>>> 1251                                         mp->m_maxicount);
>>> 1252         statp->f_ffree = statp->f_files - (sbp->sb_icount - sbp->sb_ifree);
>>> 
>>> Assume no free space and no free inodes (statp->f_bfree = 0, => fakeinos = 0),
>>> and we have just hit the above race condition to allocate more inodes than
>>> mp->m_maxicount. Hence we have sbp->sb_icount > mp->m_maxicount and that gives:
>>> 
>>> 	statp->f_files = min(sbp->sb_icount, mp->m_maxicount);
>>> 	statp->f_files = mp->m_maxicount;
>>> 
>>> And now we've allocated all the free inodes (sbp->sb_ifree = 0). Therefore:
>>> 
>>> 	statp->f_ffree = mp->m_maxicount - (sbp->sb_icount - 0)
>>> 
>>> Which gives statp->f_ffree < 0 and hence negative free inodes. I think
>>> all that is required to "fix" this is to clamp statp->f_ffree to zero.
>>> i.e.:
>>> 
>>> 	if (statp->f_ffree < 0)
>>> 		statp->f_ffree = 0;
>>> 
>>> Make sense?
>> 
>> I agree that if we are willing to accept the fact that the actual
>> number of inodes allocated can be over maxicount then your fix is
>> correct in just clamping the f_ffree to 0.
> 
> Given that it already exceeds maxicount (and has for years ;) and
> nothing breaks except for the stats, I don't see any problem
> here. It seems much more complex to do anythign accurate and AFAICT
> it is not necessary to be absolutely accurate.
> 
> Anyway, we have to allow the allocated inode count to exceed
> maxicount as you can use growfs to reduce the allowed inode
> percentage in the filesystem. Hence if we are near maxicount
> allocated inodes and we reduce the max inode percentage then the
> allocated inode count will exceed maxicount. In that case, we really
> do need to report zero free inodes, not some negative number....
> 
>> I just don't like
>> using a counter that has the potential to be out of date any where
>> in the code.
> 
> I'm not sure I follow you - nothing gets out of date AFAICT.
> 
>> In this case as you suggest being over maxicount is
>> not the end of the world.  We will report ENOSPC a bit later but
>> we still will detect it.
> 
> We still report ENOSPC at exactly the same time as we do now.
> Nothing there changes, only the information going to userspace is
> sanitised.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
