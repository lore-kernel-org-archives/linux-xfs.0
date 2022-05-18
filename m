Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FFEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241642AbiERSzt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241708AbiERSzi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED71B1FB548
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 751C2B821B0
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFACC34113;
        Wed, 18 May 2022 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900135;
        bh=o3hcC1x1Iwvb3w+2XNQEXWGK+QChOF8Vx8aCS0U/ZFU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=h3bQLEEsevV6beE/XKKfiv2XCfNPuMbZEuCRzwlZJ/uskaOCmkN6oH367j9QeVkmx
         Hc2LrkavIQO02h1TZgeVSMjJwo8MsftdKOs26KYCWrX78JOEHILUMwIP1OthUxKCfx
         XNZf8iwKynx6TD+Ro/qh0QJtNmt8aWADF4hSneZBNdhrL19+QczNpUqCLSMv7LEouP
         lN2/tXD/o804JTTmfhukL092sFPK0XoMIkdNiuhXHyc2BUCDKDmrcks0dyJBNl3NmC
         r8qB2NJn7Z+GXUSLPnifbc/cn0mb1NOcMyvcfETbtGuw2dhkNYRRj9yvP2dHWoe4a0
         WDLn+0KfQw/CQ==
Subject: [PATCH 2/3] xfs: don't leak xfs_buf_cancel structures when recovery
 fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 18 May 2022 11:55:34 -0700
Message-ID: <165290013462.1646290.6497497049561091089.stgit@magnolia>
In-Reply-To: <165290012335.1646290.10769144718908005637.stgit@magnolia>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
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
---
 fs/xfs/xfs_buf_item_recover.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 8624ac22ca4a..d1e484649a33 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1013,9 +1013,22 @@ void
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

