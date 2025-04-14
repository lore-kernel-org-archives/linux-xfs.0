Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEF62CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609098; cv=none; b=eNUD4MrLvW5J8Js9ccqDH8JRtnn073ieXnay0S5/H7f0KLwWM8NxjhDXhJFjPOpK0JhK10+oUWgqpWs2b+kvqrLM80qvySrh6TxgtV8NMo/hjFtvfHIyuAMHYTlbjHzDwLLcSeHwsP1fE0OPRloSLjpimZtJbPk6NVSiJJtwgTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609098; c=relaxed/simple;
	bh=wBMu4o3thDlumaj6yNYZ//Rf7GIMESkQTm/5SO8yNG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQegWKxIGBiG8pR8cu1DGfMQWvrNTCUopR49HrZRvUmTAEA0Dh55gMkxmB3GD2Jec3dXtnwNg631S06y1TCx/ACf3mzgwfrGz0z3+SADQBBdwWbxDNgRO1DPedENuWn2codNAo7b8tpn407RTWVKeZX6Kw7lvG/XV60t+1ZO6jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KD3FJDlj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KD3FJDlj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jjuyOVFDZnaxhR12Qvrnd/hTbTEYf+aPUyd1ZlTapfo=; b=KD3FJDljNAAGbv7T8y9LYTqtTY
	k+4RMyHsSwdpwNc23FmKZE6jPxFhwttsESzPOwSIJQ7Ct1h9OtEPBURIoUJpEXzH+wL8VCIlchTvH
	IUC/7WCF313yXfmyArmyLdlRTho7gjjASV94uNA9Nyl7YgF2jQrK0Jdnz3sLzNVzfQO1g+RPTQzL3
	0BVR6us4cJkKMEOH4oXg1OI0FMtxFfxt+ZagKUEOO+WJQPZzJ9zh/m+0x+DvJ9FRXt21n7w586GEA
	zzeU+rR18Y/MBnjScHboCXmcj2aprTLI2XaRmr1YX7qAAJvqJSZH/Q3dpN3vsQJt7nxT6UewiXnxX
	MJwFUQGQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWO-00000000iRp-3RlK;
	Mon, 14 Apr 2025 05:38:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 37/43] xfs_io: correctly report RGs with internal rt dev in bmap output
Date: Mon, 14 Apr 2025 07:36:20 +0200
Message-ID: <20250414053629.360672-38-hch@lst.de>
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

Apply the proper offset.  Somehow this made gcc complain about
possible overflowing abuf, so increase the size for that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/bmap.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/io/bmap.c b/io/bmap.c
index b2f6b4905285..944f658b35f0 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -257,18 +257,21 @@ bmap_f(
 #define	FLG_BSW		0000010	/* Not on begin of stripe width */
 #define	FLG_ESW		0000001	/* Not on end   of stripe width */
 		int	agno;
-		off_t	agoff, bbperag;
+		off_t	agoff, bbperag, bstart;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
-		char	rbuf[32], bbuf[32], abuf[32];
+		char	rbuf[32], bbuf[32], abuf[64];
 		int	sunit, swidth;
 
 		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
 		tot_w = MINTOT_WIDTH;
 		if (is_rt) {
+			bstart = fsgeo.rtstart *
+				(fsgeo.blocksize / BBSIZE);
 			bbperag = bytes_per_rtgroup(&fsgeo) / BBSIZE;
 			sunit = 0;
 			swidth = 0;
 		} else {
+			bstart = 0;
 			bbperag = (off_t)fsgeo.agblocks *
 				  (off_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
@@ -298,9 +301,11 @@ bmap_f(
 						map[i + 1].bmv_length - 1LL));
 				boff_w = max(boff_w, strlen(bbuf));
 				if (bbperag > 0) {
-					agno = map[i + 1].bmv_block / bbperag;
-					agoff = map[i + 1].bmv_block -
-							(agno * bbperag);
+					off_t bno;
+
+					bno = map[i + 1].bmv_block - bstart;
+					agno = bno / bbperag;
+					agoff = bno % bbperag;
 					snprintf(abuf, sizeof(abuf),
 						"(%lld..%lld)",
 						(long long)agoff,
@@ -387,9 +392,11 @@ bmap_f(
 				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
 					boff_w, bbuf);
 				if (bbperag > 0) {
-					agno = map[i + 1].bmv_block / bbperag;
-					agoff = map[i + 1].bmv_block -
-							(agno * bbperag);
+					off_t bno;
+
+					bno = map[i + 1].bmv_block - bstart;
+					agno = bno / bbperag;
+					agoff = bno % bbperag;
 					snprintf(abuf, sizeof(abuf),
 						"(%lld..%lld)",
 						(long long)agoff,
-- 
2.47.2

