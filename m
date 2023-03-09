Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA8CC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Mar 2023 13:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjCINrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Mar 2023 08:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCINrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Mar 2023 08:47:25 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BB4DB4AC
        for <linux-xfs@vger.kernel.org>; Thu,  9 Mar 2023 05:47:23 -0800 (PST)
Received: from kwepemi500009.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PXVlf67C6zSkMs;
        Thu,  9 Mar 2023 21:44:14 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 9 Mar
 2023 21:47:20 +0800
Date:   Thu, 9 Mar 2023 22:10:30 +0800
From:   Long Li <leo.lilong@huawei.com>
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
CC:     <linux-xfs@vger.kernel.org>, <houtao1@huawei.com>,
        <yi.zhang@huawei.com>, <guoxuenan@huawei.com>
Subject: Re: [PATCH v2] xfs: fix hung when transaction commit fail in
 xfs_inactive_ifree
Message-ID: <20230309141030.GA2546427@ceph-admin>
References: <20230227062952.GA53788@ceph-admin>
 <Y/6k1kmxtLqKwq8o@magnolia>
 <20230301050135.GG360264@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230301050135.GG360264@dread.disaster.area>
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500009.china.huawei.com (7.221.188.199)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 01, 2023 at 04:01:35PM +1100, Dave Chinner wrote:
> On Tue, Feb 28, 2023 at 05:05:26PM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 27, 2023 at 02:29:52PM +0800, Long Li wrote:
> > > After running unplug disk test and unmount filesystem, the umount thread
> > > hung all the time.
> > > 
> > >  crash> dmesg
> > >  sd 0:0:0:0: rejecting I/O to offline device
> > >  XFS (sda): log I/O error -5
> > >  XFS (sda): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+0x12e0/0x1cf0
> > > 	(fs/xfs/libxfs/xfs_defer.c:504).  Shutting down filesystem.
> > >  XFS (sda): Please unmount the filesystem and rectify the problem(s)
> > >  XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -5
> > >  XFS (sda): Unmounting Filesystem
> > > 
> > >  crash> bt 3368
> > >  PID: 3368   TASK: ffff88801bcd8040  CPU: 3   COMMAND: "umount"
> > >   #0 [ffffc900086a7ae0] __schedule at ffffffff83d3fd25
> > >   #1 [ffffc900086a7be8] schedule at ffffffff83d414dd
> > >   #2 [ffffc900086a7c10] xfs_ail_push_all_sync at ffffffff8256db24
> > >   #3 [ffffc900086a7d18] xfs_unmount_flush_inodes at ffffffff824ee7e2
> > >   #4 [ffffc900086a7d28] xfs_unmountfs at ffffffff824f2eff
> > >   #5 [ffffc900086a7da8] xfs_fs_put_super at ffffffff82503e69
> > >   #6 [ffffc900086a7de8] generic_shutdown_super at ffffffff81aeb8cd
> > >   #7 [ffffc900086a7e10] kill_block_super at ffffffff81aefcfa
> > >   #8 [ffffc900086a7e30] deactivate_locked_super at ffffffff81aeb2da
> > >   #9 [ffffc900086a7e48] deactivate_super at ffffffff81aeb639
> > >  #10 [ffffc900086a7e68] cleanup_mnt at ffffffff81b6ddd5
> > >  #11 [ffffc900086a7ea0] __cleanup_mnt at ffffffff81b6dfdf
> > >  #12 [ffffc900086a7eb0] task_work_run at ffffffff8126e5cf
> > >  #13 [ffffc900086a7ef8] exit_to_user_mode_prepare at ffffffff813fa136
> > >  #14 [ffffc900086a7f28] syscall_exit_to_user_mode at ffffffff83d25dbb
> > >  #15 [ffffc900086a7f40] do_syscall_64 at ffffffff83d1f8d9
> > >  #16 [ffffc900086a7f50] entry_SYSCALL_64_after_hwframe at ffffffff83e00085
> > > 
> > > When we free a cluster buffer from xfs_ifree_cluster, all the inodes in
> > > cache are marked XFS_ISTALE. On journal commit dirty stale inodes as are
> > > handled by both buffer and inode log items, inodes marked as XFS_ISTALE
> > > in AIL will be removed from the AIL because the buffer log item will clean
> > > it. If the transaction commit fails in the xfs_inactive_ifree(), inodes
> > > marked as XFS_ISTALE will be left in AIL due to buf log item is not
> > > committed,
> > 
> > Ah.  So the inode log items *are* in the AIL, but the buffer log item
> > for the inode cluster buffer is /not/ in the AIL?
> 
> Which is the rare case, and I think can only happen if an unlinked
> file is held open until the unlinked list mods that last logged the
> buffer have been written to disk. We can keep modifying the inode
> and having it logged while the buffer is clean and has no active log
> item...
> 

Yes, buffer log item may be in the AIL, but it could be delete from AIL by
xfs_buf_item_release when transaction commit fail.
> 
> > Is it possible for neither inode nor cluster buffer are in the AIL?
> > I think the answer is no because freeing the inode will put it in the
> > AIL?
> 
> I think the answer is yes, because after an unlink the buffer log
> item should be in the AIL at the same LSN as the inode log item when
> the unlink transaction updated both of them. Pushing a dirty inode
> flush all the dirty inodes and so both the inode and buffer items
> get cleaned and removed from the AIL in the same IO completion.
> 
> Hence if the unlinked inode has been held open long enough for
> metadata writeback to complete, close() can trigger inactivation on
> both a clean inode cluster buffer and clean inode log item. i.e.
> neither are in the AIL at the time the inactivation and inode chunk
> freeing starts, and the commit has to insert both.
> 
> 
> > > @@ -679,6 +681,19 @@ xfs_buf_item_release(
> > >  	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> > >  	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> > >  
> > > +	/*
> > > +	 * If it is an inode buffer and item marked as stale, abort flushing
> > > +	 * inodes associated with the buf, prevent inode item left in AIL.
> > > +	 */
> > > +	if (aborted && (bip->bli_flags & XFS_BLI_STALE_INODE)) {
> > > +		list_for_each_entry_safe(lp, n, &bp->b_li_list, li_bio_list) {
> > > +			iip = (struct xfs_inode_log_item *)lp;
> > 
> > Use container_of(), not raw casting.
> > 
> > > +
> > > +			if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE))
> > > +				xfs_iflush_abort(iip->ili_inode);
> > > +		}
> > > +	}
> > > +
> 
> This is closer to the sort of fix that is needed, but this should
> not be done until the last reference to the buf log item goes away.
> i.e. in xfs_buf_item_put().
> 
Agree with you, Take a look at the other code, aborting stale inodes are
after last reference to the buf log item.

> But then I look at the same conditions in xfs_buf_item_unpin(),
> which is the normal path that runs this stale inode cleanup, it does
> this for stale buffers if it drops the last reference to the buf log
> item.
> 
>                 /*
>                  * If we get called here because of an IO error, we may or may
>                  * not have the item on the AIL. xfs_trans_ail_delete() will
>                  * take care of that situation. xfs_trans_ail_delete() drops
>                  * the AIL lock.
>                  */
>                 if (bip->bli_flags & XFS_BLI_STALE_INODE) {
>                         xfs_buf_item_done(bp);
>                         xfs_buf_inode_iodone(bp);
>                         ASSERT(list_empty(&bp->b_li_list));
>                 } else {
>                         xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
>                         xfs_buf_item_relse(bp);
>                         ASSERT(bp->b_log_item == NULL);
>                 }
> 		xfs_buf_relse(bp);
> 
> And if the buffer is not stale, then it runs it through
> xfs_buf_ioend_fail() to actually mark the attached log items as
> failed.
> 
> So it seems to me that the cleanup needed here is more complex than
> unconditionally aborting stale inodes, but I haven't had a chance to
> think it through fully yet. This is one of the more complex corners
> of the buffer/inode item life cycles, and it's been a source of
> shutdown issues for a long time....
> 
Sorry I replied so late, I tried to think a little clearer. The normal path
that runs stale inode cleanup in xfs_buf_item_unpin() just release buf log
item and aborting stale inodes, three will be no non-stale inode in the buf
b_li_list list because of buf lock, so I think it is enougth aborting stale
inodes. There may be something I haven't thought through, thanks for pointing
it out.

As you said, it is a complex corners of the buffer/inode item life cycles.
The problem [1] about inode log item UAF that I tried to solve previously,
it can't be solved simply due to inode log item life cycles, and I don't 
have a new solution yet.

[1] https://patchwork.kernel.org/project/xfs/patch/20230211022941.GA1515023@ceph-admin/

Thanks
Long Li
