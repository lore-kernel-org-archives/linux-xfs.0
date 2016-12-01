Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753936AbcLAIsA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Dec 2016 03:48:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8E717AABE
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2016 08:47:58 +0000 (UTC)
Date: Thu, 1 Dec 2016 09:47:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: XFS blocking suspend
Message-ID: <20161201084757.GE12804@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I've got a report of xfs_aild blocking system suspend in 4.8.7 (in openSUSE
Tumbleweed which is our rolling distro):

Freezing of tasks failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
xfsaild/sdb3    D 0000000000019680     0 918      2 0x00000080
 ffff9e685409fb88 0000000000000000 ffff9e67beaea080 ffff9e68504c6000
 ffff9e6677226b80 ffff9e68540a0000 ffff9e676068c6d8 ffff9e68504c6000
 ffff9e685e48dc00 ffff9e676068c600 ffff9e685409fba0 ffffffffb66cfbac
Call Trace:
 [<ffffffffb66cfbac>] schedule+0x3c/0x90
 [<ffffffffb66d2f1e>] schedule_timeout+0x22e/0x410
 [<ffffffffb66d0f4a>] wait_for_completion+0x9a/0x100
 [<ffffffffc0f0689e>] xfs_buf_submit_wait+0x7e/0x250 [xfs]
 [<ffffffffc0f06ba8>] xfs_buf_read_map+0x108/0x190 [xfs]
 [<ffffffffc0f340c0>] xfs_trans_read_buf_map+0x100/0x370 [xfs]
 [<ffffffffc0ef631e>] xfs_imap_to_bp+0x5e/0xd0 [xfs]
 [<ffffffffc0f1ac6a>] xfs_iflush+0xca/0x220 [xfs]                                                                                        
 [<ffffffffc0f2b21b>] xfs_inode_item_push+0xcb/0x120 [xfs]
 [<ffffffffc0f32e8e>] xfsaild+0x30e/0x770 [xfs]
 [<ffffffffb609c5ed>] kthread+0xbd/0xe0
 [<ffffffffb66d459f>] ret_from_fork+0x1f/0x40
DWARF2 unwinder stuck at ret_from_fork+0x1f/0x40

Leftover inexact backtrace:
 [<ffffffffb609c530>] ?  kthread_worker_fn+0x170/0x170

What I think has happened is that b_ioend_wq got already frozen during
suspend and thus submitted read could not be completed (all buffer IO
completions seem to be happening from workqueue now if I'm reading the code
right) and thus xfs_aild never finished waiting for IO so that it could be
frozen in try_to_freeze().

I'm not sure how to best fix this since I don't think we can easily have
suspend dependencies between different execution contexts... We could
possibly complete buffer IO already from softirq (which should also reduce
IO latency somewhat) if it does not have ->iodone callback but maybe there's
some problem with it I'm missing.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
