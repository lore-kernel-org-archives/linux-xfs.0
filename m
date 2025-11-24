Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B230B514
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 13:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763992487; cv=none; b=mUYr47kWckCbqUD59bFGzlAFKEpVSSgmiDStSWjQZcNToQHiO17geLSvE0Ju4j4eqffUzCBjxt42dwCAU40OdNTbi/5aHYpAwtt4c2WCeSZdoPwvjOTfAy+MJyxby/k+IE73NPlsfYBiuiJRfj4ZvlhCvb5+8RiO4lJIgNnTqEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763992487; c=relaxed/simple;
	bh=KX0caMZ9l8hEBOHcBD8FMjLvT5w8lx5xfuR//qBqjDY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LJ2VhFQlGoJMtx0298KvTnBU0hlmBcSw08ViIcDx24KYlXLUZDdNqNYKgzaft4GfOju/+L4TZkjNZAu+hKMkMq6tF/d8VXK8cndo0vWYQASQtgH5J+5TjVMkACvU+tiyv089HwDOeSqVPyMNxeOofDv1fnUR2DHv/0nIlKqxTpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K8bmmdER; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K8bmmdER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OfM0AoRIhJzRB9cR7DbkC3b42bO10uUEWudrTmSnWrY=; b=K8bmmdERgMwO0MTqOJwuU3hr+c
	3NixO4I0ee3LuAgYp4DaY2/oUH/Vinz6fkUq4F/ZvtxInqMn9FG8/b5whOEMLmiJO3+R1yOtAgNH7
	feeM8iET6a2sXPxPi3sdYbw65FM3cV12JSQ/GGP/bC9/ZW4GWYWibZzme4CW93yuKCeH4jfIP/Re9
	EAbiCh3tQB3Kz0lN0+mwc+2Lq2SFXNUVjjGt9pvawB7taImqG03wLS5cYfWD6B5SRXSsIVlXqQYNT
	9TvLN2BLPDnAZJ2nyVU1YZRg8Mmo49pgifkLHWzZHek2mwlQhTTqiNBGc0Aj5DSVDbsU00nUnPjvJ
	Dy1eTjrw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNX1f-0000000Bn23-2bh5;
	Mon, 24 Nov 2025 13:54:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH, resend] xfs: move some code out of xfs_iget_recycle
Date: Mon, 24 Nov 2025 14:54:14 +0100
Message-ID: <20251124135439.899060-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Having a function drop locks, reacquire them and release them again
seems to confuse the clang lock analysis even more than it confuses
humans.  Keep the humans and machines sanity by moving a chunk of
code into the caller to simplify the lock tracking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---

Standalone resend to get onto the radar.

 fs/xfs/xfs_icache.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e44040206851..546efa6cec72 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -358,7 +358,7 @@ xfs_reinit_inode(
 static int
 xfs_iget_recycle(
 	struct xfs_perag	*pag,
-	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
@@ -366,20 +366,6 @@ xfs_iget_recycle(
 
 	trace_xfs_iget_recycle(ip);
 
-	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
-		return -EAGAIN;
-
-	/*
-	 * We need to make it look like the inode is being reclaimed to prevent
-	 * the actual reclaim workers from stomping over us while we recycle
-	 * the inode.  We can't clear the radix tree tag yet as it requires
-	 * pag_ici_lock to be held exclusive.
-	 */
-	ip->i_flags |= XFS_IRECLAIM;
-
-	spin_unlock(&ip->i_flags_lock);
-	rcu_read_unlock();
-
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
 	error = xfs_reinit_inode(mp, inode);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
@@ -576,10 +562,19 @@ xfs_iget_cache_hit(
 
 	/* The inode fits the selection criteria; process it. */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
-		/* Drops i_flags_lock and RCU read lock. */
-		error = xfs_iget_recycle(pag, ip);
-		if (error == -EAGAIN)
+		/*
+		 * We need to make it look like the inode is being reclaimed to
+		 * prevent the actual reclaim workers from stomping over us
+		 * while we recycle the inode.  We can't clear the radix tree
+		 * tag yet as it requires pag_ici_lock to be held exclusive.
+		 */
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 			goto out_skip;
+		ip->i_flags |= XFS_IRECLAIM;
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+
+		error = xfs_iget_recycle(pag, ip);
 		if (error)
 			return error;
 	} else {
-- 
2.47.3

