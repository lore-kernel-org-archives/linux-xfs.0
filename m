Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C216621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710599; cv=none; b=lRyWGDOeuKGHW2HJiLUDv8gDtBfMiR/CMADbILiklIz9URPBUkPG1hf/tzE3E1LxKXCOTgSM4/kXKPM9SyCiSeWukqbQj2GISer5TGifC5bNoedk80p3QODlQO0docKYu4UNdsYaET+JSn5by0Q0cKxUHPdWC9JD0Udrsv7q4ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710599; c=relaxed/simple;
	bh=RIepamdrzH8iQ0PwIfrhJ2WCE9DXdkvmpSXySQFTfrY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ah0nYCJa6P+3MLN1SXbkgMCREaZlzPPXAoUakUsDFUn38Rpy2JmgjnMZxpk7cQWk3fa+o7fx7gnS5R4GS4A4jXeP7dnfgseqO9BK3oN/lEaZmLeIM9cLhAhgDcnh3fNgGlTwET3al6mvoAenMrsabOr6JixmkQrB6EfVT2+T7vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGAmLOAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGAmLOAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F48C433C7;
	Wed, 10 Apr 2024 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710598;
	bh=RIepamdrzH8iQ0PwIfrhJ2WCE9DXdkvmpSXySQFTfrY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FGAmLOAXJH93v6q1QiAXQ94rOxTtQN7YWrHBOebwFyVP9jkpeZvLe24epmAPxyNx/
	 TMulpJf217NwQY9v5d/W36SyqlwO3bPsoG1iK3UJZyT8dBAcBFor990yoM7AZw0k/H
	 khHS0WbnoV9H4P44/9foyLzOEnxv3v3IYf5+B2RJPl16s1IzA9ECHspX3sf7vnC4yA
	 bKyvJMGhZuI2E1SbbPJ77y3wFi85HSa2xhz2cgqqEAgtsHm9D8L7v3vimUdEbA6Ibx
	 ZgwfyKCZocK5Et8FYwTaF0NCapLfEiqWoaz1xAmgCUK129UhYMPU2KnGkGkXfOLhwd
	 w/xlG9RUoOHmg==
Date: Tue, 09 Apr 2024 17:56:38 -0700
Subject: [PATCH 12/32] xfs: record inode generation in xattr update log intent
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969756.3631889.2291525923694183307.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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

For parent pointer updates, record the i_generation of the file that is
being updated so that we don't accidentally jump generations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_format.h |    2 +-
 fs/xfs/xfs_attr_item.c         |   26 ++++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 632dd97324557..3e6682ed656b3 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -1049,7 +1049,7 @@ struct xfs_icreate_log {
 struct xfs_attri_log_format {
 	uint16_t	alfi_type;	/* attri log item type */
 	uint16_t	alfi_size;	/* size of this item */
-	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint32_t	alfi_igen;	/* generation of alfi_ino for pptr ops */
 	uint64_t	alfi_id;	/* attri identifier */
 	uint64_t	alfi_ino;	/* the inode for this attr operation */
 	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 8d33294217aca..be8660a0b55ff 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -382,14 +382,22 @@ xfs_attr_log_item(
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = attr->xattri_nameval->value.i_len;
 
-	if (xfs_attr_log_item_op(attrp) == XFS_ATTRI_OP_FLAGS_PPTR_REPLACE) {
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
 		ASSERT(attr->xattri_nameval->value.i_len ==
 		       attr->xattri_nameval->new_value.i_len);
 
+		attrp->alfi_igen = VFS_I(attr->xattri_da_args->dp)->i_generation;
 		attrp->alfi_old_name_len = attr->xattri_nameval->name.i_len;
 		attrp->alfi_new_name_len = attr->xattri_nameval->new_name.i_len;
-	} else {
+		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+		attrp->alfi_igen = VFS_I(attr->xattri_da_args->dp)->i_generation;
+		fallthrough;
+	default:
 		attrp->alfi_name_len = attr->xattri_nameval->name.i_len;
+		break;
 	}
 
 	ASSERT(!(attr->xattri_da_args->attr_filter & ~XFS_ATTRI_FILTER_MASK));
@@ -632,6 +640,19 @@ xfs_attri_recover_work(
 	if (error)
 		return ERR_PTR(error);
 
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		if (VFS_I(ip)->i_generation != attrp->alfi_igen) {
+			xfs_irele(ip);
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					attrp, sizeof(*attrp));
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+		break;
+	}
+
 	if (xfs_inode_has_attr_fork(ip)) {
 		error = xfs_attri_iread_extents(ip);
 		if (error) {
@@ -782,6 +803,7 @@ xfs_attr_relog_intent(
 	new_attrp = &new_attrip->attri_format;
 
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_igen = old_attrp->alfi_igen;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 

