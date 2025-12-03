Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E732255E26
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788826; cv=none; b=YTVLlTMhv0yTxRVdwgd9wTybUDv4GrN9gCsJkxetkBAx0H93srvec/Lv9R9+k8B8KgYZl9tnnY1tkOAve4OomTarIK63ifqS+MwwlmcuDk+yWWN/To5mzXDdExy6dtm5WIluXHjEtBht62Pa7c99ASgCKzT5a9Kfp9lZ9leSJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788826; c=relaxed/simple;
	bh=ASe0zzl3hwzNx8mujtKny9cahyA2Xc9hb92rJ4noXfM=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5oeJED01pYWOZ1XfNQgHOCYQAno57SEbO0djestQQU/bzii0CRTV0b1yeugQ3JdKR6rxuY48bLMTKQGi/Es5Aw6cYyx/Re7sdQ2aXh9CBFgGsa7+ms+YDB4X3Bw184IojUbAoctTqqvwT0aEb8VIvjGfIg9fQ2Da+DgxjxQ6yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mleee5Ys; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cPMhHVQo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mleee5Ys";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cPMhHVQo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nl7q++Sd32UUf1Iyi9mR6gpY2iyhqgW4P6QYostOlYw=;
	b=Mleee5YsXvImpnLzFs0RtHguydBXpqXocKx4nlr/kRpWH8F7Masf9SDwVRIJ2Ioy42MGGn
	yRWGzTd+TNcaWuKHMQOKYqykZOGO6c9jgHubeGJ9Mh9RTF7dzOpD1CRrAiO6wXHuqV14eZ
	N+THrsetGqzb37dhSUBETaHrYn89XX0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-oY_xqkWvPfKs1qzDswbHug-1; Wed, 03 Dec 2025 14:07:02 -0500
X-MC-Unique: oY_xqkWvPfKs1qzDswbHug-1
X-Mimecast-MFC-AGG-ID: oY_xqkWvPfKs1qzDswbHug_1764788821
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42b3b5ed793so80342f8f.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788821; x=1765393621; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nl7q++Sd32UUf1Iyi9mR6gpY2iyhqgW4P6QYostOlYw=;
        b=cPMhHVQoOlEceKfVHZ4eg0fauR2oOKWFppocQMe4MIF3XHs1OKd+bbpsawtK1bM0ww
         63XfQu9c672cC7QhLKq04Z7j2YWVBUjW3PeMDATFBmBS+rbUjy9synQHedAylTG2ZqaQ
         XXmkwxS6wnF78vP7EWQhA//+BG5lWlOptrbbj33l73R5D31jCQe8rSmcvHzLPkDxeFtF
         oLfLnq4RR9eyU4/qmAxtSv7Vq74hzaOB8mosS7Z0x+ezIl1JKtjC0w+HfcVbBf5+wlL+
         Q/uZBS97ote//B+fah8552DTH+Pa0pzSdplCbcGsYDxNHtFsP1WTLWVh5r86OehyFEMQ
         qJYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788821; x=1765393621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nl7q++Sd32UUf1Iyi9mR6gpY2iyhqgW4P6QYostOlYw=;
        b=kSKtNf3A8w8wrN6Wt0T2LvZ9tEiWTV4HNjJ0m/1peda81eLGq0PAuD0avqugtFB5kl
         AHW3LsdZbGIh+1UB1VO7a6O8ReImzpXbf9zU4cQTgSaDczh5BcnBwudL/BzTlifPQNW8
         jBYPHxHBHXigzVHtv4ILN7h59JVgJC9wT0xHpHERiMJKY23lIKLgOP0My0POA96+iAJ6
         y/X52q0amxJW++UZqlR+RNGX15pa3NLTaovJ5woS+yCe9btoZHPB53FRK4EeZ3C6YdKd
         CcCOgoNETuow/IWzBWBhIyXqIuSM1TfARqV0DmQCVJP8o8P70GwcN9GMi5afxAoDV/2Y
         E4Gw==
X-Gm-Message-State: AOJu0Yw/P1WNeBo6VFjr/iyl/uh5Vael3U4RkZ9DpJ3rAMhGrpfoh6zj
	40OUaZkAMuKNW6LXoHAGHuXfX9XiSjTQQAZIcJAJrk/HRl8wNRhsHNPHzTm+3mRdvjJ5YYNarLp
	OO+bRPKSKlyxWxnnOlpMBxph8KPoaMIgzegmsgA3XN4A0g9flcb9JG6UfSk+0BRNVAQknS3AeBy
	ZCVaGy3l/FvvRzZjEeP1segOaJny/9LSJZcU7Wh9RtEjdN
X-Gm-Gg: ASbGnctLxBkJUOuXpDUG94MRCYPNcwiEZYFOrTLqjIsw6ZWg6CDXcH6koIFnWvS4KkZ
	xJtIhxJwwhRN4Nwsm+JWOIlpJ6luufPOkl8zoh7uq9jzdecMDPl+FeSArXmbRbUa88rqFM7gA9f
	Nlif3slGrqdX3s9SyIX0Bo2jG1IWbM1KRWQb0wKKDzzOyZUjO+4addfxzggffx5GhBcxDQx0JUu
	IoeiLvsdsP0fOvqDIE6gKzvMsjMCgNoHXfbXDzExFVUPeTlRl+ET8iILpq/z1mNzG+PrmNWYUY9
	44lVXweMjFTMRirKGW1ioQjOJs6vaaTQCF8UKI95FGXDsY8BuYY1pT/5qLzXRsydh0YMgJAdNCQ
	=
X-Received: by 2002:a05:6000:4025:b0:42e:28a4:1fc4 with SMTP id ffacd0b85a97d-42f731cf0femr3797540f8f.55.1764788821045;
        Wed, 03 Dec 2025 11:07:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUju40RHJ9f2zVgIxLc1J/cEHdI+npG5Bwm97N/fz5gx5bL/L/RNNR973OwnutrltgySebGQ==
X-Received: by 2002:a05:6000:4025:b0:42e:28a4:1fc4 with SMTP id ffacd0b85a97d-42f731cf0femr3797499f8f.55.1764788820537;
        Wed, 03 Dec 2025 11:07:00 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1c5c30b8sm41110395f8f.7.2025.12.03.11.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:00 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:06:59 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 6/33] xfs: remove the xfs_extent32_t typedef
Message-ID: <q65k5mnrl6kvrvrdzitgdrcnuv453dmtlbumpxsq6vufrntbql@hi3lqyiojual>
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

