Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D184028E3
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885592; cv=none; b=uQfxcNMu56sbDsYPZScF5UAXNkI+dCwnmbBtP9CcTpMzWeK4OwiOyZtKtOnYk2Ve41nN64Fc0TeAodY4EoB/qVyWBRuLTdkZmklu81ke/A0N5H2OAA7SSN4WCYG4AF5iuR1ncUew7N7X5+fGlFj+G7DvqxW7zk+EHs4obJBmM04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885592; c=relaxed/simple;
	bh=UFGUNrFPUWBJpc1hK8kCEfIKTApWlvFtsStZJuXECEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co9t7ZlHKgdaX9DKiq7kRAA6cmTJLOKoJ5XnOMZvYP30F8SuV4ZgTUD+cu3bRG45QG7Syap4zg524bjk0Q2CkdtQVUuMxva/AkSQKcrR0vvskV3PSm13/Ok2Q/RD9yfJsMoad2daQtGwzg46JwSNs8nsbuWEggM1cxNN9NoxL1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i0rmwG25; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i0rmwG25"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SmbkpOfwGOPkIJmsgy6bSN4HQcnSw32wHEJSic/1kGg=; b=i0rmwG25Ueko2aSbfHNLciYcKe
	NfAtIC2t5oqkcJ3XjBhuGfgU3JBC4N8myQ2/TVKlWEbOelV/31aA/4VX8+gRSM4uu6aWfyMHvLdyZ
	uDc4131HGqofA1jpPnzl1I+gf1rPGsplL/WayxUROHbZFABwP7TCnDejpGx4FmaBQDR4Lk5tui7cZ
	I6mzI810ArRHivEoKvErWAgbEN3g2PS8ckoBPZTmjVnFbNvsHDLR3PtRRA6ZeK9X8tiXwxxkRuqk3
	4pAXTAHe7t+sNTEsrOlMMCeVZiDWgfvf7j/eZrnRDBx9saxohb3TsWihqMXSIkAZ79Wwe51ICqR76
	1JakMG1Q==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDY4-000000047CT-1UUI;
	Wed, 27 May 2026 12:39:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/3] xfs: drop the RTG reference later in xfs_ioc_rtgroup_geometry
Date: Wed, 27 May 2026 14:39:28 +0200
Message-ID: <20260527123941.2319377-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260527123941.2319377-1-hch@lst.de>
References: <20260527123941.2319377-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Keep the rtgroup reference until after reporting the write pointer, as
that uses it.  Right now this is not a major issue as we don't support
shrinking file systems in a way that makes RTGs go away, but let's stick
to the proper reference counting to prepare for that.

Fixes: c6ce65cb17aa ("xfs: add write pointer to xfs_rtgroup_geometry")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 46e234863644..737afcb5652a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -433,9 +433,8 @@ xfs_ioc_rtgroup_geometry(
 		return -EINVAL;
 
 	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
-	xfs_rtgroup_put(rtg);
 	if (error)
-		return error;
+		goto out_put_rtg;
 
 	if (xfs_has_zoned(mp)) {
 		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
@@ -453,8 +452,10 @@ xfs_ioc_rtgroup_geometry(
 	}
 
 	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
-		return -EFAULT;
-	return 0;
+		error = -EFAULT;
+out_put_rtg:
+	xfs_rtgroup_put(rtg);
+	return error;
 }
 
 /*
-- 
2.53.0

