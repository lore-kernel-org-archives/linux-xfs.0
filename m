Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A0FAC77B7E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Jun 2023 08:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjFAIEM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Jun 2023 04:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbjFAIEJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 04:04:09 -0400
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE8C18F
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 01:04:06 -0700 (PDT)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QWzDL5Lsfz4f3lXk
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 16:04:02 +0800 (CST)
Received: from localhost (unknown [10.175.127.227])
        by APP4 (Coremail) with SMTP id gCh0CgAHcLPzUHhkgpC5Kg--.10748S3;
        Thu, 01 Jun 2023 16:04:03 +0800 (CST)
Date:   Thu, 1 Jun 2023 16:02:20 +0800
From:   Long Li <leo.lilong@huaweicloud.com>
To:     Dave Chinner <david@fromorbit.com>, Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, houtao1@huawei.com,
        yi.zhang@huawei.com, guoxuenan@huawei.com
Subject: Re: [PATCH] xfs: xfs_trans_cancel() path must check for log shutdown
Message-ID: <20230601080220.GC3861632@ceph-admin>
References: <20230524121121.GA4130562@ceph-admin>
 <ZG6wM/VjZb7wIOPC@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZG6wM/VjZb7wIOPC@dread.disaster.area>
X-CM-TRANSID: gCh0CgAHcLPzUHhkgpC5Kg--.10748S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFy8Jr1fKFy8WFWrZF15XFb_yoW3uF1rpF
        ZakrsrCr4ktF10yrn2yF48Ka4YyF18Aa1UJFy2gw1xXa15WF1jqryfKFW8tFyUWrsYvw42
        qr4DA3y0gw15ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUgCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6r1j6r18M7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
        0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
        6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
        CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF
        0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr
        1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsG
        vfC2KfnxnUUI43ZEXa7IU1sYFJUUUUU==
X-CM-SenderInfo: hohrhzxlor0w46kxt4xhlfz01xgou0bp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi, Dave

I realized there may be a problem with my email so you may not receive my
previous reply. So I'm replying to you with another email address, and if
you received my previous reply, you can ignore this email. Thank you very much!

On Thu, May 25, 2023 at 10:47:47AM +1000, Dave Chinner wrote:
> On Wed, May 24, 2023 at 08:11:21PM +0800, Long Li wrote:
> > The following error occurred when do IO fault injection test:
> > 
> > XFS: Assertion failed: xlog_is_shutdown(lip->li_log), file: fs/xfs/xfs_inode_item.c, line: 748
> 
> This line of code does not match to any assert in the current
> upstream code base. 
> 
> I'm assuming that the assert is this one:
> 
>  735                 /*
>  736                  * dgc: Not sure how this happens, but it happens very
>  737                  * occassionaly via generic/388.  xfs_iflush_abort() also
>  738                  * silently handles this same "under writeback but not in AIL at
>  739                  * shutdown" condition via xfs_trans_ail_delete().
>  740                  */
>  741                 if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
>  742  >>>>>>>                ASSERT(xlog_is_shutdown(lip->li_log));
>  743                         continue;
>  744                 }
> 
> Is that correct? I am going to assume that it is from this point
> onwards.

The problem is hard to reproduce, so I added some print and delay
which affects the function line number, so what you pointed out is
right. I will try to avoid these small mistakes.

> 
> Also, please include the full stack trace with the assert - the assert by
> itself does not give us any context about where the failure
> occurred, and the above code path can be run from several different
> contexts, especially when a shutdown is in progress.

The full stack trace information as fllows:

 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4368, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 4368, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/xfs_iomap.c, line 988, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/xfs_iomap.c, line 988, on filesystem "sda"
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 XFS (sda): User initiated shutdown received.
 XFS (sda): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 3887, on filesystem "sda"
 sda: writeback error on inode 524398, offset 3125248, sector 529448
 XFS: Assertion failed: xlog_is_shutdown(lip->li_log), file: fs/xfs/xfs_inode_item.c, line: 748
 ------------[ cut here ]------------
 kernel BUG at fs/xfs/xfs_message.c:102!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN
 CPU: 2 PID: 359 Comm: kworker/2:0 Tainted: G        W          6.4.0-rc2-next-20230516-dirty #139
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
 Workqueue: xfs-buf/sda xfs_buf_ioend_work
 RIP: 0010:assfail+0xa1/0xb0
 Code: 95 59 20 ff 83 e3 01 75 1c e8 8b 59 20 ff 0f 0b 5b 5d 41 5c 41 5d c3 48 c7 c7 30 47 be 8b e8 06
      37 6a ff eb ca e8 6f 59 20 ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 66 0f 1f 00 0f 1f 44
 RSP: 0018:ffff888015b57c80 EFLAGS: 00010293
 RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
 RDX: ffff8880139ad1c0 RSI: ffffffff822b6c51 RDI: ffffffff83e4d3e0
 RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed1002b6af27
 R10: ffffed1002b6af26 R11: ffff888015b57937 R12: ffffffff83e5b820
 R13: 00000000000002ec R14: ffff88801bede9ac R15: ffff88801bf7ab00
 FS:  0000000000000000(0000) GS:ffff88806bb00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007fadc8403020 CR3: 00000000252ac000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <TASK>
  xfs_buf_inode_iodone+0x656/0xf30
  xfs_buf_ioend+0x230/0x11a0
  process_one_work+0x6f9/0x1030
  worker_thread+0x58b/0xf60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x1f/0x30

> 
> > In commit 3c4cb76bce43 (xfs: xfs_trans_commit() path must check for log
> > shutdown) fix a problem that dirty transaction was canceled before log
> > shutdown, because of the log is still running, it result dirty and
> > unlogged inode item that isn't in the AIL in memory that can be flushed
> > to disk via writeback clustering.
> 
> Yes, but this was a race checking shutdown state before inserting the
> dirty item into the CIL, moving it from filesystem level context
> to log level context. i.e. it caused the object to be handled as
> valid instead of being aborted.
> 
> > xfs_trans_cancel() has the same problem, if a shut down races with
> > xfs_trans_cancel() and we have shut down the filesystem but not the log,
> > we will still cancel the transaction before log shutdown. So
> > xfs_trans_cancel() needs to check log state for shutdown, not mount.
> 
> Yet this is cancelling a transaction that has dirty objects that
> will be aborted. It is not the same context as the race fixed in
> 3c4cb76bce43, especially as the log item is marked as aborted as
> part of the transaction cancel. As this is operating at the
> filesytsem level, checking for filesystem level shutdown before
> issuing a filesystem level shutdown is appropriate - we're about to
> release items, not hand them off to the log.

Yes, I now understand that you are talking about filesystem level context
and log level context, this is the difference between transaction commit
and transaction cancel.

> 
> Transaction cancel this ends up in xfs_trans_free_items(abort =
> true) which sets XFS_LI_ABORTED then releases the log items.  This
> then calls xfs_inode_item_release() for inodes, which does nothing
> special with XFS_LI_ABORTED inode items, nor does it check for log
> shutdown.
> 
> I may be missing something obvious that hasn't been explained, but
> from the information provided I can't see how the above assert is
> related to not doing a log shutdown check in the transaction cancel
> path. Nothing in the transaction cancel path removes the inode item
> from the AIL, so it can't be responsible for the ASSERT firing...
> 
> However, looking at this abort path does point out that the code in
> xfs_inode_item_release() is probably wrong - it probably should check
> for XFS_LI_ABORTED and log shutdown and mark the inode as stale if
> it is dirty and then remove it from the AIL. In comparison, the
> buffer log item release method does these checks and removes the
> buffer log item from the AIL on abort/log shutdown, so I suspect
> that inodes log items should be doing something similar.

Yes, xfs_inode_item_release() does nothing with XFS_LI_ABORTED inode items.
So it will have the same result as 3c4cb76bce43. when filesystem is shutdown
but log is still running, after transaction cancel, dirty and unlogged inode
item that has been added to bp->b_li_list but isn't in the AIL, would be
flushed to disk via writeback clustering, it will trigger ASSERT above.

If check log shutdown in xfs_trans_cancel(), xfs_trans_free_items() called
must be latter than log shutdown,  dirty and unlogged inode item that isn't
in the AIL can not be flushed to disk via writeback clustering. As far as
context level you said above is concerned, check log shutdown is not a good
solution. As you said xfs_inode_item_release() may need to do more processing
with XFS_LI_ABORTED inode items.

Thanks,
Long Li

> 
> I also supsect that the AIL push (metadata writeback) should skip
> over aborted log items, too.
> 
> But none of these things explain to me how the change is in any way
> related to the assert I have assumed has fired. More information,
> please.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

