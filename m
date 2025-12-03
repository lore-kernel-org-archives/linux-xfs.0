Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F4328611
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764788857; cv=none; b=OLdlUxPSoUHq4Sz6/+yxb+FDN3Yxk/iN/EH+raAvpVYPPdt7UDyH0pLZkSfwUlUR1W9IWjoCz4MuSi1mti4lgXj8p2RxXh4/LgfVffGIG+CoY4NF3OU/pBEVvJG4DOoOu1TI8FEEDgX1bZFID6yEM+v9RS8gs6/eUhzXSjztsv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764788857; c=relaxed/simple;
	bh=m31jT0Kw+XIAZ3XZMDTYVNL39AxVeT92e5gZosPwgYU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EfB9he5hRwn2nUz+r2OGos2SOJaPXW1YJl4fK7wseXvrcPXhv5/yuK919DVILRE4tauis8j25MI40LtJ81GLF5xvcnLUkNkX+mt2gr7uzf6DPpGXW1sW5r/uOpKb8VE49YP7rBpQORbRiq7A762EPF6plo5L4fbtW6m2hmhLyvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GNkHQPxh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QcXwaOLj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GNkHQPxh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QcXwaOLj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764788853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
	b=GNkHQPxhBNCFEaavSvDdjpAEUTl84iCN6jmVsptD7f8wXY+2O2o4Hd205gAN2sYV/GvgTT
	NqO4Py7+bpabZ2LSeRhxYlDgFllKjbAgjCnSjCwNWgVlnUamtsAqHAEe3JrFZKD9RN3b0I
	L0Z/JuoWUkWV0aMolWayG/v4zXVzsf8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-LgLMP58dN6eUnooUYBo-6g-1; Wed, 03 Dec 2025 14:07:32 -0500
X-MC-Unique: LgLMP58dN6eUnooUYBo-6g-1
X-Mimecast-MFC-AGG-ID: LgLMP58dN6eUnooUYBo-6g_1764788851
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-477a11d9e67so475405e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764788851; x=1765393651; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
        b=QcXwaOLj0PnvSuAcnc05BJF3d3fGVeYuNeh8RUsz3MY//RxwEw9S4Q4YLPNPYz7h0H
         GnoDQrFLlTt5R1XZFdmQaTw3IApmiHkR9a7c2lRyfVXaKfHNCGBEINdRwpyDe3qKnx7b
         +Zrd94772G1Ew5nnftvVnM5H9YzbcEuxamlIaD3dUeU2/+cEDIZsjvPzwjpu877MpX72
         O7UJZRX+yVspCIa+iSTDauyCe7Xrs/Cz9y38IL3JewQxaOd1qaJXgRyORT0F7unNoJ3M
         zft3CChW1EyIGF+BQMbsqJThCHiI9qPwxhUIRMgg0kBnyQGox+zsQkzsewhSdhuet6Vh
         ybdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764788851; x=1765393651;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=myd2cb6jiJMWmrBGk1+ROJ1AXszUUq3lTteTMN3MqJE=;
        b=kWmL1DiJmN9fJ4aNTEYshRwLHZTSwsP5iD37T+LqQU+u//0dLf7Mt3YBRD2gbVHUKy
         TaIb2qlkU+ewpPzZsdJfAZtwkNSVSmRYvbfIQxfGQb4Z+eqEsNaH9+sszOVxoVqNRnoQ
         szKm6bGOHXgiq5hxo0mQC12mfZs5Oz+DiuZ22d+JBKaCZEsgx979sB2nLmWS+OUFZicg
         ikhOTh8XrPw7/FUR9D9jpjSnvxub6+CvXsWovNEuV7Vu7cl6dtFavGvzK2Yay+A5Ex7S
         wdjLxN8C13kcG+xKg1EnRDezPmZyQM0ufHyCUJiCjlhiNshD9tUnUwctg2MKykQGRONb
         veBw==
X-Gm-Message-State: AOJu0YyvUTSED1s373YpVejsJXqj5Oaa0z/UfuMvsQTPuU1d1N2DGgjv
	jTjWdMku8cQSePc5oElUgdLJYqM8tqnSPtAlCDtdKBuPC84B5/MjPx2171Jl/Q43FtZD/zmR/X1
	3yKmoXB+BWtK3Dz0JF87qPyk2Ca7WJAk1o5gOoDUwsX0lC5Zo8DrV2+bxd13gCRzfvkuP/b4n6F
	wKNQ9B9T9ftRyreNyjykM1Y560oLSHDggaORm3QqWyPgxU
X-Gm-Gg: ASbGncv+ynf8/8lrVjQ+iRXUcyEmlDv/nfimUDOA9aZWHwjhHWXII3OsQUFWzwCGCZ+
	8SpfSHcTNpX2tDYB8Lue0s1Mdk8siTZHKZIlhKX34kqS5/MXZG5ME8BUwWfrAUQQn6iBDThg4yO
	DKodMgs0MEWKQ+DAznfo5gPm7LflGP0ZnZGyb3i4JwnUyWDuvRYaRZzpvWjVgDe+sqRE63HKN12
	kJQU6M1YCg3j3X8QtGHqGDMzR/hJpd0vgm5aizTLsN0KIeoRDjqtDwbgsCXrixAl6YeYYnbaAD2
	1R3GzeA013R5imjlNsKK/w3pXYdrshaWI5fMycmZM+UZEwxFhoEG+aaz/ZmbDtZ+5FscMaXv6dA
	=
X-Received: by 2002:a05:600c:4f41:b0:477:8b77:155f with SMTP id 5b1f17b1804b1-4792aee3719mr34084855e9.8.1764788850958;
        Wed, 03 Dec 2025 11:07:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXoLTZOJTGG975zY05/nwIE8Zg+Ji06Znxs/SZJvHqCYddlkDwOHHlifZX/IWWvOHMw9aR1w==
X-Received: by 2002:a05:600c:4f41:b0:477:8b77:155f with SMTP id 5b1f17b1804b1-4792aee3719mr34084495e9.8.1764788850458;
        Wed, 03 Dec 2025 11:07:30 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a8d37aesm62849805e9.15.2025.12.03.11.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:07:29 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:07:29 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 9/33] xfs: remove the xfs_efi_log_format_32_t typedef
Message-ID: <g7iiqsmk5cal2s6ef32yy5ee36yggfyaozgzyfwq7leum53xbh@jznm2ajkfyxw>
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

Source kernel commit: 68c9f8444ae930343a2c900cb909825bc8f7304a

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libxfs/xfs_log_format.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index 81c84c8a66..75cc8b9be5 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -649,13 +649,13 @@
 			nr * sizeof(struct xfs_extent);
 }
 
-typedef struct xfs_efi_log_format_32 {
+struct xfs_efi_log_format_32 {
 	uint16_t		efi_type;	/* efi log item type */
 	uint16_t		efi_size;	/* size of this item */
 	uint32_t		efi_nextents;	/* # extents to free */
 	uint64_t		efi_id;		/* efi identifier */
 	struct xfs_extent_32	efi_extents[];	/* array of extents to free */
-} __attribute__((packed)) xfs_efi_log_format_32_t;
+} __attribute__((packed));
 
 static inline size_t
 xfs_efi_log_format32_sizeof(

-- 
- Andrey

