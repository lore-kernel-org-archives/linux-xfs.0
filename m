Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF3E10F1
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710380; cv=none; b=hIh2LIX7X1u0JtrzPaSBJbu/xu62fpndWLcWBmCCFAJCiktqiRCRVkDhCGAklf7MM6Je0tRTYntFAlhBaYd6s23uU2KhPmyL+wJrLvNPwagRClegw4kvPfQ/7QIPMrf7alxxxAcbCJnV1tvDco2H8i7VC2Z2N8pprvlluCtgS9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710380; c=relaxed/simple;
	bh=iL03dAQ+Rv9WZj7R3zTQJDe+9aZXk/G5hcuYm2wzc6o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R6m3NMaue0SzVwy3JqUOVv/vdT0MX9o6WQVKcGK7/tzvYPDzVt447sYP+TkmxObpnwfwgRk0lQKYNokDm488TdN5wVwuhi+04PV9RDDavLER069+Q0Jd6MyZ4kWocdiMt2XQWCv0NuDG52ec/K/LscDPxnPUbPGg92dZhmgN1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+4+jx2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+4+jx2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22D1C433F1;
	Wed, 10 Apr 2024 00:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710379;
	bh=iL03dAQ+Rv9WZj7R3zTQJDe+9aZXk/G5hcuYm2wzc6o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c+4+jx2d+fsboU8J1ipYpLN6cqcVlbQ3fj9A0k6ThhJF4KW6Z5FTdXbmynykmjtPX
	 Iejhxh+GAUGt14mf2RpSnRdOoW16U8/4FFm5ZyckELvhEvzRTWrMkA0vNxjXZ9TUae
	 gY2J10BiRCFaAXXKtal/eRZwZZUIaC4V/BadBmbUXtM3N6QwYgZqIfn1cZvVLmIWjU
	 As9nk7ne2AE3wLHO83Mri1Zu3LkDgYPZ/f/clOWdhKC5fIIT4563ygkUNYSTJcHvBT
	 7w+6psOG4baY9HEfqIp6lIf2zkDvqwqQETlLV5jOh3kR2b8JjxfcCrzSpCGYfkqFdy
	 sv30W9v3/6+mg==
Date: Tue, 09 Apr 2024 17:52:59 -0700
Subject: [PATCH 10/12] xfs: use local variables for name and value length in
 _attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270969015.3631545.13851851506156175786.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're about to start using tagged unions in the xattr log format, so
create a bunch of local variables in the recovery function so we only
have to decode the log item fields once.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 8a13e2840692c..59723e5f483e2 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -738,9 +738,11 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_item       *attrip;
 	struct xfs_attri_log_format     *attri_formatp;
 	struct xfs_attri_log_nameval	*nv;
-	const void			*attr_value = NULL;
 	const void			*attr_name;
+	const void			*attr_value = NULL;
 	size_t				len;
+	unsigned int			name_len = 0;
+	unsigned int			value_len = 0;
 	unsigned int			op, i = 0;
 
 	/* Validate xfs_attri_log_format before the large memory allocation */
@@ -769,6 +771,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -777,6 +781,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -786,15 +791,14 @@ xlog_recover_attri_commit_pass2(
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
-	if (!xfs_attr_namecheck(attr_name, attri_formatp->alfi_name_len)) {
+	if (!xfs_attr_namecheck(attr_name, name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
@@ -802,8 +806,8 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
@@ -827,7 +831,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+		if (attr_value != NULL || value_len != 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -840,7 +844,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -853,9 +857,8 @@ xlog_recover_attri_commit_pass2(
 	 * name/value buffer to the recovered incore log item and drop our
 	 * reference.
 	 */
-	nv = xfs_attri_log_nameval_alloc(attr_name,
-			attri_formatp->alfi_name_len, attr_value,
-			attri_formatp->alfi_value_len);
+	nv = xfs_attri_log_nameval_alloc(attr_name, name_len,
+			attr_value, value_len);
 
 	attrip = xfs_attri_init(mp, nv);
 	memcpy(&attrip->attri_format, attri_formatp, len);

