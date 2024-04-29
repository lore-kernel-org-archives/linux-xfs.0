Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34D1101DA
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371344; cv=none; b=CdKDy5TOzVZSBYVvUVpXlN9rYlf+0y10KvA3N8pS8OIT60BdghJO6fqCbVqrwxu+IZLNBsuDJrr0Ml927FMkfl0wjgv0bEWVLmnlO3z39XEXsxJB0WIfnE/2G+8S5YM8fhawCUbqUYVPhWwd2rB38PhwGB/MwQeplpBQE/Pkpcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371344; c=relaxed/simple;
	bh=Lx3jFaLXRHLtD1SDoeQlGtRXJB62W6iX53QUoM0fFZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Sv8eabzFXWD8Qh4ugrmsZ9XRtfHtgkntjzj5Xoy9jHAdiuRb1fUkLlHZ/x4ZhSP1Ag3nAinAIZQAA1M1Qvl8XSDKCdLTw0Kapk8XaL0lD2NXuaRDE05JCMf6IK23dPT2+3+mYDdYokEf2To7b0sambPatTxWucovzz8/WWuRPL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bhHzJX8M; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bhHzJX8M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Uv2ouj9BLPeR3dwFzYKkTY4S4vz2j7mzWQDFj7Rn3yo=; b=bhHzJX8MJQp6GME0lEGbtnLQVX
	sCtQ4tFMsnYMrrKtLw9yI0widP1tvPHg8T6nzRdNl26qREs8U6dNLdL3JwgoywQPX1JlQ2RNFApVu
	Cqo3OUe1H7qA44WpzDKT9DvBhZbniuklV8zlpd8GHtXcdjKcqX+RP2V7sbVD0vZsR85UomNR6SeB+
	9e0/r2rjaDLttIDpTE6M+u3Tb+YIqkGbiQ2i9nQJbSFE59kUo2QYQdhlVZlrB1zhmlBHO6v+HcjtU
	gyPJuKmA6Fi6UNb3w15K7TkM8adLSmtfOeV/nqiZ13YaaXSPN27963WxqETFwFLLFZVsy27lA+aIc
	Pxk5+nGw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIg-00000001cjU-0mI8;
	Mon, 29 Apr 2024 06:15:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: don't open code XFS_FILBLKS_MIN in xfs_bmapi_write
Date: Mon, 29 Apr 2024 08:15:24 +0200
Message-Id: <20240429061529.1550204-5-hch@lst.de>
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

XFS_FILBLKS_MIN uses min_t and thus does the comparison using the correct
xfs_filblks_t type.  Use it in xfs_bmapi_write and slightly adjust the
comment document th potential pitfall to take account of this

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ee8f86c03185fc..f7b263d0b0cf1c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4528,14 +4528,11 @@ xfs_bmapi_write(
 			 * allocation length request (which can be 64 bits in
 			 * length) and the bma length request, which is
 			 * xfs_extlen_t and therefore 32 bits. Hence we have to
-			 * check for 32-bit overflows and handle them here.
+			 * be careful and do the min() using the larger type to
+			 * avoid overflows.
 			 */
-			if (len > (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN)
-				bma.length = XFS_MAX_BMBT_EXTLEN;
-			else
-				bma.length = len;
+			bma.length = XFS_FILBLKS_MIN(len, XFS_MAX_BMBT_EXTLEN);
 
-			ASSERT(len > 0);
 			ASSERT(bma.length > 0);
 			error = xfs_bmapi_allocate(&bma);
 			if (error) {
-- 
2.39.2

