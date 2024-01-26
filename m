Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE49BA39
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706272706; cv=none; b=nMtn2zHpbq/EqF/298irwsM53xTNyMIG9L0Xa5AfFUlS07gShBWaj7nL4ngY4TLmFg4tR66KujPQ93rfAGTTiRVJ9YUkCy/2h36Iupr142eJ5BzhbmjhJ+zFL2At9aMktBMlfDa+DGjVS7ZE3bWfZs/gP/6aeJIf3LomrcjL0JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706272706; c=relaxed/simple;
	bh=/q3N+f/OD18jXpPq+chgFsXpSsttpD3ygV3epqchrKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tv5xh9WJFJG3pTJwrd69B1mmcRoeyi7sD9CBnnw4OkbnXCsPp1wHW4PdehxmDQJT4dKcQBWox5K3kMTeqLjFR16zLhuORfHBL2TwTKGvsw6ZkGopbsDUvkL3d9pvJe+asP4KSkmn7Jl012VyGhbXAn3ZMYHlynE3z+UpTFzVfPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eudoMuFE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eudoMuFE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706272703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FpXtWa/FbpyKoHWu9UKHP8n22Llt8QHnUvrPFjiZA/M=;
	b=eudoMuFE6jwIzx1k4/FVlgA4zZyuZJ5Y5KHmOtcxd0thpzrR2Mt9OLXkr62vdpk9WuP7Li
	4McSGQpOSIs+hcq4xTHmoH8IE8Jl5xw1XrcaZFRihgxINlPB9bOHuOOIa1QZ/7dO4bIEiG
	G+ghnD7PkWG/DiHFzvn84EZ2DvDNsHE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-rtpVwH2qOAWwhJGtoFNKtA-1; Fri, 26 Jan 2024 07:38:20 -0500
X-MC-Unique: rtpVwH2qOAWwhJGtoFNKtA-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a3260df549dso8028966b.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 04:38:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706272699; x=1706877499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpXtWa/FbpyKoHWu9UKHP8n22Llt8QHnUvrPFjiZA/M=;
        b=TiKM0defcoWTc59lUN9wLEOBViz/P6n/CqunF0aWwFZpi5lP/uAA3/RwVlYYvXNlXQ
         XVcbyGHLVIgWoH/dEBl+6kGXDFlI1bVw2HLtxa4CyCaxjXT6RHHwQUUHL1tPm/LAfcm8
         hE+tPWSlyzH43b39PgDE7kZ0D8ZmXTNwGx0IvBaESgf8LURKHM7CnX23WWIFEwB39QxE
         8jucDH101vRsTdOqa5w5WrpKyhJmtGtbKZS6xJDk53RRbYMJ08eZ0Um5EBk22q3m6MhJ
         RPjk0VbRdMRL6XvAkAipBg+tnaeFvIu42HjUAV0e/Gtto0TWU6LGFBBOzcmc9VPisHoo
         jHiw==
X-Gm-Message-State: AOJu0YxqNVwqJ5ojn1Hpa6x8uq+IDrWBzTu20iKXtD6nKouTOoDR+/JW
	hbD9CtRibP8dOc3btXWA/BX8mUtENe2cgLvHlPcsaiZVvYezCVczseKqi0dxuAbEEKzXxe2Qlwa
	v0KRBjejCb241EhhuVzxN8eovllBgD+o6CtMcVFQLlEdF/8+A56qVzCDh
X-Received: by 2002:a17:906:68d8:b0:a2d:52dc:1841 with SMTP id y24-20020a17090668d800b00a2d52dc1841mr535543ejr.18.1706272699806;
        Fri, 26 Jan 2024 04:38:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEhUY1JUv7jiHgxMfx06oU/jmhOZo7rXSEL5a6svFyU0TVPHlLZldd7m1QCMRtwJS7HjGKmFA==
X-Received: by 2002:a17:906:68d8:b0:a2d:52dc:1841 with SMTP id y24-20020a17090668d800b00a2d52dc1841mr535541ejr.18.1706272699470;
        Fri, 26 Jan 2024 04:38:19 -0800 (PST)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id i9-20020a170906264900b00a34a0163ee7sm579868ejc.205.2024.01.26.04.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jan 2024 04:38:19 -0800 (PST)
Date: Fri, 26 Jan 2024 13:38:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org
Subject: Re: [PATCH 10/10] xfs/122: fix for xfs_attr_shortform removal in 6.8
Message-ID: <rnmqtpiatzcj6ysi5ivz2tbylbu3f6q5lblnot226m3tgoiso3@kfye2yeryfn7>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924507.3283496.17636943697618850238.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924507.3283496.17636943697618850238.stgit@frogsfrogsfrogs>

On 2024-01-25 11:06:35, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The xfs_attr_shortform struct (with multiple flexarrays) was removed in
> 6.8.  Check the two surviving structures (the attr sf header and entry)
> instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/122.out |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/tests/xfs/122.out b/tests/xfs/122.out
> index 89f7b735b0..067a0ec76b 100644
> --- a/tests/xfs/122.out
> +++ b/tests/xfs/122.out
> @@ -62,6 +62,8 @@ sizeof(struct xfs_agfl) = 36
>  sizeof(struct xfs_attr3_leaf_hdr) = 80
>  sizeof(struct xfs_attr3_leafblock) = 88
>  sizeof(struct xfs_attr3_rmt_hdr) = 56
> +sizeof(struct xfs_attr_sf_entry) = 3
> +sizeof(struct xfs_attr_sf_hdr) = 4
>  sizeof(struct xfs_attr_shortform) = 8
>  sizeof(struct xfs_attrd_log_format) = 16
>  sizeof(struct xfs_attri_log_format) = 40
> 
> 

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

