Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E369320E3
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719120956; cv=none; b=XazB0yydJwj0EzFRIOwVZZk3Mi3rCbvYBDHfESVFa7NYlFExykmStwA92jDh7WvlWAjPF00jRCj+oGsQ9ePb26qlb9ptxSbpKIPRCjInpy5qUQj+5Pa4VVVSaXAAdwqHkQ0VZZ5XXyzCil9xSEQUc1B9UunreTwsIyN298vGNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719120956; c=relaxed/simple;
	bh=HWabCiX3GTPhrfxrrsppQSueQUNNqBGS0vFCkyD5X9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro8CgjCLooW2cYKElvresBHNM90rW/wBO+WCpW8poduWDEuDl5+3Of7tyGOZB2qQvxbG2uOXKdIXElTBcn5dFbZ+gi46lBAslTbkHWlzjsEUUQOP6A5plbCDZDkwQSQ6KRgnj8RWvGlqVI+ZxfcG4hKg0cRhg42uvnzio4CVDx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sxLv7GS+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sxLv7GS+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/Wa+SZievx5M4xESTm6kE3zxysjRLotQPJd2n797pJ0=; b=sxLv7GS+H33P7Q0CgwMU+Am/hf
	JEOv/su0Pynm3s9Gmf57qKK1NjCWLRRlvqtbnPZGbIpCkUj1PSns4jrWR25XYrIG0AUiJqHmYpUrL
	S5BbkiZVAODUlONcSPK6mQAtKwD92rIcN0ipgvR1SDf73lkuYT8ifkSL9oRVEG69mH/gdzw11xkgO
	d3nmPur6Dh/D8fIhkszNiKUtH6lrIJdQP7GxLDNsyvapojamSLUK0jmFpVUKf0QXpajHo22XkU2bP
	6aEXBiInG5AEFyoisYx00Td79qtRL8/Urka4Nf0yD/5dDfC/5ZTBg8EGIO/UV23kcvDcBMrEKMleA
	hUQrhY6w==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLFtJ-0000000DOGc-3kLt;
	Sun, 23 Jun 2024 05:35:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] xfs: skip all of xfs_file_release when shut down
Date: Sun, 23 Jun 2024 07:34:50 +0200
Message-ID: <20240623053532.857496-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623053532.857496-1-hch@lst.de>
References: <20240623053532.857496-1-hch@lst.de>
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
---
 fs/xfs/xfs_file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7b91cbab80da55..0380e0b1d9c6c7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1198,8 +1198,11 @@ xfs_file_release(
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
@@ -1211,8 +1214,7 @@ xfs_file_release(
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

