Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F981C388F9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 307D32231B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiUnpRqZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgKBJvV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:21 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2E9C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:21 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id j18so10662515pfa.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=WiUnpRqZraaNxPt428CkKXYQaFsM5MSk1yF8HRBtorgoehNItBtCOXAXelXBcTGbjT
         TmAH1T9n+pzQy4rzqjiGcQCfbaSQJrwDWBfNCdsq3w4nf5p0MEXdbWEjjFVCpE9k7Io6
         WsUJRojPR/oZ9/atJT0M48f6Nu182ZWPmKaTI7dtD2onpIDgJqsy7JiauJ4Y/j9UZG78
         Hn/ff+iNIFQv7r1jESWn95KhfcvP8CdhegthdiHurRR54Tqrh9FZK6p6i8n1iOhuwgEW
         vcox5gQfQt3uLYFq+Cuj75mWhGygy3tAUXv7OwLgT2hdzMIFpYcMhNdPAsdF+TFq3OsG
         PYtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILp5iM7cQcNHUrkAX0Lz/6PweGyzSkbIPzR9qhi/Ue0=;
        b=kQKPgKuEeqmO/1jkhvBIwwc1to+YJbn5uS34ulutadkxVmla8Y0tBGcsgA7Sb/mz6t
         FcV6H5SEEbJYupCK/EudjeuhG7LTYnWM2/ZGUZT6kVV7FZou2JAiD32emQEeUfPn5xMi
         4+PclMSws82srokAAMOsRWq6MJuH1u+H89mJGNqrmS342TS4YWAsDLOQp4StxdZGiDZN
         hBuCJqFbgwZNiiXb3dIRQKpKFeoCM34BXBseIqHffSThSqypvw6/AQbktNIV/90/stJK
         zRPkHfAVHuhbP91Y+VBoc6gJvaL+MA7ITZe+WhxvvTciu1m00qgULeGr7uCVFO4ERE/L
         329w==
X-Gm-Message-State: AOAM530E3SSNLILRbXi9sPZ6SWQ+8uQx/dSAn5wqMb2bHv4HA5xhP5Ig
        6cyRLWFcxqvvfevuZHGGp52Wl729ek4=
X-Google-Smtp-Source: ABdhPJzWGs5wyPdV8GckBkTQ9QWqtMHFlUtuFjhD4WMItUr9PRDuBxVGp57SsVYusoxxwFyX/E8T3A==
X-Received: by 2002:a63:4a43:: with SMTP id j3mr13026713pgl.103.1604310680836;
        Mon, 02 Nov 2020 01:51:20 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:20 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com, Christoph Hellwig <hch@lst.de>
Subject: [PATCH V9 07/14] xfs: Check for extent overflow when moving extent from cow to data fork
Date:   Mon,  2 Nov 2020 15:20:41 +0530
Message-Id: <20201102095048.100956-8-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Moving an extent to data fork can cause a sub-interval of an existing
extent to be unmapped. This will increase extent count by 1. Mapping in
the new extent can increase the extent count by 1 again i.e.
 | Old extent | New extent | Old extent |
Hence number of extents increases by 2.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 9 +++++++++
 fs/xfs/xfs_reflink.c           | 5 +++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index afb647e1e3fa..b99e67e7b59b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,6 +78,15 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
+/*
+ * Moving an extent to data fork can cause a sub-interval of an existing extent
+ * to be unmapped. This will increase extent count by 1. Mapping in the new
+ * extent can increase the extent count by 1 again i.e.
+ * | Old extent | New extent | Old extent |
+ * Hence number of extents increases by 2.
+ */
+#define XFS_IEXT_REFLINK_END_COW_CNT	(2)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..4f0198f636ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -628,6 +628,11 @@ xfs_reflink_end_cow_extent(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_REFLINK_END_COW_CNT);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * In case of racing, overlapping AIO writes no COW extents might be
 	 * left by the time I/O completes for the loser of the race.  In that
-- 
2.28.0

