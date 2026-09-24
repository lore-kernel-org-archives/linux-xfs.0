Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16E431A3E
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244329; cv=none; b=X9DCrnhvUwSo5QuapNkZRADfDeKh25QcOROpGQFmqIiXNyi81ju+9Zo7S9Xl4WMy1DKNIzDC64AKjY25aREUC6DrblapgjL+Q98jk3IN3SUsQEZa4OKScviwkEBLeG8qK0NgHr6EFPyrZP6x2zazZHs8dxpTZ9YZkc7cWSFMjDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244329; c=relaxed/simple;
	bh=17C+xlwCB93lEmVWQftje1YFE5F8iwWRrdFjG4rh4/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nkd24q8giDTXpyWTJhNGJ3iHIba8eTgySz66o0NqRRWWkXFSxkcIEfUkQ2Rf2fCK35L4MlKMZwkGc0w7jwLIX7MmRdV+zi1v88T6u4Dsp3ZlFsr6IueAhIS2sIhqz/P0msSrvzCF1uZViwhHFa3ADKRJlJEaL7db2gQAKGgzizM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aLXZX0wR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aLXZX0wR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yEVkCPYqR/XmwRcsA5VlDyyHPoBPTxlHLX6Ph12zzag=; b=aLXZX0wRNH7AECNPquQjI7vt+N
	fl5DEIeaZ3jstasrCioSPgi5svjFy8sorIzjPoHWe2BsGsA2BW104KZ3Dt1foSRCLLdpkMX/pCfmC
	HaAG5bpTek6gDo+QCd7Y23yXW4fRElg3Jo4Hi/PF14rHkDpMGfCdIaXjpnMchQqk7D5pSioxYn3GP
	FPXzt1oDQm6TUXdKvnX0Sj9vcs1Os5jADUTxISa4/P6NdENwdoAfi8YzPUb9sp9UyBmJrnqjVssvj
	WxOZFUI1iF99Zj6BLto1tIp5hIrTfnze1iOkgNwQJanc8LuG8Mq+H/wqL0xpHDOQTn7/UD4Wuf/Qr
	mcIqwrZg==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gKM-0000000Af9S-1vEm;
	Thu, 24 Sep 2026 10:05:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/32] man: fix alignment of the rtstart field in ioctl_xfs_fsgeometry.2
Date: Thu, 24 Sep 2026 12:03:51 +0200
Message-ID: <20260924100512.2733748-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Using tabs for indentation messes up man page rendering, so use spaces
for rtstart to match the other fields.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 037f8e15e415..6d30610b71be 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -50,7 +50,7 @@ struct xfs_fsop_geom {
 	__u32         sick;
 	__u32         checked;
 	__u64         rgextents;
-	__u64	      rtstart;
+	__u64         rtstart;
 	__u64         rtreserved;
 	__u64         reserved[14];
 };
-- 
2.53.0

