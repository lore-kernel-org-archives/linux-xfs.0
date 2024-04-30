Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D71F17592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481413; cv=none; b=FcyrfCHkHLvJlxuA7+oha2d94gclS2983non8FHbS6am0zQzenw6K32deQiwcTv4a+XQRpzpTywEJWqMMHJ4Rgz/slKV00tvPisgzTMAwdoarPGEQjcV4jkQFKwYm3KHdk3nFP6Z1tizqMEV+TMk8H6bE79deH3OTqWqroZQwSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481413; c=relaxed/simple;
	bh=wnKZz6PesFc1bNHR2T8aZJyBgeHFVosjIKjh2uUPbHs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tPWJXIxtp7HlhPBtR3WawCEh7CEK5U+Kmp6jLNhwlRFgQSF7ErUw1OY6hdZBYGShtel9vAiasoOBYrqCzlPXieaV/GBc85k2eH93nIPvHhq1dsWL9B09qh+tBeX83Db5kWHXJLQ6+uZUOp6ZFUOlAuKtnuGPEpIap/rqMDKTEOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UyfK+790; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UyfK+790"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=l1IAur0Kb3O1OPp+F06u++cBxau47NGB/nujCLuXRq8=; b=UyfK+7908swztp5RFLP1lQoBy3
	kYV+UQ60wB3kmpkN5h2BFzhHMLU09e8X5cwj2HPxVg1TJxa3EUxv82HR4fFq8hJfQ+6uOqzZXa7bm
	T5JrUY0A2K/ovOEp2MWj1s3mFk/HVZHuw4kYZvwhtFsBQMmPH8mwkHNNK2oSZPpzVGUKLNFeYoCv4
	BHuvn0l7dOSbKyNR0iYZKtB0sW5kP1ZIQzhCqrXr3PHJL8BTfkkCIBLAamRmjEvfzyfGJjRdrs25g
	5s/nfh6I5Lalk0m0tSVMxZU1qUK+LJeunVjbTib9EfZ0gXM7IvDTugkOalfdyAnM9NQBreOEsMv0G
	prAMdwmA==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvz-00000006Np2-1KBN;
	Tue, 30 Apr 2024 12:50:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 14/16] xfs: optimize adding the first 8-byte inode to a shortform directory
Date: Tue, 30 Apr 2024 14:49:24 +0200
Message-Id: <20240430124926.1775355-15-hch@lst.de>
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

When adding a new entry to a shortform directory we have to convert the
format of the entire inode fork if the new entry is the first 8-byte
inode number.

Instead of allocating a new buffer to convert the format, and then
possible another one when doing an insert in the middle of the directory,
simply add the new entry while converting the format and avoid the
extra allocation.

For this to work, xfs_dir2_sf_addname_pick also has to return the
offset for the hard case, but this is entirely trivial.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 46 +++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index a9d614dfb9e43b..02aa176348a795 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -35,7 +35,8 @@ static void xfs_dir2_sf_check(xfs_da_args_t *args);
 #endif /* DEBUG */
 
 static void xfs_dir2_sf_toino4(struct xfs_da_args *args, bool remove);
-static void xfs_dir2_sf_toino8(xfs_da_args_t *args);
+static void xfs_dir2_sf_toino8(struct xfs_da_args *args,
+		xfs_dir2_data_aoff_t offset);
 
 int
 xfs_dir2_sf_entsize(
@@ -450,6 +451,16 @@ xfs_dir2_sf_addname(
 	 */
 	if (args->op_flags & XFS_DA_OP_JUSTCHECK)
 		return 0;
+
+	/*
+	 * If we need convert to 8-byte inodes, piggy back adding the new entry
+	 * to the rewrite of the fork to fit the large inode number.
+	 */
+	if (objchange) {
+		xfs_dir2_sf_toino8(args, offset);
+		return 0;
+	}
+
 	/*
 	 * Do it the easy way - just add it at the end.
 	 */
@@ -461,8 +472,6 @@ xfs_dir2_sf_addname(
 	 */
 	else {
 		ASSERT(pick == 2);
-		if (objchange)
-			xfs_dir2_sf_toino8(args);
 		xfs_dir2_sf_addname_hard(args, objchange, new_isize);
 	}
 
@@ -622,6 +631,8 @@ xfs_dir2_sf_addname_pick(
 	for (i = 0; i < sfp->count; i++) {
 		if (!holefit)
 			holefit = offset + size <= xfs_dir2_sf_get_offset(sfep);
+		if (holefit)
+			*offsetp = offset;
 		offset = xfs_dir2_sf_get_offset(sfep) +
 			 xfs_dir2_data_entsize(mp, sfep->namelen);
 		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
@@ -1053,7 +1064,7 @@ xfs_dir2_sf_replace(
 		/*
 		 * Still fits, convert to 8-byte now.
 		 */
-		xfs_dir2_sf_toino8(args);
+		xfs_dir2_sf_toino8(args, 0);
 		i8elevated = 1;
 		sfp = dp->i_df.if_data;
 	} else
@@ -1205,7 +1216,8 @@ xfs_dir2_sf_toino4(
  */
 static void
 xfs_dir2_sf_toino8(
-	xfs_da_args_t		*args)		/* operation arguments */
+	struct xfs_da_args	*args,
+	xfs_dir2_data_aoff_t	new_offset)
 {
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1213,6 +1225,7 @@ xfs_dir2_sf_toino8(
 	int			oldsize = dp->i_df.if_bytes;
 	int			i;		/* entry index */
 	int			newsize;	/* new inode size */
+	unsigned int		newent_size;
 	xfs_dir2_sf_entry_t	*oldsfep;	/* old sf entry */
 	xfs_dir2_sf_entry_t	*sfep;		/* new sf entry */
 	xfs_dir2_sf_hdr_t	*sfp;		/* new sf directory */
@@ -1225,6 +1238,18 @@ xfs_dir2_sf_toino8(
 	 * Compute the new inode size (nb: entry count + 1 for parent)
 	 */
 	newsize = oldsize + (oldsfp->count + 1) * XFS_INO64_DIFF;
+	if (new_offset) {
+		/*
+		 * Account for the bytes actually used.
+		 */
+		newsize += xfs_dir2_sf_entsize(mp, oldsfp, args->namelen);
+
+		/*
+		 * But for the offset calculation use the bigger data entry
+		 * format.
+		 */
+		newent_size = xfs_dir2_data_entsize(mp, args->namelen);
+	}
 
 	dp->i_df.if_data = sfp = kmalloc(newsize, GFP_KERNEL | __GFP_NOFAIL);
 	dp->i_df.if_bytes = newsize;
@@ -1250,6 +1275,17 @@ xfs_dir2_sf_toino8(
 				xfs_dir2_sf_get_ino(mp, oldsfp, oldsfep));
 		xfs_dir2_sf_put_ftype(mp, sfep,
 				xfs_dir2_sf_get_ftype(mp, oldsfep));
+
+		/*
+		 * If there is a new entry to add it once we reach the specified
+		 * offset.
+		 */
+		if (new_offset &&
+		    new_offset == xfs_dir2_sf_get_offset(sfep) + newent_size) {
+			sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
+			xfs_dir2_sf_addname_common(args, sfep, new_offset,
+					true);
+		}
 	}
 
 	kfree(oldsfp);
-- 
2.39.2

