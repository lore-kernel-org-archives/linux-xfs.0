Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E45EFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C283361209
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 00:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbhIQAtv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 20:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232111AbhIQAtv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 20:49:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31CF7611C8;
        Fri, 17 Sep 2021 00:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631839710;
        bh=HxJw6vOW5k2FFFL10OyVeCgu2mw6w08nOXbqpgFz3FM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQv99HZT0ikpMoP+A5Ly8TWvHxpY3gTL046g5NPj0zgX+ozy/s9gR4HAtr/HcqXCW
         gzXFV5ntSy/Nmdw9iXXpNbgRMrdTazAjv4JRfRASujpalHyRiSIC8CFsAgfHHJSSPS
         fJxD18zuQ4sScUDHpcBRze5Q0/SkyrhaOb1waRngflaxeeYdV+5dwrHeE3MYNeibn4
         YeO4PdXPmsVbviBoRLkGOG0L1zHSTFE3MgiwkvNfyYPfKsDTY4Lk5C28iLUf47KomO
         GWU5VWrZe83epT0M8FGdkqi+MM9wABmSvzsr/EMYWpHB4ruAHzt38x7qtcNuHnRWgq
         z+7kcdKiKzHYw==
Date:   Thu, 16 Sep 2021 17:48:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        osandov@fb.com
Subject: [PATCH 2/1] common/rc: use directio mode for the loop device when
 possible
Message-ID: <20210917004829.GD34874@magnolia>
References: <163174932046.379383.10637812567210248503.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174932046.379383.10637812567210248503.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Recently, I've been observing very high runtimes of tests that format a
filesystem atop a loop device and write enough data to fill memory, such
as generic/590 and generic/361.  Logging into the test VMs, I noticed
that the writes to the file on the upper filesystem started fast, but
soon slowed down to about 500KB/s and stayed that way for nearly 20
minutes.  Looking through the D-state processes on the system revealed:

/proc/4350/comm = xfs_io
/proc/4350/stack : [<0>] balance_dirty_pages+0x332/0xda0
[<0>] balance_dirty_pages_ratelimited+0x304/0x400
[<0>] iomap_file_buffered_write+0x1ab/0x260
[<0>] xfs_file_buffered_write+0xba/0x330 [xfs]
[<0>] new_sync_write+0x119/0x1a0
[<0>] vfs_write+0x274/0x310
[<0>] __x64_sys_pwrite64+0x89/0xc0
[<0>] do_syscall_64+0x35/0x80
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae

Here's the xfs_io process performing a buffered write to the file on the
upper filesystem, which at this point has dirtied enough pages to be
ratelimited.

/proc/28/comm = u10:0+flush-8:80
/proc/28/stack : [<0>] blk_mq_get_tag+0x11c/0x280
[<0>] __blk_mq_alloc_request+0xce/0xf0
[<0>] blk_mq_submit_bio+0x139/0x5b0
[<0>] submit_bio_noacct+0x3ba/0x430
[<0>] iomap_submit_ioend+0x4b/0x70
[<0>] xfs_vm_writepages+0x86/0x170 [xfs]
[<0>] do_writepages+0xcc/0x200
[<0>] __writeback_single_inode+0x3d/0x300
[<0>] writeback_sb_inodes+0x207/0x4a0
[<0>] __writeback_inodes_wb+0x4c/0xe0
[<0>] wb_writeback+0x1da/0x2c0
[<0>] wb_workfn+0x2ad/0x4f0
[<0>] process_one_work+0x1e2/0x3d0
[<0>] worker_thread+0x53/0x3c0
[<0>] kthread+0x149/0x170
[<0>] ret_from_fork+0x1f/0x30

This is a flusher thread that has invoked writeback on the upper
filesystem to try to clean memory pages.

/proc/89/comm = u10:7+loop0
/proc/89/stack : [<0>] balance_dirty_pages+0x332/0xda0
[<0>] balance_dirty_pages_ratelimited+0x304/0x400
[<0>] iomap_file_buffered_write+0x1ab/0x260
[<0>] xfs_file_buffered_write+0xba/0x330 [xfs]
[<0>] do_iter_readv_writev+0x14f/0x1a0
[<0>] do_iter_write+0x7b/0x1c0
[<0>] lo_write_bvec+0x62/0x1c0
[<0>] loop_process_work+0x3a4/0xba0
[<0>] process_one_work+0x1e2/0x3d0
[<0>] worker_thread+0x53/0x3c0
[<0>] kthread+0x149/0x170
[<0>] ret_from_fork+0x1f/0x30

Here's the loop device worker handling the writeback IO submitted by the
flusher thread.  Unfortunately, the loop device is using buffered write
mode, which means that /writeback/ is dirtying pages and being throttled
for that.  This is stupid.

Fix this by trying to enable "directio" mode on the loop device, which
delivers two performance benefits: setting directio mode also enables
async io mode, which will allow multiple IOs at once; and using directio
nearly eliminates the chance that writeback will get throttled.

On the author's system with fast storage, this reduces the runtime of
g/590 from 20 minutes to 12 seconds, and g/361 from ~30s to ~3s.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/rc b/common/rc
index 275b1f24..a174b695 100644
--- a/common/rc
+++ b/common/rc
@@ -3849,6 +3849,14 @@ _create_loop_device()
 {
 	local file=$1 dev
 	dev=`losetup -f --show $file` || _fail "Cannot assign $file to a loop device"
+
+	# Try to enable asynchronous directio mode on the loopback device so
+	# that writeback started by a filesystem mounted on the loop device
+	# won't be throttled by buffered writes to the lower filesystem.  This
+	# is a performance optimization for tests that want to write a lot of
+	# data, so it isn't required to work.
+	test -b "$dev" && losetup --direct-io=on $dev 2> /dev/null
+
 	echo $dev
 }
 
