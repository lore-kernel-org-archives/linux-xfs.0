Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761E42F1FD3
	for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767206790; cv=none; b=X0zm6N1lO5ceG6wcyFByh/e7Rwh7PIEJn9b1tUiqwma9KZlH11JUWg0jSDIVaCfwtjaLeWnqTcatG/uAoixdeZ61UFk4QeMqMGhfdUj4NvP+SVDV5PaOKsxGt1esf8QAgkyU3Nyspzw59gCRrn1HRC10gn34K8AwjQvZJOMPI7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767206790; c=relaxed/simple;
	bh=FUUPf8P2gy6AfTGvgSEut/D50AGb2LN/8jOvl5/hOmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XP0S0y0XbDSvecA4aJV5bGN5g92b91al5xJ2ATqcWfmWigdcgHRCs3yt9NYmwebXE2YnRkefq/NJC8XRB8UFuc9gSDyblzBWVw4npWOXIMgnSNhLp8QkXv/gxnDvasjl7V5NxrYIM2VPrd2kulib0GTQRijnTUtOA0Jff7RZnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eDJF2Y0o; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kPSzF4Pc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eDJF2Y0o";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kPSzF4Pc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767206787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vlla47aoLrcDYDSY4BpG3tEXVHnjclwu0RsmzL7mzWQ=;
	b=eDJF2Y0oAo15iDTCfqRzFEvvNkSdjzKpFpUuZ7kQdwTt0qG5yrESDW/FfRMdyNxhUD0IoF
	A6yqf/hE+zpQrEmsUBMWZeDtZJ4/qdHpQItGGhm3tUMeRTpuDJuZxMcCFtVVa1FQnV0ZNw
	jJKXdbi4XqeePTC6HuAEN+c1qEYZxK8=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-FCG2LH6HMcGuIQgDpAuBVQ-1; Wed, 31 Dec 2025 13:46:25 -0500
X-MC-Unique: FCG2LH6HMcGuIQgDpAuBVQ-1
X-Mimecast-MFC-AGG-ID: FCG2LH6HMcGuIQgDpAuBVQ_1767206784
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-7b80de683efso20292891b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 31 Dec 2025 10:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767206784; x=1767811584; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vlla47aoLrcDYDSY4BpG3tEXVHnjclwu0RsmzL7mzWQ=;
        b=kPSzF4PckFqlK36WK1SOUBBOxquIoBvFmQIN8fZqgK8aeyqYCfOdOENroZiLI98FmD
         FyClLc81r2qjzFofVnl3bFvBDHZ1i+CFOJU2YvjV/Z/pqt/EDaERgyLhbn5IrC21mqp4
         k5pLTmDolB2caWX2VInP9K+XB1z3sup8xyEYzV7flHSSFvq+wBfM5njJq6Xxu8AlP0fi
         IdZWSoGt4Zbzk6+nGw3Mw9H3HIgN7OELWAt2aOwU+OtwimybBRtYqaBh/SLUW6n6GO5D
         IE6x0Rr6I3/xd6GztOGnhMkzGYrhLHc5pgG3Uprn09pux1HRJmoY9WV/KrlbHKncE5GF
         YA5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767206784; x=1767811584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vlla47aoLrcDYDSY4BpG3tEXVHnjclwu0RsmzL7mzWQ=;
        b=HYCmWr2eAbHo943j2K8EyctbP/tqv26xZocvx5XnRpt77rB4rebykSe/GeQpNAvN6D
         ddGEhlWlWI+6U8Iy/SHfMRz5L/D2p509xid2l0zQTE9N4SzM5hbVCwPKd9lQRnD24uUQ
         19NoFeiLTA5Ygitl0tywQSykTcqPXQzGplBOx33YSYolBjry8W4KFbl0e5MmSvAMGTnZ
         q8mCcYD6DXzRrKMDGcRNTUoxgnM2a0hdAnyFa6EeWfbjU+HeR/1k7qPMWgxVvy7uKzSG
         /5e+5f5R/KsRpYmjDs56/3RlSpbjliqbcaFB6PFR5/VFwWwyrC8vFfsIe/GEKU79zzJ5
         +UtA==
X-Forwarded-Encrypted: i=1; AJvYcCXx7yVj1lOWOJVACEh2A0UJabs+28iOG0BElvhQU36gqtixszOVnR6zwAjlOsi9ebZuVYoa9OaeOjM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3LVy4fjlAomoW1OKB1eVqH2UOaBF3PXNJp6X5D19Qr8RoKA7V
	cVWZuuo+3T6tAME2VIGlDDBJgZYiVpYH1MkUWRt3zTBwV4FNweevEw2znbC73R6dvnocyypOanX
	bPeuh35FckRHflYyOQol2ZPDG46peLeumwTnZ//5AL8eI603VYx3lNFQCgZWP8A==
X-Gm-Gg: AY/fxX7k4LzQWHJ7r73TRjVTkP6JSXD6/iI66Be8bYt1FZPd7DAKgzjrWfGCGm+XMb6
	jMWyPqj/v1sni7us6W/EX774tFEx5VOq03yMuz/MzIHexQtnmzadrnlzyfMqRYgKmsne5AUkpLu
	reT0nVRh/QXp3HkpoINCxA29/0DO8FECHoO1fzwv1PGVaJnY0vgtBsQ+2dCJUi6gHMeKOCD4wF7
	zcHSMs/tiBtuWKIN9wi/RDycxa+bLH9V6mwOuw16N3D5qww11J0oPoVAKIFCiG3j/63pmPQQ/MC
	ChCfcVnFJAYBELluWcx6SBY6SaYBz5U8UMEMl9MbNL8dmuvAYGPSB3zckkHyN3BN8+OqkAoTtNE
	RqURjRQGLN21XcPQFnODJPuyH5WtFlSlfAll9mtWhcRx2+S3EWA==
X-Received: by 2002:a05:6a20:3c8f:b0:366:14ac:e20f with SMTP id adf61e73a8af0-376aaff1da6mr34738970637.77.1767206783755;
        Wed, 31 Dec 2025 10:46:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMrTlUistPjfFysJnldiS5PO8w2FC+NyZPv9Rma3Q+vU3A+h1qDnobsntt4ae2SIRL2aZ62g==
X-Received: by 2002:a05:6a20:3c8f:b0:366:14ac:e20f with SMTP id adf61e73a8af0-376aaff1da6mr34738950637.77.1767206783308;
        Wed, 31 Dec 2025 10:46:23 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7961fbb9sm30838452a12.2.2025.12.31.10.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Dec 2025 10:46:22 -0800 (PST)
Date: Thu, 1 Jan 2026 02:46:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: cem@kernel.org
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] punch-alternating: prevent punching all extents
Message-ID: <20251231184618.qpl2d32gth4ajcsp@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251221102500.37388-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221102500.37388-1-cem@kernel.org>

On Sun, Dec 21, 2025 at 11:24:50AM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> If by any chance the punch size is >= the interval, we end up punching
> everything, zeroing out the file.
> 
> As this is not a tool to dealloc the whole file, so force the user to
> pass a configuration that won't cause it to happen.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  src/punch-alternating.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/src/punch-alternating.c b/src/punch-alternating.c
> index d2bb4b6a2276..c555b48d8591 100644
> --- a/src/punch-alternating.c
> +++ b/src/punch-alternating.c
> @@ -88,6 +88,11 @@ int main(int argc, char *argv[])
>  		usage(argv[0]);
>  	}
>  
> +	if (size >= interval) {
> +		printf("Interval must be > size\n");
> +		usage(argv[0]);
> +	}

OK, I don't mind adding this checking. May I ask which test case hit this
"size >= interval" issue when you ran your test?

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
>  	if (optind != argc - 1)
>  		usage(argv[0]);
>  
> -- 
> 2.52.0
> 

