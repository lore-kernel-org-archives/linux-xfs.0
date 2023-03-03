Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98794C64EC4
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Mar 2023 17:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjCCRMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjCCRMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Mar 2023 12:12:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E3725975
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 09:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED7AB615DA
        for <linux-xfs@vger.kernel.org>; Fri,  3 Mar 2023 17:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50170C433EF;
        Fri,  3 Mar 2023 17:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677863518;
        bh=5JPOZ3u6ZnWuvsmfekFnah4UkWkBRdblHoejQenowPE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ghdN3P/ZlxJXhn/mB+ucHoHdy2DYHnJPOfHFurgvDEt1d0gnMngifHrASZTMayExv
         0TGRlaSsdbSkpffiWBncAXT6FB9hbyBpK5QDuViLSqZNPABfRLcjk4Qopy7zs6/Bpg
         /T0HYYVnyebkxsMATruiI+f/NE9n2P00DVUF/3miG3CS9djT3qwpN3T059I7EzJCZ9
         NAuGqQ5SCx0UkabZEaQwao8ILAGMLvbA407Scd5gWt1OVcm/lf6OZ98MsVf4PkIISh
         96uReSHJzXAfP4TMLxozhb+qtTqNpFzY+hFR60nzcH+zHYPA6Hp04bAOdN/2FtIifH
         NtIbUewJKI5jA==
Subject: [PATCH 07/13] xfs: overlay alfi_nname_len atop alfi_name_len for
 NVREPLACE
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Date:   Fri, 03 Mar 2023 09:11:57 -0800
Message-ID: <167786351788.1543331.14769917906504208002.stgit@magnolia>
In-Reply-To: <167786347827.1543331.2803518928321606576.stgit@magnolia>
References: <167786347827.1543331.2803518928321606576.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In preparation for being able to log the old attr value in a NVREPLACE
operation, encode the old and new name lengths in the alfi_name_len
field.  We haven't shipped a kernel with XFS_ATTRI_OP_FLAGS_NVREPLACE,
so we can still tweak the ondisk log item format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |   14 ++++++-
 fs/xfs/xfs_attr_item.c         |   81 ++++++++++++++++++++++++----------------
 2 files changed, 60 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 1fe9f7394812..32035786135b 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -979,11 +979,21 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	alfi_nname_len;	/* attr new name length */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
-	uint32_t	alfi_name_len;	/* attr name length */
+	union {
+		uint32_t	alfi_name_len;	/* attr name length */
+		struct {
+			/*
+			 * For NVREPLACE, these are the lengths of the old and
+			 * new attr name.
+			 */
+			uint16_t	alfi_oldname_len;
+			uint16_t	alfi_newname_len;
+		};
+	};
 	uint32_t	alfi_value_len;	/* attr value length */
 	uint32_t	alfi_attr_filter;/* attr filter flags */
 };
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 6dce2110a871..6042ba34f705 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -402,8 +402,14 @@ xfs_attr_log_item(
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
-	attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
-	attrp->alfi_nname_len = attr->xattri_nameval->nname.i_len;
+
+	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		attrp->alfi_oldname_len = attr->xattri_nameval->name.i_len;
+		attrp->alfi_newname_len = attr->xattri_nameval->nname.i_len;
+	} else {
+		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+	}
+
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
 	attrp->alfi_attr_filter = attr->xattri_da_args->attr_filter;
 }
@@ -533,10 +539,6 @@ xfs_attri_validate(
 {
 	unsigned int			op = xfs_attr_log_item_op(attrp);
 
-	if (attrp->alfi_op_flags != XFS_ATTRI_OP_FLAGS_NVREPLACE &&
-	    attrp->alfi_nname_len != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -545,29 +547,37 @@ xfs_attri_validate(
 
 	/* alfi_op_flags should be either a set or remove */
 	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		if (attrp->alfi_value_len != 0)
+			return false;
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
-	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREMOVE:
 	case XFS_ATTRI_OP_FLAGS_NVSET:
+		if (attrp->alfi_name_len == 0 ||
+		    attrp->alfi_name_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
+		break;
+	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		if (attrp->alfi_oldname_len == 0 ||
+		    attrp->alfi_oldname_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_newname_len == 0 ||
+		    attrp->alfi_newname_len > XATTR_NAME_MAX)
+			return false;
+		if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+			return false;
 		break;
 	default:
 		return false;
 	}
 
-	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
-		return false;
-
-	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_nname_len > XATTR_NAME_MAX) ||
-	    (attrp->alfi_name_len == 0))
-		return false;
-
-	if (op == XFS_ATTRI_OP_FLAGS_REMOVE &&
-	    attrp->alfi_value_len != 0)
-		return false;
-
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
@@ -737,8 +747,12 @@ xfs_attri_item_relog(
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
-	new_attrp->alfi_name_len = old_attrp->alfi_name_len;
-	new_attrp->alfi_nname_len = old_attrp->alfi_nname_len;
+	if (xfs_attr_log_item_op(old_attrp) == XFS_ATTRI_OP_FLAGS_NVREPLACE) {
+		new_attrp->alfi_newname_len = old_attrp->alfi_newname_len;
+		new_attrp->alfi_oldname_len = old_attrp->alfi_oldname_len;
+	} else {
+		new_attrp->alfi_name_len = old_attrp->alfi_name_len;
+	}
 	new_attrp->alfi_attr_filter = old_attrp->alfi_attr_filter;
 
 	xfs_trans_add_item(tp, &new_attrip->attri_item);
@@ -762,6 +776,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_name;
 	size_t				len;
 	const void			*attr_nname = NULL;
+	unsigned int			name_len = 0, newname_len = 0;
 	int				op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -790,6 +805,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		if (item->ri_total != 2) {
@@ -797,6 +813,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
 		if (item->ri_total != 3 && item->ri_total != 4) {
@@ -804,6 +821,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_oldname_len;
+		newname_len = attri_formatp->alfi_newname_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -813,15 +832,14 @@ xlog_recover_attri_commit_pass2(
 
 	i++;
 	/* Validate the attr name */
-	if (item->ri_buf[i].i_len !=
-			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {
+	if (item->ri_buf[i].i_len != xlog_calc_iovec_len(name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(mp, attr_name, attri_formatp->alfi_name_len,
+	if (!xfs_attr_namecheck(mp, attr_name, name_len,
 				attri_formatp->alfi_attr_filter)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				item->ri_buf[i].i_addr, item->ri_buf[i].i_len);
@@ -829,10 +847,9 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	i++;
-	if (attri_formatp->alfi_nname_len) {
+	if (newname_len > 0) {
 		/* Validate the attr nname */
-		if (item->ri_buf[i].i_len !=
-		    xlog_calc_iovec_len(attri_formatp->alfi_nname_len)) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(newname_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
 					item->ri_buf[i].i_len);
@@ -840,8 +857,7 @@ xlog_recover_attri_commit_pass2(
 		}
 
 		attr_nname = item->ri_buf[i].i_addr;
-		if (!xfs_attr_namecheck(mp, attr_nname,
-				attri_formatp->alfi_nname_len,
+		if (!xfs_attr_namecheck(mp, attr_nname, newname_len,
 				attri_formatp->alfi_attr_filter)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[i].i_addr,
@@ -868,9 +884,8 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_nname,
-			attri_formatp->alfi_nname_len, attr_value,
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len, attr_nname,
+			newname_len, attr_value,
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);

