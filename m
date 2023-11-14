Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CEB2C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Nov 2023 01:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjKNBxw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 20:53:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbjKNBxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455C5D45
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:49 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc53d0030fso39780735ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926828; x=1700531628; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QpEHm/X6Y+wEH5fOG9EXlVOtdkt4c+ZXbK0RLckQUA=;
        b=a4pflXExtblPSgC/78R4kyqpI9Og3DEs/CEwSZ2Y+rNDMWUYmhrg2gML0tdLQ8cjnR
         LjovxhhiKOjZfKKer27rqfIji10iq2DnFQJ5x1z7V9Zo9whzwNQDaDtrWZGSLwY+PNjL
         UYCdtEKnvGpNEGCJqKbgAXilXZkc8NAmM9bsIgxCXciHjfT0G3sPj90dLUjP6mXhuuvV
         VjYBQ/zeocnfh6imZYxqCkNAErHZwL6qPcwLl3W/1fbprRuIcyxYvq7oEy7PsjezRGTe
         +J5YOudyR6BVEGfYHnq56cjj6aX3vKvYpU21brqfYwFsUaKpWXidH7LOnBG3oH/3pz1D
         iLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926828; x=1700531628;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QpEHm/X6Y+wEH5fOG9EXlVOtdkt4c+ZXbK0RLckQUA=;
        b=qpM/V8Rjyc2mYl5fkFEz2YpSUXF3C2YeUcL/myX4GLWmX/OAIQp4EYSuMiyksFMlYe
         e8rjjoBNprhKW88h6+27+OAIwfZxEaBc+n4XLELYGVMfQMV5lG2hg+D2lToJva/xKPdm
         dKVNcBaGIEKDaTweH2olPSTKiXECpmXDR1X16c772UW+kDtUcZR+GWNEAZ6rS7H+vzpd
         FHrObISYl1WiOthnI03Q1YrUaL2fiUmS7VKLedda8gQeOnQuJidgYGU+O/gFNwzU4OY5
         ubnH/fTQI8eB4nqyLKxwyHHCb6lVrngLxtjMtP+iWfShUR/52H5veZQoT/lXkybk8D/k
         j91w==
X-Gm-Message-State: AOJu0YxOPHrj+rx50qQD7xpR97GYjLRmniGjbQLpGqK/cL+OIuB298Vx
        24wxLyXaWnFl7O4DztuEYiYsDPwgB+BBFQ==
X-Google-Smtp-Source: AGHT+IEIfRrzFhASMAZaZQmxkIj8CLT4f+IPI2piQpggbDr6OcqOOIJpEvBydKXKELv3h3hAL4Yw1g==
X-Received: by 2002:a17:902:e80a:b0:1cc:5549:aab8 with SMTP id u10-20020a170902e80a00b001cc5549aab8mr1275183plg.5.1699926828577;
        Mon, 13 Nov 2023 17:53:48 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:48 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 02/17] xfs: don't leak xfs_buf_cancel structures when recovery fails
Date:   Mon, 13 Nov 2023 17:53:23 -0800
Message-ID: <20231114015339.3922119-3-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 8db074bd84df5ccc88bff3f8f900f66f4b8349fa ]

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_buf_item_recover.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index dc099b2f4984..635f7f8ed9c2 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1044,9 +1044,22 @@ void
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
-- 
2.43.0.rc0.421.g78406f8d94-goog

