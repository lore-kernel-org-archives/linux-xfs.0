Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A816C3101C7
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946982; cv=none; b=V12fgSs8qTq1MUPmxsJiGO96kXcbusDChT686IC3FYLfQ1qnqE62dTGlrWEz/aWf3P+bw4BTvrLhsrMIaGThw68pq4zUV0pMZc4W5v8zR6lBYp8mQnTopRb3qRhX9z72mQcVay7iVIBgVFVL2GZqQOGvGoJ/hD9+1q5VnkyDEjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946982; c=relaxed/simple;
	bh=6vdq3dXwfFCulhiEs/uCJoi7h0HlmgrcWf+QcE7Nkdk=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vFQuv080wRr8b0YAKUgDI8UI3Vxn0UhGcz+sgw5KlRUT5WiGscPsad4+Qrr1vazAz07PMTEOyQkNWfq2R844y1PsiYVzP3tFCpwLzNPjcSLvFw/NMNJjn4IZx/2d8oiv9EO8eWPoByrOOnVfFEnPY/oNftz2ZTdVxlleYctJWNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fL6zhHFY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IaJQhc7k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fL6zhHFY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IaJQhc7k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B1ghITYXmght39kpsZ1aDrwUAAGrRW239T/5UQ5a/to=;
	b=fL6zhHFYGnusiBa9Zcpywg068/1eHfZ9oLf7jvW2UEFZUKqqTnKzmeI0aIweduwSQNv+aZ
	xgSBuA+T3Uo2rMMegvGflVsRl1UqT4yrxrRZvlgvfYGoufmELyOtXWTzpJLSqi/mnxcUiv
	z1eLoyVWJReiXf8t+fzOFglwxwMbzzo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-4ZL_lr9lOe-LSl3ItJug0Q-1; Fri, 05 Dec 2025 10:02:55 -0500
X-MC-Unique: 4ZL_lr9lOe-LSl3ItJug0Q-1
X-Mimecast-MFC-AGG-ID: 4ZL_lr9lOe-LSl3ItJug0Q_1764946974
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4776079ada3so26987125e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946973; x=1765551773; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B1ghITYXmght39kpsZ1aDrwUAAGrRW239T/5UQ5a/to=;
        b=IaJQhc7kR8nwpcCTb85JknczuWrBnE81NXVMC/LEGP0ztFS6LAoor8p5dae8ZoLJdJ
         YnOGp0OnXeVhFPuXQzwcTDzQatuBUMo0oXnSUua+enOoEVo22HXEPgvxoOH+TPpzbuNz
         Okl5leH4wbgjFVxzqdINRQ45c94ucORmFKkECnpzut+ivp5/lmn+77fCDXvVEw5duJgx
         H0wJSclIbDge9cnctd/Da0U7Wuv3+xrpfCppV9hr8AyHGS/9jy08F5JPb9Xi5NUv7yOy
         l1T2NHzQUFWeDD1btcwfuZoiHKpX6dsfW6o6l53NhKui2dl1X6tP/bcqbTXxPQBff7ra
         H9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946973; x=1765551773;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=B1ghITYXmght39kpsZ1aDrwUAAGrRW239T/5UQ5a/to=;
        b=qhJLxXFUgXsiLFOT9uOr8xS3Zfae3GdgLGHuJohMsD9/NW8JkDG2DRPyMDEMmoxOoX
         kWD3IEknXj1swT+hPAIM9IYDzKAbLewFgxrLut/XlUrFIy1Aru0F8wf50WUlWvp4AC7y
         vTDxL5EH4xAVPswbbjQGezTEed9D/bVlNWmc0VJeZ7Us1/IyvX2RoSbDX9llrNuy5dax
         HOi1HBC8eDtT7G2Ppvdd5IbtZ7BJQPh5akZY84dTfZpQD64kRpItl0YmL+hgSlpQ6wRC
         TKipSEjBG5aD/O+pgj9CCltsnEuF0zxTNKNPA4ooFqRG9jxSua0ZR89tMzm/zcX+FZ62
         Q8iA==
X-Gm-Message-State: AOJu0YzBkSG44Om5T3bACwxgrnY0OosOcR2+xuZx5OxCdwbF3Q8j1MZ8
	sjTghqe3U1CPzXgCn/15/PP/Lurt+W2YEk7wKFYXhHyOJxjiFMeyQVqxJ3WgfzESy4225OWrF2a
	4MLhEHhqSZDIn25TR5Ys6QBrITymc6eg5aidKmZQ75P4gmqKn/hc9BX0ltx+4sx30ikBNiZuB1s
	qr2CspVw+7W/IGo64xm6sg/jfv9SF3G0kmTaObTWIYpO8U
X-Gm-Gg: ASbGncuJy8TpY6XK3tIW9W2QoRazjVe41E9AJW+MszpoQjVOAynT7WgZbkA1CdcSAz6
	mQubR3qnePBq0p4F0m5ZxS/oUDHARU2Bv48W0I4KsyqIulIiLkNEhtasX7ZBJpyLszKvrHzzgRA
	gFX7lS4AnTqmguSq2eAkJACVsNh7qszJ696tsC+HUPs2YdWH1WmBMXN3jNx+xiJHcxFT37mB9Mm
	l+sDlporHsdbtp0Fa+2BWCjG3uoPjH0EmtLjOAWP1BIjHNaLnb1FSpibVBE7BwGOCEZm5ZrhLgy
	uO+xQWSy9WfMMOtZRJBwk2pEYXlDnII86yv3wCtLWwIgbyTcgENp4I9OUPiV1rVw6qz3jw4k6P0
	=
X-Received: by 2002:a05:600c:1c27:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-4792f1b1040mr73550245e9.0.1764946973073;
        Fri, 05 Dec 2025 07:02:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE8waz2oVgLhYbVLRo5VZZI+WJo1ubL2F7CN1rGAClDkZBaYwFStIlVnUi2SJMHaEkhGXW3GA==
X-Received: by 2002:a05:600c:1c27:b0:477:9fcf:3fe3 with SMTP id 5b1f17b1804b1-4792f1b1040mr73549695e9.0.1764946972445;
        Fri, 05 Dec 2025 07:02:52 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930920b6dsm99997345e9.1.2025.12.05.07.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:52 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:51 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 16/33] xfs: remove the xfs_extent_t typedef
Message-ID: <h63fo6qevzsdudgluzj6uwoylip4q663c3lhu2rkfp3bpv3bgd@w2gneixypxfz>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 476688c8ac60da9bfcb3ce7f5a2d30a145ef7f76

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Also fix up the comment about the struct xfs_extent definition to be
correct and read more easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 2c3c5e67f7..6d0cad455a 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -605,16 +605,17 @@
 /*
  * EFI/EFD log format definitions
  */
-typedef struct xfs_extent {
+struct xfs_extent {
 	xfs_fsblock_t	ext_start;
 	xfs_extlen_t	ext_len;
-} xfs_extent_t;
+};
 
 /*
- * Since an xfs_extent_t has types (start:64, len: 32)
- * there are different alignments on 32 bit and 64 bit kernels.
- * So we provide the different variants for use by a
- * conversion routine.
+ * Since the structures in struct xfs_extent add up to 96 bytes, it has
+ * different alignments on i386 vs all other architectures, because i386
+ * does not pad structures to their natural alignment.
+ *
+ * Provide the different variants for use by a conversion routine.
  */
 typedef struct xfs_extent_32 {
 	uint64_t	ext_start;
@@ -637,7 +638,7 @@
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent	efi_extents[];	/* array of extents to free */
 } xfs_efi_log_format_t;
 
 static inline size_t
@@ -690,7 +691,7 @@
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent	efd_extents[];	/* array of extents freed */
 } xfs_efd_log_format_t;
 
 static inline size_t

-- 
- Andrey

