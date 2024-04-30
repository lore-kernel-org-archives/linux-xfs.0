Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A6617592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481407; cv=none; b=U9oh3+57LHmfX8UTfx+AoQRIiBf93tWxnxW4SGqfvdaokKfCn2HO6MuAxJhntBTL3TnKGtTbn768RFIH5d8UmznBGQwqmZtQva5GuIPLN8JfWXbyRKY0uTVPliE7D6MxUCUBvbB5EkrokjCEY3puPBXHlY5cr+VqHlg89K8pYHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481407; c=relaxed/simple;
	bh=eRcU4iIIY57N4vn62f6u7OXzLWWgVe8Oknqlh12TEjg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ndI6FAO0Coa+QSBQUy/q6DgU3j54DqOINTaIOljEuUHVlvTS8ZTgEXoytE/oxY+1I2m7FQV3cK1J3z2o03vM5Y4xu8OgFCqhuWRR8PVK86NCuzvXXSYug9ri9sE8voCVpOQsv/SnblcR3o/pAW6LGYuN/ZwwDLUz94/lNo3Sgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=esMwyAr3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="esMwyAr3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=hAxpc4jiPSEvUyDRqmT+Unkp8CiVyVygMLF9vfEjJH8=; b=esMwyAr3Ib2L5Y2BWNsFv8YX7t
	40Z38yb/tDwZ6CTRLoa3lmEogjCGzaeyW5/ojP3sMEZATakb97P7dLyLz9S5OIQ8E7HNPkrz0PLoZ
	tseUiPMhcsgVjj13nlcOQnC7kJho4hJkXyYfvvZx145Lae7QB+sGvfQddd2VSKsfRLVcxhOmf3vqj
	DN1mZ3cvjfE4EWRENVEWY9Z1iW7TSeMR3aUj6G1BmXKlm1Fd6BtAOsJmpObkW56o27RimqqyE6qLZ
	TwN7oLxL9m5nN8uac+1fbI2IW4xPFhjdpHp+SOTK3REK8R/wEezhhnouyhneA5tn5voLgg6/JAfdR
	aoNT7ImA==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mvt-00000006NnT-1a6w;
	Tue, 30 Apr 2024 12:50:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 12/16] xfs: factor out a xfs_dir2_sf_addname_common helper
Date: Tue, 30 Apr 2024 14:49:22 +0200
Message-Id: <20240430124926.1775355-13-hch@lst.de>
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

Move the common code between the easy and hard cases into a common helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 48 +++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 1e1dcdf83b8f95..43e1090082b45d 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -360,6 +360,27 @@ xfs_dir2_try_block_to_sf(
 	return error;
 }
 
+static void
+xfs_dir2_sf_addname_common(
+	struct xfs_da_args	*args,
+	struct xfs_dir2_sf_entry *sfep,
+	xfs_dir2_data_aoff_t	offset,
+	bool			objchange)
+{
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_dir2_sf_hdr	*sfp = dp->i_df.if_data;
+
+	sfep->namelen = args->namelen;
+	xfs_dir2_sf_put_offset(sfep, offset);
+	memcpy(sfep->name, args->name, sfep->namelen);
+	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
+	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
+	sfp->count++;
+	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
+		sfp->i8count++;
+}
+
 /*
  * Add a name to a shortform directory.
  * There are two algorithms, "easy" and "hard" which we decide on
@@ -476,21 +497,7 @@ xfs_dir2_sf_addname_easy(
 	 * Need to set up again due to realloc of the inode data.
 	 */
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + byteoff);
-	/*
-	 * Fill in the new entry.
-	 */
-	sfep->namelen = args->namelen;
-	xfs_dir2_sf_put_offset(sfep, offset);
-	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
-	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
-
-	/*
-	 * Update the header and inode.
-	 */
-	sfp->count++;
-	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
-		sfp->i8count++;
+	xfs_dir2_sf_addname_common(args, sfep, offset, false);
 	dp->i_disk_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
@@ -562,17 +569,12 @@ xfs_dir2_sf_addname_hard(
 	nbytes = (int)((char *)oldsfep - (char *)oldsfp);
 	memcpy(sfp, oldsfp, nbytes);
 	sfep = (xfs_dir2_sf_entry_t *)((char *)sfp + nbytes);
+
 	/*
 	 * Fill in the new entry, and update the header counts.
 	 */
-	sfep->namelen = args->namelen;
-	xfs_dir2_sf_put_offset(sfep, offset);
-	memcpy(sfep->name, args->name, sfep->namelen);
-	xfs_dir2_sf_put_ino(mp, sfp, sfep, args->inumber);
-	xfs_dir2_sf_put_ftype(mp, sfep, args->filetype);
-	sfp->count++;
-	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && !objchange)
-		sfp->i8count++;
+	xfs_dir2_sf_addname_common(args, sfep, offset, objchange);
+
 	/*
 	 * If there's more left to copy, do that.
 	 */
-- 
2.39.2

