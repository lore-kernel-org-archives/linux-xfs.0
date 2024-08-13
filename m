Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A535758ABF
	for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2024 07:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723534808; cv=none; b=N7emfnV7NvX4hsi/OLSi5BlhMAC8+gq1UyDEjNGEUBlUrmpzYmEB2KZvXBIc3nutr6p+heWgySCNS/4Yo6bK0h53tq/sblRRHtkaiKepHHzsnPXHdcfohN2fOSyJXnnm74fqRRuUgwz6uJNhfeEZN29asKj+2pShnImYivA71Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723534808; c=relaxed/simple;
	bh=v8MwnvbvNtnmXSzY943jsIaLRSBB9RHgWxmytGelWSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TeJ6mriRse/P4ccB9W4NpRUqlGMNH2jL/5kz+YvyHIbN60/lCfsZo8QwxkGdURNIElNYoOmiiuPKxJwBNmufwd6WBnNY5kgaiGZXNor0+8qpAWSM3VbCpl44m2mDHFirijiqUtmocxzdgOq+zNSyNoOTbjFjUP/8Mo3URA8tZQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LQOmjfHW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LQOmjfHW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=csA3mBRj+AdrxmsmZfswdPz2GMhOXLgIuIxCdd0oJo4=; b=LQOmjfHW47PK6iYCrF0AeHaubN
	mee5zwEME7KUDabjvppyYjUnHroZNspASLxP+ejHpW5tGMoFtcTQNgEwtKlULKLKV0w5QsWgrFkBp
	ssehjh2cTrOVPpV36Bck3bjfNOHT9+dANOTqUvfuY0N1kNqIwn2HqoPiws/5Je9gAwThUPXC3Ooxk
	F1CZPkqQ1qD0ANFst4cNR7XsLJT7Jghny3COlXjaEQaK5+yVfAv+CtRQI41Q9NgviS2jJgLM8TrrL
	XrELpK+Az/AYkRp6Br3BbvGfgzOOoXbiODDvM2RaBvqqnVcUiMztPr10ys3GjTRhiQhcFsvAG2vmI
	s5J7CcfA==;
Received: from 2a02-8389-2341-5b80-d764-33aa-2f69-5c44.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d764:33aa:2f69:5c44] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sdm8U-00000002l8j-2cZ5;
	Tue, 13 Aug 2024 07:40:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: don't bother returning errors from xfs_file_release
Date: Tue, 13 Aug 2024 09:39:36 +0200
Message-ID: <20240813073952.81360-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240813073952.81360-1-hch@lst.de>
References: <20240813073952.81360-1-hch@lst.de>
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

