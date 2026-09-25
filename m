Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D78C400E15
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313252; cv=none; b=RKNMuLLKipG8pjtOOGy7qS9cau/PRWY0UurIzVBhjijptRgI2awGRYn+OZduFTRvLnvcG0Jslv0ZRxovbY/Ts4Zfn0Dcgtg6XlAXYpGeoEDs5aV+ov2Svcw5+rXcJFQUQavUDFtND5X5YqklZq/s9HThobqlqgdkk5Ok5aiO/0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313252; c=relaxed/simple;
	bh=T9ACBLkg5Qb7+kVrzd8FBiOvUjmNqd7NSsTePxcQBpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkeT9ptBBQghq+3zauQxdLNY3lP+0iy3sfed1ZSmvCOO8uP3pb6ixtKegszSUJPidjmEpAdEVzHHzQVLntKW5Niy4WsYQ8KlQOmCjSJNAS5k23n0ozNAXRw6169ARy7M8zd477aWoTHllZPZxIURvGW0gvdxhLEU+XkpzJuK/aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F9jsL6wF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F9jsL6wF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+l8m+aWBrl/0Lr+AI3xsBHdx0rB2Y12L+Cf9DIElFmk=; b=F9jsL6wFJSLd3qlgDpMRA1Vq5Y
	FEVR/xZ5TjRylyLoKf99FVRhsk2lGRP45Q8UBVFPu9zQvgyleoC0LQM1E4M8qsoXfcJlPOzLK4lKP
	K6zTRTLyKK6AqlfkcZP+Bwlgxp3AwGlMIIUhS7/PX/6TAE+nNC1qpKzISKBJrAQgxX4XytbItp8Ge
	M/4kbqwyCzTUybOt0DJWoPakWt6cyXERW1sEWL4swSZFj4lw6OQGvrqxSanNGuv1OeMB0saopfFq5
	gwIjq4wMJGpg4U0TYO1i4QrdJoMdKDg+szASjG9cVoa+Msyg1f1xUCmGns6fopibT1/CtRofeHVgQ
	VAUKG0BQ==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yG7-0000000CgdR-3x2k;
	Fri, 25 Sep 2026 05:14:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/10] xfs_db: remove a double-whitespace in rdump_regfile_data
Date: Fri, 25 Sep 2026 07:12:56 +0200
Message-ID: <20260925051336.2997014-11-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/rdump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/rdump.c b/db/rdump.c
index 7fd171a9d53f..a0177e5bd007 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -643,7 +643,7 @@ rdump_regfile_data(
 
 		fd_pos = XFS_FSB_TO_B(mp, irec.br_startoff);
 		if (XFS_IS_REALTIME_INODE(ip))
-			daddr =  xfs_rtb_to_daddr(mp, irec.br_startblock);
+			daddr = xfs_rtb_to_daddr(mp, irec.br_startblock);
 		else
 			daddr = XFS_FSB_TO_DADDR(mp, irec.br_startblock);
 
-- 
2.53.0

