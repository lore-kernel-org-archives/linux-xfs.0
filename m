Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD31BC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:56:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjBPU4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjBPU4D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:56:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4EE521F1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:55:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CF3360C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2870C433EF;
        Thu, 16 Feb 2023 20:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580951;
        bh=MHoo9KgKzn31KNpYVr+bq857Q28DUN5fwtbFMizX3kE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=oY31dgHtimx1EsSm8looAzIz6Ad7VRq5pjbs121EdFGBRRi9KJpGW9asKeL74z71F
         vQVED5s6FSD905nN/DAEyiIIV2ceXyW8ciBkMgh92KFPfWdzgSV+S9KBO1X/dpxXL2
         SiPutCX+DdYtnjGWD/Tneca0H5bS/dqO9tVP9UIkRKP7NxBtejMrLuig63kH6G5oYd
         fA4eCWWZHKulsqmsyoFzjP3lS8Iu33A3wmE1s+7orTp2U1/OdVBs2OwVPit0hGJXaM
         lqtkK4GYm5VN5Lk3b8/yD/4UgwN/+uTiUCVedvfRZfE73mrep9t+vGSiULqS13/t1A
         CtDNlV61pmzgg==
Date:   Thu, 16 Feb 2023 12:55:51 -0800
Subject: [PATCH 09/25] xfsprogs: Add xfs_verify_pptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879022.3476112.514649224408561663.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: b328f630fcee8dc96e0e3942355fd211f8e15a5d

Attribute names of parent pointers are not strings.  So we need to modify
attr_namecheck to verify parent pointer records when the XFS_ATTR_PARENT flag is
set.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c      |   47 ++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_attr.h      |    3 ++-
 libxfs/xfs_da_format.h |    8 ++++++++
 repair/attr_repair.c   |   19 ++++++++++++-------
 4 files changed, 66 insertions(+), 11 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 04f8e349..d5f1f488 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1575,9 +1575,33 @@ xfs_attr_node_get(
 	return error;
 }
 
-/* Returns true if the attribute entry name is valid. */
-bool
-xfs_attr_namecheck(
+/*
+ * Verify parent pointer attribute is valid.
+ * Return true on success or false on failure
+ */
+STATIC bool
+xfs_verify_pptr(
+	struct xfs_mount			*mp,
+	const struct xfs_parent_name_rec	*rec)
+{
+	xfs_ino_t				p_ino;
+	xfs_dir2_dataptr_t			p_diroffset;
+
+	p_ino = be64_to_cpu(rec->p_ino);
+	p_diroffset = be32_to_cpu(rec->p_diroffset);
+
+	if (!xfs_verify_ino(mp, p_ino))
+		return false;
+
+	if (p_diroffset > XFS_DIR2_MAX_DATAPTR)
+		return false;
+
+	return true;
+}
+
+/* Returns true if the string attribute entry name is valid. */
+static bool
+xfs_str_attr_namecheck(
 	const void	*name,
 	size_t		length)
 {
@@ -1592,6 +1616,23 @@ xfs_attr_namecheck(
 	return !memchr(name, 0, length);
 }
 
+/* Returns true if the attribute entry name is valid. */
+bool
+xfs_attr_namecheck(
+	struct xfs_mount	*mp,
+	const void		*name,
+	size_t			length,
+	int			flags)
+{
+	if (flags & XFS_ATTR_PARENT) {
+		if (length != sizeof(struct xfs_parent_name_rec))
+			return false;
+		return xfs_verify_pptr(mp, (struct xfs_parent_name_rec *)name);
+	}
+
+	return xfs_str_attr_namecheck(name, length);
+}
+
 int __init
 xfs_attr_intent_init_cache(void)
 {
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 3e81f3f4..b79dae78 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -547,7 +547,8 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_namecheck(struct xfs_mount *mp, const void *name, size_t length,
+			int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index b02b67f1..75b13807 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -731,6 +731,14 @@ xfs_attr3_leaf_name(xfs_attr_leafblock_t *leafp, int idx)
 	return &((char *)leafp)[be16_to_cpu(entries[idx].nameidx)];
 }
 
+static inline int
+xfs_attr3_leaf_flags(xfs_attr_leafblock_t *leafp, int idx)
+{
+	struct xfs_attr_leaf_entry *entries = xfs_attr3_leaf_entryp(leafp);
+
+	return entries[idx].flags;
+}
+
 static inline xfs_attr_leaf_name_remote_t *
 xfs_attr3_leaf_name_remote(xfs_attr_leafblock_t *leafp, int idx)
 {
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index c3a6d502..afe8073c 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -293,8 +293,9 @@ process_shortform_attr(
 		}
 
 		/* namecheck checks for null chars in attr names. */
-		if (!libxfs_attr_namecheck(currententry->nameval,
-					   currententry->namelen)) {
+		if (!libxfs_attr_namecheck(mp, currententry->nameval,
+					   currententry->namelen,
+					   currententry->flags)) {
 			do_warn(
 	_("entry contains illegal character in shortform attribute name\n"));
 			junkit = 1;
@@ -454,12 +455,14 @@ process_leaf_attr_local(
 	xfs_dablk_t		da_bno,
 	xfs_ino_t		ino)
 {
-	xfs_attr_leaf_name_local_t *local;
+	xfs_attr_leaf_name_local_t	*local;
+	int				flags;
 
 	local = xfs_attr3_leaf_name_local(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 	if (local->namelen == 0 ||
-	    !libxfs_attr_namecheck(local->nameval,
-				   local->namelen)) {
+	    !libxfs_attr_namecheck(mp, local->nameval,
+				   local->namelen, flags)) {
 		do_warn(
 	_("attribute entry %d in attr block %u, inode %" PRIu64 " has bad name (namelen = %d)\n"),
 			i, da_bno, ino, local->namelen);
@@ -510,12 +513,14 @@ process_leaf_attr_remote(
 {
 	xfs_attr_leaf_name_remote_t *remotep;
 	char*			value;
+	int			flags;
 
 	remotep = xfs_attr3_leaf_name_remote(leaf, i);
+	flags = xfs_attr3_leaf_flags(leaf, i);
 
 	if (remotep->namelen == 0 ||
-	    !libxfs_attr_namecheck(remotep->name,
-				   remotep->namelen) ||
+	    !libxfs_attr_namecheck(mp, remotep->name,
+				   remotep->namelen, flags) ||
 	    be32_to_cpu(entry->hashval) !=
 			libxfs_da_hashname((unsigned char *)&remotep->name[0],
 					   remotep->namelen) ||

