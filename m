Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD9F3BFE52
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226355; cv=none; b=fJAZ7G81GEMNZDiYwJrQPQdND3jZmVnT4/c7FVe6G3dxgN5i7HAvxv36OTzcjijcxKl/foV166PLrlCzYk+tghiVOlG+zuseN5QPHZKz71X40V3IYltRWIi0rs3uyjwgovWVW3dsSoBQ3OTlEykl1vRJbEjFOrQPmY1ex9DTuSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226355; c=relaxed/simple;
	bh=aMBHLo54dtSTXIcgd1wrDzPyNawGr3vpAk03aTVi3xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hV2CyfAnINWSsA7v+8Iy9baUO0M7ijlSvO/gxuYlBiYE9yKYp6zINaoav3sboLiNEApeRk+Y8O/cwzG+Kx7oLyg+YdlH+7newhrNJK3LKimyq5hcbZAvo46Kqp5owEstxL47xYIrYN98cOO+nEEcQzD41vtOxtzai+ITw+2vw/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=X9Kb29o3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="X9Kb29o3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N/Htsrk4cbSCavsysGXDSawyedNY0sgOcBaK5l3nlhQ=; b=X9Kb29o3wM5CIpV/Sy2KxhrjtJ
	9mpBx9lrGsepX0QDaJUwQ1jmnQ1UVkxBkhBdw1cZ2RYVgtp+yqzMlNsOaz90lPwcs4lC+/BMwi+s4
	7fkf7LzZgjryLeIpwwpOngGwrQw2KO2b9ZDk+iRO6plCs4EYFPnzmcY652AsZ+3ZslQiN9OaOmSrg
	Np4+ihR/r+VhvBYP/JMGrALXfwmKLemXIeLPlkmdTmE1fVH5RQ66cwsOz4KEU5RMqt3nm0QQ/YcC6
	ng/OCLugAY27zYGJUISexjz/tXYdYb46h7vx/wh8KNECFh07lSYnL9xv7LRfr8LgiJB/aownC0VEG
	CTOEEncw==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocvR-00000004hAu-3uyU;
	Tue, 28 Jul 2026 08:12:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/12] xfs: move buffer locking out of xfs_find_get_buf
Date: Tue, 28 Jul 2026 10:11:19 +0200
Message-ID: <20260728081152.1778841-12-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728081152.1778841-1-hch@lst.de>
References: <20260728081152.1778841-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

To prepare for buffer loookups that don't lock the buffer, move the
call to xfs_buf_find_lock from xfs_find_get_buf to its callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index aee58aca8c7c..bc23fa59680e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -593,12 +593,6 @@ __xfs_find_get_buf(
 			return error;
 	}
 
-	error = xfs_buf_find_lock(bp, flags);
-	if (error) {
-		xfs_buf_rele(bp);
-		return error;
-	}
-
 	*bpp = bp;
 	return 0;
 }
@@ -620,6 +614,13 @@ xfs_buf_get_map(
 	if (error)
 		return error;
 
+	error = xfs_buf_find_lock(*bpp, flags);
+	if (error) {
+		xfs_buf_rele(*bpp);
+		*bpp = NULL;
+		return error;
+	}
+
 	/*
 	 * Clear b_error as the callers don't expect to find valid data in the
 	 * buffer.
@@ -664,6 +665,12 @@ xfs_buf_read_map(
 	error = __xfs_find_get_buf(target, map, nmaps, flags, &bp);
 	if (error)
 		return error;
+	error = xfs_buf_find_lock(bp, flags);
+	if (error) {
+		xfs_buf_rele(bp);
+		*bpp = NULL;
+		return error;
+	}
 
 	trace_xfs_buf_read(bp, flags, _RET_IP_);
 
@@ -766,20 +773,26 @@ xfs_buf_readahead_map(
 	if (xfs_buftarg_is_mem(target))
 		return;
 
-	if (__xfs_find_get_buf(target, map, nmaps, flags | XBF_TRYLOCK, &bp))
+	if (__xfs_find_get_buf(target, map, nmaps, flags, &bp))
 		return;
+	if (xfs_buf_find_lock(bp, XBF_TRYLOCK))
+		goto out_rele;
+
 	trace_xfs_buf_readahead(bp, 0, _RET_IP_);
+	if (bp->b_flags & XBF_DONE)
+		goto out_unlock;
 
-	if (bp->b_flags & XBF_DONE) {
-		xfs_buf_relse(bp);
-		return;
-	}
 	XFS_STATS_INC(target->bt_mount, xb_get_read);
 	bp->b_ops = ops;
 	xfs_buf_clear_flags(bp, XBF_WRITE | XBF_DONE);
 	xfs_buf_set_flags(bp, flags);
 	percpu_counter_inc(&target->bt_readahead_count);
 	xfs_buf_submit(bp);
+	return;
+out_unlock:
+	xfs_buf_unlock(bp);
+out_rele:
+	xfs_buf_rele(bp);
 }
 
 /*
-- 
2.53.0

