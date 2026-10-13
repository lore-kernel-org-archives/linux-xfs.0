Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2A630ACE6
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871370; cv=none; b=foh+ugvb4g9F6u7ZTjgj2FuBsCC8uadp8vvbjayV3qIDaFuNx4sWxdNBdW8VU7JXI6j5NauN5baZp7nzAQvRWFZ+bBNxVVKrTwM++d7lWGxIOYsY0aLqC7cQJmM93n0vjrDCqPjnOfgXX3YxNKx9vUos08BUjau4zZ4DNBphLHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871370; c=relaxed/simple;
	bh=hBWsOK773KldNUWeXGoNt8BIbADEov8pTzF/bT+b+P4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWBmPfbXjez72NobmSBou/CK/A9xllkSFTcNhOEqP17HSZC6u0nDcSMGOC8rn2fh1U61dVcdTY+qdk2nvdtND7gdqcHthbISVA67v2NUa6eETpfiyj581dpgAZBzwcMw8C1mC4wPBSHClYHiE9+ZSEOyzslo0/0d6WGqOBSRJw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRTyECoF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRTyECoF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF14E1F00898;
	Tue, 13 Oct 2026 06:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871368;
	bh=CZb9z3ZgzJRzm7SpNHjXcpxleFWEyIE2lZ4jVo5e9eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aRTyECoF/PUkIDi0i4JX5if92ffVuJLLIojd+0D6jtKNSLy7/AcF6aK8pizZJtIBJ
	 oilFbvPyIVVaTYa34/p84SRayB5TbDRttFxgC8nw9OOcdPVZkJKBFwYKkBEsFL2zNM
	 rJt0PVRDMA1cas17YybZ08ZeYbK/fa244tz9zj9kvG43cj3aMU031WEvJ95aecc5lv
	 /oBgO6Dh5g1AhSf/iHOrmSYpD2SBAOGdcEpv8nU2qBKNtARKXfJMUF1hjrnGQW2lv4
	 lPGzLVTk3F2EnHqErur92kH/zymD0oe5WlwUAb4Xq+ua7WdUCYzJLsyXivmL8HID5x
	 ZrzpSahne8hZQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 32/48] xfs: validate attr intents during recovery
Date: Tue, 13 Oct 2026 17:01:22 +1100
Message-ID: <20261013060204.3138690-33-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An attr intent is a format header region followed by up to four name and value
regions, the number and contents of which depend on the operation it describes.
Recovery validated all of this inline in the commit handler, interleaved with
building the in-core item, so the item was validated only as it was being set
up for replay.

Validate the attr intent as it is decoded instead. Region lengths are bounded
as the regions are assembled. Exact region length validation is done during
item validation. The commit handler is then left to do only the replay setup:
pull the validated name and value regions out of the item and build the in-core
intent from them.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_attr_item.c | 249 +++++++++++++++++++++++++----------------
 1 file changed, 151 insertions(+), 98 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a6e36b2aa7b3..cd0225957c6d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -1002,151 +1002,200 @@ xlog_recover_attri_commit_pass2(
 {
 	struct xfs_mount                *mp = log->l_mp;
 	struct xfs_attri_log_item       *attrip;
-	struct xfs_attri_log_format     *attri_formatp;
+	struct xfs_attri_log_format     *attri_formatp = item->ri_buf[0].iov_base;
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_name;
 	const void			*attr_value = NULL;
 	const void			*attr_new_name = NULL;
 	const void			*attr_new_value = NULL;
-	size_t				len;
 	unsigned int			name_len = 0;
 	unsigned int			value_len = 0;
 	unsigned int			new_name_len = 0;
 	unsigned int			new_value_len = 0;
-	unsigned int			op, i = 0;
+	unsigned int			i = 1;
 
-	/* Validate xfs_attri_log_format before the large memory allocation */
-	len = sizeof(struct xfs_attri_log_format);
-	if (item->ri_buf[i].iov_len != len) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				item->ri_buf[0].iov_base, item->ri_buf[0].iov_len);
-		return -EFSCORRUPTED;
+	/*
+	 * The item has already been validated, so pull the name and value
+	 * lengths out of the format header. The regions present depend on the
+	 * operation being performed.
+	 */
+	switch (xfs_attr_log_item_op(attri_formatp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		name_len = attri_formatp->alfi_name_len;
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+		name_len = attri_formatp->alfi_old_name_len;
+		new_name_len = attri_formatp->alfi_new_name_len;
+		new_value_len = value_len = attri_formatp->alfi_value_len;
+		break;
 	}
 
-	attri_formatp = item->ri_buf[i].iov_base;
-	if (!xfs_attri_validate(mp, attri_formatp)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
+	/* Pull the name and value regions out in the order they are logged. */
+	attr_name = item->ri_buf[i++].iov_base;
+	if (new_name_len > 0)
+		attr_new_name = item->ri_buf[i++].iov_base;
+	if (value_len > 0)
+		attr_value = item->ri_buf[i++].iov_base;
+	if (new_value_len > 0)
+		attr_new_value = item->ri_buf[i++].iov_base;
+
+	/*
+	 * Memory alloc failure will cause replay to abort.  We attach the
+	 * name/value buffer to the recovered incore log item and drop our
+	 * reference.
+	 */
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
+			attr_new_name, new_name_len,
+			attr_value, value_len,
+			attr_new_value, new_value_len);
+
+	attrip = xfs_attri_init(mp, nv);
+	memcpy(&attrip->attri_format, attri_formatp,
+			sizeof(struct xfs_attri_log_format));
+
+	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
+			&xfs_attr_defer_type);
+	xfs_attri_log_nameval_put(nv);
+	return 0;
+}
+
+/*
+ * An attri has a format header region followed by up to four name and value
+ * regions, the exact number depending on the operation it describes. The exact
+ * count for the operation is checked once the format header is decoded in
+ * ->validate_item(); here we only bound the count to the possible range.
+ */
+static int
+xlog_recover_attri_nregions(
+	struct xlog			*log,
+	uint16_t			nregions)
+{
+	if (nregions < 2 || nregions > 5)
 		return -EFSCORRUPTED;
+	return nregions;
+}
+
+/*
+ * Bound each region by its largest possible size. Region 0 is the fixed size
+ * format header. Region 1 is always a name, so no larger than a maximum length
+ * attr name. Regions 2 to 4 may be a name or a value, so no larger than a
+ * maximum length attr value. This detects an unbounded continuation of a region
+ * before the exact per-operation sizes are checked in ->validate_item().
+ */
+static int
+xlog_recover_attri_validate_region(
+	struct xlog			*log,
+	struct xlog_recover_item	*item,
+	int				region_index)
+{
+	size_t				len = item->ri_buf[region_index].iov_len;
+
+	if (region_index == 0) {
+		if (len != sizeof(struct xfs_attri_log_format))
+			goto out_error;
+		return 0;
 	}
 
-	/* Check the number of log iovecs makes sense for the op code. */
-	op = xfs_attr_log_item_op(attri_formatp);
-	switch (op) {
+	if (region_index == 1) {
+		if (len > xlog_calc_iovec_len(XATTR_NAME_MAX))
+			goto out_error;
+		return 0;
+	}
+
+	if (len > xlog_calc_iovec_len(XATTR_SIZE_MAX))
+		goto out_error;
+	return 0;
+
+out_error:
+	xfs_warn(log->l_mp, "ATTRI: bad region %d length %zu recovered.",
+			region_index, len);
+	return -EFSCORRUPTED;
+}
+
+/*
+ * Validate the whole attri: the format header, the exact region count for the
+ * operation it describes, and the name and value regions that operation
+ * requires. Once this passes, the rest of recovery can walk the regions without
+ * checking them.
+ */
+static int
+xlog_recover_attri_validate_item(
+	struct xlog			*log,
+	struct xlog_recover_item	*item)
+{
+	struct xfs_mount		*mp = log->l_mp;
+	struct xfs_attri_log_format	*attri_formatp = item->ri_buf[0].iov_base;
+	unsigned int			name_len = 0;
+	unsigned int			value_len = 0;
+	unsigned int			new_name_len = 0;
+	unsigned int			new_value_len = 0;
+	unsigned int			i = 1;
+
+	if (!xfs_attri_validate(mp, attri_formatp))
+		return -EFSCORRUPTED;
+
+	/* Check the number of regions makes sense for the op code. */
+	switch (xfs_attr_log_item_op(attri_formatp)) {
 	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
 	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
-		/* Log item, attr name, attr value */
-		if (item->ri_total != 3) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
+		/* Format header, attr name, attr value */
+		if (item->ri_total != 3)
 			return -EFSCORRUPTED;
-		}
 		name_len = attri_formatp->alfi_name_len;
 		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		/* Log item, attr name, optional attr value */
-		if (item->ri_total != 2 + !!attri_formatp->alfi_value_len) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
+		/* Format header, attr name, optional attr value */
+		if (item->ri_total != (2 + !!attri_formatp->alfi_value_len))
 			return -EFSCORRUPTED;
-		}
 		name_len = attri_formatp->alfi_name_len;
 		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		/* Log item, attr name */
-		if (item->ri_total != 2) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
+		/* Format header, attr name */
+		if (item->ri_total != 2)
 			return -EFSCORRUPTED;
-		}
 		name_len = attri_formatp->alfi_name_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
-		/*
-		 * Log item, attr name, new attr name, attr value, new attr
-		 * value
-		 */
-		if (item->ri_total != 5) {
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-					     attri_formatp, len);
+		/* Format header, attr name, new name, attr value, new value */
+		if (item->ri_total != 5)
 			return -EFSCORRUPTED;
-		}
 		name_len = attri_formatp->alfi_old_name_len;
 		new_name_len = attri_formatp->alfi_new_name_len;
 		new_value_len = value_len = attri_formatp->alfi_value_len;
 		break;
 	default:
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				     attri_formatp, len);
 		return -EFSCORRUPTED;
 	}
-	i++;
 
-	/* Validate the attr name */
-	attr_name = xfs_attri_validate_name_iovec(mp, attri_formatp,
-			&item->ri_buf[i], name_len);
-	if (!attr_name)
+	if (!xfs_attri_validate_name_iovec(mp, attri_formatp, &item->ri_buf[i++],
+			name_len))
 		return -EFSCORRUPTED;
-	i++;
-
-	/* Validate the new attr name */
-	if (new_name_len > 0) {
-		attr_new_name = xfs_attri_validate_name_iovec(mp,
-					attri_formatp, &item->ri_buf[i],
-					new_name_len);
-		if (!attr_new_name)
-			return -EFSCORRUPTED;
-		i++;
-	}
-
-	/* Validate the attr value, if present */
-	if (value_len != 0) {
-		attr_value = xfs_attri_validate_value_iovec(mp, attri_formatp,
-				&item->ri_buf[i], value_len);
-		if (!attr_value)
-			return -EFSCORRUPTED;
-		i++;
-	}
-
-	/* Validate the new attr value, if present */
-	if (new_value_len != 0) {
-		attr_new_value = xfs_attri_validate_value_iovec(mp,
-					attri_formatp, &item->ri_buf[i],
-					new_value_len);
-		if (!attr_new_value)
-			return -EFSCORRUPTED;
-		i++;
-	}
 
-	/*
-	 * Make sure we got the correct number of buffers for the operation
-	 * that we just loaded.
-	 */
-	if (i != item->ri_total) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				attri_formatp, len);
+	if (new_name_len > 0 &&
+	    !xfs_attri_validate_name_iovec(mp, attri_formatp, &item->ri_buf[i++],
+			new_name_len))
 		return -EFSCORRUPTED;
-	}
 
-	/*
-	 * Memory alloc failure will cause replay to abort.  We attach the
-	 * name/value buffer to the recovered incore log item and drop our
-	 * reference.
-	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
-			attr_new_name, new_name_len,
-			attr_value, value_len,
-			attr_new_value, new_value_len);
+	if (value_len > 0 &&
+	    !xfs_attri_validate_value_iovec(mp, attri_formatp, &item->ri_buf[i++],
+			value_len))
+		return -EFSCORRUPTED;
 
-	attrip = xfs_attri_init(mp, nv);
-	memcpy(&attrip->attri_format, attri_formatp, len);
+	if (new_value_len > 0 &&
+	    !xfs_attri_validate_value_iovec(mp, attri_formatp, &item->ri_buf[i++],
+			new_value_len))
+		return -EFSCORRUPTED;
 
-	xlog_recover_intent_item(log, &attrip->attri_item, lsn,
-			&xfs_attr_defer_type);
-	xfs_attri_log_nameval_put(nv);
 	return 0;
 }
 
@@ -1210,6 +1259,10 @@ static const struct xfs_item_ops xfs_attri_item_ops = {
 
 const struct xlog_recover_item_ops xlog_attri_item_ops = {
 	.item_type	= XFS_LI_ATTRI,
+	.min_hdr_len	= sizeof(struct xfs_attri_log_format),
+	.validate_nregions = xlog_recover_attri_nregions,
+	.validate_region = xlog_recover_attri_validate_region,
+	.validate_item	= xlog_recover_attri_validate_item,
 	.commit_pass2	= xlog_recover_attri_commit_pass2,
 };
 
-- 
2.55.0

