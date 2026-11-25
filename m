Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617881;
	b=jImBasyxuM1PGK87dhNnVryR4TPgK9vXihZ4Jkk70uAuoGp1Mlih1FG4nT5XnFeIdcUh
	 KNVrpoim+Orbsl69cV23A2iKbw631nKECJWHbkYXP6eg5tWKS54SZt1FnGKE2Svt/wWqJ
	 42UOmju7+9sQgLe1wW2kgkNW2/SI62Z6V8BMbWc8qARxI3g1EtmtOa0p5QG/3Yqm6rmuw
	 etpII+K10hlUqyNER+xGcQzYzG6ys2EJqqiEhbCc2bLSNjxKe+5XBIz69tQM7RsQ/wxJB
	 OGohkgxAcqR3AytL3TCawg+O7mQXyXUTUgbpItLLd57h9N4i+E+T1MKRD5d0CBTzVMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617881;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=tNahOwGVUDKuNja6lXC+AYwZ0nAqtC3osxCZ/ac4vNU=;
	b=1U2BtbOI98qKlkaTRlbmBFuYjhApxavLAhXeK31I7Ns2h8b2Ei1mKGB78xj4wCFGKIrV
	 Itvl7Bh2hWQzYoS5frMKUerd1bRmcTBStRCUaganTusE0YArnKGjYzWdz1RFQEm8tsFxM
	 egIWw97ElRJHRWUDrprDYItKMulz/rATMcb/PQ9sTkq4ZrEa1iZfMEf5AMu/xQTh5MH58
	 VM+xXPtT8PX0fI3gmFqRyequ57k8Pxy89XAD8fXnKQ/GSBfM1DRJgawcW0Of9S7o38/0R
	 yI8cGsogycu31/xRqbR+9GQFSUjJlleRBlFOOn1dDJ2ZqukF9KSqs6y8eWZbtO44Now==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uClI5J3n;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB17606A323
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEB17606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=uClI5J3n
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tNahOwGVUDKuNja6lXC+AYwZ0nAqtC3osxCZ/ac4vNU=; b=uClI5J3n5ic7ihM70fDC3OpGiF
	B+EH5u+5uedSQlgznGYvYFzbmZUbRpLmH6vlBsXPYkjx/1Z22byQevT+FBlqYVL3/BB9RyKI9vebA
	hKbIEd2e4vaXzZYiUmy9loyn/mmXZOPfVzbI1gpqtutqP+3ois/Iw+IWVLUCRxMFUcTvSA/wBsx3C
	F0WiYGZMbve2UZmc3NHg7UMnF9xsbLXhcwaNBB2opItiKAgjP7pHUG0ww/DOTaS/a3+kW7iqK2/6D
	TeEE49x8tDavXkW8YIPrcC8OUY2xKaeeDNk3iaEjkOy4iRIw5j9qGg0ZVxnIXiwo2GqDS0wWVTnBz
	m15QS/3g==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEi-0000000ADj6-0TCh;
	Wed, 25 Nov 2026 14:44:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 02/15] xfs: always set oh_len in xlog_write
Date: Wed, 25 Nov 2026 15:42:23 +0100
Message-ID: <20261125144430.728485-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261125144430.728485-1-hch@lst.de>
References: <20261125144430.728485-1-hch@lst.de>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xlog_write_partial already updates oh_len to match the split regions.
Also set oh_len based on the log iovec in xlog_write_full so that the
callers don't have to also set the length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c     | 2 ++
 fs/xfs/xfs_log_cil.c | 9 ---------
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9029e7856f1c..7a067cfe59e6 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2025,6 +2025,8 @@ xlog_write_full(
 		struct xlog_op_header	*ophdr = reg->i_addr;
 
 		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
+		ophdr->oh_len =
+			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
 		xlog_write_iovec(data, reg->i_addr, reg->i_len);
 	}
 }
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 7ba4ef32479c..c7c3fa29eaa8 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -470,7 +470,6 @@ xlog_format_commit(
 {
 	struct xfs_log_vec	*lv = lfb->lv;
 	struct xfs_log_iovec	*vec = &lv->lv_iovecp[lfb->idx];
-	struct xlog_op_header	*oph = vec->i_addr;
 	int			len;
 
 	/*
@@ -486,13 +485,6 @@ xlog_format_commit(
 
 		memset(buf + data_len, 0, len - data_len);
 	}
-
-	/*
-	 * The opheader tracks aligned payload length, whilst the logvec tracks
-	 * the overall region length.
-	 */
-	oph->oh_len = cpu_to_be32(len);
-
 	len += sizeof(struct xlog_op_header);
 	lv->lv_buf_used += len;
 	lv->lv_bytes += len;
@@ -1250,7 +1242,6 @@ xlog_cil_build_trans_hdr(
 
 	/* log opheader */
 	hdr->oph[1].oh_clientid = XFS_TRANSACTION;
-	hdr->oph[1].oh_len = cpu_to_be32(sizeof(struct xfs_trans_header));
 
 	/* transaction header in host byte order format */
 	hdr->thdr.th_magic = XFS_TRANS_HEADER_MAGIC;
-- 
2.53.0

