Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4138190067
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130910; cv=none; b=S8Jw9BmxHvyiDOknjKwYeFXKByqEBf/puJI9TBBMd4DRIzFL5vP1tMlw65JU12pFFzi7vkTlc50jYNfbOYy+bBZqDfmjO7O5dYAerE2XZpRbs4rquI9STCeZu5K4gYv1e+gg8CM6ornq5za9IR1WwIN2nxpK4qowp4tEfV+3lHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130910; c=relaxed/simple;
	bh=v8MwnvbvNtnmXSzY943jsIaLRSBB9RHgWxmytGelWSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDrBlFoSktvddLnLmW1PP+BcQGCBxy/QQG50BI7vlxHrSukE5+EQ9gP5N4i2c5UwG5j0YsiOQlrBlElXK6ZacnTQ6Ndq08WX7rcYBm6a9Z1O5FSGObzXLBcgn6DmdEU3Qdd5pk0qJLgwIL2PXCOwI2djT8vwBZZYob52f4vs2yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M/d85VrD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M/d85VrD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=csA3mBRj+AdrxmsmZfswdPz2GMhOXLgIuIxCdd0oJo4=; b=M/d85VrDKeW0z/P7rFzg+LSGfz
	RwNbW7RoFZMUO/DM27WAYgpLixiRJt3Pq840mqo9S3BZwK+RlupokWmRZV39dTAQenep3WBqhwFjA
	b05O68yz+4Z+Jp+9FjGnkm7WvfO1eQWC2ZbM+yd3nTK6fgvz5kgjsrw4jCnaxDz+WW73qOE9MHyMb
	pdEd6EeAyTcYD7E1tsXPHHN2mPh5NPrzHCLXS8JII0iuZN3yiiJn6N+bmnGkXT/vBJTqEFaQZcQGU
	q5aIcZt+V4iZ0eIeyxsa+ORejS9SwEpltMJQHu/8J+1PVfZeeICui2AIsZPK4d0d4ZiaZD3WpSObQ
	es+tRlUQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc540-00000008kWU-0ofG;
	Thu, 08 Aug 2024 15:28:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: don't bother returning errors from xfs_file_release
Date: Thu,  8 Aug 2024 08:27:29 -0700
Message-ID: <20240808152826.3028421-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808152826.3028421-1-hch@lst.de>
References: <20240808152826.3028421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While ->release returns int, the only caller ignores the return value.
As we're only doing cleanup work there isn't much of a point in
return a value to start with, so just document the situation instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 11732fe1c657c9..17dfbaca1c581c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1175,6 +1175,10 @@ xfs_dir_open(
 	return error;
 }
 
+/*
+ * Don't bother propagating errors.  We're just doing cleanup, and the caller
+ * ignores the return value anyway.
+ */
 STATIC int
 xfs_file_release(
 	struct inode		*inode,
@@ -1182,7 +1186,6 @@ xfs_file_release(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error;
 
 	/* If this is a read-only mount, don't generate I/O */
 	if (xfs_is_readonly(mp))
@@ -1200,11 +1203,8 @@ xfs_file_release(
 	if (!xfs_is_shutdown(mp) &&
 	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
 		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
-		if (ip->i_delayed_blks > 0) {
-			error = filemap_flush(inode->i_mapping);
-			if (error)
-				return error;
-		}
+		if (ip->i_delayed_blks > 0)
+			filemap_flush(inode->i_mapping);
 	}
 
 	/*
@@ -1238,14 +1238,14 @@ xfs_file_release(
 			 * dirty close we will still remove the speculative
 			 * allocation, but after that we will leave it in place.
 			 */
-			error = xfs_free_eofblocks(ip);
-			if (!error && ip->i_delayed_blks)
+			xfs_free_eofblocks(ip);
+			if (ip->i_delayed_blks)
 				xfs_iflags_set(ip, XFS_IDIRTY_RELEASE);
 		}
 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 	}
 
-	return error;
+	return 0;
 }
 
 STATIC int
-- 
2.43.0

