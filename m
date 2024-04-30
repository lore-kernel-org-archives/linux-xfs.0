Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE88171096
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481401; cv=none; b=iCMYoo67R69aRgAqzaP0ktV10E9lkDmAlj5VZHfO3uFf3yyIkZUr7KvH/izt/jRNv68zF2CnzhnNy2rZHv5PsUkIpZpsbGIB+sMIHjdtJk7M6anYJrCyYXgxrxQ6MAnH3FYYslQnnde81znS532qlBSnQYhqmbTGf/h8jLPV8+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481401; c=relaxed/simple;
	bh=Tg1yzlGJFBz4oR19sUBymvIseE8UJ9sT5iIGfV/GbeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DJiQvJfIVA54MIYj4hdwbluokib/eS5Qxi5r1xumwxBTwUDNnQqfmy+lL3eygmqTIVWYcrewsxpRGWa8c2wI6HJ5g6lZpRd+xiU9beLR5HcyoaIbRBP+PjUezdYFEzWDgp0EOfVsv475B9R+rlvP3e3pvNBprZomJbMFsIkXtZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OAOVLa68; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OAOVLa68"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6oqexfbvenAiAelP7Qw382h+gwFKlIzCmN8NYMQ0SW4=; b=OAOVLa68aPRcjI4KCJH7SLZXpA
	U1di1hLA8P4xbvZNs4ct4zj2vR+Ybt0JUV8FvbA+u2SsTetjJbn5EmnbvYOeSq/JagT3GilffiWBD
	Dp9POh7rv1E3EMdQNvt883vZGQm/ps0SocqbmL8UVy+Cd/w0TPagunc/DWfX0TftvxpmaI8NzwPaW
	YzNrPuwpuJez3rlvLKR2VeK9/WwPh5poAX5eg7QFa3qp6ahp2/Pri6msht/paPWrM82jV6KC4LBT3
	9QuYbvqJ9BdC6nEVX8qLMn4gcNXxWw8aEr73KMojBZklAp8XJmDYOc8W49Svzraxcl8vWG5xW3GY4
	7T4ieMMA==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvn-00000006NmF-0en8;
	Tue, 30 Apr 2024 12:49:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 10/16] xfs: optimize removing the last 8-byte inode from a shortform directory
Date: Tue, 30 Apr 2024 14:49:20 +0200
Message-Id: <20240430124926.1775355-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430124926.1775355-1-hch@lst.de>
References: <20240430124926.1775355-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When removing the last 8-byte inode, xfs_dir2_sf_removename calls
xfs_dir2_sf_toino4 after removing the entry.  This is rather inefficient
as it causes two buffer realloacations.  Instead of that pass a bool
argument to xfs_dir2_sf_toino4 so that it can remove the entry pointed
to by args as part of the conversion and use that to shortcut the
process.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 41 ++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 3b6d6dda92f29f..21e04594606b89 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -34,7 +34,7 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
 #define	xfs_dir2_sf_check(args)
 #endif /* DEBUG */
 
-static void xfs_dir2_sf_toino4(xfs_da_args_t *args);
+static void xfs_dir2_sf_toino4(struct xfs_da_args *args, bool remove);
 static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
 
 int
@@ -935,6 +935,15 @@ xfs_dir2_sf_removename(
 	ASSERT(dp->i_df.if_bytes == oldsize);
 	ASSERT(oldsize >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
+	/*
+	 * If this is the last 8-byte, directly convert to the 4-byte format
+	 * and just skip the removed entry when building the new fork.
+	 */
+	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 1) {
+		xfs_dir2_sf_toino4(args, true);
+		return 0;
+	}
+
 	/*
 	 * Loop over the old directory entries.
 	 * Find the one we're deleting.
@@ -980,10 +989,8 @@ xfs_dir2_sf_removename(
 	 * Are we changing inode number size?
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM) {
-		if (sfp->i8count == 1)
-			xfs_dir2_sf_toino4(args);
-		else
-			sfp->i8count--;
+		ASSERT(sfp->i8count > 1);
+		sfp->i8count--;
 	}
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
@@ -1087,7 +1094,7 @@ xfs_dir2_sf_replace(
 		if (i == sfp->count) {
 			ASSERT(args->op_flags & XFS_DA_OP_OKNOENT);
 			if (i8elevated)
-				xfs_dir2_sf_toino4(args);
+				xfs_dir2_sf_toino4(args, false);
 			return -ENOENT;
 		}
 	}
@@ -1100,7 +1107,7 @@ xfs_dir2_sf_replace(
 		 * And the old count was one, so need to convert to small.
 		 */
 		if (sfp->i8count == 1)
-			xfs_dir2_sf_toino4(args);
+			xfs_dir2_sf_toino4(args, false);
 		else
 			sfp->i8count--;
 	}
@@ -1128,7 +1135,8 @@ xfs_dir2_sf_replace(
  */
 static void
 xfs_dir2_sf_toino4(
-	xfs_da_args_t		*args)		/* operation arguments */
+	struct xfs_da_args	*args,
+	bool			remove)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1148,6 +1156,8 @@ xfs_dir2_sf_toino4(
 	 * Compute the new inode size.
 	 */
 	newsize = oldsize - (oldsfp->count + 1) * XFS_INO64_DIFF;
+	if (remove)
+		newsize -= xfs_dir2_sf_entsize(mp, oldsfp, args->namelen);
 
 	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
 	dp->i_df.if_bytes = newsize;
@@ -1166,11 +1176,22 @@ xfs_dir2_sf_toino4(
 	     i < sfp->count;
 	     i++, sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep),
 		  oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep)) {
+		xfs_ino_t ino = xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep);
+
+		/*
+		 * Just skip over the entry that is removed if there is one.
+		 */
+		if (remove && args->inumber == ino) {
+			oldsfep = xfs_dir2_sf_nextentry(mp, oldsfp, oldsfep);
+			sfp->count--;
+			if (++i == sfp->count)
+				break;
+		}
+
 		sfep->namelen = oldsfep->namelen;
 		memcpy(sfep->offset, oldsfep->offset, sizeof(sfep->offset));
 		memcpy(sfep->name, oldsfep->name, sfep->namelen);
-		xfs_dir2_sf_put_ino(mp, sfp, sfep,
-				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
+		xfs_dir2_sf_put_ino(mp, sfp, sfep, ino);
 		xfs_dir2_sf_put_ftype(mp, sfep,
 				xfs_dir2_sf_get_ftype(mp, oldsfep));
 	}
-- 
2.39.2

