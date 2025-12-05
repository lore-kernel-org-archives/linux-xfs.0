Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EB93242D4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946949; cv=none; b=RSLyMii4yd6UxS4n1xLR9tQIXDHWiVNHDdASBaG0r3wPls6FuzynsvXt4DEoEa6AZpqEzJtJFWSAkE7MYo9GZ40DyKu34+CXMyT4vG9hESEHEj+Z/B4/yF4kbUaHsB3bFNI5uywrRWBfJXOK50MuF3NnW9ckaM9WMJrJhTITMGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946949; c=relaxed/simple;
	bh=NZ7YtUlFmqvxw+SofYxkCz3k8q75ld9imHF0lvtGwC0=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjrmT4NPvU4rxz2visrPYbDQv5Ub2fEEYUssIS8IXugG0jC15+IRH+5EOfJRzJXDh/AjvP/ZabaKP2iVlYqGHjfUdahcb/wAYBRBmEeTDQX9HL0wJAUWTl1t+jRj7eMjymy2IyKruhu5Y67qB+ghB3JQ1YRHv0UAkWEVzy7G3do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UqNYvZZR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3TP8Iw2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqNYvZZR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3TP8Iw2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
	b=UqNYvZZRIJ4SIaBxVopbaO18IhoGbyee15iDzsgeK9YLjsRg3caW4mmJ+iEel/Bu3ApGxB
	dzMeflJJGeyi1P50JmGbqwxSn/CUeWAXfzT5+vhG9Nuqls2N9EBVKQ+BxFfjBMLujEnMJF
	jEDnx+3n77jBS7j0GEbGYBpHGNYqV6s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-FU0wXFeLN16rjiI3BItWmQ-1; Fri, 05 Dec 2025 10:02:19 -0500
X-MC-Unique: FU0wXFeLN16rjiI3BItWmQ-1
X-Mimecast-MFC-AGG-ID: FU0wXFeLN16rjiI3BItWmQ_1764946937
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47918084ac1so18548455e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946937; x=1765551737; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
        b=P3TP8Iw2V5Yoj3LlCnFpYcPY9cQfcGEM0VG+97NFe58evEn6fBAqFhqPrcwGsKrFrP
         RMENpUjmtT45PJY5OZrn2jqsRagJNj76wrU0k/68SzYZdtyFvG8QOxtq2xBGmAFZmCCr
         ViF/VPmn3Nw8AgpPykFUu+NuiQz1f3M2SvKMW4ftGZScGl9R2j7F/oVnsuub6Uwggf8j
         q7Pq4poS0mplo9VOfjmSZM84wUtuzHwqnOdfbTYUDavKM3Ts76ExFYdGbVTKChhOU/R4
         9EEAeu1sE3rvi60zk+M8g7OSVVT2YGVqD0GNR+SH2guFQn/1qRb6xHrm1Td10STJrCHx
         NVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946937; x=1765551737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
        b=halySP9yczZrI6EXj7cBOUqCCgbtAh1/vb9NdeqXq8X9obdEm7YuCHPknw/KC+XJt5
         ygB8V9lRWqiwcYwRg0swrRzV8MeSKyCCcaAjm2+qs9EbmWRnkyE/+gllmogHj5OLYzMR
         RZKQ8WV56zEX/HdQ6yXW164Rd4PZcPEfSEis31c8e/GMqDcmk8L8f9CksvlrHACutAxa
         xtSIF2H2lS7KeyTWaLK00wWbbMEyCnMNSLNR8481YdpkeK9GBdVIuYxyy6kmgN2JYxpe
         U46jV6jVVAlidd0zbYPLzb3hTsaq/4tnE4eVvOC73fX47e6K3EJEaDrMIDBwykdrJmMU
         4/fw==
X-Gm-Message-State: AOJu0YwLvtVtZ17bOIK5kG/MF9fKR2BUB5wWkJ74/DmySdSy3F5HJ2Af
	7wwCvECdgXhGiL7mZczFtdtiwBzwLdcW+BwQ38BqbDwuTzGk3Oq2uziXzRcS8w8GHnqnc66l5KV
	F1zPnn0nLAWAnEQfLPXdr17SZhebaA5a/9o5Mq1jHws6evDtQn2dkGjBnvgEAH3jbS4JtwASM+k
	htNT3Sck1djpvcta1f6ie+broPosjXI4V2pf0rscGRRj5Q
X-Gm-Gg: ASbGnctdMGRaZe0l0D9HbMPMBWTBq/8FuCXk9801s6qSZLylZkGK4zuTsWL6LJCdsB/
	H5cGhQ5lYjp15/6/aTnAEHGPbJzKduTBVo2f568dnw4z1Ad62VbQHWflRb94lkaacnmrhDmY+1s
	z0f+mo1e/5TcIrQpS39GfCCzd9LlF6AzWRjF/7ahOWuTudEQrj0xSA+eF1pn/V/q/L+dzff4SF5
	JTCLAQXilvqQDqok5NlXpEtq8fQ5oPvKptVzsPRhXelXyA3sk7pDjD9M+JGjsmNp4mTC4Q+iKkr
	fvWJdZYuqu7GbChpOtUag5uPnSrQh5nEMObUc2h3CpvaQHHiCyudQqRaJqmrnqdXiLQEqeSSQMw
	=
X-Received: by 2002:a05:600c:46ca:b0:471:9da:5248 with SMTP id 5b1f17b1804b1-4792af35091mr108140885e9.26.1764946937076;
        Fri, 05 Dec 2025 07:02:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnayWagSIc/qLnSDfL5kLvslEq9PtLvVpyLvbpQAviKbu4GpGUoCiBvFJMM0oa7oJxCv7yqw==
X-Received: by 2002:a05:600c:46ca:b0:471:9da:5248 with SMTP id 5b1f17b1804b1-4792af35091mr108140315e9.26.1764946936472;
        Fri, 05 Dec 2025 07:02:16 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47936f651dfsm21810015e9.5.2025.12.05.07.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:15 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 9/33] xfs: convert xfs_efi_log_format typedef to struct
Message-ID: <2k25xh5bbqbd7wn6pj4vwvkd3ey4kcxolluhyoo6kqumudoh6z@kyq7powx3kma>
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

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 logprint/log_redo.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index e442d6f7cd..5581406d43 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -19,7 +19,7 @@
 	int			  continued)
 {
 	uint i;
-	uint nextents = ((xfs_efi_log_format_t *)buf)->efi_nextents;
+	uint nextents = ((struct xfs_efi_log_format *)buf)->efi_nextents;
 	uint dst_len = xfs_efi_log_format_sizeof(nextents);
 	uint len32 = xfs_efi_log_format32_sizeof(nextents);
 	uint len64 = xfs_efi_log_format64_sizeof(nextents);
@@ -63,23 +63,24 @@
 
 int
 xlog_print_trans_efi(
-	char			**ptr,
-	uint			src_len,
-	int			continued)
+	char				**ptr,
+	uint				src_len,
+	int				continued)
 {
-	const char		*item_name = "EFI?";
-	xfs_efi_log_format_t	*src_f, *f = NULL;
-	uint			dst_len;
-	xfs_extent_t		*ex;
-	int			i;
-	int			error = 0;
-	int			core_size = offsetof(xfs_efi_log_format_t, efi_extents);
+	const char			*item_name = "EFI?";
+	struct xfs_efi_log_format	*src_f, *f = NULL;
+	uint				dst_len;
+	xfs_extent_t			*ex;
+	int				i;
+	int				error = 0;
+	int				core_size = offsetof(
+			struct xfs_efi_log_format, efi_extents);
 
 	/*
 	 * memmove to ensure 8-byte alignment for the long longs in
-	 * xfs_efi_log_format_t structure
+	 * xfs_efi_log_format structure
 	 */
-	if ((src_f = (xfs_efi_log_format_t *)malloc(src_len)) == NULL) {
+	if ((src_f = (struct xfs_efi_log_format *)malloc(src_len)) == NULL) {
 		fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
 		exit(1);
 	}
@@ -95,7 +96,7 @@
 		goto error;
 	}
 
-	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
+	if ((f = (struct xfs_efi_log_format *)malloc(dst_len)) == NULL) {
 		fprintf(stderr, _("%s: xlog_print_trans_efi: malloc failed\n"), progname);
 		exit(1);
 	}
@@ -135,15 +136,15 @@
 
 void
 xlog_recover_print_efi(
-	struct xlog_recover_item *item)
+	struct xlog_recover_item	*item)
 {
-	const char		*item_name = "EFI?";
-	xfs_efi_log_format_t	*f, *src_f;
-	xfs_extent_t		*ex;
-	int			i;
-	uint			src_len, dst_len;
+	const char			*item_name = "EFI?";
+	struct xfs_efi_log_format	*f, *src_f;
+	xfs_extent_t			*ex;
+	int				i;
+	uint				src_len, dst_len;
 
-	src_f = (xfs_efi_log_format_t *)item->ri_buf[0].iov_base;
+	src_f = (struct xfs_efi_log_format *)item->ri_buf[0].iov_base;
 	src_len = item->ri_buf[0].iov_len;
 	/*
 	 * An xfs_efi_log_format structure contains a variable length array
@@ -151,9 +152,9 @@
 	 * Each element is of size xfs_extent_32_t or xfs_extent_64_t.
 	 * Need to convert to native format.
 	 */
-	dst_len = sizeof(xfs_efi_log_format_t) +
+	dst_len = sizeof(struct xfs_efi_log_format) +
 		(src_f->efi_nextents) * sizeof(xfs_extent_t);
-	if ((f = (xfs_efi_log_format_t *)malloc(dst_len)) == NULL) {
+	if ((f = (struct xfs_efi_log_format *)malloc(dst_len)) == NULL) {
 		fprintf(stderr, _("%s: xlog_recover_print_efi: malloc failed\n"),
 			progname);
 		exit(1);

-- 
- Andrey

