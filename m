Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AAD13F016
	for <linux-xfs@vger.kernel.org>; Mon,  8 Apr 2024 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712588109; cv=none; b=nau+tp63w/6yuOruwEk9j/noN/fTagnMI88ofkjv8sty2ddFCPvcruKktJfgYzZ5jUDvPyWzSy6JTH9uYjEXvEsaj76WXCIZA/oKb8eKmrLg23RBTAPAhTZanpSHCDo7H1fkQ5IyCwH4Gl5VrloyM4HCQLuRcBAUWZDXDUsMYvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712588109; c=relaxed/simple;
	bh=iqVgKJZKIKNVDBbTKAj6omoAdkN1lfVbEuB58X+EaFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PEGwey956qGb5GXCo4CFozAPwRZkbPsRiP2fC5SgbJxGDdz2kBkKn2jTCNWbTtt0Dn2/i/RHsUWWEXYeTQl793DLWSV3CRnzpozMPyF8AMnFmjAn4KHnyzglwN1lsxa9p13Qw3JeKSDl9tbBIHjGfYiYXDeePP64IRut+ScRKko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KdxRHfRk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KdxRHfRk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=j2smyACZIxn+9n9dkXVgPL65PdF0Zbmyzqnbie8zNXA=; b=KdxRHfRkVbDtmpB1ecHY2buxS7
	NgZRLSb1qxvu9JQL8L7nDXd82SPhEIcGf9IJTzvXZIAbL1chhV0XoQGSRpXRENq1BqGY0n47TCNo8
	igyYD7i2OwQlyuJ4AlQyLcJR4WNHNQVgixTeJLDJl1yO3Tmk65cMzFRycTnS7GmXE6j4CpMjsIj3D
	ZuELNq8MlqZw0LXUp5I+7QsBrzHTPC1vpg8Cz90d0FB1EijSgzknIdUXnTY9Opp+OgJcuZNTDb3Ed
	zfWW5RHawyxZ00kZ7m328N+wDc83r53XBNMClog+gLcTZMYoyJZSwbe6biax0dW5fHs4+ZJI3Qei8
	a93DlDYg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rtqOo-0000000FwYV-3nZP;
	Mon, 08 Apr 2024 14:55:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org (open list:XFS FILESYSTEM)
Subject: [PATCH 4/8] xfs: don't open code XFS_FILBLKS_MIN in xfs_bmapi_write
Date: Mon,  8 Apr 2024 16:54:50 +0200
Message-Id: <20240408145454.718047-5-hch@lst.de>
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

XFS_FILBLKS_MIN uses min_t and thus does the comparison using the correct
xfs_filblks_t type.  Use it in xfs_bmapi_write and slightly adjust the
comment document th potential pitfall to take account of this

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3b5816de4af2a1..f2e934c2fb423c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4537,14 +4537,11 @@ xfs_bmapi_write(
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

