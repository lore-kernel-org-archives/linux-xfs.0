Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A15328B43
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947009; cv=none; b=scc3kYPaQFRLYA6agRywCOwDEXj41+QxC0d0Liw4y0sAkK3FFDWMItS+RXAOQPnRFIRxC8Fv+0en0fookbhyO92PncyhK01x+kokMdItMKeIS5d9F5bYPqj/cBmKKW1ilWd9nGDxiZkHsJVWqK18YnF/fBOlt1K7GueHTXKmqzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947009; c=relaxed/simple;
	bh=ScEO7wfgnfLBfS0FBQohNs8DYo0U/reczMR/5SuKeNU=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gx/EW+cVPqL+yJ9ihkvpdGZ/AAMXSkGKPUuDdRKaXQH2LS6tRCy5tlaE1i2B4Wi853lH7cm6r1Tk9ETWDjTHkQqy/5qaXzq3R1jfMNz9BuNoIkT08GpCKeLoU0CFSVjcePC93GI/W91a0cf52E5cJmFY2xROhQMvX9eWOVFTjOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H6mJG1Al; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZkFSmWAj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H6mJG1Al";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZkFSmWAj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
	b=H6mJG1Al8I0GraZQIQMvFOLnDqeSQaIp5i6Rsoz5W+fTAHNKGRkBkZCu4fxTlktp5OD0rk
	a2Nb7kJ50DZi534uZd4TKU9d5SlysInnrY6EgDa3iVfbcQw+/IfkO3ZYk2wxr0KAt/QpWF
	xyD9Fh9oAXDcrDAtZOQmX2Kv6r7xXwU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-5YQ6CLDOPD-ZQ97pfnq6HQ-1; Fri, 05 Dec 2025 10:03:23 -0500
X-MC-Unique: 5YQ6CLDOPD-ZQ97pfnq6HQ-1
X-Mimecast-MFC-AGG-ID: 5YQ6CLDOPD-ZQ97pfnq6HQ_1764947002
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779981523fso16355935e9.2
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947002; x=1765551802; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
        b=ZkFSmWAj53Cd2DBTMYrPsaIiQ801Fnb0KR1GjIrovipeGOft4Ht1FyVMvVaFtRprOM
         zPJsqUPp1K96Ef1EeD5gVLHptiYoB1ByqhpWQJUodg2Gem+l9Z1zUwokrhrmJ9zbaFSz
         VEjrlNUuS2YLP6OIXDH9+LrgUd7yoGcZZFzKDeEgWR+t5Mu/+xtTnmJA8wXJugkXxTpV
         +qrcGaLC91it9sGTqtoa0buQBZR/K0QL/ktH+QPcthnLxCLOkRjVRrMaJwKJQAu1xCo0
         UF4f0UIzu/m5rLc0rGpNGKKJpzGhqkios2ixEgaA2tgjq11wzQtT5U0PT7sPyuL7LCCI
         MyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947002; x=1765551802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fFueDBUjtUwwyZm6JPF2ilU5dT5f4VsSY549X6J8OF8=;
        b=oRLXPM5z+nb49nZXfi64IATN3tuLRd+lAN4aqPP8pvtCEVLqqCtnGlPk4HmF+Vq1e5
         aKq2qQR1V+eo9D+tHMG7fOy6XnIvcSv8vHicSHy6KTclyzHMGlhZubqahX6dQJZFVfR9
         9N132IiyGiT/ApTDIPtBQJsDqzJMwMpyJrdr3P/INjlUeKZM5qBMv59yHBngjzXJD5ug
         zpzrwyFF9e9dmfmNRoPQIj3oIC8wUIKZnn6I55S0Fzuk/4fhCGwsy7BqjGyB0u0AGExQ
         S1LpUJhBznJrz6sEEVh2TYRlKmUZZMHKeU0cB6NwN8lef30+8f+PZsuVWgNw59sipK44
         6HUw==
X-Gm-Message-State: AOJu0YwKHEPX6xbG6sfpPiQG1QNPqY8pbnE0TBMlz9G1KWF+8xNCofZ2
	iwQhW6ylLeOGGiZHpv+mT9h9a0RbhcF12UsqrCX+TJVOFaNIFxmst/+4O5mhEVUWgMgsqf2CEB+
	uzpie6Mt/w3ctrb4UIZn2lVnfG9e8N+9P5eKxzDdbEGnLXsjrt4VzJ2cO0xWMZvk+xKpBQbe9Zc
	x4jgX3HTL826oC7nPi0a6xgzle7L++UCxGKLdgCh1zQ/3C
X-Gm-Gg: ASbGncshF7eKX5e2lnPLZ+S2iKXi0E8wB0++KSZwqhQ/cO6v8njuhEfGJ0b1yeIXCu2
	Kc/VGC65LqWUWBjtMckTKd405LuSwsPo5V5aZIOWcBPI8vfLVohMSl5U9ozxz1pkIrzlTtUG9t+
	veOkH6X4vZ7PULFcmk7cocKLcPXGCHqRvTPwJSPS6wWo3TriJKYv/jhff7Veay0HRqA2A50TDdn
	Ha6+sGiit8M1ykF+XU9zAjYtPtK1RJnb/Cr6ClurYsm9hOkoXPoubk8MnT0cwwNLTfLX+2lk21n
	xxfU76jaXy16YObhZC8xh7LClJZd+fPgYryN7BGM9upNIFCyKe/XkzEYwdd8ky+SeMPDy4ufS8Y
	=
X-Received: by 2002:a05:600c:3152:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4792af3dedfmr94261685e9.23.1764947001384;
        Fri, 05 Dec 2025 07:03:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGS+u32eyppYu4SNE5OFvUF39Wmemtxu0wGdVzdGnvixmtf509PgUGysj76NIC5YK/FGwIyIA==
X-Received: by 2002:a05:600c:3152:b0:475:dae5:d972 with SMTP id 5b1f17b1804b1-4792af3dedfmr94261215e9.23.1764947000790;
        Fri, 05 Dec 2025 07:03:20 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479310a6d9dsm87303305e9.2.2025.12.05.07.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:03:20 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:03:19 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 22/33] xfs: remove the xfs_efd_log_format_t typedef
Message-ID: <q5outzz2qbolwdsy7pnyfzr6lg5wimclzey3smob3bzkrmnafp@jvm3hbrzuswi>
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

Source kernel commit: 0a33d5ad8a46d1f63174d2684b1d743bd6090554

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
index 358f7cb43b..cb63bb156d 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -686,13 +686,13 @@
  * log.  The efd_extents array is a variable size array whose
  * size is given by efd_nextents;
  */
-typedef struct xfs_efd_log_format {
+struct xfs_efd_log_format {
 	uint16_t		efd_type;	/* efd log item type */
 	uint16_t		efd_size;	/* size of this item */
 	uint32_t		efd_nextents;	/* # of extents freed */
 	uint64_t		efd_efi_id;	/* id of corresponding efi */
 	struct xfs_extent	efd_extents[];	/* array of extents freed */
-} xfs_efd_log_format_t;
+};
 
 static inline size_t
 xfs_efd_log_format_sizeof(

-- 
- Andrey

