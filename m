Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7DBA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSEhlDCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674CBC433C7;
	Sun, 31 Dec 2023 20:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055663;
	bh=te6+QFbiUlaTjreEuZoTMAW57J1olFys5dHXBNuDdsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HSEhlDCGrVcmafqGXSJl0egrToNI7jjcumWLmZi0CoQVRrYgdxyYCKamkI1KhwMqb
	 IPrxMe787QzxMn/l4SoEBEu/VfIlv7KkYFJXgD0cj/4rK5q8nsVhHpn06BLBtqI1CM
	 0+VWneq5qcSfiaQ0kZNlD75MJEIlkFTSWTUGk5FkYBE/w5Jbzz9viniXM2pQH/zGaP
	 NFkvS5uENub1jZa/GqX+Hx0z458hSTVDnVPzP3/ZAMtqBaxTZJzuCOQ7B2N8xZ5e4K
	 byuxfMPSwcy1m8e+vadGY6FnJnM+3bdnch2HVuMCJ2LDpL+Uo0eYOYcUxH6NfdO6cY
	 NGsL3W1/JcCBA==
Date: Sun, 31 Dec 2023 12:47:42 -0800
Subject: [PATCH 11/14] xfs: use local variables for name and value length in
 _attri_commit_pass2
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840577.1756514.14919447984066330984.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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
index fbf392ab2dc5b..19fc535b4a22b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -709,9 +709,11 @@ xlog_recover_attri_commit_pass2(
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
@@ -740,6 +742,8 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
+		value_len = attri_formatp->alfi_value_len;
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Log item, attr name */
@@ -748,6 +752,7 @@ xlog_recover_attri_commit_pass2(
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
 		}
+		name_len = attri_formatp->alfi_name_len;
 		break;
 	default:
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
@@ -757,15 +762,14 @@ xlog_recover_attri_commit_pass2(
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
@@ -773,8 +777,8 @@ xlog_recover_attri_commit_pass2(
 	i++;
 
 	/* Validate the attr value, if present */
-	if (attri_formatp->alfi_value_len != 0) {
-		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(attri_formatp->alfi_value_len)) {
+	if (value_len != 0) {
+		if (item->ri_buf[i].i_len != xlog_calc_iovec_len(value_len)) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					item->ri_buf[0].i_addr,
 					item->ri_buf[0].i_len);
@@ -798,7 +802,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
 		/* Regular remove operations operate only on names. */
-		if (attr_value != NULL || attri_formatp->alfi_value_len != 0) {
+		if (attr_value != NULL || value_len != 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -811,7 +815,7 @@ xlog_recover_attri_commit_pass2(
 		 * and do not take a newname.  Values are optional for set and
 		 * replace.
 		 */
-		if (attr_name == NULL || attri_formatp->alfi_name_len == 0) {
+		if (attr_name == NULL || name_len == 0) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
 			return -EFSCORRUPTED;
@@ -824,9 +828,8 @@ xlog_recover_attri_commit_pass2(
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

