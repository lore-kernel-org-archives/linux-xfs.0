Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B9625A2A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311456; cv=none; b=MWJ574eNe1l2sQoKXk8hdK3e3i2Np24Ztq2VJAo0oPpnw8ewz7OqpMmjsV1ReLePbYOILK4pY5sSPU8il9Qv/OnVJU6+L/AbRbpEc8uxLeVXDSJvKxYeGezLrej1+9WnMA7kolc1MpZnZ6Dv0a2W+mlwOyukQ79nLLFgJt9obtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311456; c=relaxed/simple;
	bh=nBDROIb3/IpcWnkQcsjiP0M3u7PNjRXzNQZJEjIayUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DD3Tz4TQaA3By7ruArSWTHnLFZ/UofF3s4PqQ1IxbSCz460IY9+KsjqoHAjVcVKa6On+BZwwnYp0KljvAjJntzbWFcS2eGCTIiHzuhFtsSJMrI3UPGH2XdUAdLFSVq6k+LSxYNL+6Vfsv905askaezAdF0als8+0bN5/iwBON54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PRVxKR8/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PRVxKR8/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T1MSRIai94jwf5a1DvFa13RkGDWeOQoUpi+ZFpq3z+0=; b=PRVxKR8/zM2Nm4WBjhSRQbC6YW
	YmqXSr6X1khvH/tvRSDvHfxNn9PH6exqeWlXbb9jn5N/wBDIZpVuLlroaMLDvwVzcTlw3Fz1/Ixr1
	w4loZVQWvs4W5ZsbNO1wiPEzFjWPPOqkIHLls8FwSgm31lNpnPQOwvkKXdUHSJeNuOL4+yh+qh2ht
	3r4I5L865AXmnZn14ehFZP7oxmBgmwJMo61ZUHnuQbamAHvjO/36SAJ3i6JJvBKBqZW8uEiMGp0Ig
	NobmpekZdYd/fAAQsAana+J7QH5J9bvrtev80WRetX66KwVo1i3oXITUVNNtjfdvf9mQptzm58unH
	c8V1BEXg==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0M-000000002ad-0HDI;
	Fri, 28 Nov 2025 06:30:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 06/25] logprint: cleanup xlog_print_trans_header
Date: Fri, 28 Nov 2025 07:29:43 +0100
Message-ID: <20251128063007.1495036-7-hch@lst.de>
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
 logprint/log_misc.c | 49 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a4fba0333a60..48611c746bea 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -192,36 +192,35 @@ xlog_print_find_tid(
 }
 
 static int
-xlog_print_trans_header(char **ptr, int len)
+xlog_print_trans_header(
+	char			**ptr,
+	int			len)
 {
-    xfs_trans_header_t  *h;
-    char		*cptr = *ptr;
-    uint32_t          magic;
-    char                *magic_c = (char *)&magic;
-
-    *ptr += len;
-
-    magic = *(uint32_t *)cptr; /* XXX be32_to_cpu soon */
+	struct xfs_trans_header	*h;
+	char			*cptr = *ptr;
+	uint32_t		magic;
+	char			*magic_c = (char *)&magic;
 
-    if (len >= 4) {
+	*ptr += len;
+	magic = *(uint32_t *)cptr; /* XXX be32_to_cpu soon */
+	if (len >= 4) {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
-	printf("%c%c%c%c:",
-		magic_c[3], magic_c[2], magic_c[1], magic_c[0]);
+		printf("%c%c%c%c:",
+			magic_c[3], magic_c[2], magic_c[1], magic_c[0]);
 #else
-	printf("%c%c%c%c:",
-		magic_c[0], magic_c[1], magic_c[2], magic_c[3]);
+		printf("%c%c%c%c:",
+			magic_c[0], magic_c[1], magic_c[2], magic_c[3]);
 #endif
-    }
-    if (len != sizeof(xfs_trans_header_t)) {
-	printf(_("   Not enough data to decode further\n"));
-	return 1;
-    }
-    h = (xfs_trans_header_t *)cptr;
-    printf(_("     tid: %x  num_items: %d\n"),
-	   h->th_tid, h->th_num_items);
-    return 0;
-}	/* xlog_print_trans_header */
-
+	}
+	if (len != sizeof(struct xfs_trans_header)) {
+		printf(_("   Not enough data to decode further\n"));
+		return 1;
+	}
+	h = (struct xfs_trans_header *)cptr;
+	printf(_("     tid: %x  num_items: %d\n"),
+		h->th_tid, h->th_num_items);
+	return 0;
+}
 
 static int
 xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
-- 
2.47.3

