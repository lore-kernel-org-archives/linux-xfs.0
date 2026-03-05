Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877F28F935;
	Thu,  5 Mar 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.155.198.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772735299; cv=none; b=KZQ28Pi4Jr++Xk4/htzLXV69jU9Uhhc1IU487oUj9NkAc0WoFGtX2q77rjt13Q5haQnKn1vQvmAIHavPtUH4HlvkcQnZKgSJduh5UWdX48O/t8jPeoC5i/AvuAO9pST0FouO/sfHy9GKtmpomYbkQ78Gx4vBfZVNhqz1MoZmIQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772735299; c=relaxed/simple;
	bh=Zc1JD/vQ3eBmwbhZoiTJR7kJBcHq+H3ZIfIzqBH3hnc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=daoFUKhcDkudx7BjWkQTm2wlsVCVP6+lcpt2fC29NsV3BbmFBhI1Thb5w80303hAKpMmJM1f9h5I+qxBCsFGka91i8eaRjHII/2vZn8hZ3U1eDXXM7SbT82shJeABGA3DYtWQEiuP984taFwK9bbPKdpjRNM+5FKVDj6Y5lVf9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=MaalXT71; arc=none smtp.client-ip=35.155.198.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="MaalXT71"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772735297; x=1804271297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bfAciVkMwFRmjXk+lUnT6lw/SAW9jquv86dB4jo7vEg=;
  b=MaalXT71Gr/NsJyiQIq7V43qmLewXUO4VZcZpd5AF7HQb4DzAIkPiFYX
   1cK+dKvSdN40RJXt3dMxaLO1eDRvpMJYfjxv3GchZhOAHceJehpjgOj3P
   zN4+1/Go7WOR+Zo5jFTiIJvIIe7c1IGp+lBDokD78TghBHvlxWSfdtcI1
   AIGTxZJFF+C91dW7wDJnt6Dx01/J0mDVm54RuDHjL91Iu1kVh29mvbN6A
   C1hoyKjluLob7Jxdl9T0s1EZwlAHmHWLqV8TzFyFEewrrTMT0EKblxziX
   SIZQZTsdj7jpDfX1Y5AwHr3VU9sSK8zjKQ2lMx2R8QwVJxcN7Z+sGMPXa
   A==;
X-CSE-ConnectionGUID: jAnXqq9SSeqUgYS+AhSkGQ==
X-CSE-MsgGUID: 8O5vTNhCReW6QxcdFv5YSw==
X-IronPort-AV: E=Sophos;i="6.23,103,1770595200"; 
   d="scan'208";a="14288302"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 18:28:15 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:5755]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.3:2525] with esmtp (Farcaster)
 id 5c930534-db54-45d9-b4ec-b2eed9cffdf8; Thu, 5 Mar 2026 18:28:14 +0000 (UTC)
X-Farcaster-Flow-ID: 5c930534-db54-45d9-b4ec-b2eed9cffdf8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 5 Mar 2026 18:28:14 +0000
Received: from c889f3b07a0a.amazon.com (10.106.82.26) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Thu, 5 Mar 2026 18:28:12 +0000
From: Yuto Ohnuki <ytohnuki@amazon.com>
To: <dgc@kernel.org>
CC: <bfoster@redhat.com>, <cem@kernel.org>, <darrick.wong@oracle.com>,
	<dchinner@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>,
	<syzbot+652af2b3c5569c4ab63c@syzkaller.appspotmail.com>,
	<ytohnuki@amazon.com>
Subject: Re: Re: [PATCH] xfs: fix use-after-free in xfs_inode_item_push()
Date: Thu, 5 Mar 2026 18:28:06 +0000
Message-ID: <20260305182805.47304-2-ytohnuki@amazon.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <aai66aCvGC66P8cN@dread>
References: <aai66aCvGC66P8cN@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D041UWA004.ant.amazon.com (10.13.139.9) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> How? You state this can happen, but then don't explain how this
> occurs. i.e. the commit message just describes the UAF failure and
> the fix in the code rahter than how the failure occurs in the first
> place.
> 
> IOWs, I have to spend a bunch of my time reverse engineering the bug
> report to understand exactly how this UAF occurs, because it
> certainly doesn't happen in normal operation.
> 
> i.e in normal operation, either (or both) the IFLUSHING lock is held
> on the inode, or the inode is attached to and referenced by the
> inode cluster buffer.
> 
> xfs_reclaim_inode() explicitly takes IFLUSHING and checks the inode
> is clean (i.e. not attached to the cluster buffer) before starting
> the process of freeing it.
> 
> IOWs, the inode cannot be reclaimed until it is unlocked and removed
> from the inode cluster buffer, and this happens during inode cluster
> buffer IO completion in normal operation whilst the buffer is still
> locked.
> 
> The only way that we can do anything differently in reclaim is if we
> are in shutdown conditions. In which case reclaim locks the inode
> and calls xfs_iflush_shutdown_abort(). This locks the buffer, then
> removes the inode from the buffer, the AIL and clears the IFLUSHING
> state, then allows indoe reclaim to continue.
> 
> Omitted from the sysbot traces is this:
> 
> [ 1161.203695][T20859] XFS (loop6): metadata I/O error in "xfs_btree_read_buf_block+0x2b0/0x490" at daddr 0x4 len 4 error 74
> [ 1161.254510][T20859] XFS (loop6): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x518/0x950 (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
> [ 1161.254574][T20859] XFS (loop6): Please unmount the filesystem and rectify the problem(s)
> [ 1162.085767][T19986] XFS (loop6): Unmounting Filesystem 9f91832a-3b79-45c3-9d6d-ed0bc7357fe4
> [ 1162.203508][T20924] ==================================================================
> [ 1162.203522][T20924] BUG: KASAN: slab-use-after-free in xfs_inode_item_push+0x396/0x720
> [ 1162.203550][T20924] Read of size 8 at addr ffff88805e822ae8 by task xfsaild/loop6/20924
> 
> The filesystem is indeed in a shutdown state and is being unmounted.
> However, the AIL is still running, which means unmount hasn't yet
> got to reclaiming inodes - the AIL is flushed and emptied before
> that happens. Hence this must be a race between background inode
> reclaim and the xfsaild. Interestingly, some of the failures are on
> quota inodes, which get released in unmount moments before we call
> xfs_unmount_flush_inodes(). This implies unmount triggered the AIL
> to run and is waiting in xfs_ail_push_all_sync() for all dirty
> inodes to be removed from the AIL.
> 
> IOWs, the reason this race condition occurred is that unmount has
> triggered the AIL to push -and fail- all the dirty inodes in the
> system at the same time that background reclaim is trying to -fail
> and reclaim- all the dirty inodes.
> 
> There's the underlying root cause of the race condition that is
> resulting in the UAF bug being exposed - the unmount code
> is allowing background inode reclaim to remove dirty inodes from the
> AIL whilst it is explicitly pushing dirty inodes and failing them to
> remove them from the AIL.
> 
> Indeed, xfs_unmount_flush_inodes() does:
> 
>         xfs_ail_push_all_sync(mp->m_ail);
>         xfs_inodegc_stop(mp);
>         cancel_delayed_work_sync(&mp->m_reclaim_work);
>         xfs_reclaim_inodes(mp);
> 
> IOWs, it pushes the entire AIL to fail everything on it and waits
> for that to complete, then stops inodegc, then is
> stops background reclaim work, then it reclaims all the remaining
> inodes.
> 
> Honestly, that looks broken. If there are inodes queued for GC, then
> they can be dirtied and inserted into the AIL as part of the inodegc
> queue flush. This is unlikely if the filesystem is shut down, but
> it could happen in normal operation. We also don't need background
> inode reclaim running here, because we are about to run a blocking
> inode reclaim pass, too.
> 
> Hence If we change this like so:
> 
> +        cancel_delayed_work_sync(&mp->m_reclaim_work);
> +        xfs_inodegc_stop(mp);
>          xfs_ail_push_all_sync(mp->m_ail);
> -        xfs_inodegc_stop(mp);
> -        cancel_delayed_work_sync(&mp->m_reclaim_work);
>          xfs_reclaim_inodes(mp);
> 
> We no longer have a vector for adding inodes to the AIL after it has
> been flushed, and we will not have two background threads both
> racing to abort/fail/free dirty inodes during unmount. I think this
> needs to be done for correctness of unmount, regardless of the fact
> it exposes a UAF issues elsewhere in the code.
> 
> Ok, so that's one problem, but how is background inode reclaim and
> inode item pushing racing to create a UAF situation?
> 
> Again, I think that's a shutdown related issue. xfs_iflush_cluster()
> does:
> 
>                /*
>                  * Abort flushing this inode if we are shut down because the
>                  * inode may not currently be in the AIL. This can occur when
>                  * log I/O failure unpins the inode without inserting into the
>                  * AIL, leaving a dirty/unpinned inode attached to the buffer
>                  * that otherwise looks like it should be flushed.
>                  */
>                 if (xlog_is_shutdown(mp->m_log)) {
>                         xfs_iunpin_wait(ip);
>                         xfs_iflush_abort(ip);
>                         xfs_iunlock(ip, XFS_ILOCK_SHARED);
>                         error = -EIO;
>                         continue;
>                 }
> ......
>         if (error) {
>                 /*
>                  * Shutdown first so we kill the log before we release this
>                  * buffer. If it is an INODE_ALLOC buffer and pins the tail
>                  * of the log, failing it before the _log_ is shut down can
>                  * result in the log tail being moved forward in the journal
>                  * on disk because log writes can still be taking place. Hence
>                  * unpinning the tail will allow the ICREATE intent to be
>                  * removed from the log an recovery will fail with uninitialised
>                  * inode cluster buffers.
>                  */
>                 xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
>                 bp->b_flags |= XBF_ASYNC;
>                 xfs_buf_ioend_fail(bp);
>                 return error;
>         }
> 
> The first hunk results in individual inodes being aborted, marked
> clean and removed from the AIL. This then allows reclaim to lock
> them and call xfs_iflush_shutdown_abort() on them, which then
> serialises on the buffer lock.
> 
> The second hunk is where the buffer lock gets dropped. This runs IO
> completion to abort any inodes that were previously marked IFLUSHING
> and so skipped by the first hunk. This will result in them being
> marked clean and removed from the AIL, hence also allowing reclaim
> to lock and abort them.
> 
> At this point in xfs_buf_ioend_fail(), the buffer is then unlocked
> and any pending inode reclaim will now make progress. For a UAF to
> then occur a few lines of code later in xfs_inode_item_push() on the
> log item, the xfsaild() -must- be preempted and not rescheduled
> until the inode reclaim has done all it's work (which is quite a
> lot, with lots of locking involved) and then have the rcu grace
> period expire and have all the RCU callbacks run to free the inode
> before it gets scheduled again to relock the AIL....
> 
> So, yes, we need to handle this case in xfs_inode_item_push().
> 
> More importantly:
> 
> Now I understand why the UAF occurs, it becomes obvious that
> xfs_dquot_item_push() has the same log item UAF bug in it, too. the
> path to it is slightly more convolutedi and does not involve RCU
> freeing at all. i.e. dquots can be reclaimed asynchronously via a
> memory pressure driven shrinker, so if xfsaild can be preempted for
> long periods of time, the same race window exists where a flushed
> dquot can be marked clean, reclaimed and freed before the AIL lock
> is regained.
> 
> > This results in a use-after-free when the function reacquires the AIL
> > lock by dereferencing the freed log item's li_ailp pointer at offset 48.
> > 
> > Fix this by saving the ailp pointer in a local variable while the AIL
> > lock is held and the log item is guaranteed to be valid.
> > 
> > Also move trace_xfs_ail_push() before xfsaild_push_item() because the
> > log item may be freed during the push.
> 
> That will simply create lots of unnecessary noise in AIL
> tracing. We do not want "push" traces on every item, we only want
> them on the items that returned XFS_ITEM_SUCCESS. We have other
> trace points for different return values, too, and they are often
> much noisier than XFS_ITEM_SUCESS. e.g. inode cluster flushing can
> have a 30:1 ratio of XFS_ITEM_FLUSHING to XFS_INODE_SUCCESS - we do
> not want a "push" trace for every "flushing" trace, as that will
> massively increase the number of traces emitted by this code.
> 
> Also, because I know understand how the race condition occurs, I can
> state that the UAF doesn't just occur when XFS_ITEM_SUCCESS is
> returned. The UAF is most likely to occur when the buffer is failed
> because xfs_iflush_cluster() returns -EIO, which results in
> XFS_ITEM_LOCKED being returned.
> 
> In that case, we run:
> 
>                 case XFS_ITEM_LOCKED:
>                         XFS_STATS_INC(mp, xs_push_ail_locked);
> >>>>>>>>                trace_xfs_ail_locked(lip);
> 
>                         stuck++;
>                         break;
> 
> See the problem?
> 
> If we cannot rely on the the log item being valid after
> xfsaild_push_item() is called in shutdown conditions due to
> pre-emption, then we cannot rely on it being valid for any of
> the code we run after that call. Hence there are more issues than
> just movign a tracepoint.
> 
> The tracepoints will need to be modified to take individual values,
> which will need to be stored in temporary variables before
> xfsaild_push_item() is called.
> 
> Comments need to be added to xfsaild_push_item() to indicate that
> after ->iop_push is called, the log item may be invalid.
> 
> Comments need to be added to xfsaild_push() at the
> xfsaild_push_item() call site that the log item cannot be referenced
> after this call as it may already be free on return.
> 
> Comments need to be added to xfs_inode_item_push() and
> xfs_dquot_item_push() indicating the exact line of code where we can
> no longer reference the log item because it may have been freed.
> 
> And the unmount inode flushing operation ordering also needs to be
> fixed...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dgc@kernel.org

Hi Dave,

Thank you for the detailed analysis and comprehensive feedback on this
patch. Your explanation of the race condition mechanism and the
additional issues you identified (dquot_item_push, unmount ordering,
and all switch case tracepoints) were extremely helpful.

I've prepared a v2 patch that addresses all the points you raised:

- Fixed the unmount ordering in xfs_unmount_flush_inodes()
- Added ailp local variables to both xfs_inode_item_push() and
  xfs_dquot_item_push()
- Modified all 4 tracepoints in the switch statement to avoid
  dereferencing the log item after xfsaild_push_item() returns
- Introduced a new xfs_ail_push_class to preserve compatibility with
  existing tracepoints
- Added comments documenting where log items must not be referenced

I've also updated the commit message to provide a more detailed
explanation of how the UAF occurs, as you commented.

I'll send the v2 patch shortly.

Thanks again for taking the time to review this thoroughly.

Best regards,
Yuto



Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284

Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705



