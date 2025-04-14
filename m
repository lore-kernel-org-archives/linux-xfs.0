Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F6148832
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609079; cv=none; b=k7EcogxSgDSEV9qvfGRgicooeK1WyenoM6mI7OixjXDXrhEQ74K34BFvSkwLKn2B6zEOcQ8EWSnoeRe8kdHou6sukFKfkSWM4mVzRadaB65fZNMoGLn3M/IPehbfSPcWq0ZrnFiIJsKEPTgLFouPlzRcxB0QgQCXoHBHBSQXufw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609079; c=relaxed/simple;
	bh=U2MELDivvYOtLkUw4UAUAtU57x944Tz8q593ZLvXSp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aCB+Hdgae8tXH3AdQOAdZL5NiAE0BVo3xzVtCpwvzsg+UY3qZ4p2Tkz+EkJnbWGSdDHXyQlSJOgRZpCL9a7mB394OILM4xPuEiPEdsbJ4l1Aaj7t6a+gr8rxERKVKad6PyX/iYNT9ADiLRoOQNBvhASgRmN0au+Eurqbk6lVKD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cA/FLgAY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cA/FLgAY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MCk7Qv5+U2kmAzN0IkwtZq6ArOL0ilED98VDtxXq+9Q=; b=cA/FLgAYmhOUwvgA8X2Hp8zjvE
	yypB6IrqvwPLl+EisjW4v2aIcbzIE/nzXvFpN8ENbA12Za6fnZtZSFlqLuuwK1egBuHECoEIymPZC
	0nH04TIHneRYsx4DsegLQQ3l2KVD6g3xvJbXvFnyB8abByi5tzSSJTZCk577zw4uK7MjE7fRN3Lxg
	IxVOrYE1tIcPEl+Xi4koTugE2CD97hzKt6ruKp96b7a5wxq6GvLUokEozn1KtAk0X3enSxIl8sreJ
	S+SyZPD81MT6psH//EuSJBN41n8qzo6v+jCQMb1LdPtFN4izss9CscwpfHxu0Qy4WdamX55e3/a3e
	xkyOnGqQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CW5-00000000iMq-3GgP;
	Mon, 14 Apr 2025 05:37:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 30/43] xfs_mkfs: factor out a validate_rtgroup_geometry helper
Date: Mon, 14 Apr 2025 07:36:13 +0200
Message-ID: <20250414053629.360672-31-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Factor out the rtgroup geometry checks so that they can be easily reused
for the upcoming zoned RT allocator support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 67 +++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ec82e05bf4e4..13b746b365e1 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3950,6 +3950,42 @@ out:
 	cfg->rgcount = howmany(cfg->rtblocks, cfg->rgsize);
 }
 
+static void
+validate_rtgroup_geometry(
+	struct mkfs_params	*cfg)
+{
+	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgsize,
+				XFS_MAX_RGBLOCKS);
+		usage();
+	}
+
+	if (cfg->rgsize % cfg->rtextblocks != 0) {
+		fprintf(stderr,
+_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
+				(unsigned long long)cfg->rgsize,
+				(unsigned long long)cfg->rtextblocks);
+		usage();
+	}
+
+	if (cfg->rgsize <= cfg->rtextblocks) {
+		fprintf(stderr,
+_("realtime group size (%llu) must be at least two realtime extents\n"),
+				(unsigned long long)cfg->rgsize);
+		usage();
+	}
+
+	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
+		fprintf(stderr,
+_("realtime group count (%llu) must be less than the maximum (%u)\n"),
+				(unsigned long long)cfg->rgcount,
+				XFS_MAX_RGNUMBER);
+		usage();
+	}
+}
+
 static void
 calculate_rtgroup_geometry(
 	struct mkfs_params	*cfg,
@@ -4007,36 +4043,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
 				(cfg->rtblocks % cfg->rgsize != 0);
 	}
 
-	if (cfg->rgsize > XFS_MAX_RGBLOCKS) {
-		fprintf(stderr,
-_("realtime group size (%llu) must be less than the maximum (%u)\n"),
-				(unsigned long long)cfg->rgsize,
-				XFS_MAX_RGBLOCKS);
-		usage();
-	}
-
-	if (cfg->rgsize % cfg->rtextblocks != 0) {
-		fprintf(stderr,
-_("realtime group size (%llu) not a multiple of rt extent size (%llu)\n"),
-				(unsigned long long)cfg->rgsize,
-				(unsigned long long)cfg->rtextblocks);
-		usage();
-	}
-
-	if (cfg->rgsize <= cfg->rtextblocks) {
-		fprintf(stderr,
-_("realtime group size (%llu) must be at least two realtime extents\n"),
-				(unsigned long long)cfg->rgsize);
-		usage();
-	}
-
-	if (cfg->rgcount > XFS_MAX_RGNUMBER) {
-		fprintf(stderr,
-_("realtime group count (%llu) must be less than the maximum (%u)\n"),
-				(unsigned long long)cfg->rgcount,
-				XFS_MAX_RGNUMBER);
-		usage();
-	}
+	validate_rtgroup_geometry(cfg);
 
 	if (cfg->rtextents)
 		cfg->rtbmblocks = howmany(cfg->rgsize / cfg->rtextblocks,
-- 
2.47.2

