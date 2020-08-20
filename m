Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0A3C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1EC321741
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 05:44:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dythoEv7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726745AbgHTFoZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 01:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgHTFoY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Aug 2020 01:44:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3FCC061757
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q1so159873pjd.1
        for <linux-xfs@vger.kernel.org>; Wed, 19 Aug 2020 22:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3vwkX7+KSEBYbeLsNYS+2jKbh2t+OB1cw7PHNOQevcU=;
        b=dythoEv7XIOHJLWXB4PNMFZcAAkHAN6NUPKki6bFhCD8LAhcVHaoZnGcG3383796U0
         M1KhMDlmpWE5O6rbKVhGAKt5mkh59S93Urf8BFf6XTlmYFKseZ4pbbZ7NPZuLOA9YTrx
         TQpKrAr49x6Ve/y0hv62vQ8kKxeh5UFHAQoLN/8birJQXNvzdE6KRPBspmoJhfyrih0H
         FMcmxiJez/GJyhzIzAL1o0XXKglpSqi+iut5dHAX5CGFBZvZw+HUxcQvqbP58mNOdR4Q
         pS9rJLnCxDo/xH8n4iVrEKXXVklzm6wtxJpmPUGMvpgYXUDl8hvCal2H74bdbdxyl6qd
         wKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3vwkX7+KSEBYbeLsNYS+2jKbh2t+OB1cw7PHNOQevcU=;
        b=HDd1efi8leiaz3rNw5uwmgFYGc7c6y+X7djkrUM/BUMyVBebQT+CsLE9efll2WzJFf
         uW0nI6JFbqh//4OnFxQ+bM4gqAfP38G3XlKEZ2x6P4vw2nnj71cwk+ULxwFII+xPSi4I
         0yjKpc/Mqh7XJBXG8GwEGWBS8YPcAkkuu+CmayMqN22obk/qT/qJ8M0QLUaJglbapJ7h
         WF/R76DHpwBjg8L3l2a/7SHhpERL0ibfzJIrda3S85hOBFcU3fVERx1PVvdB6kCQ+Jk0
         sVCZWYPJI3e3+P+nq7lJvGiTu2p69jIdHEkV7wP2U3iGMRhkimMKs223mAIaXRORKeBV
         yv3A==
X-Gm-Message-State: AOAM5336zt2NmlIoXwfmSIj14ZzX7bh3M1iX0HCQE6wtgCo4mTJH0o1c
        WzEcK2bu/dh1Eje8fGBfdfeDwKF4a/4=
X-Google-Smtp-Source: ABdhPJw85Fesxl7Q2Zk7jfJ2ZVb04QuladXzVoDToqGmaUt8h7nJSaZJf5o1NYw9UbNAJgQrgrW/tQ==
X-Received: by 2002:a17:90b:3891:: with SMTP id mu17mr1148860pjb.160.1597902263208;
        Wed, 19 Aug 2020 22:44:23 -0700 (PDT)
Received: from localhost.localdomain ([122.171.166.150])
        by smtp.gmail.com with ESMTPSA id l4sm1044034pgk.74.2020.08.19.22.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 22:44:22 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org
Subject: [PATCH V3 06/10] xfs: Check for extent overflow when writing to unwritten extent
Date:   Thu, 20 Aug 2020 11:13:45 +0530
Message-Id: <20200820054349.5525-7-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820054349.5525-1-chandanrlinux@gmail.com>
References: <20200820054349.5525-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A write to a sub-interval of an existing unwritten extent causes
the original extent to be split into 3 extents
i.e. | Unwritten | Real | Unwritten |
Hence extent count can increase by 2.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 7 +++++++
 fs/xfs/xfs_iomap.c             | 5 +++++
 2 files changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index f686c7418d2b..83ff90e2a5fe 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -66,6 +66,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_DIR_MANIP_CNT(mp) \
 	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+/*
+ * A write to a sub-interval of an existing unwritten extent causes the original
+ * extent to be split into 3 extents
+ * i.e. | Unwritten | Real | Unwritten |
+ * Hence extent count can increase by 2.
+ */
+#define XFS_IEXT_WRITE_UNWRITTEN_CNT	(2)
 
 /*
  * Fork handling.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 37b0c743c116..694b25fbb4a3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -566,6 +566,11 @@ xfs_iomap_write_unwritten(
 		if (error)
 			goto error_on_bmapi_transaction;
 
+		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+				XFS_IEXT_WRITE_UNWRITTEN_CNT);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.28.0

