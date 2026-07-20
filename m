Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526F03101A9
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540792; cv=none; b=R60FMgowj4wNeLO4X/M1IrlWytLddmymlt8q779IfZmFcn3NGcyPSWFmTGXbJ9bVeYi1GrMOuxYY/gBDLt7XH7skZuGg5VqvFAN2oE9A7v1757yHKxFIpMYyn5kt4X3MfZ0VvSa9V9FJeeiiwzfBPmWcCnLj86IouNdSdandn2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540792; c=relaxed/simple;
	bh=C7J7Hct2EPGYPUHOjjBovCMLTlDGgOakP3D4ixyuIy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heb7uNGEuPeMdoTubM+GVMmPn98ZYqtsUFjb8Ib+8C/oHLZQ2bMmcirx1tz/8FuhPyBZXnblyWzoTFtGm0dLwOstqOjP7RsW3vVEJLeIy2a1L9lD54p/R63XdFIDyHmwowCKONU33bsT6mZAtuFugAj0lCm1nIESfgOTGg+4kxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k4RwTMbx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k4RwTMbx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J3YYhTrYBIjUo2hsb3e5Ids85NLzSVljlte0ayn21BA=; b=k4RwTMbxHrPUIw85BsBX0co1p5
	0rQyEly78QW0UXBmxOL1d8DbI6mxtqCayhTQRt/axILP6rQr/VrlyWEgE7ubomUh0ufYYCXzmOyqT
	TaVHwhOa0K61MbI8T+dcPFTcmvAPDbnlI7HPW99E646GkD7SEkWjHgXrzBQaYSrjSbdNf6fNMgenz
	xUvfKtsekjmKP6dGeu1GfghD6uYQ4NyXddndkGqtixS60sdQNG+MOpqBL7WTHJy4i7mh1sX8i+tRX
	YoLkhIZRIlEl5+/zCwTl9smWY/3p89xosGOsTEkfXxoJPc9PX1ll/PVvwtdP9Gou/A2tTnnhgSXFA
	1qWzk+JQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZy-00000006Mie-1tbv;
	Mon, 20 Jul 2026 09:46:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] xfs: add a lock annotation to xlog_cil_push_background
Date: Mon, 20 Jul 2026 11:45:44 +0200
Message-ID: <20260720094609.2191633-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is required to make the clang context analysis happy, which is
more strict than the old sparse lock context tracking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ae1ed16aeb2f..166531018ce4 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1627,6 +1627,7 @@ xlog_cil_push_work(
 static void
 xlog_cil_push_background(
 	struct xlog	*log)
+		__releases_shared(&log->l_cilp->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 	int		space_used = atomic_read(&cil->xc_ctx->space_used);
-- 
2.53.0

