Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF49A22B8AB
	for <linux-xfs@vger.kernel.org>; Tue, 18 Feb 2025 08:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739866330; cv=none; b=UjrL9sIvPurrVscjjvfQLYGZcbxVQ17YfTEyUulkWj+jJQNEDmXNDE/gdlOrygUpHB5c9pLt4ab+LvEiJ4iCmcDnfJSKAndUmimxb55vtz7Fqay6RTU4WkSwl6OxtLFUHE+aMol3iqHDPDn8txMTcTRC5VCBtDSPfjP+Qmt5DTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739866330; c=relaxed/simple;
	bh=wv6MWZjSD2pgkYq5MXzhMknsfwCZSPhJil6fw8wwoW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsOB2nV0TYmotcB7LANjSG00dviVGm1wAfg7sDwM3HtGkiPXpNglWlXCqqonOEEtad/+Wti1/dAhKTMLk5dnV5fzH8D4e3xz3NqlnTjUnwDaKpeVNfHMddGSq5kSvFX/rg290Wuhj1LE3t95eP3m+6USxybHV9dMuW/nNihDYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gNmbPQHG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gNmbPQHG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A9xCFu0f8nvHXOTw5EBerVVJPcZVAz1mYuFvy5x0pOA=; b=gNmbPQHGMrzfFtTRf/x1pBfMCS
	lGqLkELSq2QEc/AVfwZ8+0r9PpGQMUTIiV+iblWPcIQ9ccI9NqQN2CCugpZw/zhXPahh96YdFrPI5
	x3EIHklFEWSMlxnL9WyDelNIoOIq+u7k8NAh7g11Aqq8V4M+PhqLjgE1qiVxw9Ifs5QEcOnYb9FMu
	VdOrrNqPW0N7+agL8vVFWM9SF4g+fg8L8lSaHorXTl4VITle7N9r/iKEn/k1UZMkpoekL2NIirMz7
	WIwNzaefVlxDsF4G6x6ChmDD0sZEeKiKmMIKDs+ESGCvRhKInnrz0Fs5RXTHVd/BtBtEjfUJPt4m4
	CnfeONJg==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkIi8-00000007CI2-16OB;
	Tue, 18 Feb 2025 08:12:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 04/45] xfs: trace in-memory freecounter reservations
Date: Tue, 18 Feb 2025 09:10:07 +0100
Message-ID: <20250218081153.3889537-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250218081153.3889537-1-hch@lst.de>
References: <20250218081153.3889537-1-hch@lst.de>
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
index c401fd47c763..0270c77796e5 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1330,6 +1330,7 @@ xfs_dec_freecounter(
 			goto fdblocks_enospc;
 		}
 		counter->res_avail -= delta;
+		trace_xfs_freecounter_reserved(mp, ctr, delta, _RET_IP_);
 		spin_unlock(&mp->m_sb_lock);
 	}
 
@@ -1337,6 +1338,7 @@ xfs_dec_freecounter(
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

