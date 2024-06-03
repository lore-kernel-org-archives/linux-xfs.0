Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C72E130492
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441412; cv=none; b=aOEavHprOAW2hIUIyqfhFUcP1msu2cGWcpS/s1uaJlysGAkeMdmsc7OR2KNti4xZGNHY0qRbKa5DdCgzbeqXlzLusOQVdHBnpidaNdODowelhmS/MNAuORITS7ByONGYUzZuq4ko7wqJ2lRTXxouqUqkWV2Y+nbW7532GdEJ0EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441412; c=relaxed/simple;
	bh=uuY280bq8SCwjHuT/QJ1yQEOmnJ0MIaX+qs5qFJ9KKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mBQC6B1YOrYHABMvdIiT7Aykr/hGN6P58YPxviGWOv4uVzs29jvH/mLVh57QRaN0V26ADAMpc0OaXl2ZBCu3zUmjon4TcD0VGSCSOW4oJ/yrm7uOwItBpUuYc7gXnxSZubBte1zRgjc6BGzmWugmSuhHlUucEfLLFjh91PP452U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QyCcLz5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QyCcLz5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176A2C2BD10;
	Mon,  3 Jun 2024 19:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441412;
	bh=uuY280bq8SCwjHuT/QJ1yQEOmnJ0MIaX+qs5qFJ9KKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QyCcLz5kXTOL31eOJ5RR0AUc/RtOu5uiW/8RwcA3sJiwNbN1ug1cmBP9fd21FjQ5R
	 sGjJLtQJ5/G2Gubgtls8/5sL6scyn+UYuU/wkBGrXZYov1rQ/Zkojj7Wd05XhJYVkY
	 9whPN+gKStrQTtFF2OrLwiVxVzbtBamKOZtsapx8X/dsjod6+Dak751PbB0fKFnpcS
	 R8R8+FStq5CDuW+kS89CZD/SYkVOo70WPdawjxsb1hu23me3md+KPD7y1ZC/x2Ek3C
	 LixKko+2H0dhD4qqrp49n9gdY958ZLnrGq6d6XKCVLEnS8whJV9YbhyLQJkO0uxl+D
	 jPVDaNUfkfvgA==
Date: Mon, 03 Jun 2024 12:03:31 -0700
Subject: [PATCH 044/111] xfs: factor out a xfs_btree_owner helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040034.1443973.10880126220687851966.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 2054cf051698d30cc9479678c2b807a364248f38

Split out a helper to calculate the owner for a given btree instead of
duplicating the logic in two places.  While we're at it, make the
bc_ag/bc_ino switch logic depend on the correct geometry flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: break this up into two patches for the owner check]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 150f8ac23..dab571222 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1219,6 +1219,15 @@ xfs_btree_init_buf(
 	bp->b_ops = ops->buf_ops;
 }
 
+static inline __u64
+xfs_btree_owner(
+	struct xfs_btree_cur    *cur)
+{
+	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		return cur->bc_ino.ip->i_ino;
+	return cur->bc_ag.pag->pag_agno;
+}
+
 void
 xfs_btree_init_block_cur(
 	struct xfs_btree_cur	*cur,
@@ -1226,20 +1235,8 @@ xfs_btree_init_block_cur(
 	int			level,
 	int			numrecs)
 {
-	__u64			owner;
-
-	/*
-	 * we can pull the owner from the cursor right now as the different
-	 * owners align directly with the pointer size of the btree. This may
-	 * change in future, but is safe for current users of the generic btree
-	 * code.
-	 */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_LONG_PTRS)
-		owner = cur->bc_ino.ip->i_ino;
-	else
-		owner = cur->bc_ag.pag->pag_agno;
-
-	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs,
+			xfs_btree_owner(cur));
 }
 
 /*

