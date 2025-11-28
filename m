Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C200F296BD1
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311587; cv=none; b=BPF9NoLbZFHp3Pvm7YROzV3cUOpSdfjEOFv2yQlV5O4tS1OzD3axgGQlSkigLhuh5jvZCSn+pf2BiNLDf5Tp643RGZV9lUfKuiFsVItDZMi3/T347DS1pHk2gVzYxrGxN/TD/OYC1Ds7jDfn+FOXJ1Yi+JRJwjpfblygr9Sq6j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311587; c=relaxed/simple;
	bh=sZgITE8Vh2ZBda3LmJTVRN0hKzhUGGPADRZm0MZRwIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsJmUkYlzunck/8wXHj/aylIyzz8qQ37WQbrMNuQ1xHPu5QhPRIg8X4UkbCQEH/Q3wkytxW1hvnaccEGBkNbSDtI35vT0hDARk/ZcZ+ZXOjy2ChtTDcFlkzCrRYO7d72SGRX3LmQ4zuEltjx3xrFpugT+QgA7KkDPXsaG7jC+r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VX1V8Wn+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VX1V8Wn+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DVDhDR3A0qOvvyUNgm1Kkeel/mZ7D5xXJe3pNsoSQv8=; b=VX1V8Wn+vl/sL8aE5HcyaIcUW/
	Er4k/rXCsIFF4ZOgqLFYyCj+smhaYcahaLOCMks6ro+Gy/YtJ2YL5DqIdYwTCFsdL7j10ziHlzhNh
	cXGdbImM5FIwVFQFetKe5w2H6oKVnao1sXhuN85zMuOhNHThQBuFwFNCbpwZm+Xf0mW8w1yYMxoug
	1+xk0dTZbBChEi+pskWQ2DLLtvMrcDlDm0VY7XvqSzh4i2gpYQBQKkkwXkkZdwqdQ4mxvHOYByoFT
	cpfU0wnICFtvp3NiHDxY07rWItt4ixjgWBIWcu4Rzt8lLkjpm9Aay8ogwS1OZrCHqisiKyGRC2NxH
	4iFeJG7A==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs2T-000000002lf-0aU3;
	Fri, 28 Nov 2025 06:33:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 24/25] logprint: cleanup xlog_print_extended_headers
Date: Fri, 28 Nov 2025 07:30:01 +0100
Message-ID: <20251128063007.1495036-25-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Re-indent and drop typedefs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 45 +++++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 94efd3839f8b..ea696fb282d3 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -1388,49 +1388,46 @@ xlog_print_ext_header(
 /* for V2 logs read each extra hdr and print it out */
 static int
 xlog_print_extended_headers(
-	int			fd,
-	int			len,
-	xfs_daddr_t		*blkno,
-	xlog_rec_header_t	*hdr,
-	int 			*ret_num_hdrs,
-	xlog_rec_ext_header_t	**ret_xhdrs)
+	int				fd,
+	int				len,
+	xfs_daddr_t			*blkno,
+	struct xlog_rec_header		*hdr,
+	int 				*ret_num_hdrs,
+	struct xlog_rec_ext_header	**ret_xhdrs)
 {
-	int			i;
-	int 			num_hdrs;
-	int 			num_required;
-	xlog_rec_ext_header_t	*xhdr;
+	int 				num_hdrs, num_required;
+	struct xlog_rec_ext_header	*xhdr;
+	int				i;
 
 	num_required = howmany(len, XLOG_HEADER_CYCLE_SIZE);
 	num_hdrs = be32_to_cpu(hdr->h_size) / XLOG_HEADER_CYCLE_SIZE;
 	if (be32_to_cpu(hdr->h_size) % XLOG_HEADER_CYCLE_SIZE)
 		num_hdrs++;
 
-	if (num_required > num_hdrs) {
-	    print_xlog_bad_reqd_hdrs((*blkno)-1, num_required, num_hdrs);
-	}
+	if (num_required > num_hdrs)
+		print_xlog_bad_reqd_hdrs(*blkno - 1, num_required, num_hdrs);
 
 	if (num_hdrs == 1) {
-	    free(*ret_xhdrs);
-	    *ret_xhdrs = NULL;
-	    *ret_num_hdrs = 1;
-	    return 0;
-	}
-
-	if (*ret_xhdrs == NULL || num_hdrs > *ret_num_hdrs) {
-	    xlog_reallocate_xhdrs(num_hdrs, ret_xhdrs);
+		free(*ret_xhdrs);
+		*ret_xhdrs = NULL;
+		*ret_num_hdrs = 1;
+		return 0;
 	}
 
+	if (*ret_xhdrs == NULL || num_hdrs > *ret_num_hdrs)
+		xlog_reallocate_xhdrs(num_hdrs, ret_xhdrs);
 	*ret_num_hdrs = num_hdrs;
 
 	/* don't include 1st header */
 	for (i = 1, xhdr = *ret_xhdrs; i < num_hdrs; i++, (*blkno)++, xhdr++) {
-	    if (xlog_print_ext_header(fd, len, *blkno, xhdr, i == num_hdrs - 1))
-	        return 1;
+		if (xlog_print_ext_header(fd, len, *blkno, xhdr,
+				i == num_hdrs - 1))
+			return 1;
 	}
+
 	return 0;
 }
 
-
 /*
  * This code is gross and needs to be rewritten.
  */
-- 
2.47.3

