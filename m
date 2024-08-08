Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12DF190468
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130910; cv=none; b=Ury+NygcTmnmWoH87HA8dKp67Wa0geMdFhg3UaKn2RqZ4wsv69a2N0bgzP0ACUz0pV+TL7McwQcOy4UFzQ0wbLKbv51wXMIjq1NOPJICMOsAqe49FFNqsd0v4GVbENlSEj9TCymQJySL4kUkeWzZ6pLmnEtvI+//de19A5CGHFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130910; c=relaxed/simple;
	bh=2TgH0p5TosrlSsMxGUROgGAE8R2IehSYh2uS77SHBtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdEoW7Wu/Sww29RJvRxsiNRUE6DyCB2Ge1ziwUc/pn6va5AylMHHsrSjg5JOQSj1U+tAEenD3UkTup5wQW8D4aUlcIYFwDQ1Z79KMzT2d/zqoUAZ+shYDddbBPs3lFHEAW19zW96PuYCXurTaAF7/BwioDw9R2a2+N1h1wJ+MYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mXRo82ga; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mXRo82ga"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5apWJdn802bBJYi7AzwrCJlPHotmf/dCE+yMU+gJqj4=; b=mXRo82gaFzbR87otzsdYP/8Gym
	rKulBq6z31AJ5X5GZLVF2UokgHfaSV6yRGpFAwH4Z+LsffcqgUkTMTj994UYjL2+uR4zDevZ896ry
	KilVsyIgyp84mq2WyZzam1JyEuW32pBo8+3Yd5dTncHzIxtBERyt16JLb80kcb2tr7zwt2IJRTVt7
	QsrTfjkDPOZPSkGWTEdQQ9225FZO+FtSV27ruIyMfK0tcGq/aomWVAMF37JM8UmkhyDFRvuHSpKcr
	+VJOvNRF+xJgvdGrwTznwBrwdjFyoRNDt4e1EQNhk6HGVcBEwNnng/+iF0SP/OhbpMLLzfZK2Ej3h
	MOjo0Jqw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc540-00000008kWa-1bIW;
	Thu, 08 Aug 2024 15:28:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: skip all of xfs_file_release when shut down
Date: Thu,  8 Aug 2024 08:27:30 -0700
Message-ID: <20240808152826.3028421-5-hch@lst.de>
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

There is no point in trying to free post-EOF blocks when the file system
is shutdown, as it will just error out ASAP.  Instead return instantly
when xfs_file_shutdown is called on a shut down file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 17dfbaca1c581c..dae8dd1223550d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1187,8 +1187,11 @@ xfs_file_release(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 
-	/* If this is a read-only mount, don't generate I/O */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount or the file system has been shut down,
+	 * don't generate I/O.
+	 */
+	if (xfs_is_readonly(mp) || xfs_is_shutdown(mp))
 		return 0;
 
 	/*
@@ -1200,8 +1203,7 @@ xfs_file_release(
 	 * is significantly reducing the time window where we'd otherwise be
 	 * exposed to that problem.
 	 */
-	if (!xfs_is_shutdown(mp) &&
-	    xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
+	if (xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED)) {
 		xfs_iflags_clear(ip, XFS_IDIRTY_RELEASE);
 		if (ip->i_delayed_blks > 0)
 			filemap_flush(inode->i_mapping);
-- 
2.43.0

