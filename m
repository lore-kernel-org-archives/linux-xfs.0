Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09E819047A
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130911; cv=none; b=mCvFWhlBx9oDftEE7LzpvULwfWNOhRxGWWgAfGn29spOTfF0QONbA65P92F8VqT1syzJU+i6W+kCSpxkihXs3p4sp5ZVoeJaC9GcG0JEx74wDfNN7CKF0uMlwdLBEpJknBOLZjDdOryP9Y3KXWpXpxrE32QkMvxeBw4gaH2edK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130911; c=relaxed/simple;
	bh=8//IyHH2UxdcO8DZauXXyB3/vGpvdzDHOnpIoBEVXU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuwbOhCvWSnnUcRzTfhgNWPx64l86mOoFHtm83z6u1L+rvjnj4GDbHS74TyvHrtSTG+9YPiO/JZYSHc8RzA8De809VATLTQnAVAj8NhQbcd3RF1FMSEAHWZH1jile459T/X+vKfeGEwywSHuDIYyDXBj7y0QB4Uu74oZdUYIuIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L6CyxXe6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L6CyxXe6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vQuJegpM089kECOq4DIYSw1jMJAARhUns4DObOmiRJM=; b=L6CyxXe6P9SC/hq+5ATCCzTxlz
	D9U3GKGNijXsF+9ERq/zF9000TYJrLsRdtSz8cjcHXS0g82/JPhVr3oveIU5mJBR3MQ2PQ4aQEHTy
	uTzqpRw/AxsY7dYlgpd9hVH03YYcFCUMjr+8YL+7Kfnj6wG5TTmiJiEJC1GnkPrDy0mgxemFBeaFS
	Fu3mhpa7qTbtg6/Ufrfi7QrSl6MSjbuhRLVNcUv3XG9E9Qc1kzxSc83rXd6mpDP59We4OL2FjW4fo
	vaguPlm6LhxxKK5gzpTSPqgcCJrYIMZhPJOoM0E7X+aUvbSvxrTSUU4ePxahA4a2zJpT+lpXdI8a/
	b7afLIlg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc541-00000008kXG-0xjF;
	Thu, 08 Aug 2024 15:28:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: check XFS_EOFBLOCKS_RELEASED earlier in xfs_release_eofblocks
Date: Thu,  8 Aug 2024 08:27:33 -0700
Message-ID: <20240808152826.3028421-8-hch@lst.de>
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

If the XFS_EOFBLOCKS_RELEASED flag is set, we are not going to free the
eofblocks, so don't bother locking the inode or performing the checks in
xfs_can_free_eofblocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 30b553ac8f56bb..f1593690ba88d2 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1234,9 +1234,9 @@ xfs_file_release(
 	 */
 	if (inode->i_nlink &&
 	    (file->f_mode & FMODE_WRITE) &&
+	    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
-		if (xfs_can_free_eofblocks(ip) &&
-		    !xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED)) {
+		if (xfs_can_free_eofblocks(ip)) {
 			xfs_free_eofblocks(ip);
 			xfs_iflags_set(ip, XFS_EOFBLOCKS_RELEASED);
 		}
-- 
2.43.0

