Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617886;
	b=cK3LMf/nzF4uDCtfHEWg67OR7jeE24Ohvd8MmF8T+33pqq3OY44xhrq+2UDF2oVV70Vm
	 F/+Es1+jsyWUM7yplhlLoMRcLSlwQgajJ5GwPXju783m8IgdfiLC81uuEtOLEJwobZWpf
	 SfYxQR3Umxe5Pvgkzo/wkvQlnihlRe0LO6QrV5wZVCQ6zJCfJHWJbMG2akI2pBcJ9d7VW
	 15DwgVFYMn/7+dU43hbY/RbFwYqPldZ2SS+8peml5pjfFakkTzglpTwVa+FCDNYPWUb+p
	 DInc5L4Vy7L4OqDtuC7GjTB86GU6DeubJnmHQT0ExtCKnN4fceMG3iTQ4/DCifhABBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617886;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=6WzkHe77L/xbZiRvGOj+WEEeIwqYRfsm3gXHUKJyZ7M=;
	b=S9Qdx/nDvl92Y1UU06cNQ3WRCwSs4uHJPhC4VrbLPjMTlUL001QGP6EhStD8088hS2xB
	 SJSLK/3lhJl8m8h03rmfRwlkiuFQHOArtAup1cNF90h97ZwFXOShell4Ht4TIW/2QSrYj
	 Cw2COmFLbCTJhB5JS+yUuKaX8n+wBU3mAUygZwhOa/N6xnbmiZNrtLOd6VHyfGSbzuKBk
	 rk7AvHnte0Mbgn6N6JwdNa5py/ZB2g7AHApbLrfvQ1FMLbanONAIPQLNp/1nUoGMJlK2+
	 bb8ltzMBiQhfeRIGNsHn4cX88jokp7K5dujp3LiAVWn8weXej5IbrjEbk0PNVGXPGKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=j7r8ePLS;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48913606A323
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:44:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48913606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=j7r8ePLS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6WzkHe77L/xbZiRvGOj+WEEeIwqYRfsm3gXHUKJyZ7M=; b=j7r8ePLSBBtJBQDQUVKDruIdfX
	9pqQiSFsczevE2sK3uKY6H+AHVH3440DT58fjtXvWefMZT2Pl8yz8WzImWWY/eDT9gMwgNh7SZ5+H
	7+Sypt5WBkzwWwfGbhdkqXwmSwJ0PalUc2Y6T3gDEetbCimVrATP2TCp3TedgadHELLNjBjDezhZA
	tYUmYJqdVB9MUiqcw/RIlcnvYNrIT46xQS7pMLTU5f2I+ibb/TafKQ1AM8J3P2N82TWjRjGtFzzv7
	jVVCXJDL1bIA70MXEzBgARXqAX4c1xsgP0/YuhH6w5B/bYT+SRIgJuKGHKVBFLUkjVPnVJpr9ADsl
	dwUTLSjQ==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEEn-0000000ADlk-1rGt;
	Wed, 25 Nov 2026 14:44:45 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/15] xfs: factor out a xlog_write_ophdr helper
Date: Wed, 25 Nov 2026 15:42:25 +0100
Message-ID: <20261125144430.728485-5-hch@lst.de>
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

Add a helper to format common bits of the opheader into a helper
function to prepare for moving the opheader construction to common
code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e6dbd532bbdd..68934406a48d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1992,6 +1992,20 @@ xlog_write_space_advance(
 	return p;
 }
 
+static void
+xlog_write_ophdr(
+	struct xlog_write_data	*data,
+	struct xfs_log_iovec	*reg,
+	unsigned int		rlen)
+{
+	struct xlog_op_header	*ophdr = reg->i_addr;
+
+	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
+	ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
+	if (rlen != reg->i_len)
+		ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
+}
+
 static inline void
 xlog_write_iovec(
 	struct xlog_write_data	*data,
@@ -2022,11 +2036,8 @@ xlog_write_full(
 	 */
 	for (index = 0; index < lv->lv_niovecs; index++) {
 		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
-		struct xlog_op_header	*ophdr = reg->i_addr;
 
-		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
-		ophdr->oh_len =
-			cpu_to_be32(reg->i_len - sizeof(struct xlog_op_header));
+		xlog_write_ophdr(data, reg, reg->i_len);
 		xlog_write_iovec(data, reg->i_addr, reg->i_len);
 	}
 }
@@ -2094,14 +2105,9 @@ xlog_write_partial(
 				return error;
 		}
 
-		ophdr = reg->i_addr;
 		rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
 
-		ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
-		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
-		if (rlen != reg->i_len)
-			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
-
+		xlog_write_ophdr(data, reg, rlen);
 		xlog_write_iovec(data, reg->i_addr, rlen);
 
 		/*
-- 
2.53.0

