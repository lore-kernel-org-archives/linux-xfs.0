Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFE044C9B
	for <linux-xfs@vger.kernel.org>; Sun, 17 Dec 2023 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jVbXfM1y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FQ8zTlIpDnWeJMBqPQ8S7sWdunjXIHi344Rq7zep4CQ=; b=jVbXfM1ydEmfVISGGe7QYhigLD
	W/5u4QXS4T2D1EO3/JT8Lnqsr5vaV2gcjaN+C28iHeSigZusXVNO1DkRvy98IpNabMi1GimVzrG74
	oy+PtOOdWA1fHpHcQKuyIzoCUSYWQZG1/vaIGIaD9gjsU1cZdpBxKTR+yIV76iaGrKVN33OkS5w6W
	EvMJiZR7ICRLcwAa+VAAi9JPI28SlGnp/47jdUU9q5oKRQ/ewnrAgT7MeOUS8fpMwsEYxps1EIhkR
	FEFtxc5KozZExFJkMzzOSGILLUWHPBT5aKs3GZUCuoG8kmcXopGRr9uCeEkyDRsulR/SAY0XAzwnM
	CbeXDCmg==;
Received: from [88.128.92.84] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rEuYj-008AIN-2l;
	Sun, 17 Dec 2023 17:04:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
Date: Sun, 17 Dec 2023 18:03:48 +0100
Message-Id: <20231217170350.605812-7-hch@lst.de>
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

xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
Use the helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 75c597805ffa8b..82e1830334160b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -848,23 +848,17 @@ int
 xfs_attr_shortform_getvalue(
 	struct xfs_da_args		*args)
 {
-	struct xfs_attr_shortform	*sf = args->dp->i_af.if_data;
 	struct xfs_attr_sf_entry	*sfe;
-	int				i;
 
 	ASSERT(args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL);
 
 	trace_xfs_attr_sf_lookup(args);
 
-	sfe = &sf->list[0];
-	for (i = 0; i < sf->hdr.count;
-				sfe = xfs_attr_sf_nextentry(sfe), i++) {
-		if (xfs_attr_match(args, sfe->namelen, sfe->nameval,
-				sfe->flags))
-			return xfs_attr_copy_value(args,
-				&sfe->nameval[args->namelen], sfe->valuelen);
-	}
-	return -ENOATTR;
+	sfe = xfs_attr_sf_findname(args);
+	if (!sfe)
+		return -ENOATTR;
+	return xfs_attr_copy_value(args, &sfe->nameval[args->namelen],
+			sfe->valuelen);
 }
 
 /* Convert from using the shortform to the leaf format. */
-- 
2.39.2

