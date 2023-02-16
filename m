Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23460C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:52:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjBPUwd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUwc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:52:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD6E4BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C6A3B829AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D7BC433EF;
        Thu, 16 Feb 2023 20:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580749;
        bh=dy8in5Ii1dF36Hd9o97Bz8yHz6Mb9e6xQfCoY9SSjAU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TDYqkh1u1iFynM0dYd4r0ob0UtuzrpjSWpSAI7om7DePJiv//vf5Em+/0Aac0DYr2
         xYAvm2PkCmvRId1awtoEexhXzyov8TJUyggp2iAmgEwGF7+/++TggV99srmXuWo+Rb
         QIT2K2iAi9XPZ/IZCgZGcoLIcChMDubxPSJcFFdITIHNzYBJTGZssx7c34ontAPTEu
         NzHjXa/ftZSrrL7R/PVSj9wKPnpGBW6gMHuEz7QorDHSNHoJk5x0qmVVDCKRl4bhy0
         VM2vLH+jRM6KIvnoa9EEFh0DxcygWrjB3TmbnlM9u9VFT+79AV72VvLT0vJnPvQBDH
         C2R9QGJn3M4fg==
Date:   Thu, 16 Feb 2023 12:52:28 -0800
Subject: [PATCH 4/5] xfs: make the ondisk parent pointer record a flex array
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875924.3475422.11827990483807692730.stgit@magnolia>
In-Reply-To: <167657875861.3475422.10929602650869169128.stgit@magnolia>
References: <167657875861.3475422.10929602650869169128.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we can use the filename as the parent pointer name hash, we
always write the full 64 bytes into the xattr.  In other words, the
namehash is really a flex array, so adjust its C definition.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  |    9 ++++++---
 fs/xfs/libxfs/xfs_parent.c     |    4 ++--
 fs/xfs/libxfs/xfs_parent.h     |   15 ++++++++++++---
 fs/xfs/libxfs/xfs_trans_resv.c |    6 +++---
 fs/xfs/xfs_ondisk.h            |    2 +-
 5 files changed, 24 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 275357506394..4d85830785ae 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -842,21 +842,24 @@ xfs_failaddr_t xfs_da3_blkinfo_verify(struct xfs_buf *bp,
 struct xfs_parent_name_rec {
 	__be64  p_ino;
 	__be32  p_gen;
-	__u8	p_namehash[XFS_PARENT_NAME_HASH_SIZE];
+	__u8	p_namehash[];
 } __attribute__((packed));
 
+#define XFS_PARENT_NAME_MAX_SIZE \
+	(sizeof(struct xfs_parent_name_rec) + XFS_PARENT_NAME_HASH_SIZE)
+
 static inline unsigned int
 xfs_parent_name_rec_sizeof(
 	unsigned int		hashlen)
 {
-	return offsetof(struct xfs_parent_name_rec, p_namehash) + hashlen;
+	return sizeof(struct xfs_parent_name_rec) + hashlen;
 }
 
 static inline unsigned int
 xfs_parent_name_hashlen(
 	unsigned int		rec_sizeof)
 {
-	return rec_sizeof - offsetof(struct xfs_parent_name_rec, p_namehash);
+	return rec_sizeof - sizeof(struct xfs_parent_name_rec);
 }
 
 #endif /* __XFS_DA_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 32235a0e9e0d..6520e35178a0 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -98,7 +98,7 @@ xfs_init_parent_name_rec(
 	rec->p_ino = cpu_to_be64(dp->i_ino);
 	rec->p_gen = cpu_to_be32(VFS_IC(dp)->i_generation);
 	return xfs_parent_namehash(ip, name, rec->p_namehash,
-			sizeof(rec->p_namehash));
+			XFS_PARENT_NAME_HASH_SIZE);
 }
 
 /*
@@ -197,7 +197,7 @@ __xfs_parent_init(
 	parent->args.attr_filter = XFS_ATTR_PARENT;
 	parent->args.op_flags = XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED;
 	parent->args.name = (const uint8_t *)&parent->rec;
-	parent->args.namelen = sizeof(struct xfs_parent_name_rec);
+	parent->args.namelen = 0;
 
 	*parentp = parent;
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 4c3100760bba..3431aac75e92 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -43,8 +43,14 @@ void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec, int *reclen,
  * the defer ops machinery
  */
 struct xfs_parent_defer {
-	struct xfs_parent_name_rec	rec;
-	struct xfs_parent_name_rec	old_rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
+	union {
+		struct xfs_parent_name_rec	old_rec;
+		__u8			dummy2[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 	bool				have_log;
 };
@@ -112,7 +118,10 @@ unsigned int xfs_pptr_calc_space_res(struct xfs_mount *mp,
 
 /* Scratchpad memory so that raw parent operations don't burn stack space. */
 struct xfs_parent_scratch {
-	struct xfs_parent_name_rec	rec;
+	union {
+		struct xfs_parent_name_rec	rec;
+		__u8			dummy1[XFS_PARENT_NAME_MAX_SIZE];
+	};
 	struct xfs_da_args		args;
 };
 
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 93419956b9e5..0e625c6b0153 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -427,19 +427,19 @@ static inline unsigned int xfs_calc_pptr_link_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 static inline unsigned int xfs_calc_pptr_replace_overhead(void)
 {
 	return sizeof(struct xfs_attri_log_format) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
 			xlog_calc_iovec_len(XATTR_NAME_MAX) +
-			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec));
+			xlog_calc_iovec_len(XFS_PARENT_NAME_MAX_SIZE);
 }
 
 /*
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 2dc1eef63d96..24361ae0fd48 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -116,7 +116,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, offset,		1);
 	XFS_CHECK_OFFSET(xfs_dir2_sf_entry_t, name,		3);
 	XFS_CHECK_STRUCT_SIZE(xfs_dir2_sf_hdr_t,		10);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	76);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_name_rec,	12);
 	BUILD_BUG_ON(XFS_PARENT_NAME_HASH_SIZE != SHA512_DIGEST_SIZE);
 
 	/* log structures */

