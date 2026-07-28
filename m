Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1973BA220
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226021; cv=none; b=Z8zg6wWRFgQZmFKWnbdjbUuG53Pt1p6v/It2deRMhWxZHeuzbOYj/awUQc4jtdb3xkbe9649FafwlPpW4a23qEIGXEAq14a/17AnESURJP+ppNOrawDSjLY3oSkSBPmokdxX/ESoeB4sWWSq5kl1bJ680W0XRqZIr1eCPh1R5X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226021; c=relaxed/simple;
	bh=Da9g7oZGAxheBfWrp05F1NghWIb39Q21p4AAbojK0Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEq25ZT+MXvIUgXCAfLTqJpWGKcAVNTOitzsPm/oUPV7Q96cCRCxyDcDmqksyX+ofsaXiWGxBcnM7XSlSo1YrM85rOL/TZyUttDs3SSi9eSgh5hARyra8b5S8AeEcyl4nHPyYy0grVfBpRnFEAEENNcnGwzxWW/OP0gRldK9vzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3r39VJY6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3r39VJY6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5Fz7JsyBQh9E4opjSn78eGw6BIcPPVCX6YglErZstqQ=; b=3r39VJY6OdeAt+HIASQgwh3LA3
	aUfFjM8iAMRZM0VXdb4sX8kC22gwIAEXOwcnaFPI1iQ7n6bXcHHWaXENXVWj40GywFJNkAB0TCkdW
	TSJqUYOPAC4hddxNmzdgkn8tZc16Vpf1DhrjMNaQLER1IZffB0FRGCY0lQ43sHtzgXxcG9WnjrcH0
	RZzbLbOB4vSsKuXIfsg0hawpZ634+3Li6YEs4Goha0rlGQEAt0gYIuDUuAKHv0pioQ8NL5YncxVPy
	rAoxcRVJLoak97pAhhLozJJ2w9YLaFgLUv2euQUNYJoTCfxyvqNDq9hKvpU7jpJQeoYnXgtY35Sl/
	ScunxfEQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocq3-00000004g4s-2sqo;
	Tue, 28 Jul 2026 08:07:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: add a comment to describe xfs_gc_bio.victim_rtg
Date: Tue, 28 Jul 2026 10:06:45 +0200
Message-ID: <20260728080650.1777545-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728080650.1777545-1-hch@lst.de>
References: <20260728080650.1777545-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

All other fields have comments describing them, add one for this field
as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index e4f70e024632..e2bad83b10f6 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -103,6 +103,7 @@ struct xfs_gc_bio {
 	/* Open Zone being written to */
 	struct xfs_open_zone		*oz;
 
+	/* Realtime group currently evacuated */
 	struct xfs_rtgroup		*victim_rtg;
 
 	/* Bio used for reads and writes, including the bvec used by it */
-- 
2.53.0

