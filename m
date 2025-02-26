Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2811B236451
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596247; cv=none; b=aagl3wv5CQfaX0Vw4Gr6SzWJZea6BpBb5ovC8PVuHF0I+aNuaajphaYMocp5fSP+FZlSunr3Pa/coMrl+yZpi9PtVYAm2vRujQtEUHquZh1xE/6tpABbTaEezghWgAtkDP66WH0WP7aefvpdfhs4nzryBDqHfUO2TSvdH9fRg4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596247; c=relaxed/simple;
	bh=vwb/UmeLjYpiJ2NlWaNZq2vPWszMa+68nL39t/pwcRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uj4g5YTSvpwX2e8+Uk/l1MLmIEH1Na76cabY/fNuvg5VajMidlynfPDcdTPyJp8CGc7G7mxy1WN7BnFEKv9GtyfAPmTLjC8e6jBAw6LIYEXXbgd+LyicVuZ3B4p7Q50z/yMbHbbMGKzOQ/k/TyjBn0f5eDV6YVOcxFJcL8Y8UX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=30UIiReT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="30UIiReT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eFZNB9CnmP5cFi4f92BaRXgPolojF8cX12zu2iXMq14=; b=30UIiReT69wlr4mB8LoULjlaaW
	oKMQLwRGm3P2ur/8cQc/aSbYwABcjFg71+/Ga8DHR8rnS0tn+YcZOmuQm/+00Man+ahPa8VZjcfEF
	jajFsgJOgc205+j2zQrUYkxVGGx0oWx77r2q2UHbbVqWClMQAuAmNzQpGKibiKEldJBFFDXcu7kwD
	lr60LKgF8oAgJVRco50rxhPHEv0YXO0reoxG+EyVdwH97Qat7eer7J+lHltae9M6TmuelBlPSefrb
	HiePqS+JR60zn6U9ko0072eYPwVFjcDlqhVfIWsrpEdCJoEMxWq1VVLqojJfe/CV7JTAjkO1UTUx/
	WiXBJBnA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMaz-000000053rP-2Lsk;
	Wed, 26 Feb 2025 18:57:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/44] xfs: trace in-memory freecounter reservations
Date: Wed, 26 Feb 2025 10:56:36 -0800
Message-ID: <20250226185723.518867-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c |  2 ++
 fs/xfs/xfs_trace.h | 39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 097e7315ba66..6b80fd55c787 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1344,6 +1344,7 @@ xfs_dec_freecounter(
 			goto fdblocks_enospc;
 		}
 		counter->res_avail -= delta;
+		trace_xfs_freecounter_reserved(mp, ctr, delta, _RET_IP_);
 		spin_unlock(&mp->m_sb_lock);
 	}
 
@@ -1351,6 +1352,7 @@ xfs_dec_freecounter(
 	return 0;
 
 fdblocks_enospc:
+	trace_xfs_freecounter_enospc(mp, ctr, delta, _RET_IP_);
 	spin_unlock(&mp->m_sb_lock);
 	return -ENOSPC;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7fdcb519cf2f..cdaf8fdf6310 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5668,6 +5668,45 @@ TRACE_EVENT(xfs_growfs_check_rtgeom,
 );
 #endif /* CONFIG_XFS_RT */
 
+TRACE_DEFINE_ENUM(XC_FREE_BLOCKS);
+TRACE_DEFINE_ENUM(XC_FREE_RTEXTENTS);
+
+DECLARE_EVENT_CLASS(xfs_freeblocks_resv_class,
+	TP_PROTO(struct xfs_mount *mp, enum xfs_free_counter ctr,
+		 uint64_t delta, unsigned long caller_ip),
+	TP_ARGS(mp, ctr, delta, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(enum xfs_free_counter, ctr)
+		__field(uint64_t, delta)
+		__field(uint64_t, avail)
+		__field(uint64_t, total)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->ctr = ctr;
+		__entry->delta = delta;
+		__entry->avail = mp->m_free[ctr].res_avail;
+		__entry->total = mp->m_free[ctr].res_total;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d ctr %s delta %llu avail %llu total %llu caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->ctr, XFS_FREECOUNTER_STR),
+		  __entry->delta,
+		  __entry->avail,
+		  __entry->total,
+		  (char *)__entry->caller_ip)
+)
+#define DEFINE_FREEBLOCKS_RESV_EVENT(name) \
+DEFINE_EVENT(xfs_freeblocks_resv_class, name, \
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

