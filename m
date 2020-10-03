Return-Path: <SRS0=fxM9=DK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E618C4363D
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 649E62072E
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Oct 2020 05:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYdbP1V1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgJCF4x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 3 Oct 2020 01:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJCF4x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Oct 2020 01:56:53 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86F3C0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  2 Oct 2020 22:56:53 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id u24so2330274pgi.1
        for <linux-xfs@vger.kernel.org>; Fri, 02 Oct 2020 22:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwfX1/EcLsyZiWi+KJA2zfiE3bjogd/2F0jOWYeSwno=;
        b=kYdbP1V1uZGyS94/5VIE4HT1oOX9KvdCSH/Ll12zftuD5H1JrI1mD+dS+T1Qtk2L16
         BPqnJvabBtHeNuEbFXHFrg4KVR46n6xmDWqhpOQhJJ2xnahZJP1/7V4KSguT8Z4slTTq
         CVUh7kBhO+Ke6R6Lo00aPdeXpPVeaa+/ZLWeMtr9x8Y+AlHqepiyium5m3o7THsN2jlG
         h4B+h3qSDGe6IsNDOWVzz08AFzJST+4nO8u+HxJODrskwgmrv16b57yf2RbTwN3VFQjm
         Mj3zv9DqEKEJFZzmn7ZmhS1EWEdBoTGPT+aefWeSDuN4fqKHaCa2dNASf1zBaZ0k2dP2
         9gAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwfX1/EcLsyZiWi+KJA2zfiE3bjogd/2F0jOWYeSwno=;
        b=U8Vzmdl8DRlSsPBCCT4+/DxyMrfNnZMQT8nztdxYGzZmDIkqzN1bRMFddkoSqH/Dj/
         rDxIvX7porwp5hZvgiWtS1z/QsarTIMSvImpmig/ZFJedBLFDRjvxOXwreTJmMoZhRco
         g9HLZy/i9QuF7fIuDC1H/x+sBuNF4gIpA4Ylt0PBZ6dwgm9ZVQ3mxaZTZZWbOwf46NqI
         JSI3X0oIG6/4awyiB0UsIeM/wzcapdehuTTEyRJBn3PtADJ3oVsWV38Eyx+SQZwdI4fN
         tL2IqXzDZ8CfQ6V7KojY6ZSDrlQmNejOnC61GDnRevABDwNr6mJPghQjq1nHBOg1TrLy
         h2Zg==
X-Gm-Message-State: AOAM533BuMO++Bl1aK0nGyrfTEs794J3zDA8WblukpFEYIDeg2Nvf7fl
        MBQ/qM8tsBYTJEHKEtfrIhdSeMrpu9ZWFg==
X-Google-Smtp-Source: ABdhPJws7kbkDOQy2fKLYZ8F3g8JrOYBqSss7c3LQUl1cuBohih3bojNGsZ13IABlSQaPHwOIU0Tyw==
X-Received: by 2002:a63:5566:: with SMTP id f38mr5558815pgm.9.1601704612990;
        Fri, 02 Oct 2020 22:56:52 -0700 (PDT)
Received: from localhost.localdomain ([122.171.168.96])
        by smtp.gmail.com with ESMTPSA id 125sm4106664pff.59.2020.10.02.22.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 22:56:52 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V5 03/12] xfs: Check for extent overflow when punching a hole
Date:   Sat,  3 Oct 2020 11:26:24 +0530
Message-Id: <20201003055633.9379-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201003055633.9379-1-chandanrlinux@gmail.com>
References: <20201003055633.9379-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The extent mapping the file offset at which a hole has to be
inserted will be split into two extents causing extent count to
increase by 1.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_item.c         | 15 +++++++++------
 fs/xfs/xfs_bmap_util.c         | 10 ++++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 7fc2b129a2e7..bcac769a7df6 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -40,6 +40,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_ADD_NOSPLIT_CNT	(1)
 
+/*
+ * Punching out an extent from the middle of an existing extent can cause the
+ * extent count to increase by 1.
+ * i.e. | Old extent | Hole | Old extent |
+ */
+#define XFS_IEXT_PUNCH_HOLE_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 6a7dcea4ad40..323cee00bd45 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -440,6 +440,7 @@ xfs_bui_item_recover(
 	bool				op_ok;
 	unsigned int			bui_type;
 	int				whichfork;
+	int				iext_delta;
 	int				error = 0;
 
 	/* Only one mapping operation per BUI... */
@@ -519,12 +520,14 @@ xfs_bui_item_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
-	if (bui_type == XFS_BMAP_MAP) {
-		error = xfs_iext_count_may_overflow(ip, whichfork,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error)
-			goto err_inode;
-	}
+	if (bui_type == XFS_BMAP_MAP)
+		iext_delta = XFS_IEXT_ADD_NOSPLIT_CNT;
+	else
+		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
+
+	error = xfs_iext_count_may_overflow(ip, whichfork, iext_delta);
+	if (error)
+		goto err_inode;
 
 	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, type, ip, whichfork,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index dcd6e61df711..0776abd0103c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -891,6 +891,11 @@ xfs_unmap_extent(
 
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	error = xfs_bunmapi(tp, ip, startoffset_fsb, len_fsb, 0, 2, done);
 	if (error)
 		goto out_trans_cancel;
@@ -1176,6 +1181,11 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
+	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+			XFS_IEXT_PUNCH_HOLE_CNT);
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * The extent shifting code works on extent granularity. So, if stop_fsb
 	 * is not the starting block of extent, we need to split the extent at
-- 
2.28.0

