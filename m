Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00D4272E51
	for <linux-xfs@vger.kernel.org>; Sat, 22 Nov 2025 07:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797281; cv=none; b=IjkqeBw4DYrQk93bzk6EdizPgHmGp8EXT8N6ppIA3E1aDLC4KQ+D7Bwtd/l77H3KUDVI2ZSqM3ly1vd1Dxww3E3Jt9a2nyLdMr2+3q4TvheeXGD1+WlnGGyMhVjhMyzB9SnR1qBTkEjhStme70GnIjRd0MXFY2Izv3ZhcMQeRz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797281; c=relaxed/simple;
	bh=i5ISNR6vMM/F/kla/kmJr+XHj4sLn6qvyzzfnXmHaXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvMTuvbFh+W3s3LljSXtvZNYyEpPwYnfXo+V6nyOpNXPkekymFUl5e0c5/oNamy6sfY5VnrlKwJK9qPhwC4ZIwehtJ4IyKijmvK2pNTdNQ6CQFrPx6YckgfOdaqNzkcomgsZyXSX61f5MgGmdrKTNrlmPGCaDxf4LeCfOk6X4f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cHQbuKlV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdkHG4U8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cHQbuKlV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdkHG4U8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763797278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lzzkrYSefFSUe5bJI0RBijIkjMIBc7EYqbMfwC7QqQ=;
	b=cHQbuKlVaF8mbdP9MS8soAC0IW+oaUgLXunT2rbI5548qxNjVxmV/76iD1lNw0YRjKxTgL
	PBybbXLx21iBWuBjCKEPYblht61rTQl8chd7veQkJcOgnR3JEcsI3eWbR1uYsWR+ofhulv
	KgBnNvXWTuoTea4hfpjojK+zH4Nqwto=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-nFzFVnEPPeK5-YeqoZeBUg-1; Sat, 22 Nov 2025 02:41:16 -0500
X-MC-Unique: nFzFVnEPPeK5-YeqoZeBUg-1
X-Mimecast-MFC-AGG-ID: nFzFVnEPPeK5-YeqoZeBUg_1763797275
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-29557f43d56so37193915ad.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 23:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763797275; x=1764402075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lzzkrYSefFSUe5bJI0RBijIkjMIBc7EYqbMfwC7QqQ=;
        b=PdkHG4U8/PwaUULJIvS/p23vFfVrP32BYhbMH3//oNcD1IaFFs7NvAyoKYLH175RN8
         Z9ftzrrice2dUMArj5KbzPo0Z5cP4wh/UpppRN8GyhHL/CUDOuvOSvLCuqcheFOxmmjj
         jVTO2vQI1hbVslG+y7ewmn+DV+++UYBS5w6afZHaLI4bRWCqzA3Ng5cCvPaFUyK/t0xc
         2Wwf73b8DC1JLu4WZ9WVEkDPpQ1vVkhdmpJEWCMvil3xvF4HD2/BMFFN7wakmpwHZAKo
         AEDSdHLa4lXXlyarohvpY2UGz78hItXXzzm33KYgMeHCKg5GG9sDa4wDRI87MFrhBpfs
         rmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797275; x=1764402075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lzzkrYSefFSUe5bJI0RBijIkjMIBc7EYqbMfwC7QqQ=;
        b=p5S6NpO6Vhjho3S8BoehuM60/We1H26AOcjFk6hLQhjIoSUvz3J92Im0Qxjs/k7RGl
         hvDe2R9Vmg5mRNj0vr8Z3E/BOcH8zt10Gi6trGPKv2qe/jGtuP7YYdEBAw0b851ibmK8
         Yrl3jWRHB5yW5RS++f2QCUtZ+EqYxy2sWaZsvOtswcZLfZrAbzbXfBxm7kyE7neZwUtT
         42lksY3xx01U+ub12qER28x/r4wu+/RKLJEuR/7R6JeH7RgTCTL+f8EKLfVjzAoUfgs9
         FD7nlrJgjIESPFZbZ0MxWX1/W0XmGKvUorPYHZwpxwZB55gZMj8lwdYK7UlCxoLcleEV
         gPgA==
X-Forwarded-Encrypted: i=1; AJvYcCUSYDMrlZ1CSYQoqIQgXO7SiFhLPY1yKeadb5e9HE02UV7gwRjIIpR383VuxctEqFlCSYi6T8VtF7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNpLkUT+Abo4lodB7rw8d9QtL8GIoOA/uhp9nVk4yaK5GlIYn6
	Z6fpGxmr04w+TnB20LTsUdolK9exgd65XerirnVQSneLyG6TqLR9I7p8+edEQNfL7xWSMAKj319
	6IZp8oQjthH70sp4v7lUiL7lnvkMVAbphFUHiFCOdQ69MFykUzhToUG4guyX4Bw==
X-Gm-Gg: ASbGnctAsKVM6HSX2v+rbB+AXiB0BdCGosvlpdndXcv0GG04OoHlxufuJKiioGn5GzG
	XZURxO6md7qpBqVOFeEnnsPlAcR0olyxicO4MTsqfWTC3qB5KQyyMfPy5O5oSeyPleuz4X9urfk
	DIm17fO2LD/92JdR2MtE0qF2Tqlrys/oITnKU7coMej2HGUug4BvhkZJQ0pxnmYV3GPGBkjEiAd
	we+2HOX6rkvbo82Xhc6FbKqxdtFm50YrPYXS+kngIm0rMc2dx1IZJ2ZI6fo/p1moxYbhHqUfEvA
	7HJ2QqSZSyiTRFPfMOJxCwIWi9dgUqKvgkeRopX8UM/el6ecCGFjuhbSbgFXkbIHqDdJ3Hk13ql
	YJanQorBDILcRe6HVuSWCkFyswE4IotLp5HtVew9TPqN0YblhRQ==
X-Received: by 2002:a17:903:3c46:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-29b6bf3bdc4mr61786005ad.29.1763797274880;
        Fri, 21 Nov 2025 23:41:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGeQbPuHNYN4oOKN5LWmPMEd3/TkK5RwO8DF2irVXxmUm2vCXD3Fwsq79Vn2QYwDeataKTxwQ==
X-Received: by 2002:a17:903:3c46:b0:269:82a5:f9e9 with SMTP id d9443c01a7336-29b6bf3bdc4mr61785875ad.29.1763797274388;
        Fri, 21 Nov 2025 23:41:14 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b2a6b22sm76166955ad.86.2025.11.21.23.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:41:13 -0800 (PST)
Date: Sat, 22 Nov 2025 15:41:08 +0800
From: Zorro Lang <zlang@redhat.com>
To: cem@kernel.org
Cc: zlang@kernel.org, hch@lst.de, hans.holmberg@wdc.com,
	johannes.thumshirn@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/zoned: enable passing a custom capacity
Message-ID: <20251122074108.x4zenebioteynejq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120160901.63810-2-cem@kernel.org>

On Thu, Nov 20, 2025 at 05:08:29PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Extend _create_zloop() to accept a custom zone capacity.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  common/zoned | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/common/zoned b/common/zoned
> index 88b81de5db4d..51c011b247d2 100644
> --- a/common/zoned
> +++ b/common/zoned
> @@ -61,7 +61,7 @@ _find_next_zloop()
>  }
>  
>  # Create a zloop device
> -# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones>
> +# usage: _create_zloop <base_dir> <zone_size> <nr_conv_zones> <zone_capacity>

Actually from the logic of _create_zloop, these 4 arguments are optional, not
necessary, so the "<...>" should be "[...]"

>  _create_zloop()
>  {
>      local id="$(_find_next_zloop)"
> @@ -80,9 +80,13 @@ _create_zloop()
>          local conv_zones=",conv_zones=$3"
>      fi
>  
> +    if [ -n "$4" ]; then
> +	local zone_capacity=",zone_capacity_mb=$4"
> +    fi
> +
>      mkdir -p "$zloop_base/$id"
>  
> -    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones"
> +    local zloop_args="add id=$id,base_dir=$zloop_base$zone_size$conv_zones$zone_capacity"

If the "zone_capacity" isn't a new feature which need a _require_ helper to check
it's supported, then this patch looks good to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  
>      echo "$zloop_args" > /dev/zloop-control || \
>          _fail "cannot create zloop device"
> -- 
> 2.51.1
> 

