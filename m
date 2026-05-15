Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EA480DEC
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853096; cv=none; b=MziwAxuYnxpanWUqXPd2HEUWbVAODT2squ3z4RdA8p2yy3A+F2xqc4BFsPqGKkBwGZxLneWCiAnZFDsNg+LSLGYy5EudVDomEuNVpF0tyCVBz/hd1KxJgx2vDkOeR8CvO2iOS8rwMs19/6Dm2ZYDSZcJ9GjSE8w3aho/g46WVXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853096; c=relaxed/simple;
	bh=snXEl/Qjbr49wBdHcTy9z8WkVcBsG6dwosiijQDEhCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwpSAniiEIiEGgctGZXHOY/GoGlebQ+QRtnHy8OlMobRU+l1ylGeJ4I1H50MmTLUhEBgT3v7gm/7BiqoCzyOwy8uSP4pn8F5nLrH2Z0H5PHsQ128tPueW9BuTji6dFhH6+yYvXV2f9d5fh5Z7ss+C8+StWTY+csAFUza+KFI5I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EqkP2Jr7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EqkP2Jr7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xGvFmObIC/JD6sNvTabEhU2jI661GVlN2DxU4+faTLI=; b=EqkP2Jr7BJLHlCh4vF99LWAhy+
	Z2iKR22GAzd/YAtslLlUZheHSbtbn9f/gexV4EnhUbpnaNpx9bY3lYAl6MDdRHDIA3HZlBSTOy+uH
	H3vehKLH2nLWSctVzJlhZAW1fcmvFFt1W2uiLhxNqhT9E+ed9Qfu+mYsqa35d0bKO8MRlTfNM77GS
	37yJWrQE3tmQAkQwbKRKHAxFzdzs2FW/TIp3T4eb4My6b959xNkO8qkDQ9Q6o8vp1SU7dkHRrejE3
	ep8b/vjTDZWPT7C7CYSHWUfgCYAQnOC1P8V7dORycrxM7S67Oy/NxA7GEQHLVTHHNbOt51BVMDFiK
	fKqvmqaQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNswt-00000008UcS-2v4p;
	Fri, 15 May 2026 13:51:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: remove xfs_setup_existing_inode
Date: Fri, 15 May 2026 15:50:29 +0200
Message-ID: <20260515135103.4042407-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_setup_existing_inode only has a single caller, fold it into that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 7 +++++--
 fs/xfs/xfs_inode.h  | 7 -------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d0bc8ea79d40..37caed10c089 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -817,8 +817,11 @@ xfs_iget(
 	 * now.	 If it's a new inode being created, xfs_init_new_inode will
 	 * handle it.
 	 */
-	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0)
-		xfs_setup_existing_inode(ip);
+	if (xfs_iflags_test(ip, XFS_INEW) && VFS_I(ip)->i_mode != 0) {
+		xfs_setup_inode(ip);
+		xfs_setup_iops(ip);
+		xfs_finish_inode_setup(ip);
+	}
 	return 0;
 
 out_error_or_again:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..724baea02c8d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -630,13 +630,6 @@ static inline void xfs_finish_inode_setup(struct xfs_inode *ip)
 	unlock_new_inode(VFS_I(ip));
 }
 
-static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
-{
-	xfs_setup_inode(ip);
-	xfs_setup_iops(ip);
-	xfs_finish_inode_setup(ip);
-}
-
 void xfs_irele(struct xfs_inode *ip);
 
 extern struct kmem_cache	*xfs_inode_cache;
-- 
2.53.0

