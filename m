Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDBCD274B48
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311448; cv=none; b=d243pot/3emWKGgoNY4sO6UnLwtip1Y6dDOwuQiiZTxa2ku0adYcXkU1Gjbrq4o4gJNKh+yOT1vlGM7DNNtRnCeYHEN/dD+9J9pM4WgGvhXMdhj23M+FohFwdcWo9Iu01iLTSv38iMMuxzoXhVf/VJgRt5qxigoTC/jRs9bCPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311448; c=relaxed/simple;
	bh=yTmWfltcaNIEBHG01+7hLuPYRsYN9eLtu/Qrq/SZrmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuGRyneP+r0V5o7a7fP3QSPqRj7n9jjc+Uk/Z2U2GUQJaTgIMa9m6ZHCzoBfG7d3kBWraSK0tGftt2uS9lImDPOxFtBxQvqdRbP07F63mX/DA/CGKImV8/cndoUe7ev4aptX1EDnKKIZWI86FJNZlGw17KZkZDuysJQAhC6xRdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ResoP/O3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ResoP/O3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VpDoLZW60qCfdj7X3KcTokNEfT0v3FVAWFA/R42ZCck=; b=ResoP/O3CEJIpvrL07j5S3phGl
	0eOEAiHefXScMlp1ZmffdWEUXeJuy5PNLEyF+vyUxVwqpDQP1JQHFh7zoeUUJs/RXDpZcMOP7SXBz
	ZZV5ZEqgyciPonB+nywbnwhofuBtQBR5bdDnF/LFRG3wnoXFugmyxqLVKtglklAHZmb6CCfHkVSub
	7YuIDeH1hObfjWPkYP4QdoF5ju7im/lJww1r9o7UsVZ+QBIHzltvzG3rfbClOEMaLmBkjeqt21Zt1
	4M2ynd9B2VbNdAfJybu5F8PUyeaWnG/sFvKTnzItlqMon7D3sfV9YcP3eT0bCE17dbDdv3EMFNW4V
	5a+itfcA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0D-000000002Zx-469x;
	Fri, 28 Nov 2025 06:30:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 05/25] logprint: cleanup struct xlog_split_item handling
Date: Fri, 28 Nov 2025 07:29:42 +0100
Message-ID: <20251128063007.1495036-6-hch@lst.de>
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

Drop the typedef and re-indent the helpers for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 94 +++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 5d44c2b1eb67..a4fba0333a60 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -17,14 +17,14 @@
 
 static int logBBsize;
 
-typedef struct xlog_split_item {
+struct xlog_split_item {
 	struct xlog_split_item	*si_next;
 	struct xlog_split_item	*si_prev;
 	xlog_tid_t		si_xtid;
 	int			si_skip;
-} xlog_split_item_t;
+};
 
-static xlog_split_item_t *split_list = NULL;
+static struct xlog_split_item *split_list;
 
 void
 print_xlog_op_line(void)
@@ -139,55 +139,57 @@ xlog_print_op_header(
 }
 
 static void
-xlog_print_add_to_trans(xlog_tid_t	tid,
-			int		skip)
+xlog_print_add_to_trans(
+	xlog_tid_t		tid,
+	int			skip)
 {
-    xlog_split_item_t *item;
-
-    item	  = (xlog_split_item_t *)calloc(1, sizeof(xlog_split_item_t));
-    item->si_xtid  = tid;
-    item->si_skip = skip;
-    item->si_next = split_list;
-    item->si_prev = NULL;
-    if (split_list)
-	split_list->si_prev = item;
-    split_list	  = item;
-}	/* xlog_print_add_to_trans */
-
+	struct xlog_split_item	*item;
+
+	item = calloc(1, sizeof(*item));
+	item->si_xtid = tid;
+	item->si_skip = skip;
+	item->si_next = split_list;
+	if (split_list)
+		split_list->si_prev = item;
+	split_list = item;
+}
 
 static int
-xlog_print_find_tid(xlog_tid_t tid, uint was_cont)
+xlog_print_find_tid(
+	xlog_tid_t		tid,
+	uint			was_cont)
 {
-    xlog_split_item_t *listp = split_list;
+	struct xlog_split_item	*listp = split_list;
 
-    if (!split_list) {
-	if (was_cont != 0)	/* Not first time we have used this tid */
-	    return 1;
-	else
-	    return 0;
-    }
-    while (listp) {
-	if (listp->si_xtid == tid)
-	    break;
-	listp = listp->si_next;
-    }
-    if (!listp)  {
-	return 0;
-    }
-    if (--listp->si_skip == 0) {
-	if (listp == split_list) {		/* delete at head */
-	    split_list = listp->si_next;
-	    if (split_list)
-		split_list->si_prev = NULL;
-	} else {
-	    if (listp->si_next)
-		listp->si_next->si_prev = listp->si_prev;
-	    listp->si_prev->si_next = listp->si_next;
+	if (!split_list) {
+		if (was_cont)	/* Not first time we have used this tid */
+			return 1;
+		return 0;
 	}
-	free(listp);
-    }
-    return 1;
-}	/* xlog_print_find_tid */
+
+	while (listp) {
+		if (listp->si_xtid == tid)
+			break;
+		listp = listp->si_next;
+	}
+	if (!listp)
+		return 0;
+
+	if (--listp->si_skip == 0) {
+		if (listp == split_list) {		/* delete at head */
+			split_list = listp->si_next;
+			if (split_list)
+				split_list->si_prev = NULL;
+		} else {
+			if (listp->si_next)
+				listp->si_next->si_prev = listp->si_prev;
+			listp->si_prev->si_next = listp->si_next;
+		}
+		free(listp);
+	}
+
+	return 1;
+}
 
 static int
 xlog_print_trans_header(char **ptr, int len)
-- 
2.47.3

