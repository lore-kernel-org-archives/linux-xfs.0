Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC141401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609114; cv=none; b=QqUoZjJIz8/Iy3dcG/CLm4NLgIUxMFSXdJ+RktRSYgUPy8Zl1LoRzlVnMFtxXvzyBjnSjX0pj5JT2HTG6cysM445/7shFB9WbR0tTcU30RrxMEONhaYFqx/nwsDZXhws/kDiz9dmxPGhqAiR6pkSkh/a2338SPmngSadkhy0JY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609114; c=relaxed/simple;
	bh=D21ckeVturXW/TI/gwdPJuA7lF+fJ1gSiu8RVL1lh6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg3aPj1/OUYKFWo5nh2btCKi9G8K1SXZZ+fgPulWEvjw9JSkBJDF/R6L1t4+I0Si8GxGDSc0EP6lxqxFkan58PF8DS5Xv/1SQj4ztkfaxZlxfyx2ALAHtaA4qhBq0LnXXRrAKWnkQp+vfXazNXVPoNWlzwY4xgGDUhGqvf/Inxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q4K/giPF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q4K/giPF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XzkeH5mGsoEIfbzb+6MiQUhJC3NxRBLcpYrQpffdMUM=; b=Q4K/giPFZ8h/U45bArXvEm6Sg9
	3ed0eGboDH4+FVEXmZx6cjl3IFMN02w0BG5gVoupJa0CX8l3TZgOolERskIfqgIVhR2Tnmlgdi5lR
	zd4RyCU4/mTJqiD5woOvv1/djDkiZxisHZMErSQq0Qg6/RNoX0YEbEGKpEkmpeK7kb6WCHqvOjN7c
	kzaR3HLM4n8bPGGr/WbgKw0m8wI4wjiePCZm7yNQgaZwMoC2fAD7UPI0poiI9vq/ikrhD5bGRmxx8
	k4AQ2eDdyTse5U5J6xXfGFaqaP21MJGmIt8qzL4Dk4BkpQbDN1jyS5NF/zYEAeTk1P47EwY1vNEww
	B67pX7iw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWd-00000000iUx-0OqJ;
	Mon, 14 Apr 2025 05:38:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 43/43] xfs_growfs: support internal RT devices
Date: Mon, 14 Apr 2025 07:36:26 +0200
Message-ID: <20250414053629.360672-44-hch@lst.de>
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

Allow RT growfs when rtstart is set in the geomety, and adjust the
queried size for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 growfs/xfs_growfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 4b941403e2fd..0d0b2ae3e739 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -202,7 +202,7 @@ main(int argc, char **argv)
 			progname, fname);
 		exit(1);
 	}
-	if (rflag && !xi.rt.dev) {
+	if (rflag && (!xi.rt.dev && !geo.rtstart)) {
 		fprintf(stderr,
 			_("%s: failed to access realtime device for %s\n"),
 			progname, fname);
@@ -211,6 +211,13 @@ main(int argc, char **argv)
 
 	xfs_report_geom(&geo, datadev, logdev, rtdev);
 
+	if (geo.rtstart) {
+		xfs_daddr_t rtstart = geo.rtstart * (geo.blocksize / BBSIZE);
+
+		xi.rt.size = xi.data.size - rtstart;
+		xi.data.size = rtstart;
+	}
+
 	ddsize = xi.data.size;
 	dlsize = (xi.log.size ? xi.log.size :
 			geo.logblocks * (geo.blocksize / BBSIZE) );
-- 
2.47.2

