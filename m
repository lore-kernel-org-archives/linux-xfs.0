Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6F43DEC2
	for <linux-xfs@vger.kernel.org>; Fri, 11 Sep 2026 07:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789110364; cv=none; b=B1By8WIPQo7PvC7OMla00xmFApNvZpn2LQd2gzAFW2ELb0Y43cjykuo1vsD8ij2iMiDNae88/MSY97Revmc9f34CF74pmRntIqpTo04D63LmRW71MrmpvRD9Nuudm4GsqDHXoxEa95mOr+lMUMwFMtZna7Ge8pSPlzhlusKO0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789110364; c=relaxed/simple;
	bh=XHgyDG1OKT+r7wGOq0Rtd7M5I7sZhgVT6ebzBIZJtSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLdiBNm6Ii7t81itFd745Qrnf6IvG9x39kXqKpwJH3X16B4rmpgTzYPp4MB7ZqDVtH1zUj0UkbavF4K+O8Z5HcQB2VD//W2N52XwzPg0OfRm2UquPhdZ2YmaQqgF/vjyYPUfPo40oH1dJqcwll04G81fTMMOS5owJ7/g9FMP/Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T9f/zfXV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T9f/zfXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=vJemQMyAN9XN9TuqroErY3J1cTeEvca4mk14bJmFW0w=; b=T9f/zfXV9dGb4qpQRNoyDvIpiO
	4WobFrqAznfycvdz6aV6X0x6YpZQK190Aawck5+xLnMoKG0s/hQoT/cWQRyWrB+b1Ne+FwZ35yVGv
	f7wgUXkuMP1V6BUiVU7Kv8qNXG+x7CjzlrvMYboajYe4Vw8VIl5zunPXJCnPY4uJdl/eoLxs0I3ST
	iVMnXtX730dxx8e8w0K49w66gaBJe/u3VbT+sNupcZ+mAdLQ7AMW/6+Ph07ZwYW1PuVFSi+nLQZxD
	iZcSmXLWEuP2HtUZCJpCZiyMT3qOUHp2s98Y79EWRlZg6OpJTIW9VoeA0RAWRtpKH6Y3aNOgjWJoV
	YRxT8pww==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4vKR-0000000Fzos-1skU;
	Fri, 11 Sep 2026 07:05:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] libxfs: remove xfs_inode.i_size
Date: Fri, 11 Sep 2026 09:05:39 +0200
Message-ID: <20260911070540.1760300-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is never actually initialized, and leaves a landmine if anything tries
to read from it.  Redirect all i_size read macros to i_disk_size instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index f07a34ec5d46..0292beecf903 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -252,7 +252,6 @@ typedef struct xfs_inode {
 	xfs_agino_t		i_next_unlinked;
 	xfs_agino_t		i_prev_unlinked;
 
-	xfs_fsize_t		i_size;		/* in-memory size */
 	struct inode		i_vnode;
 } xfs_inode_t;
 
@@ -337,7 +336,7 @@ static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
 /* We only have i_size in the xfs inode in userspace */
 static inline loff_t i_size_read(struct inode *inode)
 {
-	return XFS_I(inode)->i_size;
+	return XFS_I(inode)->i_disk_size;
 }
 
 /*
@@ -353,15 +352,8 @@ static inline bool XFS_ISDIR(struct xfs_inode *ip)
 	return S_ISDIR(VFS_I(ip)->i_mode);
 }
 
-/*
- * For regular files we only update the on-disk filesize when actually
- * writing data back to disk.  Until then only the copy in the VFS inode
- * is uptodate.
- */
 static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 {
-	if (XFS_ISREG(ip))
-		return ip->i_size;
 	return ip->i_disk_size;
 }
 #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
-- 
2.53.0

