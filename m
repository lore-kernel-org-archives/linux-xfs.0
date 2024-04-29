Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F810D534
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371341; cv=none; b=FsQJYJ6NZEcRV10zpiiF3pSpmRNjwPIwNGr9IeFtpziQ6ZuVPTyxiAug2gxMubjpS2TH0+b2TyMgBCgh8TafK283awI+G+OrKyMC+ihV++mnP7lpInvIXEzCLyrOSOINrqnTLo7inoepA/fJgr8e40J13ERQ9qjg2UsX13QXilE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371341; c=relaxed/simple;
	bh=x+bwI0h3Sw363+KCqhUmoRGZnbhHS6zmLPC0eK+2Hvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cz8+uSYjKt++HVB8Md68fNQG8hE0ULO32jGkIb4u+iLI2GNsN3NlpoLp4tcOivcNa6qch8k7FfhEPAYMyOeKH7jUUVVPPfciADZkA6iZbMucKXCww7HYwvK3R+K2WpbMK8oiiteCT0Oic9iZiOi3QjqBaVFVuHMuZSDpZ9zyNA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PhdMo+xj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PhdMo+xj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iHkmBhkA81Vza9SmVcK/Iih05U/1+xHRggmweECE7I0=; b=PhdMo+xjkH63sA/theUge3Ficb
	0UyfiWSMMLvHbSNG9aLnI345yNBUHP/OkVay7NkffoNu5OlOKyy1FWjkgIYc3CRIDMQHhWNjOLih2
	HX0rcI7ym9yrmIb7PgsmPOYPbc1S58ruSVqxTDNH3gLGBxj6jLqTP2ON2D1/0NIDYLKadCivcb6zO
	tqREs2VlIRq4K1jbXPNzl82Ypajit4vcmUQq4NaXga3sMPElDCdwkJ66MQYEHePbPf0cGIGAo2GQt
	1eAd90HSyN8hS1gd4vvyoXbRr50G+juijt9HLsg7cM+NZLwLD0rIchJx7TFAPjwsHZzv5ZKiCPo6S
	yIvSAUpg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KId-00000001ciq-1i1a;
	Mon, 29 Apr 2024 06:15:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/9] xfs: lift a xfs_valid_startblock into xfs_bmapi_allocate
Date: Mon, 29 Apr 2024 08:15:23 +0200
Message-Id: <20240429061529.1550204-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmapi_convert_delalloc has a xfs_valid_startblock check on the block
allocated by xfs_bmapi_allocate.  Lift it into xfs_bmapi_allocate as
we should assert the same for xfs_bmapi_write.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1ea1b78ad5a560..ee8f86c03185fc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4221,6 +4221,11 @@ xfs_bmapi_allocate(
 	if (bma->blkno == NULLFSBLOCK)
 		return -ENOSPC;
 
+	if (WARN_ON_ONCE(!xfs_valid_startblock(bma->ip, bma->blkno))) {
+		xfs_bmap_mark_sick(bma->ip, whichfork);
+		return -EFSCORRUPTED;
+	}
+
 	if (bma->flags & XFS_BMAPI_ZERO) {
 		error = xfs_zero_extent(bma->ip, bma->blkno, bma->length);
 		if (error)
@@ -4712,12 +4717,6 @@ xfs_bmapi_convert_delalloc(
 	if (error)
 		goto out_finish;
 
-	if (WARN_ON_ONCE(!xfs_valid_startblock(ip, bma.got.br_startblock))) {
-		xfs_bmap_mark_sick(ip, whichfork);
-		error = -EFSCORRUPTED;
-		goto out_finish;
-	}
-
 	XFS_STATS_ADD(mp, xs_xstrat_bytes, XFS_FSB_TO_B(mp, bma.length));
 	XFS_STATS_INC(mp, xs_xstrat_quick);
 
-- 
2.39.2

