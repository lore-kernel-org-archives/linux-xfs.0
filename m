Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752A30C621
	for <linux-xfs@vger.kernel.org>; Wed, 22 Oct 2025 08:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761123170; cv=none; b=r/Hqtbjp1v+loLZccG990/EXr9c8EVRPA7Xm5HAFT2/6pBvU/rTfcq0P9WhTP3xna1bO3T6ddlMbPU6AJP6gA1GTogV2fVX4kHCdDGN+QuTf4KArabEsq6whi55vD0pRlOxgzRI31GeQSVMNk9T7sWKQf/k1Fk5roEFbe1akve8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761123170; c=relaxed/simple;
	bh=JfYktLT6YqC1r25Xwy0EaXRKJz+751lc8GGVcvU2i6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Km3WgGfJYTM2Mmy+cmcsNlmVl+Yc0+xgV4EiBSmW7uG+ilQ4o6tCS8AZzWfF3f3v/GT4lgzEyiqI6OrdLYMx2mVsHjCDEKftiObzQX3e84JVL2uynZbEeBqxuH2fS92P6LKJq7qOIzSW/Dii6wGRPuQZGSGytAGNp3FiauiyY4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KX3N9WWq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KX3N9WWq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0Enao5KsLESh1gq6dyFDFpndN3An7PexK4QAjcGVmBU=; b=KX3N9WWqPzhU3BNkWIGjB1QJhn
	oO7YHP3ZZJN1dJfRdzk5WGjxdOp3t7R8kxakV0XXyByw/Am2CHE2UcQZtQoYXBfgZtHHc0z5Zrdmj
	Zs1gra83uSm3slpQNtNApd+FVYKj3j5VPV5jjmF4qnh6CSQ5pDR4sHb5urCM3RIYPQ87C9fcrbbE8
	9/obFkbCERfl7s++d3x3khuTX/N6CrcMmb8WvND2FSBuhZFu9+NL+XPVE19i60YwLU5mU/j3ik8r5
	OaU+dv8f1m1UmrhgOPiWtLf45QKK/z9qnM7tuzNaGnRokV7zk9DSBwhLoZ7+lGI2hI2Bvh86a94ey
	SrGK356A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBUaO-000000029TR-28hW;
	Wed, 22 Oct 2025 08:52:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] mkfs: improve the error message in adjust_nr_zones
Date: Wed, 22 Oct 2025 10:52:05 +0200
Message-ID: <20251022085232.2151491-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251022085232.2151491-1-hch@lst.de>
References: <20251022085232.2151491-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Print the zone counts to help the user to understand the problem.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e66f71b903eb..cb7c20e3aa18 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4552,11 +4552,11 @@ adjust_nr_zones(
 	if (!cli->rgcount)
 		cfg->rgcount += XFS_RESERVED_ZONES;
 	if (cfg->rgcount > max_zones) {
-		cfg->rgcount = max_zones;
 		fprintf(stderr,
-_("Warning: not enough zones for backing requested rt size due to\n"
+_("Warning: not enough zones (%lu/%u) for backing requested rt size due to\n"
   "over-provisioning needs, writable size will be less than %s\n"),
-			cli->rtsize);
+			cfg->rgcount, max_zones, cli->rtsize);
+		cfg->rgcount = max_zones;
 	}
 	new_rtblocks = (cfg->rgcount * cfg->rgsize);
 	slack = (new_rtblocks - cfg->rtblocks) % cfg->rgsize;
-- 
2.47.3

