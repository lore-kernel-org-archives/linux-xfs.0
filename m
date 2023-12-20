Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05211F61C
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 06:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UVY+IjMK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MgRBIWkaSGIGX140D7gJ7zKlj0SCdt271ixHDFJMPrk=; b=UVY+IjMKp3+DKw54tFqTbBv93y
	aaPfD1b6l0ywuOkSYGJWr3A9dJN1vGDrqm+Tzo2r7VfkoILCQtbq032juXAAeZ+taDyIHplCsXEr9
	QIlI5AKP8DbLpbOLvH12c6quh+mEZWCqp6Tc74JDmCGf9Haiw/3YGsAmFvtbM9pGURJTcOtzcCv6M
	yHZIPCF9vO3IQCucRhw4sjy5+Nmcnn2prCvXUNo0e2MSP1hM6B4HewC2utf6sOyZE7e5SwUM2mfNY
	QRaKjn0erFRfDCgjqGW+AVMRjMg9A2NrBg09NB8bP3rko1jpkT1AsSaN11J3N48ArjJuEhQhBDmjX
	Ky8NyODw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rFqAt-00GJSh-2o;
	Wed, 20 Dec 2023 06:35:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: turn the XFS_DA_OP_REPLACE checks in xfs_attr_shortform_addname into asserts
Date: Wed, 20 Dec 2023 07:35:03 +0100
Message-Id: <20231220063503.1005804-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231220063503.1005804-1-hch@lst.de>
References: <20231220063503.1005804-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Since commit deed9512872d ("xfs: Check for -ENOATTR or -EEXIST"), the
high-level attr code does a lookup for any attr we're trying to set,
and does the checks to handle the create vs replace cases, which thus
never hit the low-level attr code.

Turn the checks in xfs_attr_shortform_addname as they must never trip.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ec4061db7ffccd..9976a00a73f99c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1072,8 +1072,7 @@ xfs_attr_shortform_addname(
 	if (xfs_attr_sf_findname(args)) {
 		int		error;
 
-		if (!(args->op_flags & XFS_DA_OP_REPLACE))
-			return -EEXIST;
+		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
 
 		error = xfs_attr_sf_removename(args);
 		if (error)
@@ -1087,8 +1086,7 @@ xfs_attr_shortform_addname(
 		 */
 		args->op_flags &= ~XFS_DA_OP_REPLACE;
 	} else {
-		if (args->op_flags & XFS_DA_OP_REPLACE)
-			return -ENOATTR;
+		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
-- 
2.39.2

