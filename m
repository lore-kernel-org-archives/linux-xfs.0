Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05AC32E134
	for <linux-xfs@vger.kernel.org>; Wed,  3 Dec 2025 19:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764789023; cv=none; b=pxNMHbE3KeB/GV/crcKerk+VR3a7OU39iAVGm5bsiLp+A/KOKg6dXqTfm/2sK1x1zlTfW96nByZ2Bs9rOFUEIIXm+pQ7NWwFTldu5OJWPpzv+m6ifU43sq6en1hJpHRKXsN1nSYprSVnKSWmgZdG2J2+lIGaG0WRC+vFMVJdIj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764789023; c=relaxed/simple;
	bh=HCGc+jyBaTo2k4m6E8HaTGJOrT0q6UuYwZZEaeRxO0Y=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G37dNWmJx/xFpHMN0nX1mDe8p6Mx4k6ktNwpb4usgINpKr9hMPPhY32UExOuxsgzuddiHAOcgsDlhpGUGDdJw8vnM4We4RCMFt9C3MTArbyYHiAIN7NJUsabC+Kj8G9IYEOCoOnr7SHWuP1VsOv6QVdBUCzHwLKNA5KjqWA7kb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UeW1n+e5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mVk6KBh4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UeW1n+e5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mVk6KBh4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764789019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
	b=UeW1n+e5XO2wlhw2eej80PEeNMIhgTI9f4JsZNG5rcfdOOMZd4Iece8ohQ0eOAPGFdCMBC
	oltOHu+XdZw8wFxVV1YGu/Xws7gTYqp0JSsBrDz1exgCA991USPFAIbo9k7DSxoZGQwqC1
	MNKP3yMNtGoWByRI0KTLbtFbZJaWyLU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-hfFZ8jU3Oeq8n8BIcIEp8A-1; Wed, 03 Dec 2025 14:10:18 -0500
X-MC-Unique: hfFZ8jU3Oeq8n8BIcIEp8A-1
X-Mimecast-MFC-AGG-ID: hfFZ8jU3Oeq8n8BIcIEp8A_1764789017
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47788165c97so555205e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 Dec 2025 11:10:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764789017; x=1765393817; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
        b=mVk6KBh4Olia7rDT8S0p/Z9AHWFuGVx2uGxudb8O7A9lZl91BJ0EP8fcdbCWAoBwcO
         yBZQACo2GlFGng9cR0dv3LyZygCIN9tKtxuVoB4TgKG3Jf1rJDiOhyubZwQTG1eU8U43
         26j7aHyTPbb6g5VoSOUMwWKLNCNhGX2am3ZCDvAwlpH6T90hx50m1kg722b07uk1oVzz
         oMSCZ0jq3HNz3W+pL35psPnweUwEBTpPdaq9jcQgVdoPAGDGqfjPIFIVStC735ANAWxn
         UPDQwOvtxZrvV85BnhFgFStvfkdjGQQngnYC4McoZSAF1FNglhGfXt9Ajnu6uvVYugD6
         Tviw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764789017; x=1765393817;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
        b=GhMUAYKxKFnR6B9EGH7Xo6oV6IAttRgYIHnswWlkUgju2KLD0gEA5hYJFJLnyfHp94
         5u7juj6G+g0FRL6w7GEXC33XlJ0cSbyZFnuxjWfZw+fEaCpc4Rt79oniyABzfoIXavB0
         kHntr1V/0JMzXIiTorAr5c7YESwhEs3p/XZldqmX5pnJgh5DKI4iYoyf7r1SmWT2o9KS
         ozk02tIrdwahSIEQKSZyqVRev8FCYW6SEij4rnTmyqJ3kVT2E1MC3U3XbBIhMErsfnYM
         NcJyF066G61LiXx0yjMHq3IJr7nP/Ev/CuFe7bgB8yKAd+TspyNBR21YwiG3B9dXWvIt
         EfZQ==
X-Gm-Message-State: AOJu0YzFasuMqMKY0q9KLjjuAE+Hkr6QLj2aIEAQsXJPuVJ8RUUobo7I
	fGJwHREnX4yoi8DpX/spC6EupMRV4XeeRTy0ThzEXRAb+jsNGcjn91s+wbIp/vPQo2QFGpMTTQW
	cDaDo+REzYJB69ZvWYLh2vRMoF99i1OjvBgX4C/0dm5wyL/6Hhd98swuu1+WGUcsWGMKFZnDwbR
	GlDB0Rl1VVv6z7SZWhRJ9nIxw/Dv+P4FDRbotP6z/1/KF0
X-Gm-Gg: ASbGncskeylL/7QoHaHro0HG5L4cre/D4QmvfQ5BQDV6uZQskNV/oOsXCva4MQpDnwM
	34bimKNJGwY8HRwC/wLhQvWBijI42H6KYUNwhSwjg/NKqGIow0wxPjD+QWAReRdyxDACgr/AWO0
	7PxXBuZ+G/qq24FGnEm0msjjIozCcCrhmLt/pzeeoGTFHZbVwHjY2PiW4lvtaAp63fwcvWyE0LV
	LlyJAZVdQBDhh3/xeAC9rsN6XjVdrW2kAyXAi+iQozzOmpwmc2eSNgzT3XhXbixsFJ0JLgLnwYc
	Ppjm7CWS2L6FbNhITxdMrEWZLwUPq7dj3rR75IZfgay+0FObxqdTrhJsIxVpLbaHIWNuhhnIPuE
	=
X-Received: by 2002:a05:600c:310c:b0:477:7b9a:bb0a with SMTP id 5b1f17b1804b1-4792af34a44mr33879055e9.21.1764789016546;
        Wed, 03 Dec 2025 11:10:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLw+wro5o+uDuWwdUGHXQEhyAhaOpboaXGO2cI29cg1LHRIelSpTHKd6whbWluEaeWCbec/A==
X-Received: by 2002:a05:600c:310c:b0:477:7b9a:bb0a with SMTP id 5b1f17b1804b1-4792af34a44mr33878615e9.21.1764789015963;
        Wed, 03 Dec 2025 11:10:15 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a8d37aesm62953125e9.15.2025.12.03.11.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 11:10:15 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 3 Dec 2025 20:10:15 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH 26/33] xfs: convert xfs_log_iovec_t typedef to struct
Message-ID: <blapsqd6z3z52i27sjjybhl3hs6krh4yxnoyqrvxfpi4no2hyv@23xuka5jgucm>
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
 libxlog/xfs_log_recover.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 83d12df656..3e7bbf08af 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1112,8 +1112,8 @@
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf = kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
-				    0);
+		item->ri_buf = kzalloc(
+			item->ri_total * sizeof(struct xfs_log_iovec), 0);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
 	/* Description region is ri_buf[0] */

-- 
- Andrey

