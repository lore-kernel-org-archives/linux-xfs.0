Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8A546529
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qhgDV9ns"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WeC51e5purpAC0dqV8Fd15FiwXxzN6RKpWk96v4MgZ4=; b=qhgDV9nswprescxq5gTTQE49jO
	eH410oUuLTvXcqMAUtkn9+1u/sy8r7IrjIg2A7OZUXn5nb8HseBW78AQJMcEKx+7Zq4RzG3dxPIY3
	/u8S7buoalIjZDGJkGE8DXocNATCoK5PvcJscu4U+RmVu7ryj7UpsMJmQHd+5Uy1yrqibD6Fy1Uvg
	GvMbQ6u9FyqFWyk9LqnpyiKGwHJoZ6It/LlOVZ1D5xQLM5UX1H4RB60tWWl0s8E69P8ABfaINEQ1m
	5x1K3+Ns5eRU+i4olNFgPB3H8upNOOUfMm88CffuGjEqdPOL3jLWx9uHbXeTBHIQy2pa6XXC0Pe5V
	HoVqTBAA==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYb-008AGO-1g;
	Sun, 17 Dec 2023 17:04:01 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: move the xfs_attr_sf_lookup tracepoint
Date: Sun, 17 Dec 2023 18:03:45 +0100
Message-Id: <20231217170350.605812-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231217170350.605812-1-hch@lst.de>
References: <20231217170350.605812-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

trace_xfs_attr_sf_lookup is currently only called by
xfs_attr_shortform_lookup, which despit it's name is a simple helper for
xfs_attr_shortform_addname, which has it's own tracing.  Move the
callsite to xfs_attr_shortform_getvalue, which is the closest thing to
a high level lookup we have for the Linux xattr API.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2e3334ac32287a..37474af8ee4633 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -876,8 +876,6 @@ xfs_attr_shortform_lookup(
 	struct xfs_attr_sf_entry	*sfe;
 	int				i;
 
-	trace_xfs_attr_sf_lookup(args);
-
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -905,6 +903,9 @@ xfs_attr_shortform_getvalue(
 	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
+
+	trace_xfs_attr_sf_lookup(args);
+
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
 				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-- 
2.39.2

