Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B57126F07
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588120; cv=none; b=h/2aMcstQTd/mvXr6C2LyX4tQA+oTo/H8LChr4i1yZ9AZM/bJ6t9Sz9lHRAJBBbvfXMwje5fQAsU/KtNEwye44xnlyAtwxCwfnJtvEp9XDeEhmw0alqhJiR674/lYzdGRmB+cVXj3HG2jPTntu47bd1njaCgwnZRmWk+RDMbwbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588120; c=relaxed/simple;
	bh=xSyOvHZ2Rg1meoF7lsgLqvQJ9MKhZrGcG8nQvn73so0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cX/130sG1YQDZC6egoz7vvN5ju1SNR3390zSaVzJnHy5w6GkcrVbr821Cr1xneLz2ba6iiuj4JuGwvbqGk08Gcpu8Wt/BasS7dMffY1hAAb7bYULqVkkUqqJzUWpl/lnMRm/TEDLeuLTaXeEkadSM91wvAb3IbuWGOCHTDdEzSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DnvTM+6c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DnvTM+6c"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kaXGpLOIphVjuOCmCreMUGH36Gotq20lkJTAcV8g32o=; b=DnvTM+6cwjAzg4kyzvUqDGPVx9
	nyuOtzgQGUpjGXPK0zYvb+3LdDDZPQZ6F7syahs91fMjS32qNXCX8HWXPMSkAKyPYxTXFqLZIIDuR
	CJB1LGExszcpbJLHdgRkLetkP7euU4cZ1Tt0DNq1oDSRyzS/cdXjHwkznIVg0gRFv0BToqy4HofpT
	C82TKds44rjx2DadIlNwdc6RyXYtfjars1oa2BCQcAOGshmbPucku3+cBldnwJxYZLd0OEfEd1NR3
	k2grD/iZsbdx1Mx+8/qymFpYJYokKcdHdgkubAKLmoYjjy7sk2H9yT5ckhxM6CNm/9LTW3Njb1DB6
	/m6KDA1w==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOz-0000000FwbI-1Fgb;
	Mon, 08 Apr 2024 14:55:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 8/8] xfs: do not allocate the entire delalloc extent in xfs_bmapi_write
Date: Mon,  8 Apr 2024 16:54:54 +0200
Message-Id: <20240408145454.718047-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240408145454.718047-1-hch@lst.de>
References: <20240408145454.718047-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While trying to convert the entire delalloc extent is a good decision
for regular writeback as it leads to larger contigous on-disk extents,
but for other callers of xfs_bmapi_write is is rather questionable as
it forced them to loop creating new transactions just in case there
is no large enough contiguous extent to cover the whole delalloc
reservation.

Change xfs_bmapi_write to only allocate the passed in range instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7700a48e013d5a..748809b13113ab 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4533,8 +4533,9 @@ xfs_bmapi_write(
 			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
 			if (wasdelay) {
-				bma.offset = bma.got.br_startoff;
-				bma.length = bma.got.br_blockcount;
+				bma.length = XFS_FILBLKS_MIN(bma.length,
+					bma.got.br_blockcount -
+					(bno - bma.got.br_startoff));
 			} else {
 				if (!eof)
 					bma.length = XFS_FILBLKS_MIN(bma.length,
-- 
2.39.2

