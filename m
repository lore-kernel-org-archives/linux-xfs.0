Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35E319924D
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740386227; cv=none; b=hIpgt6vt8k651m6rkbVAuDCK/+/xR5BiM/pYSxEOiTF2sC2L40seJUEKFQTs9+ThvVtY/uS0hAExv/m2twINWVDloDyZLRNx10gjQmFaCCFmUSnazgW7Rj51pU5hGhEGBvTl7z3PZcG9I3sXvuxM/smuzVAGeykJX1JPK8+2xoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740386227; c=relaxed/simple;
	bh=6BjLN1GlYR2U5FpYiT+rWIggCJzI/tHDmlFAFxj0/Uo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DK0rFrsczS47R8A/ByOWzsabqojP6lpkW+riVB6dB9+2hkVajFH1cVGzmXKEQqMKaY3UiPGozmZKAtvSw3iyzeWBJ2XAOgcSfDiwnzHSJBiLlSYg2BhYv/IydiR5nnsBmNqNh2kV6n+KJ8senPBfTPOSmp0KdkDuErP1JnAO+mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W2kwE+9c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2kwE+9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740386224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uheJ2z2UvYGGB4pmLDscNMyR1jHpdE5GSYp0heuQuMg=;
	b=W2kwE+9cu/XqFwy6pU7vXMncQYjcBISQLpaWfoKFgt9QQK1NtZPD8mIKNZ8KUmcXtK30xq
	P8zMVX6snmMii6OlcfYXZx/jlI3TwscjG6mfmhJnnRqVPkpmP3EwkxSHdTSVMMqXWqPZlj
	rjcfNkfvEchGX1Z7JvedBvk72r1zvAI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-S5ZzEX7rP_S60V9JT0Wtlw-1; Mon, 24 Feb 2025 03:37:02 -0500
X-MC-Unique: S5ZzEX7rP_S60V9JT0Wtlw-1
X-Mimecast-MFC-AGG-ID: S5ZzEX7rP_S60V9JT0Wtlw_1740386222
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-abb8e0944bfso481022466b.0
        for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 00:37:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740386221; x=1740991021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uheJ2z2UvYGGB4pmLDscNMyR1jHpdE5GSYp0heuQuMg=;
        b=MBZufZ6kX4KsJurVhNv5YFbAD4baTfil2rDMgthVG2zLuKfclebE0/RULHRM9iU6ss
         4FIU7lFqrh6x56Fg0vDMIk2aioTwqEGdpAfmCJqKgnK7g13c3FyNU8ZwrsKHWOaK/hCl
         LsIYgz3gdIS3ySLePs12W//Ic/XbBlnOU4kRJKPGctlANK6n/9ZtPLHDURwBgyLzdzY8
         SUVVzpTu2rBUUCZQ9MenDqnPewLNjgZmpnQT4jEyL1qCacDgm9O3A3ip91Un1MPdhPne
         bHessD4f2R1ajs8aAPkDrhjz21mVitSY+Q0fWKA4oUWekX8kQ0XP00oaXYzAk+x+/CLC
         7l9Q==
X-Gm-Message-State: AOJu0YxGf7v2R/Gbz0IwOaFvHV5lVt9SAmnhdZR+kyaMi2Roaliz+9Vd
	YMAtvQwamt4n3eFo9TcOYiLYGbYWt58KlkUL98UB371plCTGBTvLF39VwQZK2RiDsBA1wkmBQia
	t1T4DG7nAyvNsa6pNEkcp5VEqbW6uGdG+Ol9Quctrl0XGiztE5pUxdetmf9hiKGHZ
X-Gm-Gg: ASbGncu+RGxaWqhKsY3dINXuHbbkcfC4k0jwIs/Nn7CHn6VGxMCXVW0ZgZmbRHPWUQP
	Z4ASuwJPb42WCUoe9+s8FIgfRqeCbd4orBZ1uLxK4Z+ySa29zVTM7RYUNAO7Ie3jJIItTP/jB75
	jvqKV7e0pZ/AkHiSYXwbaDU/XbVZf/UEFmDKJlDgQoZ7PY0DrrdWEOZQkqITZ2jAqEqD6f9CPDC
	kaDgopIG45XHIdvpSneT2UTCdr7JGTNFTiD3bmc0yV95BB+oIze1bsP7wHcnm3gj9AyoFNtfmkd
	FZXLWKWK5hT297E0yMesPYjby3Q9O0FBvuQ=
X-Received: by 2002:a17:906:c0c9:b0:abe:c031:eea2 with SMTP id a640c23a62f3a-abec0322afbmr77509266b.24.1740386219811;
        Mon, 24 Feb 2025 00:36:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHIptUVCJJ4OhU37Or0+8zUbP4WydK+/Yowg7CzCxKk5lw1js/PoECFZWhRvmqTDCUGvWloSg==
X-Received: by 2002:a17:906:c0c9:b0:abe:c031:eea2 with SMTP id a640c23a62f3a-abec0322afbmr77507966b.24.1740386219421;
        Mon, 24 Feb 2025 00:36:59 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb86c9320csm1700628466b.55.2025.02.24.00.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2025 00:36:59 -0800 (PST)
Date: Mon, 24 Feb 2025 09:36:58 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>, hch@lst.de
Subject: Re: [PATCH] xfs_scrub: fix buffer overflow in string_escape
Message-ID: <gztj3j7tengp7coflm6fwblyh4perxfzygfbbw5oc4oichs2ew@rh7ixixulkdk>
References: <20250220220758.GT21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220220758.GT21808@frogsfrogsfrogs>

On 2025-02-20 14:07:58, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Need to allocate one more byte for the null terminator, just in case the
> /entire/ input string consists of non-printable bytes e.g. emoji.
> 
> Cc: <linux-xfs@vger.kernel.org> # v4.15.0
> Fixes: 396cd0223598bb ("xfs_scrub: warn about suspicious characters in directory/xattr names")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  scrub/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index 6eb3c026dc5ac9..7ea0277bc511ce 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -320,7 +320,7 @@ string_escape(
>  	char			*q;
>  	int			x;
>  
> -	str = malloc(strlen(in) * 4);
> +	str = malloc((strlen(in) * 4) + 1);
>  	if (!str)
>  		return NULL;
>  	for (p = in, q = str; *p != '\0'; p++) {
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

