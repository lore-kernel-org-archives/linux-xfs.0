Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4087A59165
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 21:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710366064; cv=none; b=EwLQxxnT/QcihvazMUJh1RM8X5cv5aiOOwdttAkeXO+VboFIToJ5oc2pLwNVGJiun/Ty+21x8pZH2FGW8y70g+BUhyg80drAVYClRrBSECHyVnkC6to3dISEBfICKbR2zcS9lDyIx4snLSAg9exBLKOYxlNFWeH9bVJFzViQO+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710366064; c=relaxed/simple;
	bh=6lKCYp2feBw6fXkg3vLXnBSySd/0F6UjYk+9YS0pHig=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YSggHNd7b95YS78QDJy7OeWZAQSoCnyekHOkJFNYuaxjxIyJzow0S3+sK2l6kPSY84WQAGjEJ2fmANJygzaMCDLxPomVf5R0mAoEIC3z5Em42QU60Lp1KiriP1xQzOrn/XVmYamz53YQvQNKIsGUkDaDvfnZx10VqM8ZXytUWJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OKgerhn8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OKgerhn8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3EWpzVhg/zPlEuxPjsGAYy8nVqO2aOBX7RcVuolcSC0=; b=OKgerhn8bPloOw4vVdxA5brOBA
	twuuzm0bhaLhpPOwNxMrJSedgKd2jYAjtBiavhqYdjc/WFpkkfSKxH1CJR4ZKce+47N0xeTPc2Tme
	Xkpl0xx5hXMOEz2j5bdXdzbRdxiRwwfU+yRKuEZIX1zCb1OtC69zLavojiQWiCX6VM60+jRtx2mcq
	wF6EV/N0bHJQtVegdID1kv+oXsdNb13JIJMlRJQiLDC5wihMRV7HMrVxm3U7MMAzdvC8kaJVc9nYc
	zVWPA/u7LREwpJuis2a/mKhDakLihmJw8/vEF807qHpF17pkjbgQvqCIgvC14mFlAfMbMT9yFaES6
	SX9/ucrQ==;
Received: from [206.0.71.29] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkWLO-0000000Bxq2-1jKd;
	Wed, 13 Mar 2024 21:41:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 3/5] libxfs: remove the S_ISREG check from blkid_get_topology
Date: Wed, 13 Mar 2024 14:40:49 -0700
Message-Id: <20240313214051.1718117-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240313214051.1718117-1-hch@lst.de>
References: <20240313214051.1718117-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The only caller already performs the exact same check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/topology.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/libxfs/topology.c b/libxfs/topology.c
index 63f0b96a5..706eed022 100644
--- a/libxfs/topology.c
+++ b/libxfs/topology.c
@@ -178,15 +178,6 @@ blkid_get_topology(
 {
 	blkid_topology tp;
 	blkid_probe pr;
-	struct stat statbuf;
-
-	/* can't get topology info from a file */
-	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
-		fprintf(stderr,
-	_("%s: Warning: trying to probe topology of a file %s!\n"),
-			progname, device);
-		return;
-	}
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)
-- 
2.39.2

