Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493B329429
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928512; cv=none; b=YuFBcLX1zPdQ/E2cNlymxZ8kRQV7yDYzaFkWjpzvlQWa1PWt+QyQpBjmOyECCWyANaAgo+FTjx/35Xgoc1MkSjlZC6NG4MD5mbK4+GQO30Ot0lLkwjWhPpdHTxUYaeUte96O/WBZddshDu8cIkh+WLHE8uvvNrw+0YJluYj1kjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928512; c=relaxed/simple;
	bh=BgSlbFb08mybqkNJT8XLWgOhFlaxLGi4DOaWodsvi5M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLKvpcKlQBJMggjX1Rc/iW29f+a5C4IGCIiSUjOmNX26Pey2S2dBotXWc+evNkBx2dBmtoUmtMDc0zE5bGelcfq0eAaon6wENr/OgXCmSIMchN86Z4PYtnIb3tpglHMM8JI36EZv/08xZ5+tH7htZ5uuaH+0tNeXZ3WylmxZa+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TWEFwVDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TWEFwVDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CDC116B1;
	Wed, 24 Apr 2024 03:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928512;
	bh=BgSlbFb08mybqkNJT8XLWgOhFlaxLGi4DOaWodsvi5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TWEFwVDDr6OaZfHamzoggFCfsBLsC4SGTeAcWsPjbIihXizhQju0oDMvgbuyUs9Sv
	 eqTrHStLPYsalK7X6dvl3sB++v4xoCyu/bNjE51EZoZWIh2vWd7cc/VIwMCuQ8HVLi
	 B8JDpXaVoqWXmiTTXmJeN7FKidaoLGho9fIhxPcEuEXtNPQYZPEb67W930mfQ9THcp
	 kYz+Jxv6YXg5gjB9y2Zz0i8xsxsZsrCJrEhTAmM7D4ZpiRn/4cqegn77VKhHMkF5p4
	 5xm5nXK+K2FF1MkWz9Y7fBzbyCQpHLbdwWP+4Jopqh+utK+evUsQMiuxnXKXX+73zW
	 VoOv9R4NjpoZw==
Date: Tue, 23 Apr 2024 20:15:11 -0700
Subject: [PATCH 10/30] xfs: record inode generation in xattr update log intent
 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392783435.1905110.16885800600497620512.stgit@frogsfrogsfrogs>
In-Reply-To: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
References: <171392783191.1905110.6347010840682949070.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |    2 +-
 fs/xfs/xfs_attr_item.c         |   33 +++++++++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 632dd9732455..3e6682ed656b 100644
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
index be5064f5a531..2898eeb16366 100644
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
 

