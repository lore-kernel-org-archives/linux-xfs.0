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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C55C388F2
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEBD4222B9
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 09:51:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cn1jDHaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgKBJv1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 04:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJv1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:27 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B83CC0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:51:27 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id o3so10308602pgr.11
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=cn1jDHaFg9HbmM8j/TDQ5L+6K5+KW+3pHzDWeiPWWEBvV/++vS+0k2jWWpku5HOIf5
         NlYf1zeVvu+aTVL0QsrqNLEG1QbS1mWjKg+CxIt780FLrSQH9N3ZJs+223rsOru7+yEZ
         Y+aip5HsbKV6ILvt850c5SAOiCXTfM+2N1Tx3fyQiXfDRDPlVibE28tLJPgxlJ+jqH8R
         5lBSD3L7rhyO7fyPCAcpY5bqahUzX6i0E0l6SSV2wPnG1NqFsdq1XvoYagoy1TMwZYyN
         HYUMKj4AHBX01DC/DKgE+aapspx1GJ/0lPsdruFhtQt4LGEQBnRA1RtlaLUla1byD/kM
         pRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gjkXFZh3Yb0k29wFDewcPx5MIG4z7sYEJ/SPODbUO9A=;
        b=QqznjV80E6oik2JFtkqQ0DBtsn4j/EPbVfIUthwSyX5ufBqussoVfoRY5E0Y8kI51l
         JSMVbLPvj+42ry/Jf41PBGQ+CYc74cr22SjwiciKqY1yp7eV7bsmKgHo33ygnVU+2qZy
         IQgaiz7WnIxIrNcN8abiIBFbnWmnBoi/5Nq/Q7BSjpPPy7Nj0LDrcTDfKR3VSPfB1mU4
         /RjxLp+CbUyM5TEcbWxHWQhcskPF3xErPsgmvtIh1kCg3Xv0xbkwAz1QPTrffR3x5pdO
         KxDUD5H8O9W+lSsAsexZWOWddchX6+xxrlA7Fx2e1g2AW4SIuZ9IHLKbN+At5fGA8J81
         /yzw==
X-Gm-Message-State: AOAM532Z9LDzOaWytyJw6C5MiRIKKhRaN4+x5mMJrKCPdNr0U0JWDbZy
        nC89AQFbrGhm7yp8sxjRPaUbhwsr9yY=
X-Google-Smtp-Source: ABdhPJwTzak8sGwzfxPWRdFslDwSGvtBMRDJ5PjF40oUqXSBqn01UUiKgCfK4oUUx3tTSgKK+mQaxA==
X-Received: by 2002:a63:4459:: with SMTP id t25mr13041952pgk.104.1604310686590;
        Mon, 02 Nov 2020 01:51:26 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:51:25 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 09/14] xfs: Check for extent overflow when swapping extents
Date:   Mon,  2 Nov 2020 15:20:43 +0530
Message-Id: <20201102095048.100956-10-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102095048.100956-1-chandanrlinux@gmail.com>
References: <20201102095048.100956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Removing an initial range of source/donor file's extent and adding a new
extent (from donor/source file) in its place will cause extent count to
increase by 1.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_fork.h |  7 +++++++
 fs/xfs/xfs_bmap_util.c         | 16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index b99e67e7b59b..969b06160d44 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -87,6 +87,13 @@ struct xfs_ifork {
  */
 #define XFS_IEXT_REFLINK_END_COW_CNT	(2)
 
+/*
+ * Removing an initial range of source/donor file's extent and adding a new
+ * extent (from donor/source file) in its place will cause extent count to
+ * increase by 1.
+ */
+#define XFS_IEXT_SWAP_RMAP_CNT		(1)
+
 /*
  * Fork handling.
  */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0776abd0103c..b6728fdf50ae 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1407,6 +1407,22 @@ xfs_swap_extent_rmap(
 					irec.br_blockcount);
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
+			if (xfs_bmap_is_real_extent(&uirec)) {
+				error = xfs_iext_count_may_overflow(ip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
+			if (xfs_bmap_is_real_extent(&irec)) {
+				error = xfs_iext_count_may_overflow(tip,
+						XFS_DATA_FORK,
+						XFS_IEXT_SWAP_RMAP_CNT);
+				if (error)
+					goto out;
+			}
+
 			/* Remove the mapping from the donor file. */
 			xfs_bmap_unmap_extent(tp, tip, &uirec);
 
-- 
2.28.0

