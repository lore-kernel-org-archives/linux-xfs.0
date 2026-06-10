Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6501732B112
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068059; cv=none; b=cKfPSHJwyPJAPMu1y5QpVpLDgJfl10G53exUTokY2lGdPUR5ddthXxddw7/2uPQjpwfA8PbiihCZ353UhmdgUqSalAc8pC20NsihOn9ZDDCEqp/iY3UBo8zhm+8VGDcAYj570WodNq+kcA35Y7eM5+SJE4/NUfvS5eCJXCFjon8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068059; c=relaxed/simple;
	bh=Xw2ge3XcHYGqQP9PcN+eNx4PJKlBGlTiJJtQYUkiltw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geAsLEANshmiV/0dyB5uoroRsNTae6X5N5/J+BEdwrMZXTG+VHBmD6MEHFURFY6JKn5Vi7+GM5yDFKXDGd67F3lBV8Bn//3zonVvm9ajCWAQiWWN+9ELGwPFQ/vQk5Dzsp8/rklcO403/2rF0ncpikztexQ/Bs1z00T2Z2f59U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rLj2yxUY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rLj2yxUY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SW3k027OpyooNze9fn9tlRCFopQxHJsGlJMLstmcVeE=; b=rLj2yxUYXgQHxIwHdEx3JNl3tp
	t7KSMESWUadygHBGWNF974znarlK9LwJsHqp4HtAVSZqeYd0wazWCUNBdDnjnPsFi5Mkd4XbVGCvQ
	/9H/aTaA5KWCW+uYNuQ2AhlGuI1dqwox2owxElYjuyi90aqauOoPHUqCCSqtoibhtkAT+DDofQxIS
	5OGHzYv9opHHa8tePKWxUm5s7kc1/RBazAMVfAMQy1DKbIvrZNFzgpZFa1ZD7DsY2CgN3OxXgwIgP
	NAKYs+5ddcT9rVrkNIo0lSBuBz3SzN2fr8vdoIA8iAbJLZDDdj2ijOcOHozkOxQMzOa/zRji3iO2Y
	yqI/wjcA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBA9-00000006o7d-1x0P;
	Wed, 10 Jun 2026 05:07:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/3] xfs: factor out a xfs_zone_mark_free helper
Date: Wed, 10 Jun 2026 07:07:19 +0200
Message-ID: <20260610050731.1906760-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260610050731.1906760-1-hch@lst.de>
References: <20260610050731.1906760-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a helper for adding a zone to the free pool in preparation of adding
another caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_zone_alloc.c | 11 +++++++++--
 fs/xfs/xfs_zone_alloc.h |  1 +
 fs/xfs/xfs_zone_gc.c    |  4 +---
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 5e297b75a85f..08d8b34f467e 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -944,6 +944,14 @@ xfs_zone_rgbno_is_valid(
 			rtg_rgno(rtg), XFS_RTG_FREE);
 }
 
+void
+xfs_zone_mark_free(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+	atomic_inc(&rtg_mount(rtg)->m_zone_info->zi_nr_free_zones);
+}
+
 static void
 xfs_free_open_zones(
 	struct xfs_zone_info	*zi)
@@ -1082,8 +1090,7 @@ xfs_init_zone(
 
 	if (write_pointer == 0) {
 		/* zone is empty */
-		atomic_inc(&zi->zi_nr_free_zones);
-		xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
+		xfs_zone_mark_free(rtg);
 		iz->available += rtg_blocks(rtg);
 	} else if (write_pointer < rtg_blocks(rtg)) {
 		/* zone is open */
diff --git a/fs/xfs/xfs_zone_alloc.h b/fs/xfs/xfs_zone_alloc.h
index 8b2ef98c81ef..abf8358bb266 100644
--- a/fs/xfs/xfs_zone_alloc.h
+++ b/fs/xfs/xfs_zone_alloc.h
@@ -42,6 +42,7 @@ void xfs_zoned_wake_all(struct xfs_mount *mp);
 bool xfs_zone_rgbno_is_valid(struct xfs_rtgroup *rtg, xfs_rgnumber_t rgbno);
 void xfs_mark_rtg_boundary(struct iomap_ioend *ioend);
 
+void xfs_zone_mark_free(struct xfs_rtgroup *rtg);
 uint64_t xfs_zoned_default_resblks(struct xfs_mount *mp,
 		enum xfs_free_counter ctr);
 void xfs_zoned_show_stats(struct seq_file *m, struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f03211e4354a..f76a09130852 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -924,9 +924,7 @@ xfs_zone_gc_finish_reset(
 		goto out;
 	}
 
-	xfs_group_set_mark(rtg_group(rtg), XFS_RTG_FREE);
-	atomic_inc(&zi->zi_nr_free_zones);
-
+	xfs_zone_mark_free(rtg);
 	xfs_zoned_add_available(mp, rtg_blocks(rtg));
 
 	wake_up_all(&zi->zi_zone_wait);
-- 
2.53.0

