Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83AFC43463
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7806421D7B
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 09:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5ola9mB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgIRJsd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Sep 2020 05:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgIRJsc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Sep 2020 05:48:32 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67B7C06174A
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:32 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so3098724pfn.9
        for <linux-xfs@vger.kernel.org>; Fri, 18 Sep 2020 02:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+yzZR2iVQ2ZdH/KMJFzmnk4qPWZEMSnlIB8x5f/rCn8=;
        b=e5ola9mBABOp5rI7dmfKw9vxISdyrm7jcE7ygxlWVFIJq/kqwwVabg2diS5tSF8HLj
         D2xIFdEQkBq6ZYriOfha1efii48T5hPwZt9LmIByLRp4rkoCYsX3nQULtUS78OV38nuN
         Em4uq1blL/kiO9XkFYh660aZ8C5MZ/tl5RUaf3wcUmh5vc/+nzpk4/oYKU0u4gcvBUM/
         0bqVVeQ6RcUtElREUoz9pXoruOr7RmrZ5KoH0wl7YhgmeuAjqnjxRSS0pnV3UOpjwCTy
         B+nC9lCC/BY1OAXvf74llACa90hnUpJF9Izuoy4bSi2VqwFq3KjjvZoPVQYMzSLXu/kW
         pGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+yzZR2iVQ2ZdH/KMJFzmnk4qPWZEMSnlIB8x5f/rCn8=;
        b=PRbve2yNlGjxCKtzKWrpyXr1rhQ9lPNPOMwHikseHG5E+H9M7dLZiXSLni4oJxev5X
         IrGoKFGNc4W8n45JwOH110droOq9S/+Tm606Z4RYrtMP8EIsk8sbP0SerMPjVzLnTlLu
         o59r4rJpxw9cw693/uOwnZGk/4ZMsqfXTsF0A9jZwxv6lyyxgHTZcQDVM+Zrh6FwDPwl
         hhZwTLAJTZNYSdO3nfoMq0wgEZ1pPJvBY6PvskbEy0eFpPXo2/IpKoSUHCCRFmjS6t+T
         tmKNnvc6OlaEZMxm046Xgm5OkiQkwyfKBWI7Wwf8twlg1Wq/v05QIbrwJuCBR0wJG+Di
         TjYw==
X-Gm-Message-State: AOAM533zUNfzEcEwUZykP6E6RCoq9lY8sC/vMHJIyQEc0oXdIdBkf5fZ
        lzAXb8CMF3uYbrE73BTIlk1Ls5QlKm0=
X-Google-Smtp-Source: ABdhPJxBKXyTPpHE1eBNIT3xiCJY0OhVcmb1oz+DrNtCmVBclk4oGm+jV3Cz2hpza8t+ds0GzPArBg==
X-Received: by 2002:a63:f803:: with SMTP id n3mr11586478pgh.231.1600422511801;
        Fri, 18 Sep 2020 02:48:31 -0700 (PDT)
Received: from localhost.localdomain ([122.179.62.164])
        by smtp.gmail.com with ESMTPSA id s24sm2227194pjp.53.2020.09.18.02.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 02:48:31 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com
Subject: [PATCH V4 05/10] xfs: Check for extent overflow when adding/removing dir entries
Date:   Fri, 18 Sep 2020 15:17:54 +0530
Message-Id: <20200918094759.2727564-6-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200918094759.2727564-1-chandanrlinux@gmail.com>
References: <20200918094759.2727564-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directory entry addition/removal can cause the following,
1. Data block can be added/removed.
   A new extent can cause extent count to increase by 1.
2. Free disk block can be added/removed.
   Same behaviour as described above for Data block.
3. Dabtree blocks.
   XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these
   can be new extents. Hence extent count can increase by
   XFS_DA_NODE_MAXDEPTH.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h | 13 +++++++++++++
 fs/xfs/xfs_inode.c             | 27 +++++++++++++++++++++++++++
 fs/xfs/xfs_symlink.c           |  5 +++++
 3 files changed, 45 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 5de2f07d0dd5..fd93fdc67ee4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -57,6 +57,19 @@ struct xfs_ifork {
 #define XFS_IEXT_ATTR_MANIP_CNT(rmt_blks) \
 	(XFS_DA_NODE_MAXDEPTH + max(1, rmt_blks))
 
+/*
+ * Directory entry addition/removal can cause the following,
+ * 1. Data block can be added/removed.
+ *    A new extent can cause extent count to increase by 1.
+ * 2. Free disk block can be added/removed.
+ *    Same behaviour as described above for Data block.
+ * 3. Dabtree blocks.
+ *    XFS_DA_NODE_MAXDEPTH blocks can be added. Each of these can be new
+ *    extents. Hence extent count can increase by XFS_DA_NODE_MAXDEPTH.
+ */
+#define XFS_IEXT_DIR_MANIP_CNT(mp) \
+	((XFS_DA_NODE_MAXDEPTH + 1 + 1) * (mp)->m_dir_geo->fsbcount)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 49624973eecc..f347b1911d9c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1159,6 +1159,11 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * A newly created regular or special file just has one directory
 	 * entry pointing to them, but a directory also the "." entry
@@ -1375,6 +1380,11 @@ xfs_link(
 	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(tdp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto error_return;
+
 	/*
 	 * If we are using project inheritance, we only allow hard link
 	 * creation in our tree when the project IDs are the same; else
@@ -2850,6 +2860,11 @@ xfs_remove(
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * If we're removing a directory perform some additional validation.
 	 */
@@ -3210,6 +3225,18 @@ xfs_rename(
 	if (wip)
 		xfs_trans_ijoin(tp, wip, XFS_ILOCK_EXCL);
 
+	error = xfs_iext_count_may_overflow(src_dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
+	if (target_ip == NULL) {
+		error = xfs_iext_count_may_overflow(target_dp, XFS_DATA_FORK,
+				XFS_IEXT_DIR_MANIP_CNT(mp));
+		if (error)
+			goto out_trans_cancel;
+	}
+
 	/*
 	 * If we are using project inheritance, we only allow renames
 	 * into our tree when the project IDs are the same; else the
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8e88a7ca387e..581a4032a817 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -220,6 +220,11 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
+	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
+			XFS_IEXT_DIR_MANIP_CNT(mp));
+	if (error)
+		goto out_trans_cancel;
+
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-- 
2.28.0

