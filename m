Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BFC171B9
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 12:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tYbkzFiu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T2vqxUGgVLhpqEskNqfOC0xAKGuZIa73xwqhQrj4eJk=; b=tYbkzFiuEMVjoS/Z1Lf2VVtqEy
	zTXbjDVLiqJcaeN+r2QpjDnrpFUQ78/eWXb03L8vSMiBazG645iSNyao+8waILs/ET76+4Ssn9tQq
	SpM2TZIEpe1WG+OGr4/hkuFybH8bhG5DaQuCXGHLUfzmP+PJjkBCDv+TWXWlVOA/Gu1rPUwlHYIdK
	Ee3YH6OV99GTW6eD+XdVz8pmRN19ZZ2eJXWO7miGfwgByNe129ko2QAg6Ja9akLtXUPodudAbeb+c
	jbNw8FBunCgZLhLRJQbGC3snIniwPU5w41UJWUujAi5mlays42orhp3y6X/+qiD7XhzsjyV07JrBH
	F5ko6/6Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFYte-00DyDn-0N;
	Tue, 19 Dec 2023 12:08:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/8] xfs: move the xfs_attr_sf_lookup tracepoint
Date: Tue, 19 Dec 2023 13:08:12 +0100
Message-Id: <20231219120817.923421-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231219120817.923421-1-hch@lst.de>
References: <20231219120817.923421-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

