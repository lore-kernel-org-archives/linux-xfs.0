Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7246AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230919; cv=none; b=n9sy/fG0RuCVUBEpbpimnGl6qBB6ohp4OZkUNExa6QTYwCkK8aegXnNPzpAoZwXBSBkD22v/RO3nIBf9fmSicrBlE6FrddIgWmxHeZMtaZF7xZhi8Rqy/r9KBgf4h4NyPXWBEwOMR+Opj6QQYmZalgd1QjE3sSE1LoHqH2Gbow4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230919; c=relaxed/simple;
	bh=FXIyDy/YckfHDiUBTOLnfFSBlMExhfiLBhF+/TvreX8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOqHYYpKEu1ymZJu1NqRllfgIh2MhGV7SW22/ZpcOGrZheRSxLNU5PHQ6y4c1E2BEOZBg1sfwFUUW9oeoaYrukL+20qevjg4EXbKOnTDrIjp9/o1hOUgmirgqUWOvTUs5kuDbm8iT7v4n6sn8sI7elzak24o4yt+HF/kXBxf5mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ECUw8Mnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECUw8Mnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895DEC113CC;
	Tue, 16 Apr 2024 01:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230919;
	bh=FXIyDy/YckfHDiUBTOLnfFSBlMExhfiLBhF+/TvreX8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ECUw8MncfPRQr7/xZwQzy2rb11fbvHQMLRmE5Ao2bZqxN8GZpyfeXt60F/Oh9A3GU
	 iAx3iPmT+QBi2i6w1S/vo4DcytI+25EbE/83/KtRt/Znj7uD0scqRMQC2ZNJWKG+iR
	 TcfX9BMcPeNXlQYoPmTxAlH/LIYpRgHJrQVOWs8CwzhC8XpOTvIqHd0GwLKXmw3z3B
	 ku/Pgz4DxsVZeRiCsMdTw70/77yEVonujmwxeh3UXV4zIhDmfiBKxpksUR0msAttYt
	 cElY0Rp+t02dTzGItg2abj9E0U0vdCogb3lgXC+R0dzOxSpFNvx/9s2TN02jsErFqW
	 QcksMM3n1+QMQ==
Date: Mon, 15 Apr 2024 18:28:39 -0700
Subject: [PATCH 10/31] xfs: record inode generation in xattr update log intent
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, hch@infradead.org,
 linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Message-ID: <171323027948.251715.16414467417803139677.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_attr_item.c         |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)


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
index 8fc03195d9751..f52529cccc393 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -388,9 +388,14 @@ xfs_attr_log_item(
 	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
 		ASSERT(nv->value.i_len == nv->new_value.i_len);
 
+		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
 		attrp->alfi_old_name_len = nv->name.i_len;
 		attrp->alfi_new_name_len = nv->new_name.i_len;
 		break;
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+		attrp->alfi_igen = VFS_I(args->dp)->i_generation;
+		fallthrough;
 	default:
 		attrp->alfi_name_len = nv->name.i_len;
 		break;
@@ -545,9 +550,6 @@ xfs_attri_validate(
 {
 	unsigned int			op = xfs_attr_log_item_op(attrp);
 
-	if (attrp->__pad != 0)
-		return false;
-
 	if (attrp->alfi_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK)
 		return false;
 
@@ -639,9 +641,27 @@ xfs_attri_recover_work(
 	int				local;
 	int				error;
 
-	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
-	if (error)
-		return ERR_PTR(error);
+	/*
+	 * Parent pointer attr items record the generation but regular logged
+	 * xattrs do not; select the right iget function.
+	 */
+	switch (xfs_attr_log_item_op(attrp)) {
+	case XFS_ATTRI_OP_FLAGS_PPTR_SET:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REPLACE:
+	case XFS_ATTRI_OP_FLAGS_PPTR_REMOVE:
+		error = xlog_recover_iget_handle(mp, attrp->alfi_ino,
+				attrp->alfi_igen, &ip);
+		break;
+	default:
+		error = xlog_recover_iget(mp, attrp->alfi_ino, &ip);
+		break;
+	}
+	if (error) {
+		xfs_irele(ip);
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
+				sizeof(*attrp));
+		return ERR_PTR(-EFSCORRUPTED);
+	}
 
 	if (xfs_inode_has_attr_fork(ip)) {
 		error = xfs_attri_iread_extents(ip);
@@ -793,6 +813,7 @@ xfs_attr_relog_intent(
 	new_attrp = &new_attrip->attri_format;
 
 	new_attrp->alfi_ino = old_attrp->alfi_ino;
+	new_attrp->alfi_igen = old_attrp->alfi_igen;
 	new_attrp->alfi_op_flags = old_attrp->alfi_op_flags;
 	new_attrp->alfi_value_len = old_attrp->alfi_value_len;
 

