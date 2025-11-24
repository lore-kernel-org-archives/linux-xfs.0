Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84ADB2DEA7A
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 09:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763976513; cv=none; b=Z2jnn1/jrBqKBpSV7husQXK2rNxNhApY17SxC5ICMYPbiNArGJ9g6OB6udYqjYEotQ8/a4pZ2pDeCuQ3FOVflkpPLvT21JqJvlWHKP5SBor8DNyU9HGD6HAVh0LtenZI3U798eZuMXBfl/vBpFAAonSmiZQo9HnY6rP7R/pK1To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763976513; c=relaxed/simple;
	bh=jyCpk8JVGNGaB2eHJvHTzAEMlQb949C7DkICahHRbuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q+Tw+N28pYu/AwIcu/HiVEzh1Do5HVOx+VlhKktXxps5DNRfbqLDgPX6PXciZxcUgpKmHvrj00NnlrS91sIrMzMiDlNRtMSEa42AkediDOediEMAJqaZnZ1nGvwkzB9yRvlGp9rE5zhsWp807aJ4qpXDtLVlxAAplDyO1HIDAoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CYjszeIY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qfaxaKzM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CYjszeIY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qfaxaKzM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763976510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cwwLYy7U0VWzaRRqBnwMjegRNueLt1VhqEHOdIBq1mY=;
	b=CYjszeIYjQfHnPWiuEMkGYBrElrk82Rcrxb0+0qIFqZCK+xIanFSKIWpHgbNrhLDn2g5WL
	KGeUEgHLvuPn88/hPCiQO1B8bLTNj8vmJJVPFgGAfsXjIfQkXg25PXhNXcRh+DAnmz0Vfn
	enHGRq68ajoRSZ3XDxB+DS3H5loLsjU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-sPbTgDx5MzyslVMd5mqpMA-1; Mon, 24 Nov 2025 04:28:28 -0500
X-MC-Unique: sPbTgDx5MzyslVMd5mqpMA-1
X-Mimecast-MFC-AGG-ID: sPbTgDx5MzyslVMd5mqpMA_1763976507
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b3086a055so3639779f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 01:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763976507; x=1764581307; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cwwLYy7U0VWzaRRqBnwMjegRNueLt1VhqEHOdIBq1mY=;
        b=qfaxaKzMW5D+k+mIaVeG54honzpYaR/36nIPRTvRlsN4AL+gczh81/1u7xRTxRxPqo
         i3TZNIUPSL2fdrnpRbiDmo2mz2fpMsTPHOrDB/sLLa150+GR+j7cpltP4iv4PFaEIkzJ
         vlXAbg7Jj7CqMwlds+u0v3yMCW/VMBwkyle6gKEWmyh1WOtXMheJanKtd46zy4UYefG+
         tNG51XPGtHLVSwILbPb08cuZXdOsHHq4GNf6kzgwqvF5LEibtCVhIFXIy9AVh1zqk7c7
         zCSlBNiZEeWWKaaa5hryHU+g8NKmkQudLcAXe9gtslVtwLBPqKeUhX5utxVOj2TDwg1i
         19fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763976507; x=1764581307;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwwLYy7U0VWzaRRqBnwMjegRNueLt1VhqEHOdIBq1mY=;
        b=h/20s+INSrBKp35sRS5jOOSa5j8CwWB/BOXDp5evRjvKA0cAJKTHUGNkAC9WJjJu1L
         xDHF1+OYD9fg7au8EG9U3p1QuQ5RH26vAPJZRqMrSBKb18C6MY3WQe4DcLUGwza1RWHS
         i71xB/ESFxo3rSBmOld4Tr4uEg+6qNbRVXpGJAegGQCT2SFUCxPrh5dPys903LDS+6Lr
         /80MWRFFYr/m1/1FlyV5nwVqOrBZsfe6NPBBSUx2rMIjxhORxULDbex0X918BMsPgxm9
         1RNxyYHFe+VYI2QgzaDNrHrd9YQSJN2LV2WylUjiAzFW9JIaZFNzX/PzBQWpsariPTa5
         4KLQ==
X-Gm-Message-State: AOJu0YyaTCi1naGjgMt+MlDJgbwQ40VIInWg1XFIwPyiIwqpDHJTPh+h
	3Fne3cRmUpCs97gAkPNUUBs7qCI9DgA+D8rSgDF+rL4S4PYtSX92JUB1xE3nqY4lYmdojBi5UKS
	qiEl0V4pOCr+tV1bc5Nf1XxwpE+Uhn/dSYk0JeiIIhy1gcnwwA1peqqqunOqs
X-Gm-Gg: ASbGncvTbkpP67lIVQfKLcwAUBW/mkh3rhn/D8/NMp2jHCdoz+HwRfndOhtC+Jw1eSL
	ylafdDRpDD7yQnV5RkhkhgThIROrzQnPewLfkotw1VJVb8sNXl/t1whAfQ5Y2aNkfjXCo3k+c9M
	5wW0zDdMZc17PoTFMz3tY1S5tQBOirtJkL/ZtJhece71lomeocZrc2Aa1AgDqJTueawjCD0EE1A
	clXEPQTk6HqbNv964+uCq18+eTeLxsMpt7qwDp9LpJQKX6f3TdrAJ+aKp9IEq6ilJs5aFDcHMjN
	jyVgexQo3tP2I6dZ3LV0SHIibBrS0fwST+4sCgWT0zKzpzUjljte/HZbLnebMGtw3poDyjNAl/k
	=
X-Received: by 2002:a05:6000:1888:b0:42b:3ace:63c6 with SMTP id ffacd0b85a97d-42cc1cbcdfcmr10669813f8f.16.1763976507033;
        Mon, 24 Nov 2025 01:28:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEI8yHt3j35hm69yh+/sCn58svNHUVi2w3PZkEIJNHPm4N0PSJoZlc7h3Zzg8wuqe6ob6JxGw==
X-Received: by 2002:a05:6000:1888:b0:42b:3ace:63c6 with SMTP id ffacd0b85a97d-42cc1cbcdfcmr10669780f8f.16.1763976506593;
        Mon, 24 Nov 2025 01:28:26 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb919bsm27172360f8f.34.2025.11.24.01.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 01:28:26 -0800 (PST)
Date: Mon, 24 Nov 2025 10:28:25 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_scrub: fix null pointer crash in
 scrub_render_ino_descr
Message-ID: <22sdlduk5ceylkzl67mzuzqkwz5omtfqykwm73rntzezppcf3v@6fxjzdfxctfx>
References: <20251121163937.GN196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121163937.GN196370@frogsfrogsfrogs>

On 2025-11-21 08:39:37, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Starting in Debian 13's libc6, passing a NULL format string to vsnprintf
> causes the program to segfault.  Prior to this, the null format string
> would be ignored.  Because @format is optional, let's explicitly steer
> around the vsnprintf if there is no format string.  Also tidy whitespace
> in the comment.
> 
> Found by generic/45[34] on Debian 13.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 9a8b09762f9a52 ("xfs_scrub: use parent pointers when possible to report file operations")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  scrub/common.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/scrub/common.c b/scrub/common.c
> index a50c810a7bd5a1..49f13466d389c1 100644
> --- a/scrub/common.c
> +++ b/scrub/common.c
> @@ -404,7 +404,7 @@ within_range(
>  /*
>   * Render an inode number into a buffer in a format suitable for use in
>   * log messages. The buffer will be filled with:
> - * 	"inode <inode number> (<ag number>/<ag inode number>)"
> + *	"inode <inode number> (<ag number>/<ag inode number>)"
>   * If the @format argument is non-NULL, it will be rendered into the buffer
>   * after the inode representation and a single space.
>   */
> @@ -506,8 +506,11 @@ scrub_render_ino_descr(
>  	pathlen = ret;
>  
>  report_format:
> -	va_start(args, format);
> -	pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format, args);
> -	va_end(args);
> +	if (format) {
> +		va_start(args, format);
> +		pathlen += vsnprintf(buf + pathlen, buflen - pathlen, format,
> +				args);
> +		va_end(args);
> +	}
>  	return pathlen;
>  }
> 

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

