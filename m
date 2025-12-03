Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190B032ED2D
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789056; cv=none; b=THQEI4q6TSXxe6TafNn7bFM3ynemFiA0HaC4OA+9cY+5Kuuv1+/AFzHA4s1936rteJWhNjZCvptdixEvpt2K3l6zFY+G9E4Krcy1pkFz2MmNt6t6JGCRUYuoXBInOJULJyKrMIkGwF4twuc6Q4oWwZUz90VfGK6IbmhSzEbxWMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789056; c=relaxed/simple;
	bh=NZ7YtUlFmqvxw+SofYxkCz3k8q75ld9imHF0lvtGwC0=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpJHeVGW3dV0OjMtJG4qFJ5Bbr8tqMOmaIcFmEGF7/EAnmU8x43u2YYwZX8n993FpBiAfvYzdYtmjsZ48Mdm285hUwzpXThFkj1UpsB4uYvm/tvd82yA9v0bmbQPZUAlN4OBD0koKkNNzbu2HcndmKVowKpq52w13bDkHgcADMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YeiUH8cj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IlfvZMei; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YeiUH8cj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IlfvZMei"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
	b=YeiUH8cjhx3PaXzC/85K0SlQGuBwwwW8LrskD1XdmmUXfc0Vhjfhqglg6hev+7fueY+TVm
	+kCp68KKCow2XvrdktYGUR3sFghVbxqlXKppd9lsQUGMKlJxHTnjzph8TAQOihMmvNj9q+
	9SYpC3kNItov5SL1HkoUM8UnRP5RkGA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-y4v7utUnPWm7YX7gDUY40A-1; Wed, 03 Dec 2025 14:10:46 -0500
X-MC-Unique: y4v7utUnPWm7YX7gDUY40A-1
X-Mimecast-MFC-AGG-ID: y4v7utUnPWm7YX7gDUY40A_1764789046
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779981523fso609445e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789045; x=1765393845; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
        b=IlfvZMeiK70M7bSVrEPrmEFUdxmP7QQ1VUJWjoFsQqC7/E+j1VIE2ie1dZ8xuhghZ+
         JYQbeHyqTQAmwM0K/0myVNXn5PKOvzEww9/77Hq58maigBo69uYXgq8ReAumBSC/xs34
         GTRCp1BwQNspG0zjN/vPt4ndfgTXUMhGzygexp+cT5wVhKvhoJSgd0AIDtIAR7/7ULdb
         XVZvxnf6XVTMmp5YMvNd1lgFgNc/04VqR9d+7R35etRnerzHvvDRiUrfM/X8jNK9zM/M
         1xwSkAoIHrvYOUfiSlO8i1FIjnxPyTawr3wO7ZcVpP5SHvqia53RBM8lOPFQM7WWYLrA
         Dmtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789045; x=1765393845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5776g4seTpgyc1Bpz538HettFywEtf4bHLzuev0RwVw=;
        b=ihCGxJTRs5dXPIQUaSSOF1+Rp+hRL9ZG0UNxBGtDDs7M1bZ6Z1K7DlBaaSeSVVWd30
         QtNZtOqT/WMvDd1smG3VGM7rzUuLGRjgoQVR+zMLxq7pODbQVXiuKucB8YZPzdTo5NIc
         uedCz2LUto6EeuHHz/O4TLcl2kEvOj88yvkcSkCeIKy/AprX7Id+7ayQUsVx7cNjxjEe
         NJDRrtOJVSJAbzug5tCc2gvCDBnYssD4k/LJ4zGvBsXldNHs3ii1i3dfRhfvGnE/ocmA
         80nzo5WkX7JxdEFxqEZfjMsmsTkYJEGXF9whuR01HeeMsE8zWpBrAlacd5mIHuTDRkEm
         XUOg==
X-Gm-Message-State: AOJu0Yx31acNObU1alCvo96DqAF2TwfGLAMWY3hYrhVwINpwlrvCC1Sb
	1FTL7Mhbe6uPhTaQIaf/b+XVYG+ybnUFEFk/5ooou14MuDa2M/XNX8/usGUHW7JYFRQpqgjBVgG
	lp7fHB/9LgBn5fYSPJo3+r1ERHPZzjAv2HAPr6kZMq1LgE+2n2ca8f10JfALDdFPtdlGw9jhwWW
	hKvVM72PrdaTRXiPLW8Ih4TMsH+A1ih86qoCSC0iZV6dDa
X-Gm-Gg: ASbGncs6snAWbKeMeUoC+4nydojXakU5IMbBlh19c2WeKn3Cr8nkO0eoHZftIjD6QLb
	IHET+CDco+4BSHQg/XEKaIIyWTXE8cUXsWnqqMINBsvGBuKZxjkOsbZ97It5EzILMG4Cfo040gA
	zm+TkNtf23rxZqFVT4kSCVCJzlhc4Zyec8VuEpUJOpKrHHn4SyFM5WIt2qJ/KyK35xDjOmeQY/4
	6gyswxU470UAH/OFzo2uXR++Td5naU8gUusiKOu4aLuXirQdCah9djS20ia5DvEPR3RGyba9Dbz
	7u14/hmgN7ftWbtH6MgAr/6ObT2iWjwdCI20nESq5rjk0SBBXnkOB2U3KEsmsRwgZkUs3Ol2W8U
	=
X-Received: by 2002:a05:600c:45d5:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-4792aee03aamr38705195e9.7.1764789045340;
        Wed, 03 Dec 2025 11:10:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFIdc2aQGKFyc/1Qih959+jDmId10yKBuu5VbeQh0KKhdiw4+v8utXlzdFjPC1OL6yujPC8fA==
X-Received: by 2002:a05:600c:45d5:b0:45d:f83b:96aa with SMTP id 5b1f17b1804b1-4792aee03aamr38704765e9.7.1764789044770;
        Wed, 03 Dec 2025 11:10:44 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a7a87f8sm63298995e9.12.2025.12.03.11.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:44 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:43 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 29/33] xfs: convert xfs_efi_log_format typedef to struct
Message-ID: <dnq6yetxjrry3otd2sbzq4gu43ihaygrv6em34mm4tovoutwkz@k47iid7jegts>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>

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

