Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617911;
	b=Saea0mi5sCfFFsjInKqqecmiOiWtMAIE7yb3fwyFRbZf3R16vB4dHVFuImuuLZJL7YfJ
	 cFpI9fGyEnBq+yIuZLejlpOzg8nyA2TqFhntcOBRmsweYYgZcpua3ubqYjPOU9gqKAmuU
	 Rfite4HmmbD4PJhgPJnX8DpfCeselwRNw52IDkMPYpkjXGrFbpy1ZvLQUxrvy/1aHLtXh
	 qrWQjqg2LGvapA5YXR2ND7yOO0BEocAlHvY81QA71n55CpU7lK/KUgKtvdDsRsIDsIK9q
	 f/ns7IlJWhl5hyqG7xzRdaTRx4LYyEclIaiWskGMBD/wbdEfK6M4x+/sUSdgd36FNug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617911;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-SRS-Rewrite;
	bh=rUAnE7ltqjxnOH4xIT1LXx/gvhOJGJBA1i2Meo455P0=;
	b=sE9QdnGBLz29/djjvy2JjBn69aKiNZsu2zjWvsvKEG65ge/EsLmny/qQA3ONCgNy9sfP
	 3gnOG3vamOBPr1aiKqMw370aS3i01mw8Zjz7p80msE4YwlpdhjYOlwJWtAe9AstsjLAdS
	 3Uz2L7Q2OVkz3PUIuhxF2+thWrem3C54ROa/fO9s/gB0iEcpKrJfMPJxIRoEvZOT5FrWb
	 lT0k+ZmxZVu/9tO1eXuAb6UHCdsgVkrLj0QxCsXTy/HQygbxAkwHTJ/OIEO6ap23H3fFT
	 QjzIDUfW9h+3o5k8YBUBK9i41PTu+zF9G6D165si/xdagzcmpI95ArcbpvBYO6jOrpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=lst.de;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WQ2AE4nz;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C9C606A326
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 14:45:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A0C9C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=WQ2AE4nz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=rUAnE7ltqjxnOH4xIT1LXx/gvhOJGJBA1i2Meo455P0=; b=WQ2AE4nzrVvKvII/H4nSqtJUky
	4TM/kbf26OdQ+DARcxGHt/wgjgTNezNbe8eJv6CHnc0dHilO8RXNOES5+W+hXlHftYfDBKp4nd+ub
	3Nc/ClniLNKKe3bdeXoLZykNMy7G6KlwgVEo5AChBmOEzf1B7ldvvN8/PXXXd/7Vbs12qtjjpxotB
	jdZxSwr/74XWEGwvfoclNMqu9TeoIw4QodE0D7O9XgDxxABOyNh+brQuH6791QIS9BMNYUg1vVtya
	jMpXf7FMVNo8824iFyUpuULKwWOuK1nHl+qa6Um1HmQj0z9RHwQ0rgLFZ9lUr16cyK3o+C7tJh913
	Y7C1D7dA==;
Received: from 2a02-8389-2301-9f00-7ed2-8579-02f4-a961.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:7ed2:8579:2f4:a961] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xWEF3-0000000ADs6-3HAn;
	Wed, 25 Nov 2026 14:45:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: directly format ophdrs into the iclog
Date: Wed, 25 Nov 2026 15:42:30 +0100
Message-ID: <20261125144430.728485-10-hch@lst.de>
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

Now that xlog xlog_write_ophdr formats the entire ophdr, there is no
reason to "bounce buffer" it through the region passed in by the
xlog_write caller.  Directly format the regular ophdrs into the iclog.
This is very similar to how the continuation ophdrs are handled in
xlog_write_cont_ophdr already.  As there are log vectors that contain
nothing but an ophdr, the payload copy can now be skipped in some cases,
and the accounting of the number of written records has to move to the
ophdr writing routines.

For now the space allocated in the log vectors still includes that for
the ophdr, but this wasted space will be removed subsequently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b896f3e52110..9ce2872faf29 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2010,8 +2010,11 @@ xlog_write_ophdr(
 	struct xfs_log_iovec	*reg,
 	unsigned int		rlen)
 {
-	struct xlog_op_header	*ophdr = reg->i_addr;
+	struct xlog_op_header	*ophdr;
+
+	data->record_cnt++;
 
+	ophdr = xlog_write_space_advance(data, sizeof(struct xlog_op_header));
 	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 	ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
 	ophdr->oh_clientid = XFS_TRANSACTION;
@@ -2032,6 +2035,8 @@ xlog_write_cont_ophdr(
 {
 	struct xlog_op_header	*ophdr;
 
+	data->record_cnt++;
+
 	ophdr = xlog_write_space_advance(data, sizeof(struct xlog_op_header));
 	ophdr->oh_tid = cpu_to_be32(data->ticket->t_tid);
 	ophdr->oh_clientid = XFS_TRANSACTION;
@@ -2059,7 +2064,6 @@ xlog_write_iovec(
 	uint32_t		buf_len)
 {
 	memcpy(xlog_write_space_advance(data, buf_len), buf, buf_len);
-	data->record_cnt++;
 }
 
 static int
@@ -2118,7 +2122,11 @@ xlog_write_region(
 	rlen = min_t(uint32_t, reg->i_len, xlog_write_space_left(data));
 
 	xlog_write_ophdr(data, reg, rlen);
-	xlog_write_iovec(data, reg->i_addr, rlen);
+	if (rlen > sizeof(struct xlog_op_header)) {
+		xlog_write_iovec(data,
+			reg->i_addr + sizeof(struct xlog_op_header),
+			rlen - sizeof(struct xlog_op_header));
+	}
 
 	/*
 	 * If we wrote the whole region, move to the next region.
-- 
2.53.0

