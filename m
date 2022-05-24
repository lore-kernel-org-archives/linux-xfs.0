Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611EAC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 05:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbiEXFgD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 01:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234526AbiEXFf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 01:35:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2457CDF6
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 22:35:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0858861484
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 05:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646AFC385AA;
        Tue, 24 May 2022 05:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653370556;
        bh=W9D+n9V9+ybeYD9XPZkNIVAkUJD60b99SRzFkbwBql8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cIp1drki8cIUBVsVDrIZYJ84qPrE14v4o5BJRZVBRIpsnZawrYAy96uoPIxrS8zN/
         ChdrLyvq+eQFXnhF3dLTDktJi4UAIWuPk/yug1S6cllrODSolJm7iSx/a7c5MIcArt
         Q7KnFGSX/m4bDujvJZxmFmQk0gxWIm2HxS6JcCH1TljucRVi3wXmCA6JDxPNZtoXK+
         UDaH1O84mfbP08shjogpg4CxfejtLAun8Hx3dB/q1nLB2I6Ckwpu2CLAln8dZ39uXo
         5cjTCCFAk8AbFKeP1P/ybatJsG/zHhH0GiV9uwAXCloyXaJYz0rsWLEKANMzUHwDjG
         MeG67GkHqx92Q==
Subject: [PATCH 2/3] xfs: don't leak xfs_buf_cancel structures when recovery
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com
Date:   Mon, 23 May 2022 22:35:56 -0700
Message-ID: <165337055599.992964.776146682315663613.stgit@magnolia>
In-Reply-To: <165337054460.992964.11039203493792530929.stgit@magnolia>
References: <165337054460.992964.11039203493792530929.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If log recovery fails, we free the memory used by the buffer
cancellation buckets, but we don't actually traverse each bucket list to
free the individual xfs_buf_cancel objects.  This leads to a memory
leak, as reported by kmemleak in xfs/051:

unreferenced object 0xffff888103629560 (size 32):
  comm "mount", pid 687045, jiffies 4296935916 (age 10.752s)
  hex dump (first 32 bytes):
    08 d3 0a 01 00 00 00 00 08 00 00 00 01 00 00 00  ................
    d0 f5 0b 92 81 88 ff ff 80 64 64 25 81 88 ff ff  .........dd%....
  backtrace:
    [<ffffffffa0317c83>] kmem_alloc+0x73/0x140 [xfs]
    [<ffffffffa03234a9>] xlog_recover_buf_commit_pass1+0x139/0x200 [xfs]
    [<ffffffffa032dc27>] xlog_recover_commit_trans+0x307/0x350 [xfs]
    [<ffffffffa032df15>] xlog_recovery_process_trans+0xa5/0xe0 [xfs]
    [<ffffffffa032e12d>] xlog_recover_process_data+0x8d/0x140 [xfs]
    [<ffffffffa032e49d>] xlog_do_recovery_pass+0x19d/0x740 [xfs]
    [<ffffffffa032f22d>] xlog_do_log_recovery+0x6d/0x150 [xfs]
    [<ffffffffa032f343>] xlog_do_recover+0x33/0x1d0 [xfs]
    [<ffffffffa032faba>] xlog_recover+0xda/0x190 [xfs]
    [<ffffffffa03194bc>] xfs_log_mount+0x14c/0x360 [xfs]
    [<ffffffffa030bfed>] xfs_mountfs+0x50d/0xa60 [xfs]
    [<ffffffffa03124b5>] xfs_fs_fill_super+0x6a5/0x950 [xfs]
    [<ffffffff812b92a5>] get_tree_bdev+0x175/0x280
    [<ffffffff812b7c3a>] vfs_get_tree+0x1a/0x80
    [<ffffffff812e366f>] path_mount+0x6ff/0xaa0
    [<ffffffff812e3b13>] __x64_sys_mount+0x103/0x140

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item_recover.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d2e2dff01b99..f983af4de0a5 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1034,9 +1034,22 @@ void
 xlog_free_buf_cancel_table(
 	struct xlog	*log)
 {
+	int		i;
+
 	if (!log->l_buf_cancel_table)
 		return;
 
+	for (i = 0; i < XLOG_BC_TABLE_SIZE; i++) {
+		struct xfs_buf_cancel	*bc;
+
+		while ((bc = list_first_entry_or_null(
+				&log->l_buf_cancel_table[i],
+				struct xfs_buf_cancel, bc_list))) {
+			list_del(&bc->bc_list);
+			kmem_free(bc);
+		}
+	}
+
 	kmem_free(log->l_buf_cancel_table);
 	log->l_buf_cancel_table = NULL;
 }

