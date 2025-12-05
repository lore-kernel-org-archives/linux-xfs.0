Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B763C26E6F4
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946998; cv=none; b=KwlwsFitHkUQZR4FJu7rCyr52Y9tdEjyr8lcZ0T0Nmbb39NtYxHDjhcA1D9Bni+GVnOliHTDoFdddWuuUZ3toePYw/95PQ250BOQYhAqalHx6aY5EfpnY+5rrHStCDiStB9gA4CdbLMWXD9VigrjzW5qpwLa03wzkT8/Gyqih88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946998; c=relaxed/simple;
	bh=lNn/Vvf5AdE6XYLJuazj08oR3cwwVoUZHD3GNYGtBNk=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qJ0XBZfVFmMD2fyp7MuKvOeZDTlMwzCtiaKSLf2T56o8JAuHW7CHlagPdbvXqSLwhHGqdP4ZeaeB3zYsZsm+tEBMlnJwIK6kQ6a8ykD2p4LuA26DbxIjzHv+rUWpMlKGpDytN1Hy6uBryBEkcOLZmp20P8AElmXG1HAuVCAx/bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R87KIiEe; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DbiIHmvv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R87KIiEe";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DbiIHmvv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rxuqGqStKu3g0VIGl8jdF5NgY5MUoXC6lqrYa9c4EJg=;
	b=R87KIiEeFFPUc8inZres+PFa8jPPqVVfMudTdgVYEWJQl7WNDCXlBhCfJoHZDCdLXaeBRi
	nbGX7iqUdMGOzzD15JQmos+qLonk+YdFH3FSVAOkpDnWB5iUXnAO/LaTdIMLEam6Jmbkvv
	9rrJRJtOlzk47pPjviqbdA7IbbZ67wY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-iANeeX7eNY6kOq7A2Nk8xg-1; Fri, 05 Dec 2025 10:02:59 -0500
X-MC-Unique: iANeeX7eNY6kOq7A2Nk8xg-1
X-Mimecast-MFC-AGG-ID: iANeeX7eNY6kOq7A2Nk8xg_1764946979
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47788165c97so13713085e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946978; x=1765551778; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rxuqGqStKu3g0VIGl8jdF5NgY5MUoXC6lqrYa9c4EJg=;
        b=DbiIHmvvkirl4q9PbSdqGDTUPm5essddFNgq6BIZ+nlHZlvkNu7JCHLdTji9JEAiPa
         3onKpB9mY5f3MsEYepru4cwfYDbOG0qvnVJl4XwaMalMLIom5y6Y551Za2825wby89yH
         mQua3Ax3kXrY8d0+jzlDgml7CIkqxj7gAfkbn9hHY8XYEMIjd5uUTCZBAqdt0xDO9o2I
         p6CSDePYs1UzXG9pND5luipxoYWr4j4Tf6js9CcrL+7lSVIVnY5kI0EfIH++q5M07QRr
         dipbgkIPQNoAtl8Cimz5xbygEWxI8DRf2wN/zq46TdRHAJctEGJJNvYgGDFFn2+4F3l0
         kmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946978; x=1765551778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rxuqGqStKu3g0VIGl8jdF5NgY5MUoXC6lqrYa9c4EJg=;
        b=AQB040QYRNTQ46q7zR7112jJDJXxNZ94fHaI5DmAX87+nt8m6VDqy2KZ774uRJMFH0
         UaMHE4DKP8NbnPNuWrzGpwP7N8uDXS+0ziKpmzM9pgEqv5kWLPjq80jr8AasmSVE1IW7
         bpwDgtgr3BZChCWuK6byQxJf0HR12d5obsXdVw+iaIibkMfFLZB70GS0p9wynZKw73Du
         icqEyrClrxrtdYOKAmusQhLlflbFVYYSdNF3CwEsMoPbPMfyqsgdzcmxBv5/ftRHDLjU
         6sY8T/Uu3T02SCgODsKEzDCasNA0fvPoD+gCxkh00NbW/o0YPwNCZ61aRCvBI1PYSvtI
         QnHA==
X-Gm-Message-State: AOJu0YyUayBMxyrBQM86nA0j3N5AgXZrNPOmYFTzSw/i3oPaL8abmCWU
	/AsK+p+AR75535p/UPoa2CmVMy764x3qGIXywaitZL0v4kAoc5ZaaatFJatGoHgkFWREKoTe5bx
	ek+sQ4nWkhoPbMtOUAPvOOYWlMBnWjqbCMc3T4H/sqzd9XFpo0XsLNHa8tb9JB9Dg1V3LTGsIQt
	M6F2qWce5R9ZwQ4cgMzus3DN01R+w7InH4qUCoCbbjtIiC
X-Gm-Gg: ASbGnctLWlNmtZ80R/3c6asv9Hdq3Q4YaGQFkO5nKIHm2OFLUvulY5bIIR7lTnuNZh0
	bAPmg5X0wOKon60pSBaC5IgXvBSIjIFLiOzFHqENg19F4xooDpvjGEBNUqLkX0TT8dnGjVaK9W2
	nN0n0DhS2t+h885DZoJkZ4qCgG0Pv0OBt118f7kl4Qh/CVXNc1XlK911h081u+5ferOWQ716XdQ
	7A3oC2vVYvVTpZRwDqFW7Pm4Krh80xzXzrF+NJ1AEf8Z0Yq3Wi+2A33C4f40G1REaZSQHPL3BAV
	JAYNt0zopKxsCENzXUmfQOv1ZS0JjBDggp1jsPI4vcgdiomRUMQAdlwOXTLxuV7Pj5c45q4oyF4
	=
X-Received: by 2002:a05:600c:4fc5:b0:477:a977:b8c5 with SMTP id 5b1f17b1804b1-4792af505ffmr128238055e9.31.1764946978042;
        Fri, 05 Dec 2025 07:02:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF5ypWJBSFuS1bcE1YBQUVpHNhqcbv91SifMQI3rs32JgYiMqphd97YvQMKpQ/PZS41/cYIYg==
X-Received: by 2002:a05:600c:4fc5:b0:477:a977:b8c5 with SMTP id 5b1f17b1804b1-4792af505ffmr128237245e9.31.1764946977351;
        Fri, 05 Dec 2025 07:02:57 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b1776besm74460345e9.7.2025.12.05.07.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:02:56 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:02:56 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 17/33] xfs: remove the xfs_extent32_t typedef
Message-ID: <vhm3lsonwbosdv2h4psft6nrn3lvwvcwhmlfjsggvs7xmkzrci@adfn2lippzy5>
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

Source kernel commit: 7eaf684bc48923b5584fc119e8c477be2cdb3eb2

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 6d0cad455a..f11ba20a16 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -617,10 +617,10 @@
  *
  * Provide the different variants for use by a conversion routine.
  */
-typedef struct xfs_extent_32 {
+struct xfs_extent_32 {
 	uint64_t	ext_start;
 	uint32_t	ext_len;
-} __attribute__((packed)) xfs_extent_32_t;
+} __attribute__((packed));
 
 typedef struct xfs_extent_64 {
 	uint64_t	ext_start;
@@ -654,7 +654,7 @@
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
-	xfs_extent_32_t		efi_extents[];	/* array of extents to free */
+	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
 } __attribute__((packed)) xfs_efi_log_format_32_t;
 
 static inline size_t
@@ -707,7 +707,7 @@
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
-	xfs_extent_32_t		efd_extents[];	/* array of extents freed */
+	struct xfs_extent_32	efd_extents[];	/* array of extents freed */
 } __attribute__((packed)) xfs_efd_log_format_32_t;
 
 static inline size_t

-- 
- Andrey

