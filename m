Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FAA229B36;
	Fri, 14 Nov 2025 05:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099588; cv=none; b=Jn2i2XFMjt3FWo6l8DHfzt6CIlxAKXeC0JSpW7DjyfIrIp8RQeauD9YRFzRYHKfiWb/5De82Xjl8DtxtlEIYxLbHcmJe+EUVOOt8Eu3UUM2hqTPpGPO5DFha1emHI75HF+kx8ps50YDo1LGEOOAmMa3of2viKgei418c6ujHp5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099588; c=relaxed/simple;
	bh=LyeICp4PD0sVuS/enFjUZ56mw7Q6QIp8700dnzFlzjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dY/K+0XaAISSiZKKdRwCVyphhZLGST7VsqfaLltMJ2YUsMDx1fiKD/rRTDAoxlZn99J50yn/m6HyPjx6Lzbhjfx2x4N3KY7lpVydApN7kHj2PbU0gt/Bedx7x1/FHFcxbPtgO8G/jB1cRwP4+hu6OrLEAbO8gXJY9QQqasBjzx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=iQebYPLF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iQebYPLF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JSx9uP6P4cDvh542plH34ruSGlq0Q0vrcgGDoAhAIcI=; b=iQebYPLFexg26HEQph7Xv4l9+d
	80DsLMloxuKx5hoNtvKhOrbeITgokQdLbPdyURKla6husc2dS4Dc26e6G4V+6/bxWS8QhNMErGx5d
	FLskCnNDXNg/BO0t/EZ/cm9lP0nU/jwf7C70DabVouof9EQ5BiKN3Aw9cVFzUYcLY4CgkIhXAGjfL
	trIeI4M2dRhIxBNiH+bdVcpVcEvd3VBR/hnYYVEZW5WkUBiqXlzW04+mVLSSAQaOWh16w5NmrU39a
	vSlwyNugeOrkxQ4GZsdOj4TSPfXWqku9pr6c2W5HBa7lky5VV6W4//kuwvbmGdAUIOUMZQM4Bu8qW
	okUn9lSw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJmk3-0000000Bc3E-3qbT;
	Fri, 14 Nov 2025 05:53:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>,
	Chris Li <sparse@chrisli.org>,
	linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] xfs: move some code out of xfs_iget_recycle
Date: Fri, 14 Nov 2025 06:52:24 +0100
Message-ID: <20251114055249.1517520-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114055249.1517520-1-hch@lst.de>
References: <20251114055249.1517520-1-hch@lst.de>
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
---
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

