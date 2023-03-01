Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD4CC64EC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 05:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCAFC4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Mar 2023 00:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCAFC4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2023 00:02:56 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE68E10C7
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 21:02:51 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a9so2659446plh.11
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2023 21:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Jjz4alJ6NM57GF+4aqoxq7ybqT28U9oleLnOIUJxMYM=;
        b=AF5UIlnH1nCievNebFCDKTR6WhHxCF+OREptXR87L+k+I2yVB7RDNu9sSW4yaQ6Sx1
         biXaknJr5pcuwzLfJQpb8HQ27W9u416eUhNQHrtpxYv2prSGRYdOgAKLvNv7zHsaw/XG
         h7kdGVZsKpmQ+Bmhaaksksop2bhChjNuXouHGp/xWdVwwjhruzYYTpTlnT9FQa4laAy+
         ozC1axyrsEwG3L8l0Wf1/asWC6bWWt/4nfLitT3PThfw7HRPAaGC1NU5hvJnQlU/uXE2
         ihjTjfWficsFePeJ2iLwPvEVtZjcM6Qavus9pNYOWGMSD9BR7PJWwkYEhMclZx4IfN0q
         QX2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jjz4alJ6NM57GF+4aqoxq7ybqT28U9oleLnOIUJxMYM=;
        b=aTg1rBdVLeUXHDhnJOY3qyeZu8Tfcrha2F/0jCgI7q8zKe8a30qNhgEFpfSFdUqyzp
         SGovfj6myVSkD89HpTs2vDha/Lz+mDa9lO69bikvD7UIYagxNYbLfjJqrv/GQzyFzfaS
         rgvgK6sv213fvQ/Fxt/CXoE3t2wLZv7yDRvlWIc28xs2n8oi8pA96lML1dHCleG3ITWm
         QadvlCzj4BjsnQcQducGf8UX2A+ObIUkoivjOuuuHzV5XazihhvmwMuABENotwt281rV
         PS7HDby8Ki6P66Usx2ohNzGpa/Ovx0OCPAuU4a3Y+lTm4ieo004W4ISB0Ce65NSsRm3U
         V43Q==
X-Gm-Message-State: AO0yUKW3TzXrU7Lf7MnqB64rtSeSELcSPK31u2UG1aRBIAc+d1//iVAe
        xRElGgPsovtXaA1wi4mEA4VR5A==
X-Google-Smtp-Source: AK7set+5PpT/uP3joWkGRhRfFFhDoswNlaaSikDVoMY1tbQy1sXxgGft4w1fNM1TOuwAbE6VDklxWw==
X-Received: by 2002:a17:902:ec92:b0:19a:a9dd:ed3f with SMTP id x18-20020a170902ec9200b0019aa9dded3fmr5250929plg.49.1677646971416;
        Tue, 28 Feb 2023 21:02:51 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id ja15-20020a170902efcf00b0019ac7319ed1sm7372190plb.126.2023.02.28.21.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 21:02:27 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pXEat-003P0V-Gl; Wed, 01 Mar 2023 16:01:35 +1100
Date:   Wed, 1 Mar 2023 16:01:35 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org,
        houtao1@huawei.com, yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH v2] xfs: fix hung when transaction commit fail in
 xfs_inactive_ifree
Message-ID: <20230301050135.GG360264@dread.disaster.area>
References: <20230227062952.GA53788@ceph-admin>
 <Y/6k1kmxtLqKwq8o@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/6k1kmxtLqKwq8o@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 28, 2023 at 05:05:26PM -0800, Darrick J. Wong wrote:
> On Mon, Feb 27, 2023 at 02:29:52PM +0800, Long Li wrote:
> > After running unplug disk test and unmount filesystem, the umount thread
> > hung all the time.
> > 
> >  crash> dmesg
> >  sd 0:0:0:0: rejecting I/O to offline device
> >  XFS (sda): log I/O error -5
> >  XFS (sda): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+0x12e0/0x1cf0
> > 	(fs/xfs/libxfs/xfs_defer.c:504).  Shutting down filesystem.
> >  XFS (sda): Please unmount the filesystem and rectify the problem(s)
> >  XFS (sda): xfs_inactive_ifree: xfs_trans_commit returned error -5
> >  XFS (sda): Unmounting Filesystem
> > 
> >  crash> bt 3368
> >  PID: 3368   TASK: ffff88801bcd8040  CPU: 3   COMMAND: "umount"
> >   #0 [ffffc900086a7ae0] __schedule at ffffffff83d3fd25
> >   #1 [ffffc900086a7be8] schedule at ffffffff83d414dd
> >   #2 [ffffc900086a7c10] xfs_ail_push_all_sync at ffffffff8256db24
> >   #3 [ffffc900086a7d18] xfs_unmount_flush_inodes at ffffffff824ee7e2
> >   #4 [ffffc900086a7d28] xfs_unmountfs at ffffffff824f2eff
> >   #5 [ffffc900086a7da8] xfs_fs_put_super at ffffffff82503e69
> >   #6 [ffffc900086a7de8] generic_shutdown_super at ffffffff81aeb8cd
> >   #7 [ffffc900086a7e10] kill_block_super at ffffffff81aefcfa
> >   #8 [ffffc900086a7e30] deactivate_locked_super at ffffffff81aeb2da
> >   #9 [ffffc900086a7e48] deactivate_super at ffffffff81aeb639
> >  #10 [ffffc900086a7e68] cleanup_mnt at ffffffff81b6ddd5
> >  #11 [ffffc900086a7ea0] __cleanup_mnt at ffffffff81b6dfdf
> >  #12 [ffffc900086a7eb0] task_work_run at ffffffff8126e5cf
> >  #13 [ffffc900086a7ef8] exit_to_user_mode_prepare at ffffffff813fa136
> >  #14 [ffffc900086a7f28] syscall_exit_to_user_mode at ffffffff83d25dbb
> >  #15 [ffffc900086a7f40] do_syscall_64 at ffffffff83d1f8d9
> >  #16 [ffffc900086a7f50] entry_SYSCALL_64_after_hwframe at ffffffff83e00085
> > 
> > When we free a cluster buffer from xfs_ifree_cluster, all the inodes in
> > cache are marked XFS_ISTALE. On journal commit dirty stale inodes as are
> > handled by both buffer and inode log items, inodes marked as XFS_ISTALE
> > in AIL will be removed from the AIL because the buffer log item will clean
> > it. If the transaction commit fails in the xfs_inactive_ifree(), inodes
> > marked as XFS_ISTALE will be left in AIL due to buf log item is not
> > committed,
> 
> Ah.  So the inode log items *are* in the AIL, but the buffer log item
> for the inode cluster buffer is /not/ in the AIL?

Which is the rare case, and I think can only happen if an unlinked
file is held open until the unlinked list mods that last logged the
buffer have been written to disk. We can keep modifying the inode
and having it logged while the buffer is clean and has no active log
item...


> Is it possible for neither inode nor cluster buffer are in the AIL?
> I think the answer is no because freeing the inode will put it in the
> AIL?

I think the answer is yes, because after an unlink the buffer log
item should be in the AIL at the same LSN as the inode log item when
the unlink transaction updated both of them. Pushing a dirty inode
flush all the dirty inodes and so both the inode and buffer items
get cleaned and removed from the AIL in the same IO completion.

Hence if the unlinked inode has been held open long enough for
metadata writeback to complete, close() can trigger inactivation on
both a clean inode cluster buffer and clean inode log item. i.e.
neither are in the AIL at the time the inactivation and inode chunk
freeing starts, and the commit has to insert both.


> > @@ -679,6 +681,19 @@ xfs_buf_item_release(
> >  	       (ordered && dirty && !xfs_buf_item_dirty_format(bip)));
> >  	ASSERT(!stale || (bip->__bli_format.blf_flags & XFS_BLF_CANCEL));
> >  
> > +	/*
> > +	 * If it is an inode buffer and item marked as stale, abort flushing
> > +	 * inodes associated with the buf, prevent inode item left in AIL.
> > +	 */
> > +	if (aborted && (bip->bli_flags & XFS_BLI_STALE_INODE)) {
> > +		list_for_each_entry_safe(lp, n, &bp->b_li_list, li_bio_list) {
> > +			iip = (struct xfs_inode_log_item *)lp;
> 
> Use container_of(), not raw casting.
> 
> > +
> > +			if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE))
> > +				xfs_iflush_abort(iip->ili_inode);
> > +		}
> > +	}
> > +

This is closer to the sort of fix that is needed, but this should
not be done until the last reference to the buf log item goes away.
i.e. in xfs_buf_item_put().

But then I look at the same conditions in xfs_buf_item_unpin(),
which is the normal path that runs this stale inode cleanup, it does
this for stale buffers if it drops the last reference to the buf log
item.

                /*
                 * If we get called here because of an IO error, we may or may
                 * not have the item on the AIL. xfs_trans_ail_delete() will
                 * take care of that situation. xfs_trans_ail_delete() drops
                 * the AIL lock.
                 */
                if (bip->bli_flags & XFS_BLI_STALE_INODE) {
                        xfs_buf_item_done(bp);
                        xfs_buf_inode_iodone(bp);
                        ASSERT(list_empty(&bp->b_li_list));
                } else {
                        xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
                        xfs_buf_item_relse(bp);
                        ASSERT(bp->b_log_item == NULL);
                }
		xfs_buf_relse(bp);

And if the buffer is not stale, then it runs it through
xfs_buf_ioend_fail() to actually mark the attached log items as
failed.

So it seems to me that the cleanup needed here is more complex than
unconditionally aborting stale inodes, but I haven't had a chance to
think it through fully yet. This is one of the more complex corners
of the buffer/inode item life cycles, and it's been a source of
shutdown issues for a long time....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
