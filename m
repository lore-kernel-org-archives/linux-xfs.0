Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871088;
	b=y6HXEpCr9E9IEYLx7LkBFhw/cKDjNkyyHRU96HJZN3N5MPEXaRVi0AbouGfDisO0KlGa
	 ykqaHcG7+G4jKWObw9XJn+6MC9c3vDbWtgmDcp7Xy0mlitestfDU94mz+HJJfzYDnzTnj
	 hCAZYXb/rOwIib6bt+z1y0ricXO2HuyAFy9Tq2VgF9ozGfbL+TApOmU5L4dNU7JTjv66a
	 EJytnU7hKyidZuFMbw1bNjMtCNefwgp2Hx8THzyV6p6QL3sAoV8/TFxtSJnAkZZcMQutB
	 L2bbBRhwQ3d4Os7Qg7KBlSeKymLF0efE0/ggOEnu9oMMw6mzrtis4uv6fT//9JcnKdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=CZb9z3ZgzJRzm7SpNHjXcpxleFWEyIE2lZ4jVo5e9eQ=;
	b=hvOgZAuHIHO4unPwec9PRkF3EPqVwS8SQZ9WkNbO3MbpT4d5IfFimmmZ8P4NNhePPhSh
	 khfXhC7VAgZ6f2vKBRM2+TAQ+pkddfbD+KYZGeKf7e+zSZAUdGcO8jHy0PRb1QmOaGEJe
	 OIpdhD3vnRUkJooWafSg7wRCstkuT/8FDEHHaLbaTkSPnjfYxNIbLAHh+Ous83HMSo/w0
	 C5U43nXZrtddf9NOmPkx7au0IsFWUt6BgZfWfWoKoZ8PHLPMweFQgGfFJDooozPtGo7iM
	 y14Ws0kBm+Jp9rHKB/8FUJc+13DPoSniI6pE4UYjGQYDwSoHsq/B1xBSqCjR5wdGvqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PA5A8Lex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361B5606A329
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PA5A8Lex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B01F000C5;
	Mon, 16 Nov 2026 23:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871088;
	bh=CZb9z3ZgzJRzm7SpNHjXcpxleFWEyIE2lZ4jVo5e9eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PA5A8LexrcKT17nu6LgMKeRJ9PtCDftH2e/jojlcp0KRVddwwuHFJMEdV8Te6lcTa
	 kGu7JzfxEChDGKnEAGApRmxhaT7sQbwNwbzy+JF0UvXgu/3lHpZKACljfQWZOzdzfL
	 LOcz26e/ywU3gsjKAkBeK5kzAgfclWEJl2aCwHookesd+JXMcEBbONXo4rxx5qQDyf
	 31E0hOR9KAGJX8svth48J1etKGVbK1CLjAjJwz/bBgu8tkP9JBBIm5yn+hPPVse4lW
	 m80z0RR3qzdop6cZJFkAZTVDrBo7esNpekJ3O7NKT5YY2iiamoLXTgfessjL1iK2Td
	 E0iSytbGE8Awg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 42/59] xfs: validate attr intents during recovery
Date: Tue, 17 Nov 2026 10:14:59 +1100
Message-ID: <20261116231707.3625263-43-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
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

