Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C0A288D2
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323397; cv=none; b=a/dwYl/x5XCYXN4BPW97lFI2bJpyvXLjrSckpKgcv1UEt3UUS+ql8csS/n2XgPHCbimbsyCcrXr9kaXapGLqgGQT8XEdnhngdoGcLmG6D1OBdv6oLM1FrqZYEIwLUvPXBUjqbQAyMaYGn/NzyNZSF3mpywNVe5MVFnVZ13cEM0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323397; c=relaxed/simple;
	bh=uFT92EV6oZ4h5XUT6IXwuv8OfAIMI8ogFr07W1xV0uM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh6QsLsakingZ3Ebcdhfd0GCutg1GWty5uDlQCyFvDD39xozfswWhjBW/gKmeteTJxtTVZu2OuX824LTidksTY3HfAkVMClTT2mUtfRgoXqVrl+a4RbIZBu7qq5aL2yeelztgwvOuQbilwcXGi3oFqV768NGh14EJE/oyk4L85Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FDlmkFQl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FDlmkFQl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SBEKzWvsf9dopZyU0Dua4BStHXT+igTzJtcS+ZQ8Fc0=; b=FDlmkFQlGxETza4OCghT1qIdhT
	eeAzRh/ug9MExr0Yt8MTfq92I16oALVgdjUtLZfDOOIfTEskxAhHA1YDtyjAV4AFYHr0QE0KGLXqX
	5eeZqRhdiybIw8AvS9ayS4ShRNYdwDyFSnokSoAvd06xk6SQYP2u+iblmM++dZgANGv1QZ+zpGR8Q
	X5/cPSCAAl0ySdT7s5YYeZRcIbCyz224+Ak1I2DIENLxdM5pgmEoKJHC9b8sI8b0RYM1vHHRuJZkA
	yGon7YKIidwckC+kW7zbhM48CxC6cvs9ZfN3dlpAvQuv752YqBnwkhvsAQEWhuY1z6ifvSAKQd/z1
	lIDmnnHw==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88Wo-0000000C7IM-3P46;
	Mon, 13 Oct 2025 02:43:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 8/9] xfs: remove l_iclog_heads
Date: Mon, 13 Oct 2025 11:42:12 +0900
Message-ID: <20251013024228.4109032-9-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024228.4109032-1-hch@lst.de>
References: <20251013024228.4109032-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

l_iclog_heads is only used in one place and can be trivially derived
from l_iclog_hsize by a single shift operation.  Remove it, and switch
the initialization of l_iclog_hsize to use struct_size so that it is
directly derived from the on-disk format definition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 11 ++++++-----
 fs/xfs/xfs_log_priv.h |  1 -
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8b3b79699596..47a8e74c8c5c 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1279,11 +1279,12 @@ xlog_get_iclog_buffer_size(
 	log->l_iclog_size = mp->m_logbsize;
 
 	/*
-	 * # headers = size / 32k - one header holds cycles from 32k of data.
+	 * Combined size of the log record headers.  The first 32k cycles
+	 * are stored directly in the xlog_rec_header, the rest in the
+	 * variable number of xlog_rec_ext_headers at its end.
 	 */
-	log->l_iclog_heads =
-		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
-	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
+	log->l_iclog_hsize = struct_size(log->l_iclog->ic_header, h_ext,
+		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE) - 1);
 }
 
 void
@@ -1526,7 +1527,7 @@ xlog_pack_data(
 		dp += BBSIZE;
 	}
 
-	for (i = 0; i < log->l_iclog_heads - 1; i++)
+	for (i = 0; i < (log->l_iclog_hsize >> BBSHIFT) - 1; i++)
 		rhead->h_ext[i].xh_cycle = cycle_lsn;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ac98ac71152d..17733ba7f251 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -406,7 +406,6 @@ struct xlog {
 	struct list_head	*l_buf_cancel_table;
 	struct list_head	r_dfops;	/* recovered log intent items */
 	int			l_iclog_hsize;  /* size of iclog header */
-	int			l_iclog_heads;  /* # of iclog header sectors */
 	uint			l_sectBBsize;   /* sector size in BBs (2^n) */
 	int			l_iclog_size;	/* size of log in bytes */
 	int			l_iclog_bufs;	/* number of iclog buffers */
-- 
2.47.3

