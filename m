Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0984C8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 06:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738824338; cv=none; b=R8ZDjrEkXTHKByCPVSoloKIOa9rmCklujGPR0U3uoxuNKIaEHddLvHLnY6aUQ2QNi75P7hhpvI9KIXRXsX4ngbg5DBfaOuCv50VXGfviuSEvpk4RHpn7HcnMPaFmREQjgBRluJt76B0Gm5zzzcahXMXT7P1gs6rFNOFAnFnAtM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738824338; c=relaxed/simple;
	bh=S/cTsJlbI5YRinxWbRLmM3caLBZcTSaCoUeT5TuWKkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaq8acq47NFHl634sYhPKrkqHYnTCGdBBY1nwhe17pr/uxvL2JlT/QvWfko1edxNu6J0Ig9PfWjJj4guvUhMaYpNGx3r0MXsHK8q+lkVcvWzipCXx3dBRBhSXyTDT0Izq1Ff/Tb6zpppaolx5WRHEuoHAKKch+xpd1/sA8Z4uC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pq88JanC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pq88JanC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RT1T/I1eVIoAIFtjOSZ4ZHebrgm3dTuVYa4NZD2Zcs0=; b=pq88JanC5XTbK6HoVxCs35n+fW
	NmdjsIqgBpeuYjlMaFo83PitqFvODcZ9S8JLNiEyRgwd53DsSDIeogFdYVZ7DF+OxXdh52q50LRoo
	3/z0l5XLwhgEvYHkZMIM+cy9Ji0fEqSi3b2+93JUtFYKcfnaedihtyY3BiRAorfoP/YRxWYjnFnAq
	OnA1rGwZc3JTWP2Oosrx46YH1Hjtqwd87Y0wmyPy7qD3tIGkSUq4CVaZqvhHiL9iWsu6ABhLbZRL0
	wIgh9rcsgQZmx8mkqXD7p+lvjAhdgk9mzQfVupNkChL9f+PdAMo7D406pE/kRJthVzryeWmmTv/e6
	HE+OrM6Q==;
Received: from 2a02-8389-2341-5b80-9d5d-e9d2-4927-2bd6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d5d:e9d2:4927:2bd6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tfvdn-00000005Q93-3TKi;
	Thu, 06 Feb 2025 06:45:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/43] xfs: trace in-memory freecounters
Date: Thu,  6 Feb 2025 07:44:25 +0100
Message-ID: <20250206064511.2323878-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250206064511.2323878-1-hch@lst.de>
References: <20250206064511.2323878-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add two tracepoints when the freecounter dips into the reserved pool
and when it is entirely out of space.

This requires moving enum xfs_free_counter to xfs_types.h to avoid
build failures in various sources files include xfs_trace.h, but
that's probably the right place for it anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_types.h | 17 +++++++++++++++++
 fs/xfs/xfs_mount.c        |  2 ++
 fs/xfs/xfs_mount.h        | 13 -------------
 fs/xfs/xfs_trace.h        | 36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index ca2401c1facd..76f3c31573ec 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -233,6 +233,23 @@ enum xfs_group_type {
 	{ XG_TYPE_AG,	"ag" }, \
 	{ XG_TYPE_RTG,	"rtg" }
 
+enum xfs_free_counter {
+	/*
+	 * Number of free blocks on the data device.
+	 */
+	XC_FREE_BLOCKS,
+
+	/*
+	 * Number of free RT extents on the RT device.
+	 */
+	XC_FREE_RTEXTENTS,
+	XC_FREE_NR,
+};
+
+#define XFS_FREECOUNTER_STR \
+	{ XC_FREE_BLOCKS,		"blocks" }, \
+	{ XC_FREE_RTEXTENTS,		"rtextents" }
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 65123f4ffc2a..1cce5ad0e7a4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1347,6 +1347,7 @@ xfs_dec_freecounter(
 		}
 
 		mp->m_resblks[ctr].avail = lcounter;
+		trace_xfs_freecounter_reserved(mp, ctr, delta, _RET_IP_);
 		spin_unlock(&mp->m_sb_lock);
 	}
 
@@ -1354,6 +1355,7 @@ xfs_dec_freecounter(
 	return 0;
 
 fdblocks_enospc:
+	trace_xfs_freecounter_enospc(mp, ctr, delta, _RET_IP_);
 	spin_unlock(&mp->m_sb_lock);
 	return -ENOSPC;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2d0e34e517b1..d4a57e2fdcc5 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -105,19 +105,6 @@ struct xfs_groups {
 	uint64_t		blkmask;
 };
 
-enum xfs_free_counter {
-	/*
-	 * Number of free blocks on the data device.
-	 */
-	XC_FREE_BLOCKS,
-
-	/*
-	 * Number of free RT extents on the RT device.
-	 */
-	XC_FREE_RTEXTENTS,
-	XC_FREE_NR,
-};
-
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7fdcb519cf2f..740e0a8c3eca 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5668,6 +5668,42 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
 );
 #endif /* CONFIG_XFS_RT */
 
+TRACE_DEFINE_ENUM(XC_FREE_BLOCKS);
+TRACE_DEFINE_ENUM(XC_FREE_RTEXTENTS);
+
+DECLARE_EVENT_CLASS(xfs_freeblocks_class,
+	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr,
+		 uint64_t delta, unsigned long caller_ip),
+	TP_ARGS(mp, ctr, delta, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(enum xfs_free_counter, ctr)
+		__field(uint64_t, delta)
+		__field(uint64_t, avail)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ctr = ctr;
+		__entry->delta = delta;
+		__entry->avail = mp->m_resblks[ctr].avail;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ctr %s delta %llu avail %llu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->ctr, XFS_FREECOUNTER_STR),
+		  __entry->delta,
+		  __entry->avail,
+		  (char *)__entry->caller_ip)
+)
+#define DEFINE_FREEBLOCKS_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_freeblocks_class, name, \
+	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr, \
+		 uint64_t delta, unsigned long caller_ip), \
+	TP_ARGS(mp, ctr, delta, caller_ip))
+DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_reserved);
+DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_enospc);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.45.2

