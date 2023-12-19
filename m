Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC95171AB
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="y7ujgT7g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+Fiypp/QeCpCm9MIET+zw1PySB6Efa5HJ0qpyIuyyuE=; b=y7ujgT7gi1zNoRpUElvT+86nle
	5Id3YYwd47kn/SAvTNcUMeuszCa07yEAefcba8IA4o1HXqlJdUxV8iMo3oQByNbLUM4/i7BUYGL4V
	vVCZEFbmqCs8JNdpyl2xBwHH5/YuqRvjH7fEXr2wz9Sf4SCEDPXRUJStz0dK60WC+4kxMstmt8Yc0
	cr8vqUuXgtHmvlczEmiHrfqU/H/qWFBlFvG6L6IPnH40vbQYYFt1w2vs9lx4TIZ1ydprx6T5RNmBO
	74NtoKSQmRH9XQLK2l2OxdFv7ZwCsKVjW3/us222x4+cOWtJNFpxXEnbcUuNUm5baCiep92CZhmfX
	yuLSby7g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFYtl-00DyEF-0N;
	Tue, 19 Dec 2023 12:08:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: use xfs_attr_sf_findname in xfs_attr_shortform_getvalue
Date: Tue, 19 Dec 2023 13:08:15 +0100
Message-Id: <20231219120817.923421-7-hch@lst.de>
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

xfs_attr_shortform_getvalue duplicates the logic in xfs_attr_sf_findname.
Use the helper instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

