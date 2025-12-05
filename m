Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959D331239
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946956; cv=none; b=lx/InsT/RK4cG1OKyoB3bjU2kME8u2PSAMwHNIo8Chv622OJCcYdkB5SL22rcHpvKfGpSXqMZz3+JB08+7tXj++l4jMWa7RF5SQSB+mVmtJrV5Dp2x1XBvX/jeYbLTddY5U59l/l/MwxatDWq1TLDB8JMqP7Ed37FgfuOWj14TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946956; c=relaxed/simple;
	bh=Qe5NgPCn8hnxRDBtRW8+U5DYr2lkTh3ePKzUCIMdQvc=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I87t4nN4TTXqLnHBvkdarV/RcJvv2Mlew7WpBCKmfH0d9/qvv3Vg+nkMKxH+9/qOu2l91OCSgGuS3LtHBZhRyfFGaFxW9szxNkA8y1pz7sdwKe7AYd/KtqH4+f48hzskhcJm7p4mEbBg3CSb8Le0jA+M30UB8cXBvGMN/PpYmUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QLvJqi83; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UGCLs0l1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QLvJqi83";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UGCLs0l1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
	b=QLvJqi83/WJ33QKY1cfe4WkQoBV0AAblRhCZHk5A1JVchkMAXREFnRVQK/gvNUf+99n8MM
	0Yk8y9mV9+bih3uPXwfFJed+cS4dEScbkCbXTIjMxtR0oCykqxBRN7+h+wSa9e3Fd8Bc0g
	77SuqyHIRISt+nakQiFmT1grNWHltZg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-CBqcR0nVPaqV0e4uBiJegA-1; Fri, 05 Dec 2025 10:02:25 -0500
X-MC-Unique: CBqcR0nVPaqV0e4uBiJegA-1
X-Mimecast-MFC-AGG-ID: CBqcR0nVPaqV0e4uBiJegA_1764946944
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42e2d6d13d1so1118549f8f.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946943; x=1765551743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
        b=UGCLs0l1zifOV4GXKA60tS88Xewae8+pesB/AyAfcW0xEpXyMv2hsoQxgkaXXi7Z1c
         /6N1rkPS54DZKkbEpG4cNbub+XWR6E+8zJJn29LOoo9Q6ZQyOCyO/z3qLBkmIsfhFcQA
         9iPSarulfcuUilKAQCjhtptJFfDiL8H/PfiNbqFSsYd08ZCqmem8mL3c66griFHleSby
         WkbCROsWhBoi1BesPypKUvEGPSGu/mut7tVGB7xCKUUQq4jOukeTNs510aKBsb9ugiPH
         Vm7jkcNJuzFNlk4Wrkw3wXxJd8BlW6lJvGrnoUVPq5NHbbDW/qP8zUkS07xc8S0TzvFJ
         mrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946943; x=1765551743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X7q+Sehmhl+0qHs4QR6OPLmXT44EOIChudYrqtqS6Os=;
        b=ucmORB1QZF1apO8g1oNHSTrJKTW5aArT60yGTqraDqimG1APn8rf9ZWOTeWrIcNLHM
         AuEoIePbMLNVwKBouMmGMlkFGh2UtmzKvKKwSUTFNi33YEDtzpjdd9l00GQeAEhEOF4p
         zCEa+ShyYsIYuBxPfTeEmQ0EqyAU76O+03T/OvETbJ5/g8yFXIoq7UmSHMcmucJLxwSL
         WFq7ILj6czv9Trx2iTIDhCUEfR/eggDiQCUT9gbRybB8CsFc+pAWkOxjNGQ7diH6pY5j
         td7rnPZNHSUod6KGFk4CQLfvIR8LntpzY79YpIQRFzptEeJUHSCAR6vExoixyzqSMUhZ
         qnCQ==
X-Gm-Message-State: AOJu0YzGKpq56/BMQ9mCHz8hCYHk+nuANfxAzw3OcarQEzlviNskSAfl
	r2WNVc1NgVGFv4t11PVdHFU6w24hX1Irailek/uJnou7Fg/fHTIEAa2oacIWrYaePestAaoMf/9
	yU0KwCTsUF+Pmx4nzIuhDvvyU9qlglyM0ryChZGQHaS74q2yw1GUA98Cq0EmOImeg5ZgwKyNY8l
	5IV2f9ZW5I/tsKOmdj7X8xIwlcHKtwma2YBfGGneMEes50
X-Gm-Gg: ASbGncutvaHB5zUgLFpob0e/oMRlw3PG2tbfc+HKKMdlZYhtUsYXsP3eS72nPOIE3ll
	+hHkdMtKCPQA0RCbSUag/HwRPogf6YxEsjQuuXMxLCIw/w8GibtVf3g/lBFuSUJYpM5YGt4UjAe
	ovkK3vXVLS2Cl+F2ps1o1eygCNPr6bygpJDnq6W9s/g98t8BxTCEi76cA4lfIfqntaC/JNDuScj
	t+GG3cYlIOo2wgfv+cTUtBfApp4pkJ4tjm6VML4hQym+pQAZlWk8rxExrJQms7uoF9nH8KVPJyj
	qZN0sKgm6Y4VhB9jX2c2JZV3NQZZjLrkpaWLUx8wNtmSJp1k/+yv+d3VuMBzY+pbxJEKA3KhkGo
	=
X-Received: by 2002:a05:6000:288f:b0:42b:487c:d7cb with SMTP id ffacd0b85a97d-42f731e9719mr12026814f8f.34.1764946943312;
        Fri, 05 Dec 2025 07:02:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHL5aCaOl2N2whm6Qmase9PpPMBXAWphDCFhCkIjouFykdgCQ7ZRn5RMcIgw2zgM1wzAq8RzA==
X-Received: by 2002:a05:6000:288f:b0:42b:487c:d7cb with SMTP id ffacd0b85a97d-42f731e9719mr12026756f8f.34.1764946942788;
        Fri, 05 Dec 2025 07:02:22 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353f75sm9592074f8f.42.2025.12.05.07.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:22 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:21 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 10/33] xfs: convert xfs_efd_log_format_t typedef to struct
Message-ID: <j7necur34b666kz5ktas2acgigo6abfri4c7zapspeo52cqfr7@aqdv5cgigctb>
References: <cover.1764946339.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764946339.patch-series@thinky>

Align function arguments to new longer variable type and fix comment in
xlog_print_trans_rud() with wrong xfs_efd_log_format mention.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_redo.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 5581406d43..b957056c87 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -187,18 +187,20 @@
 }
 
 int
-xlog_print_trans_efd(char **ptr, uint len)
+xlog_print_trans_efd(
+	char				**ptr,
+	uint				len)
 {
-	const char		*item_name = "EFD?";
-	xfs_efd_log_format_t	*f;
-	xfs_efd_log_format_t	lbuf;
+	const char			*item_name = "EFD?";
+	struct xfs_efd_log_format	*f;
+	struct xfs_efd_log_format	lbuf;
 
 	/* size without extents at end */
-	uint core_size = sizeof(xfs_efd_log_format_t);
+	uint core_size = sizeof(struct xfs_efd_log_format);
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_efd_log_format_t structure
+	 * xfs_efd_log_format structure
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;
@@ -225,12 +227,12 @@
 
 void
 xlog_recover_print_efd(
-	struct xlog_recover_item *item)
+	struct xlog_recover_item	*item)
 {
-	const char		*item_name = "EFD?";
-	xfs_efd_log_format_t	*f;
+	const char			*item_name = "EFD?";
+	struct xfs_efd_log_format	*f;
 
-	f = (xfs_efd_log_format_t *)item->ri_buf[0].iov_base;
+	f = (struct xfs_efd_log_format *)item->ri_buf[0].iov_base;
 
 	switch (f->efd_type) {
 	case XFS_LI_EFD:	item_name = "EFD"; break;
@@ -376,7 +378,7 @@
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_efd_log_format_t structure
+	 * xfs_rud_log_format structure
 	 */
 	memmove(&lbuf, *ptr, min(core_size, len));
 	f = &lbuf;

-- 
- Andrey

