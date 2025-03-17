Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91423219A79
	for <linux-xfs@vger.kernel.org>; Mon, 17 Mar 2025 05:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742190552; cv=none; b=AnHvW1u8kqGAiPzL/ZxmOvToOdk9mslz2mZUtVo0MgYHr2dGdZp+rBivLjOIxAIA95XG4Ai54Wpca4mCGyX+wK+Hf8R+nj7cYc7iNqgTE9ovuK1m5V8Qmi70W/Rd1kD9HpMBguezh+zQgdr3miChz+Qr5mk+bB6KRnr9W/9VgVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742190552; c=relaxed/simple;
	bh=fPmDTdfO/+jLAnCyNNaSuoWNPbeN3xe9ZkrqNMQH5Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGiAvoE7RtPqcmiX8eI9U2VIBisH6eFjz/hyzLAK/uaZCGMYLVvpLI/jThEEoCmbnritDi+7Kzsq8nGaoaybGDwo0jKLZNOUh/6hUl3WWUOL7G6HUuQ/J+R814UA0WraBcd2EHXlVCRyGSfNbEyV2Q+6pIFreyp9wJgmDBQx1o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ku+MvIKS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ku+MvIKS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tpAgpCh8XCRzIdJBx/rREKeqv7suLQPlYqpqfq9N6JU=; b=ku+MvIKShDr3sp2iIi4qMpAqni
	qy1xxA241qHEQvMzZK6sTtdRqM1jzLYmJrtzn0N+ro55326w8Yo/FvnKogxYBKtheCr4TKrgjXqXN
	QftnYIj5xGvw6F5vpJ8mHmJwegUV5lKArX+2czT39+L+GXmUTNeNkHf1OAPG/ke1Y8frZsJtVtIA/
	XeE2uWlmIZOwXZVOAClaNt3wODWdmt3AmrXj/xYvUDGKjllu3ppjRA3Q1YHdRInCXLlucuAeTwn66
	a1PA1vw5x9y7mBWAkELPJ3DSipkrgvw0QNSrO76ZgIXWjQzI+hTeQWFJ+FKI20nvX3jDSRDIAMfl2
	CR6LIemw==;
Received: from [2001:4bb8:2dd:4138:8d2f:1fda:8eb2:7cb7] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tu3La-00000001Iqc-2Por;
	Mon, 17 Mar 2025 05:49:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: remove the flags argument to xfs_buf_get_uncached
Date: Mon, 17 Mar 2025 06:48:36 +0100
Message-ID: <20250317054850.1132557-6-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250317054850.1132557-1-hch@lst.de>
References: <20250317054850.1132557-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

No callers passes flags to xfs_buf_get_uncached, which makes sense
given that the flags apply to behavior not used for uncached buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_ag.c | 2 +-
 fs/xfs/xfs_buf.c       | 5 ++---
 fs/xfs/xfs_buf.h       | 2 +-
 fs/xfs/xfs_rtalloc.c   | 2 +-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index b59cb461e096..e6ba914f6d06 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -301,7 +301,7 @@ xfs_get_aghdr_buf(
 	struct xfs_buf		*bp;
 	int			error;
 
-	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, 0, &bp);
+	error = xfs_buf_get_uncached(mp->m_ddev_targp, numblks, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 6469a69b18fe..8e7f1b324b3b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -810,7 +810,7 @@ xfs_buf_read_uncached(
 
 	*bpp = NULL;
 
-	error = xfs_buf_get_uncached(target, numblks, 0, &bp);
+	error = xfs_buf_get_uncached(target, numblks, &bp);
 	if (error)
 		return error;
 
@@ -836,13 +836,12 @@ int
 xfs_buf_get_uncached(
 	struct xfs_buftarg	*target,
 	size_t			numblks,
-	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp)
 {
 	int			error;
 	DEFINE_SINGLE_BUF_MAP(map, XFS_BUF_DADDR_NULL, numblks);
 
-	error = xfs_buf_alloc(target, &map, 1, flags, bpp);
+	error = xfs_buf_alloc(target, &map, 1, 0, bpp);
 	if (!error)
 		trace_xfs_buf_get_uncached(*bpp, _RET_IP_);
 	return error;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 6a426a8d6197..d0b065a9a9f0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -273,7 +273,7 @@ xfs_buf_readahead(
 }
 
 int xfs_buf_get_uncached(struct xfs_buftarg *target, size_t numblks,
-		xfs_buf_flags_t flags, struct xfs_buf **bpp);
+		struct xfs_buf **bpp);
 int xfs_buf_read_uncached(struct xfs_buftarg *target, xfs_daddr_t daddr,
 		size_t numblks, struct xfs_buf **bpp,
 		const struct xfs_buf_ops *ops);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e35c728f222e..6484c596ecea 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -839,7 +839,7 @@ xfs_growfs_rt_init_rtsb(
 		return 0;
 
 	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
-			0, &rtsb_bp);
+			&rtsb_bp);
 	if (error)
 		return error;
 
-- 
2.45.2

