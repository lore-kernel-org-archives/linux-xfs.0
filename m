Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2EA7FD
	for <linux-xfs@vger.kernel.org>; Sun, 23 Jun 2024 05:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719121523; cv=none; b=m7fyfwNm5/Strmzsllmd40TCgjM9PwcBERiEgfXFvaXu+CVY1UzS0rqnmD5s23k1T2KgRhfqd7m/2g+2u4wTyv3jUa+HFIA5N9DLKqe1oiicHSXgut6PcGyuA9MH1c56C8bKdck97tDDhc0/KFEKniVthdRKnDahsj30QpGrCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719121523; c=relaxed/simple;
	bh=78rOk0bTZ/+ajJlOV7k9gQgik1ItjXExgY28H3JXj8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geqiQyeriBWCBkVOZBZaG5hnN65zm5SwQ7J9pV/RqTI7DgPY9qjdseoxAuDm7wHhV6k1heOp9R1SXTzwYGa1cY4bVWqLuRkKpTXqbiyYubDnt8iGwhONCUTzEq025h9aw17nSTAMPW8R2gLGMarEINoj8oo7zYcSBGsodk1xln8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZDw0hTQc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZDw0hTQc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+r6nVYMtFUMzJmp44iM5boDw4bE05fN7Vmvv1yNGPTc=; b=ZDw0hTQcZjYe1JQFr7V6WIZP1l
	blI0C6NgmFG8RY8Y11WLxbGwV1MDFvfUhq6xihBeRJ5y2lkr6OUDqBbETFrMrZrnpLKLyc1nVLNlZ
	ApyCQwL/CCnY+whti02oBWjlsQIczEMkSB1WIRYOZ5lUiWilS3UGaa0Y0z07IIQziJKWb4+7rNuWc
	ptQ4ixcoUdFXLXdbE75INlketdADyB+7XZRp+lp5Xwjz38NOgxm15kSKYaMfjLGkFWVx0rNG0FnpX
	YTQlzTyf4E1RrNoZCyGcYEkzjHqEeypiwY8k2Ck9M4WGfV2+e9/cGOWGLMbzg3+ECK6HdwkWLTC5h
	1T7PGmcg==;
Received: from 2a02-8389-2341-5b80-9456-578d-194f-dacd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9456:578d:194f:dacd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sLG2T-0000000DPC8-3FDU;
	Sun, 23 Jun 2024 05:45:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: always take XFS_MMAPLOCK shared in xfs_dax_read_fault
Date: Sun, 23 Jun 2024 07:44:30 +0200
Message-ID: <20240623054500.870845-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240623054500.870845-1-hch@lst.de>
References: <20240623054500.870845-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

After the previous refactoring, xfs_dax_fault is now never used for write
faults, so don't bother with the xfs_ilock_for_write_fault logic to
protect against writes when remapping is in progress.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 32a2cd6ec82e0c..904be41f3e5ec6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1279,12 +1279,11 @@ xfs_dax_read_fault(
 	unsigned int		order)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
-	unsigned int		lock_mode;
 	vm_fault_t		ret;
 
-	lock_mode = xfs_ilock_for_write_fault(ip);
+	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
 	ret = xfs_dax_fault_locked(vmf, order, false);
-	xfs_iunlock(ip, lock_mode);
+	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
 
 	return ret;
 }
-- 
2.43.0

