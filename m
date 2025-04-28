Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F79027A12F
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745857899; cv=none; b=kwN1kmcNosozb1zBBcpSv8PUVPJqDF4sNqd8uHzZD/VuxwTiAuxjdUWd7KDVpq6mz0Tn3VeWUD6nOjYd7E8J3lStA0YI5YOvYRIVIx06cBR16QXYx9daOJ50nHzFL1xZSjdyMuQpSGfpRhXDLm8aUY5tkxR2sDskZrd88QJXiIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745857899; c=relaxed/simple;
	bh=+WFWDmwFMy4aF0Vky922WLy0j+LFvgoW9VmkUblyuUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H32ppaUt4MwaPy8YUQ/Jm2qnmRWRJ8PfceqJy3kXTE2AWaEOInsHpMdZBUNlbuMCecE7DMfdzLjyfJD0l2u+CV10SSCbYQgCU96mN1XU9uHdK5YyUqBohs0+QINma2bVcXA+ytygd3lLjxDhlFPqDJshAPzCGo9LZBfwGmqZ58k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S87KHRHQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S87KHRHQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745857896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YU8xT7tWHxmpSUJmiha7eF4ZcFi3QWWLTIj9fD6FClg=;
	b=S87KHRHQ4CVd11Ceuooq5hcWW45G8GJkO7FP2aPHxnnK0m4lgqOCzwk4w373uQO3jYeiQ0
	iozcftLIvcvGBDjUGwV4VtFK/ojqajmVUsuwot1+JaZC6kOxDI3qUKYR9wIX1wAK+sDFYx
	pkrCai4BldkHiyGZLIjUlZyVvELjAhg=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-I889PuJyN9mlCcJBDxMGnA-1; Mon, 28 Apr 2025 12:31:34 -0400
X-MC-Unique: I889PuJyN9mlCcJBDxMGnA-1
X-Mimecast-MFC-AGG-ID: I889PuJyN9mlCcJBDxMGnA_1745857893
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ac297c7a0c2so314382066b.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 09:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745857893; x=1746462693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YU8xT7tWHxmpSUJmiha7eF4ZcFi3QWWLTIj9fD6FClg=;
        b=fACyWGy3ed84oJHE7N7vaqDvfzaqhyPnkI9TkeXzruxNqELy8boTap9hBpoeG0hjlk
         xoHb0OgrC5CN9YmnexCZCQBF1wE1BNwAonczts9Ivj+SXb/7A0ewpcbFAGPHqmQN/3t7
         ghPCezx7XRSzGoN5FfDLjHYcfh4F2yO21uctirpQoLg34EWS98HrBQoVUw00oR836QCn
         tsadZShdiqA+8ePp/MPtf2Ts/TjEODgd5LGrndMIj/mdatnEnhNj+dmhZgaZufOGTY0k
         MTOOEReFxvKxyhQwdhgsAmUZyMcVtqMGo2jPIaf/ljmiy7RsVe7FoqnNiTL4bLYFh6JU
         BnNw==
X-Forwarded-Encrypted: i=1; AJvYcCWd8IKys0PX7tqr76E3jT4lcbjfEra2E+/AmZCA+l9V4287FD91mvuskgtgvqCw5djTIR1MKuDuHS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxztsKlITntoN+jI5wLwh2G5rdbF5+1iFKrwTyG5e5dcHv3uRcT
	blhUyGV43tNLJhXbc1NFFs9xCCjVL5hqeOgzO3jH5HWBo/I0IjglQjlCsk12hwIG1udGsc8gmgc
	INz7/AZ6d6Ruc25sf/ulgqJrHe3URGRB5kyrRFiILg6ET8GwInffmXNs/
X-Gm-Gg: ASbGncvVMjeN14hWoJet7Pq64BB0SKX0NVwqL6OpZmpuzbGNAe+XUcxYjqda15lToUE
	NjXbbFZ2x6WfbxIzJpmuJ1Rv3qCyCrTDlMuky8oZZ1RZAGN8apxRXfD2/OYGHsQUaz3Zpv2bLll
	Qw8Xdn67mmBqtNxBpLoi7w0Zc0T3QoBZ6inGU+wqlKuAYgnKw8oiiCrTiRQISpUsfvvJu8EvYaT
	vQ75izwzPGKoqq9rTW6t8yvIsg+OOykyUaHx9oWlPXYfoC2NEUcMK6Kr4zGIDSbudOSaiFBEPP8
	8E+ckOTP5HD6vZGqGQpYvrUw0zqnRxA=
X-Received: by 2002:a17:907:9715:b0:ac8:1efc:b993 with SMTP id a640c23a62f3a-ace713998afmr1214570566b.44.1745857893331;
        Mon, 28 Apr 2025 09:31:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8HCUtCjJfl5k80DQZJwcqSXTdYEhsv63v05HWPaibR8rw0tZJKeJ3oXCxtF62nv9I7QXiCg==
X-Received: by 2002:a17:907:9715:b0:ac8:1efc:b993 with SMTP id a640c23a62f3a-ace713998afmr1214568466b.44.1745857892992;
        Mon, 28 Apr 2025 09:31:32 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6edb1abdsm659071066b.177.2025.04.28.09.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 09:31:32 -0700 (PDT)
Date: Mon, 28 Apr 2025 18:31:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 44/43] xfs_repair: fix libxfs abstraction mess
Message-ID: <2gfxawfqea2ruqhlupk62v5y74nhfn73bnhwu6seffhh7pdiol@ylqrdyc2bqkz>
References: <20250414053629.360672-1-hch@lst.de>
 <20250425154818.GP25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425154818.GP25675@frogsfrogsfrogs>

On 2025-04-25 08:48:18, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Do some xfs -> libxfs callsite conversions to shut up xfs/437.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  libxfs/libxfs_api_defs.h |    1 +
>  repair/zoned.c           |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
> index dcb5dec0a7abd2..c5fcb5e3229ae4 100644
> --- a/libxfs/libxfs_api_defs.h
> +++ b/libxfs/libxfs_api_defs.h
> @@ -407,6 +407,7 @@
>  #define xfs_verify_rgbno		libxfs_verify_rgbno
>  #define xfs_verify_rtbno		libxfs_verify_rtbno
>  #define xfs_zero_extent			libxfs_zero_extent
> +#define xfs_zone_validate		libxfs_zone_validate
>  
>  /* Please keep this list alphabetized. */
>  
> diff --git a/repair/zoned.c b/repair/zoned.c
> index 456076b9817d76..206b0158f95f84 100644
> --- a/repair/zoned.c
> +++ b/repair/zoned.c
> @@ -30,7 +30,7 @@ report_zones_cb(
>  	}
>  
>  	rgno = xfs_rtb_to_rgno(mp, zsbno);
> -	rtg = xfs_rtgroup_grab(mp, rgno);
> +	rtg = libxfs_rtgroup_grab(mp, rgno);
>  	if (!rtg) {
>  		do_error(_("realtime group not found for zone %u."), rgno);
>  		return;
> @@ -39,8 +39,8 @@ report_zones_cb(
>  	if (!rtg_rmap(rtg))
>  		do_warn(_("no rmap inode for zone %u."), rgno);
>  	else
> -		xfs_zone_validate(zone, rtg, &write_pointer);
> -	xfs_rtgroup_rele(rtg);
> +		libxfs_zone_validate(zone, rtg, &write_pointer);
> +	libxfs_rtgroup_rele(rtg);
>  }
>  
>  void
> 

LGTM
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

