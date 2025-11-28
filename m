Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA3B24DCF6
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311440; cv=none; b=hZjHWob3Yo89gCIzy9rDfhW5Lua8bOqBmcYU+OnX0kP1tiU/NRKqKUNFgD98TI4OgK2CF8vPzRaCVvLRRegkw3zCFuGa9J2/ERhxNpQwc/JZPXY86TCUSPzZuBeDaQv62KUgoVAKseUWpiJWacnrQm9iFliLGYkGu6WyZ7s7Whk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311440; c=relaxed/simple;
	bh=0tQZLUoZ4rkkT5g3lJlV1Kv3d0lDHBLAmvEZBr4bHCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6++zcNYLbNXE0yiMBAU6Em+6DuMZmvGeLR5JQ9v+POOZSFlkEceYTTnGi2XRs9ZmS+7hwsftbKlBw6UDh/b0sfdgPH0IcGn9NKYOaQB39bv8lUq2EaEu3OsT6Bj3ZVBFOROxxjpexeC0RDbmFUIDOKlWrIypIFEDmUtvosbNvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=w1wzRCED; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="w1wzRCED"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=z163vsZcsQHBwzfMPNip6uqA1mtbdIKky/UuOgQLhpI=; b=w1wzRCEDP1J8KtSat8O19+XJm9
	H0HQH2N7mKRCTy0rb85skDXHaup2dmgML8I33DDprCsv3dcbZjD3O06OiSs+EZBHHuoG7bLU7CCCf
	wxi6AZqh1ysQ2qARi0SUIWGKuh3XkFdtYZRhjf+IrgHAJ+KqlsTKczzZFeVmHsSd5NxEnzYhnVYis
	9jRROzjSFJeYOUFZo4jBR8zO1MDZvYgPk4k4VMIVxe9zoVsmQvMUhk7dF6iORfwvmG4N4WzsoaG2W
	1ixj9Zcizyim7MKBtFMW8j2PJ1FYG3bMOHW1q6DIJKEZa+vStxV1RErWA7p/4+hdvqeux6iBQlawD
	jSZHMwjA==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs05-000000002ZN-2Qqh;
	Fri, 28 Nov 2025 06:30:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 04/25] logprint: cleanup xlog_print_op_header
Date: Fri, 28 Nov 2025 07:29:41 +0100
Message-ID: <20251128063007.1495036-5-hch@lst.de>
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

Re-indent and drop typedef use.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 75 +++++++++++++++++++++++----------------------
 1 file changed, 38 insertions(+), 37 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 505b6f0fa150..5d44c2b1eb67 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -98,44 +98,45 @@ print_or_dump(char *ptr, int len)
  * a log operation header.
  */
 void
-xlog_print_op_header(xlog_op_header_t	*op_head,
-		     int		i,
-		     char		**ptr)
+xlog_print_op_header(
+	struct xlog_op_header	*ophdr,
+	int			i,
+	char			**ptr)
 {
-    xlog_op_header_t hbuf;
-
-    /*
-     * memmove because on 64/n32, partial reads can cause the op_head
-     * pointer to come in pointing to an odd-numbered byte
-     */
-    memmove(&hbuf, op_head, sizeof(xlog_op_header_t));
-    op_head = &hbuf;
-    *ptr += sizeof(xlog_op_header_t);
-    printf(_("Oper (%d): tid: %x  len: %d  clientid: %s  "), i,
-	    be32_to_cpu(op_head->oh_tid),
-	    be32_to_cpu(op_head->oh_len),
-	    (op_head->oh_clientid == XFS_TRANSACTION ? "TRANS" :
-	    (op_head->oh_clientid == XFS_LOG ? "LOG" : "ERROR")));
-    printf(_("flags: "));
-    if (op_head->oh_flags) {
-	if (op_head->oh_flags & XLOG_START_TRANS)
-	    printf("START ");
-	if (op_head->oh_flags & XLOG_COMMIT_TRANS)
-	    printf("COMMIT ");
-	if (op_head->oh_flags & XLOG_WAS_CONT_TRANS)
-	    printf("WAS_CONT ");
-	if (op_head->oh_flags & XLOG_UNMOUNT_TRANS)
-	    printf("UNMOUNT ");
-	if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-	    printf("CONTINUE ");
-	if (op_head->oh_flags & XLOG_END_TRANS)
-	    printf("END ");
-    } else {
-	printf(_("none"));
-    }
-    printf("\n");
-}	/* xlog_print_op_header */
-
+	struct xlog_op_header	hbuf;
+
+	/*
+	 * memmove because on 64/n32, partial reads can cause the op_head
+	 * pointer to come in pointing to an odd-numbered byte
+	 */
+	memmove(&hbuf, ophdr, sizeof(hbuf));
+	ophdr = &hbuf;
+	*ptr += sizeof(hbuf);
+
+	printf(_("Oper (%d): tid: %x  len: %d  clientid: %s  "), i,
+		be32_to_cpu(ophdr->oh_tid),
+		be32_to_cpu(ophdr->oh_len),
+		(ophdr->oh_clientid == XFS_TRANSACTION ? "TRANS" :
+		(ophdr->oh_clientid == XFS_LOG ? "LOG" : "ERROR")));
+	printf(_("flags: "));
+	if (ophdr->oh_flags) {
+		if (ophdr->oh_flags & XLOG_START_TRANS)
+			printf("START ");
+		if (ophdr->oh_flags & XLOG_COMMIT_TRANS)
+			printf("COMMIT ");
+		if (ophdr->oh_flags & XLOG_WAS_CONT_TRANS)
+			printf("WAS_CONT ");
+		if (ophdr->oh_flags & XLOG_UNMOUNT_TRANS)
+			printf("UNMOUNT ");
+		if (ophdr->oh_flags & XLOG_CONTINUE_TRANS)
+			printf("CONTINUE ");
+		if (ophdr->oh_flags & XLOG_END_TRANS)
+			printf("END ");
+	} else {
+		printf(_("none"));
+	}
+	printf("\n");
+}
 
 static void
 xlog_print_add_to_trans(xlog_tid_t	tid,
-- 
2.47.3

