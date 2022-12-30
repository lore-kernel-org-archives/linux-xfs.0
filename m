Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB56C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236071AbiLaBsp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBsl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:48:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100251DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:48:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B420DB81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ED8C433D2;
        Sat, 31 Dec 2022 01:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451313;
        bh=krs+9t/WZQLzhsCd7Jo/HleOAm5a7hYcVAPoWxQ44FA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PSrd600REXo3Bob+EmfQgVqjKFrl8FVTJo+pZ/gce8v7KtUZJmAjno9DbSjIHwVpU
         ok2CGNWN0MTGoyV+xtLDrqzUNoi0blB/6sWw2yC37e9mUz2wdwnYZqz0C/WRBOx632
         AmM4BDIY26VUtHtDXdydrUVqpfFeUlp/Q0ABkhookjlAax8ORz+8K269Dn5rmc/291
         NP0IFWg2uNp0DXGKjGHBH5cP5Z/B7c56llBI/sn/ZAIOqVsQji9Herj+1MfsQI3ME1
         eExVIFOBOQWup0u/ghj3cALPTuxGtxHeDKc4fzJ/NMdfBTb+bmHnO0ciWEBfVdW0dT
         /dPfv+VhGOLGg==
Subject: [PATCH 02/42] xfs: introduce realtime refcount btree definitions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870925.717073.13533133077980484735.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add new realtime refcount btree definitions. The realtime refcount btree
will be rooted from a hidden inode, but has its own shape and therefore
needs to have most of its own separate types.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.h  |    1 +
 fs/xfs/libxfs/xfs_format.h |    6 ++++++
 fs/xfs/libxfs/xfs_types.h  |    5 +++--
 fs/xfs/scrub/trace.h       |    1 +
 fs/xfs/xfs_trace.h         |    1 +
 5 files changed, 12 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 20342ed62bf4..ce5ef798c3bc 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -65,6 +65,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 #define	XFS_BTNUM_RCBAG	((xfs_btnum_t)XFS_BTNUM_RCBAGi)
 #define	XFS_BTNUM_RTRMAP ((xfs_btnum_t)XFS_BTNUM_RTRMAPi)
+#define	XFS_BTNUM_RTREFC ((xfs_btnum_t)XFS_BTNUM_RTREFCi)
 
 struct xfs_btree_ops;
 uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a2b8d8ee8afd..c78fe8e78b8c 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1796,6 +1796,12 @@ struct xfs_refcount_key {
 /* btree pointer type */
 typedef __be32 xfs_refcount_ptr_t;
 
+/*
+ * Realtime Reference Count btree format definitions
+ *
+ * This is a btree for reference count records for realtime volumes
+ */
+#define	XFS_RTREFC_CRC_MAGIC	0x52434e54	/* 'RCNT' */
 
 /*
  * BMAP Btree format definitions
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index e6a4f4a7d009..92c60a9d5862 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -126,7 +126,7 @@ typedef enum {
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_RCBAGi,
-	XFS_BTNUM_RTRMAPi, XFS_BTNUM_MAX
+	XFS_BTNUM_RTRMAPi, XFS_BTNUM_RTREFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 #define XFS_BTNUM_STRINGS \
@@ -138,7 +138,8 @@ typedef enum {
 	{ XFS_BTNUM_FINOi,	"finobt" }, \
 	{ XFS_BTNUM_REFCi,	"refcbt" }, \
 	{ XFS_BTNUM_RCBAGi,	"rcbagbt" }, \
-	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }
+	{ XFS_BTNUM_RTRMAPi,	"rtrmapbt" }, \
+	{ XFS_BTNUM_RTREFCi,	"rtrefcbt" }
 
 struct xfs_name {
 	const unsigned char	*name;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4cf8180173ca..8d66ab10e1fd 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -43,6 +43,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTREFCi);
 
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4e0c40934a7f..1f8ab7c436a9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2560,6 +2560,7 @@ TRACE_DEFINE_ENUM(XFS_BTNUM_RMAPi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_REFCi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RCBAGi);
 TRACE_DEFINE_ENUM(XFS_BTNUM_RTRMAPi);
+TRACE_DEFINE_ENUM(XFS_BTNUM_RTREFCi);
 
 DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_PROTO(struct xfs_btree_cur *cur, int level, struct xfs_buf *bp),

