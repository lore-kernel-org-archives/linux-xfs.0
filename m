Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA901079D
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 06:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714371354; cv=none; b=rInRxWDpCiTkZtJl4VODSY1YakmonKechaTSx0h3WxDDUHpOopr1uuDyWR0x9mwUM/m/v0iSc7VbM2Fo0Gn+7hyPMz0KnndL7q2hnNDz/S/mUpFZAyDoasnVdq+PEI+1WwnQ0hpr74pYFLGQcDenCNgaGVILUQVtw85l8TI7190=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714371354; c=relaxed/simple;
	bh=B6lo7376fRlMrFW8S5XxqHhRb6VuV0njd/UWRmqgisI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dPjIcmo/nWNUZS0+H7sHVtRH+YpZ/8B9Hngyah8zBGGZknfPVluaU7V3JDZNYh/8lBsmc+la12YRW8s9GIJxDGwIecvVabmUxFYeX5PftuEXaS9cANNY+O4hUmqCm2BuXIfvoNnIMHPrBHfvwnOB6wAg7jz7UQpjUtgqZ9s/B5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xRd2iapw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xRd2iapw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
	To:From:Sender:Reply-To:Content-ID:Content-Description;
	bh=L6rTEMcYceK2RrJKk6zfTIDhU+azZqufOGOX5balu8s=; b=xRd2iapwsIdx9wp5+RF2wUn160
	uG5XExr8CWuzxjFm3gN01P8r9sgIOLXx/1kXGjcxVRl25AFdVXeOk+LwRSpNCRXg/qyMzJOnXYhRe
	2ya+LvUcjPrw/Odr33Zp2HmZeOunzve24U937hxqqnGkCpY7ONMn3vWU2CUURSTG3wCqzeI0LJdJ/
	+y6jmXTht8U713lCUR/gSYmwbLXGeyGtzGAErd6x+f5fasBZTquAs0XI5QCoOFvUVbmD9G962az6Z
	fWGJYaBrn+/NRhtOjRFZuGlsc/ksde2yFjpoiX5Wyt8T2l54UlXn1ab2VmG/yEmzmWRYp9asOIbM5
	MTo55rNQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1KIq-00000001cnM-1K9a;
	Mon, 29 Apr 2024 06:15:52 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: do not allocate the entire delalloc extent in xfs_bmapi_write
Date: Mon, 29 Apr 2024 08:15:28 +0200
Message-Id: <20240429061529.1550204-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240429061529.1550204-1-hch@lst.de>
References: <20240429061529.1550204-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

While trying to convert the entire delalloc extent is a good decision
for regular writeback as it leads to larger contigous on-disk extents,
but for other callers of xfs_bmapi_write is is rather questionable as
it forced them to loop creating new transactions just in case there
is no large enough contiguous extent to cover the whole delalloc
reservation.

Change xfs_bmapi_write to only allocate the passed in range instead,
whіle the writeback path through xfs_bmapi_convert_delalloc and
xfs_bmapi_allocate still always converts the full extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 42c5a2efa656a5..f5488cc975342b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4524,8 +4524,9 @@ xfs_bmapi_write(
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

