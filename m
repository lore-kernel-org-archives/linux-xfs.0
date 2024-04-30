Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C117592
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481392; cv=none; b=bdRPmAn86WV1tqnQ6F9l6cpDdzenwS3EtZPQNkc2iM+tn92cN3VEy+akR5b9JUf3DBn4abR3TcvopuJ+aHu6iM+x17NOBZhw30jYn3n5zriL/+ifMvV7vBr2IxucBBiHn2tWdBEr0O80PvOGQG1gFfz4+ze+HyrCsOKm5SfUyn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481392; c=relaxed/simple;
	bh=u9YZB8FGk6Am7O7JHcwfAWKntKFwuhI43eORmhSQLKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PQXFINR+vFGmvd+XZCYIb0Tma/COrZyvqDhwqzlBx0W6TteunXcDCPlT46D1A6hgUFNQCFr5/uh1HjJbfjo0azDLTmaf5YuEXZoJDMl5y1tfkhpXrbH7P+8gphdguKDhR/qdCWLSt9hRaHboieCSlUTBxaBev01DgMyuR5uMffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=paeig1GA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="paeig1GA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vOu9lzLJUWogYnk+hj7DAdg4UfzYN6tFCJ5qrJMnBxs=; b=paeig1GAR4fXScKKifa8D6q4Cj
	OsHerB89r6hZkzkDJYUXaYZtvBqWvnsJgFBekvNs7P0PPkjqLCsgO5y+4pTD4YAeuP8DLymNpSCRY
	YX8FL3U6whZgUFimgYl+8QlVzzhEXOR3jkdtnQWErUr1CrlK3MjPlxFduJor+HUw+sBIut2xtuY9Y
	ANrUfVozV1Ck2EUEvUPVaLcl6U864SamvHePUFR92LTE6670nsVATY4002IqR+gyA1GgnBKXOjOJs
	/mqWM8K6DAS7JwphtOaRv07J+VzIxmZ7P8oTRr8onG34y3SR08d8SymZBlErEsvoLl7KA1bTJnkrW
	WDb78Rkw==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1mve-00000006NkR-1XEd;
	Tue, 30 Apr 2024 12:49:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/16] xfs: remove a superfluous memory allocation in xfs_dir2_block_to_sf
Date: Tue, 30 Apr 2024 14:49:17 +0200
Message-Id: <20240430124926.1775355-8-hch@lst.de>
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

Transfer the temporary buffer allocation to the inode fork instead of
copying to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_dir2_sf.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index d02f1ddb1da92c..164ae1684816b6 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -281,9 +281,8 @@ xfs_dir2_try_block_to_sf(
 	trace_xfs_dir2_block_to_sf(args);
 
 	/*
-	 * Allocate a temporary destination buffer to format the data into.
-	 * Once we have formatted the data, we can free the block and copy the
-	 * formatted data into the inode literal area.
+	 * Allocate the shortform buffer now.  It will be transferred to the
+	 * inode fork once we are done.
 	 */
 	sfp = kmalloc(size, GFP_KERNEL | __GFP_NOFAIL);
 	memcpy(sfp, &sfh, xfs_dir2_sf_hdr_size(sfh.i8count));
@@ -341,25 +340,23 @@ xfs_dir2_try_block_to_sf(
 	error = xfs_dir2_shrink_inode(args, args->geo->datablk, bp);
 	if (error) {
 		ASSERT(error != -ENOSPC);
+		kfree(sfp);
 		goto out;
 	}
 
 	/*
-	 * The buffer is now unconditionally gone, whether
-	 * xfs_dir2_shrink_inode worked or not.
-	 *
-	 * Convert the inode to local format and copy the data in.
+	 * Update the data fork format and transfer buffer ownership to the
+	 * inode fork.
 	 */
-	ASSERT(dp->i_df.if_bytes == 0);
-	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
 	dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
+	dp->i_df.if_data = sfp;
+	dp->i_df.if_bytes = size;
 	dp->i_disk_size = size;
 
 	logflags |= XFS_ILOG_DDATA;
 	xfs_dir2_sf_check(args);
 out:
 	xfs_trans_log_inode(args->trans, dp, logflags);
-	kfree(sfp);
 	return error;
 }
 
-- 
2.39.2

