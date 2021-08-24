Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D654C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 00:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4672E61183
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 00:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhHXAiX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Aug 2021 20:38:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233260AbhHXAiX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Aug 2021 20:38:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECAF161183
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 00:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629765460;
        bh=OThu3QykomBI7rqh4es9ZzmM0DNwYc1IZZ8aTYiiD7I=;
        h=Date:From:To:Subject:From;
        b=aANeVX/fjW+Q54WdTwWUXPXDet4aKj0jTT4GJWMt+4vGcdTmVxBSbb70XXdA6iEEP
         EaJJVQW9y8FybMkiEuLTWFmodjvqF4nQ8SJgTomC24Ptdqnjg5451neNt8vPeG5w0j
         hFLJQmlCZA7mJ33G3KX72V9j13cmsUmfBzyTt50lSrI3oIyGin7wgORNjV1u/zp/ZJ
         xd7qgZcV+UB2iOgfN1WmxNt1axyX3frWKoc6DnqWKnpd4IOoqNw5Bji1YLo+NDt6Vf
         o9MwNZwPgiVMp8mX16d2giaob3Y7MJhJF0IzavqjisuYM+PxGCuQnKPoK8CaLndt3D
         eRpMdlKtjrM/g==
Date:   Mon, 23 Aug 2021 17:37:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: only set IOMAP_F_SHARED when providing a srcmap to a
 write
Message-ID: <20210824003739.GC12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While prototyping a free space defragmentation tool, I observed an
unexpected IO error while running a sequence of commands that can be
recreated by the following sequence of commands:

# xfs_io -f -c "pwrite -S 0x58 -b 10m 0 10m" file1
# cp --reflink=always file1 file2
# punch-alternating -o 1 file2
# xfs_io -c "funshare 0 10m" file2
fallocate: Input/output error

I then scraped this (abbreviated) stack trace from dmesg:

WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450
CPU: 0 PID: 30788 Comm: xfs_io Not tainted 5.14.0-rc6-xfsx #rc6 5ef57b62a900814b3e4d885c755e9014541c8732
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:iomap_write_begin+0x376/0x450
RSP: 0018:ffffc90000c0fc20 EFLAGS: 00010297
RAX: 0000000000000001 RBX: ffffc90000c0fd10 RCX: 0000000000001000
RDX: ffffc90000c0fc54 RSI: 000000000000000c RDI: 000000000000000c
RBP: ffff888005d5dbd8 R08: 0000000000102000 R09: ffffc90000c0fc50
R10: 0000000000b00000 R11: 0000000000101000 R12: ffffea0000336c40
R13: 0000000000001000 R14: ffffc90000c0fd10 R15: 0000000000101000
FS:  00007f4b8f62fe40(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056361c554108 CR3: 000000000524e004 CR4: 00000000001706f0
Call Trace:
 iomap_unshare_actor+0x95/0x140
 iomap_apply+0xfa/0x300
 iomap_file_unshare+0x44/0x60
 xfs_reflink_unshare+0x50/0x140 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 xfs_file_fallocate+0x27c/0x610 [xfs 61947ea9b3a73e79d747dbc1b90205e7987e4195]
 vfs_fallocate+0x133/0x330
 __x64_sys_fallocate+0x3e/0x70
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f4b8f79140a

Looking at the iomap tracepoints, I saw this:

iomap_iter:           dev 8:64 ino 0x100 pos 0 length 0 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 0 length 131072 type DELALLOC flags SHARED
iomap_iter_srcmap:    dev 8:64 ino 0x100 bdev 8:64 addr 147456 offset 0 length 4096 type MAPPED flags
iomap_iter:           dev 8:64 ino 0x100 pos 0 length 4096 flags WRITE|0x80 (0x81) ops xfs_buffered_write_iomap_ops caller iomap_file_unshare
iomap_iter_dstmap:    dev 8:64 ino 0x100 bdev 8:64 addr -1 offset 4096 length 4096 type DELALLOC flags SHARED
console:              WARNING: CPU: 0 PID: 30788 at fs/iomap/buffered-io.c:577 iomap_write_begin+0x376/0x450

The first time funshare calls ->iomap_begin, xfs sees that the first
block is shared and creates a 128k delalloc reservation in the COW fork.
The delalloc reservation is returned as dstmap, and the shared block is
returned as srcmap.  So far so good.

funshare calls ->iomap_begin to try the second block.  This time there's
no srcmap (punch-alternating punched it out!) but we still have the
delalloc reservation in the COW fork.  Therefore, we again return the
reservation as dstmap and the hole as srcmap.  iomap_unshare_iter
incorrectly tries to unshare the hole, which __iomap_write_begin rejects
because shared regions must be fully written and therefore cannot
require zeroing.

Therefore, change the buffered write iomap_begin function not to set
IOMAP_F_SHARED when there isn't a source mapping to read from for the
unsharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7c69b124a475..abf6d60945ab 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -870,6 +870,7 @@ xfs_buffered_write_iomap_begin(
 	struct xfs_bmbt_irec	imap, cmap;
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
+	u16			cflags = 0;
 	bool			eof = false, cow_eof = false, shared = false;
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
@@ -1061,6 +1062,7 @@ xfs_buffered_write_iomap_begin(
 found_cow:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (imap.br_startoff <= offset_fsb) {
+		cflags = IOMAP_F_SHARED;
 		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
 		if (error)
 			return error;
@@ -1068,7 +1070,7 @@ xfs_buffered_write_iomap_begin(
 		xfs_trim_extent(&cmap, offset_fsb,
 				imap.br_startoff - offset_fsb);
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, cflags);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
