Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A224C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Mar 2022 21:53:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238136AbiCJVyz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Mar 2022 16:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344170AbiCJVyy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67EE6194161
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 103CEB80CB3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE325C340E8;
        Thu, 10 Mar 2022 21:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949228;
        bh=8MOMsqC6/jBRUEc0rsnaXiz2l9nBlFp9h5pxXxdShSk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FAulHX3VJhHDQbgeed5vElRWJzulJb0zd4R583IEHnDjVhUlC+39BRESub2ZLG9ed
         jWnruJPF/4/EfnhnS7BDT6Llt2iHpC90fWoEC7EpMczBW3odNpLKUnUVzJxwKm4MmJ
         s7P2j1LRtjtVWagJ6Bobp1Ibc3y5opsVVjA8jtMPmpt0nE4L9rTr0umn6xc6UpAcxr
         E0/dV9uj/q5DPWC1FGHDb54NGRDrnil7ZOMiQGqe1EDBcbFH/pOoEXPXwYdNDY4oI4
         YYQvczAnWK7JwSAF9hjueRGUdlpQ7eS3Yfy4xICFZstgg8jvSIlpy9fm81nWRnqbdc
         sV6BaOHyS+RAQ==
Subject: [PATCH 1/2] xfs: constify the name argument to various directory
 functions
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 10 Mar 2022 13:53:48 -0800
Message-ID: <164694922826.1119724.12550266189537977635.stgit@magnolia>
In-Reply-To: <164694922267.1119724.17942999738634110525.stgit@magnolia>
References: <164694922267.1119724.17942999738634110525.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Various directory functions do not modify their @name parameter,
so mark it const to make that clear.  This will enable us to mark
the global xfs_name_dotdot variable as const to prevent mischief.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c      |   30 +++++++++++++++---------------
 fs/xfs/libxfs/xfs_dir2.h      |    6 +++---
 fs/xfs/libxfs/xfs_dir2_priv.h |    5 +++--
 fs/xfs/xfs_inode.c            |    6 +++---
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_trace.h            |    4 ++--
 6 files changed, 27 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 50546eadaae2..6b531a659b1e 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -54,10 +54,10 @@ xfs_mode_to_ftype(
  */
 xfs_dahash_t
 xfs_ascii_ci_hashname(
-	struct xfs_name	*name)
+	const struct xfs_name	*name)
 {
-	xfs_dahash_t	hash;
-	int		i;
+	xfs_dahash_t		hash;
+	int			i;
 
 	for (i = 0, hash = 0; i < name->len; i++)
 		hash = tolower(name->name[i]) ^ rol32(hash, 7);
@@ -243,7 +243,7 @@ int
 xfs_dir_createname(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		inum,		/* new entry inode number */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
@@ -337,16 +337,16 @@ xfs_dir_cilookup_result(
 
 int
 xfs_dir_lookup(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*dp,
-	struct xfs_name	*name,
-	xfs_ino_t	*inum,		/* out: inode number */
-	struct xfs_name *ci_name)	/* out: actual name if CI match */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		*inum,	  /* out: inode number */
+	struct xfs_name		*ci_name) /* out: actual name if CI match */
 {
-	struct xfs_da_args *args;
-	int		rval;
-	int		v;		/* type-checking value */
-	int		lock_mode;
+	struct xfs_da_args	*args;
+	int			rval;
+	int			v;	  /* type-checking value */
+	int			lock_mode;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	XFS_STATS_INC(dp->i_mount, xs_dir_lookup);
@@ -475,7 +475,7 @@ int
 xfs_dir_replace(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,		/* name of entry to replace */
+	const struct xfs_name	*name,		/* name of entry to replace */
 	xfs_ino_t		inum,		/* new inode number */
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
@@ -728,7 +728,7 @@ xfs_dir2_namecheck(
 xfs_dahash_t
 xfs_dir2_hashname(
 	struct xfs_mount	*mp,
-	struct xfs_name		*name)
+	const struct xfs_name	*name)
 {
 	if (unlikely(xfs_has_asciici(mp)))
 		return xfs_ascii_ci_hashname(name);
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index d03e6098ded9..55e0557000db 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -39,16 +39,16 @@ extern int xfs_dir_isempty(struct xfs_inode *dp);
 extern int xfs_dir_init(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_inode *pdp);
 extern int xfs_dir_createname(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t inum,
+				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t *inum,
+				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t inum,
+				const struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name);
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 711709a2aa53..7404a9ff1a92 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -40,7 +40,7 @@ struct xfs_dir3_icfree_hdr {
 };
 
 /* xfs_dir2.c */
-xfs_dahash_t xfs_ascii_ci_hashname(struct xfs_name *name);
+xfs_dahash_t xfs_ascii_ci_hashname(const struct xfs_name *name);
 enum xfs_dacmp xfs_ascii_ci_compname(struct xfs_da_args *args,
 		const unsigned char *name, int len);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
@@ -201,7 +201,8 @@ xfs_dir2_data_entsize(
 	return round_up(len, XFS_DIR2_DATA_ALIGN);
 }
 
-xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp, struct xfs_name *name);
+xfs_dahash_t xfs_dir2_hashname(struct xfs_mount *mp,
+		const struct xfs_name *name);
 enum xfs_dacmp xfs_dir2_compname(struct xfs_da_args *args,
 		const unsigned char *name, int len);
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 35a2489942e5..67ece991d3f5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -658,9 +658,9 @@ xfs_ip2xflags(
  */
 int
 xfs_lookup(
-	xfs_inode_t		*dp,
-	struct xfs_name		*name,
-	xfs_inode_t		**ipp,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	struct xfs_inode	**ipp,
 	struct xfs_name		*ci_name)
 {
 	xfs_ino_t		inum;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b7e8f14d9fca..740ab13d1aa2 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -402,7 +402,7 @@ enum layout_break_reason {
 
 int		xfs_release(struct xfs_inode *ip);
 void		xfs_inactive(struct xfs_inode *ip);
-int		xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
+int		xfs_lookup(struct xfs_inode *dp, const struct xfs_name *name,
 			   struct xfs_inode **ipp, struct xfs_name *ci_name);
 int		xfs_create(struct user_namespace *mnt_userns,
 			   struct xfs_inode *dp, struct xfs_name *name,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a8076ef8cb4..239c8b8a5a85 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -933,7 +933,7 @@ DEFINE_IREF_EVENT(xfs_inode_unpin);
 DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
 
 DECLARE_EVENT_CLASS(xfs_namespace_class,
-	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name),
 	TP_ARGS(dp, name),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -956,7 +956,7 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 
 #define DEFINE_NAMESPACE_EVENT(name) \
 DEFINE_EVENT(xfs_namespace_class, name, \
-	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name), \
 	TP_ARGS(dp, name))
 DEFINE_NAMESPACE_EVENT(xfs_remove);
 DEFINE_NAMESPACE_EVENT(xfs_link);

