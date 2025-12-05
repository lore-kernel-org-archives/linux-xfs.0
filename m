Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306232ED53
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764946931; cv=none; b=Ie0tyZFGKEcNG98NHlLTjCGv1Lbs7fLEe12GFIS8/X3KAVe9Vx68WSJHMKq5K21WxBhPYEXpGaIfbIoifYu5y5GlVIxY4fdi9RQjwgR9h4H9mRUkQa3ayDZmsJBbgOIVOqBNvft91RvzqrzZZzHwyFzScOtcNb4JkF/7Dm3ZlDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764946931; c=relaxed/simple;
	bh=HCGc+jyBaTo2k4m6E8HaTGJOrT0q6UuYwZZEaeRxO0Y=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rjt4nK3vZPtbsQQmB44j/AZKOrKJj7BmlEtyAFUnP5dvJr/n6s0j74bbcNrhgiDYhpf128GctMagfPMprKjuU3kbDYdKErL4pgIRpdcz0s9ZpZKWr7+LnWRCCYx6SEOW4F4V8a0sE4pv0Uwd/Ul3h1TQTyXYtXXVGTohmzpBqxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UC/qgXUm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=S///8XUT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UC/qgXUm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="S///8XUT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764946920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
	b=UC/qgXUmVOlTq242BOD8ZPxwrNHh3EvxkV1KK0NGncuKIVsX/UUBuCLKy3cmQR3Ozpdtcm
	O2sQELVB78Owi7jXJZYtlc10jzHO98O/jDoSeOwnPfhAMkZscxFprgQNa1cfeINNcBFB85
	noNuUUATVzVY9+NpRdHNAWgZmSa/+Qg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-177-rHCWpdVBMtS7vcL7YM5YfA-1; Fri, 05 Dec 2025 10:01:58 -0500
X-MC-Unique: rHCWpdVBMtS7vcL7YM5YfA-1
X-Mimecast-MFC-AGG-ID: rHCWpdVBMtS7vcL7YM5YfA_1764946918
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42b487cda00so1254915f8f.3
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764946917; x=1765551717; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
        b=S///8XUTmQx4yfVsWTYWg+iDsh8a0okQEcaRlUlOVetT4Tj7RvrGpV2+e24J6t3Opo
         e4aDeIeB3xLTl1aRIH50PwHsAoNyvBFkf8Qw5/mcXhol5qVyFgretrCqZ0IjOiR3qB5z
         U0OmRsrjLKQZSxYU8VIFXVqLuYXiH5ZxDlAf7GynIkLCTb2WGRYf52UvMW29M7w99z9J
         CX3LXifHGFu94/S81B92phOnZguQnVN1TBqPJZWDsr22l77kNM866b0ELgSlfEOe+hES
         YKTqvQrgiN4Ws5a8WRLBallj4M12Ts75rVDYjzSBBZlaeYIwEHOHxIh0u7mQMOjQKtub
         Fb0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764946917; x=1765551717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oVyEjDSIBaiL5PEBIKOWVWF/FzTrTtfHlD9Dc8oevOo=;
        b=wUVyCU+yqRx2R8FXZvDKnE+48H55kbh7AVTCR77z/nVTj45Pqp1e3Oo8aXl766QvgL
         y6/OnriF5/QNrRZu3I2G2rYbRWQVJHlWHW5n4k1RmYHlS16o9NvAg3AsOoINo8oUyx0Q
         +eFnIGDV1Ar5C5qtP5NyxP5PgY51mZklZxWJD8a6K8fkO+WsOhHku4GxhIjaVXQdPSEH
         JVlp5sLACu7XcBVqWv0KoMYfPkfZBecGSDJQSvl9XKHmF9DCFfFi1d6Yn55KKIhT+iNN
         UIPh5gg0XaiFw1A/ea6cgSjZjy+Z8NjYatJhFllNzK+juBIpX++tBoHg27KqJ92GmrKI
         vnxw==
X-Gm-Message-State: AOJu0Yw2n+z3D/KLZqajlcDmEbYbtQJ2viYtyjeLuSeIHDEkoeC97LIS
	iSby4QGUB3TPy93YL4g+ZUcb9+SOPBK+RNmyXKs2G8Dk3Fcm2ozlgb6XgH2Y1EGbYxbkY54j+1p
	CZtuIB3HHUuDR8XNLMB0rKt5MjGrnYCZo5sLZzEa7RRZfcWJDIGm/Z6wf43N5wY25Cr6onxpynB
	uuPxWR8VwILH3o+vSPVyNJKNoPqR1WFemTCtcAuXsgEFBK
X-Gm-Gg: ASbGncsDyGveLOYqcxr8EPGvdlvcsLYIO1PmkA5nyyN4PEO8FVpCnqA/hkUQXnOCV1e
	ddezb2sSIzIAHVOhmd0nI2WjfMufIRntlXbX2DDFAN0eKTDbCFJ+Kg85XcTEACP3g3m/R4QewUp
	lEKLFpEb0e5oG34IECg4e1t0yHojwSxSElI/IlSenLH3yB2jrZqbmmSuyXjF0jzNZ5qssP2AYZz
	37TipiReh5CmfDC87ordfhmK/fxgYe0VpOgMS3OTEUD1lm+B/4H1sefE01ks6FsrdKRMG2+6e13
	la1/XhjtYCFN38ucW8Etb2SA6aMADqmMAzp/TF+oohykQGVWwOutFrv7k/74DG8Cgvwa8lqxWok
	=
X-Received: by 2002:a05:6000:2dc4:b0:42b:41dc:1b60 with SMTP id ffacd0b85a97d-42f731a4d45mr10894170f8f.29.1764946916787;
        Fri, 05 Dec 2025 07:01:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFe9Zulz9CubOW5jPRArEyDziwKZFwTVasS/SlWcFfbnO3ZRosz4mwZ2rmrzpi67mUt0nMsRQ==
X-Received: by 2002:a05:6000:2dc4:b0:42b:41dc:1b60 with SMTP id ffacd0b85a97d-42f731a4d45mr10894114f8f.29.1764946916152;
        Fri, 05 Dec 2025 07:01:56 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe9065sm9205283f8f.8.2025.12.05.07.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:01:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Fri, 5 Dec 2025 16:01:55 +0100
To: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	hch@lst.de, preichl@redhat.com
Subject: [PATCH v2 6/33] xfs: convert xfs_log_iovec_t typedef to struct
Message-ID: <xjfd2yyn5fw7agajtnpwffuuo67nnzgb3slfxraujiy74xnjyx@x2dbbwobaavv>
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

