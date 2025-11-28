Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81CC207A0B
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311431; cv=none; b=jT7XnxFPnaebMyAr1CXvgkikmtKodidhr/C8e9uhNO01K1uZst9vaUcc95QprzaBVJbuoIT4F6ST4zvvTtuD06UH9+Fzt3Kl+uaICpyfMv3TK/NZE3Zrp0nrXDi1EFIhBXc9CcOaiEG7fkeLaEfWNOdH0lMsCgbWpGKLuUV8vA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311431; c=relaxed/simple;
	bh=Q1somFff6mp1RBS80ZbN1B5xRh1X7F77Ler/h/dyfHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tQE0ak8Kt7tiyxAwbtnCDFnACrU02oG9HcEBUuBai5nhbhlkWcR7KBVvaU0FfbkUYtExwN7rAMQ/WZssMgunqu7ZwpLpl/RgjvZN6Q7+IvZM8bGX/+Ro4NUeKdjXvpreMhLlsasP8bw6vMNtcyTlaOwglbRUka5CSM4uzolR9/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HAtoaUAe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HAtoaUAe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tzjRv5QuvD00pYHSyodKbb/keCJjBWSz6rOSI9+K6ww=; b=HAtoaUAelGXRg2Z4/k/mq/o73n
	NzPZLg28e4Z5h/tZdFRZsR4vVs8TElJUEYazFSeoN+G+mZoTC32PgIKRaWNImtCOy7aUjkGRu7cXC
	54Y7A623EajSKvT3TfD5OmtH/Mg+N7a2wJmfx4ZMuaG+RC3EqiqIC8Szgohw37tOEt0sz+vP/PyYH
	ImEqnAUBhIursDO3SsKban4iR2h4R3BojxVNL+YI0oOWh6bzZ9zeQ739BdHUDWk2ubkjuoHKYuKXU
	AikfUpIh7FoNa8inrChQlvZLym6JcZIk0STRfE/HTPNRj6b7rREc2vDPVPj0DDwzq/XcaFz4H6yyW
	kMvzs3eQ==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOrzx-000000002Yg-1CHO;
	Fri, 28 Nov 2025 06:30:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 03/25] logprint: re-indent printing helpers
Date: Fri, 28 Nov 2025 07:29:40 +0100
Message-ID: <20251128063007.1495036-4-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index bde7e2a5f1db..505b6f0fa150 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -29,33 +29,34 @@ static xlog_split_item_t *split_list = NULL;
 void
 print_xlog_op_line(void)
 {
-    printf("--------------------------------------"
-	   "--------------------------------------\n");
-}	/* print_xlog_op_line */
+	printf("--------------------------------------"
+	       "--------------------------------------\n");
+}
 
 static void
 print_xlog_xhdr_line(void)
 {
-    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
-	   "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
-}	/* print_xlog_xhdr_line */
+	printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
+	       "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
+}
 
 void
 print_xlog_record_line(void)
 {
-    printf("======================================"
-	   "======================================\n");
-}	/* print_xlog_record_line */
+	printf("======================================"
+	       "======================================\n");
+}
 
 void
 print_stars(void)
 {
-    printf("***********************************"
-	   "***********************************\n");
-}	/* print_stars */
+	printf("***********************************"
+	       "***********************************\n");
+}
 
 void
-print_hex_dump(char *ptr, int len) {
+print_hex_dump(char *ptr, int len)
+{
 	int i = 0;
 
 	for (i = 0; i < len; i++) {
@@ -73,7 +74,8 @@ print_hex_dump(char *ptr, int len) {
 }
 
 bool
-is_printable(char *ptr, int len) {
+is_printable(char *ptr, int len)
+{
 	int i = 0;
 
 	for (i = 0; i < len; i++)
@@ -83,7 +85,8 @@ is_printable(char *ptr, int len) {
 }
 
 void
-print_or_dump(char *ptr, int len) {
+print_or_dump(char *ptr, int len)
+{
 	if (is_printable(ptr, len))
 		printf("%.*s\n", len, ptr);
 	else
-- 
2.47.3

