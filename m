Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A21F1C8611
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 06:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764915427; cv=none; b=mU2eKWx8YrxlKVMZRMB26n6rp5HqbStkhfgrOXtx6aR2gWCMBzIOSjasqHfeXqXcKq7YDhaEN/8mO92CkOV/h1aVdFqutSbxXCxgW3O2AhIT/nwxvk8WDGMOWKjL3gJ6gmpgK007LqRGYMCU//dqejyqcQh5An1U6dZtMTbQxEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764915427; c=relaxed/simple;
	bh=lRvMy3Nsa4018CCXzjE5gndFWfgaLWm51xN0ZdAb1DY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5vxgQc2VBp+YZAFcB0mg+VxAmmE7pOgazvYUyVftQAKmA1JXdnCZ/Rc3vnwxqu+AKCKzeAUdANrdMoca+YIeU6XVoIEjoBWFTDUlNy/Rs4PI5GDipF9G8uhfhOvhBqNkOOxm6BqQdpsw5w3ifTIAb2E5Rk73eFnD0oUGX/H5LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gf1z/h4c; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGhAPJYn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gf1z/h4c";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGhAPJYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764915424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xXzRynHVZD35dsZOQSAxDidWH5UYp+SP25S9dmTtEho=;
	b=gf1z/h4cKsrpqmZOmZydxJ+gcrOMYoptvdpOhDieEL6pBDn/4rWjPoLRIm5VzSrymQflB/
	L7lvJ8Y0AvcHwmn/6yr45NIQLtclHPrMWUEYuPLsOeePKwnw0jI3MthW0UPETRK7dbYZN5
	6XP9dA98Clw5WYi/Vb3IsPyF5ktsXlM=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-OfEGufDWPpG7UUAinC8Byw-1; Fri, 05 Dec 2025 01:17:02 -0500
X-MC-Unique: OfEGufDWPpG7UUAinC8Byw-1
X-Mimecast-MFC-AGG-ID: OfEGufDWPpG7UUAinC8Byw_1764915421
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2958c80fcabso41244825ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 22:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764915420; x=1765520220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xXzRynHVZD35dsZOQSAxDidWH5UYp+SP25S9dmTtEho=;
        b=gGhAPJYn7RnryCgYJqApSohtCI2gYZjkA2DdsKVDs3KvozYUFtE8+GWZTxEj2J4hai
         8NJPrDajFz6wMUzzyKaVxTZmNtJQjx6tPxMunoO4jTT5gXpdyP02ZW7juxzPZp+m4tQv
         e0GplKahWdf/pcXWFeMHrie6dAOVm8xYyijyBK1GlaGnHXlxWd/ICX22RdCHwu7LvzEA
         u5PDInUuQDF+JqgRkZbe2VceNnXhHma37LuzN/9iI2MOhzIndmofqK9uSUzPPUxvNUnS
         pm/VOjpasp7wJLn+nV8FHCdeyEl0Jx7OFDTP8WTBltqcVEepQpfCXlkmU9PLPCbAXhXa
         DruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764915420; x=1765520220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xXzRynHVZD35dsZOQSAxDidWH5UYp+SP25S9dmTtEho=;
        b=mc/hREB3RhcOle12yVqD4l3Go4gOCAqgvX6iiBKDdHqizXf/WEJSnV6MvF4n8TYIIR
         2rz6s7SYtaunbgh7eoXowuDqHEKy20XDP3buKgk0p8/oMzaPmHtRPAaS3TfIyPoyRPIr
         tkIDjPR9u7Fhl/3N6IBrlX/GVn17R4Yr0bWP6r3uS8L+tVZrd/FYs27LAoNCQXUCb9sz
         enfwzdtH5QXaelYDH0b8lWmnErs0IeJ7M7FeY5LMbqJJHN3jmWzIuPPnzjZnmOu/UFKk
         RkqKbxwpN8dE8DPJ3bJHRU05E4t9FvL2v+ELrl/KCZrXXHf5tWEofsFrDKcBI4TuSxON
         mwSw==
X-Forwarded-Encrypted: i=1; AJvYcCXTcqA1t7CP98OcY6i5kNZUDAFXLthxOXccXhoupC/uUVUrL2ueNmJnP/j2Z7hS1XSa6XF3PJM9RwE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxpFX8Evf1a8eCxxPgLCQOYZ3eo49Z7ZrIRhfLx1OFS9bVHBChu
	oB0kHxjHwbL4ViZZ5OtPlzmVB45oB8e/yCyBjbhMxbYJ2a0ctuOHRw5ClJ4f80ycBTJF22BQvbT
	EX579QepBn2UcQAuDBW/ndps1K6hTKAcuNaCosinEHY+P+0wP54mVC3IORV73FtWYG7dgdA==
X-Gm-Gg: ASbGncvrWeUumHtqtlgRqFr3RKcpRWT9Ab/E4lNmkfxiBgyeVgrGY4IdVMp48cVnSFT
	1g6T6amokcg25cQv9eF9GMZoXYjx+jLI4QwTdYpZ1QH0wZ9+V0HGDa90245MfdkyiCtY3tTj9Nz
	WVsh+hDDUXVq7iFNBF+cocORXp0XXEjUtQLfedPKkq0ykDgqtyzwuW4kFv1Bok0sjWuI+/apz8T
	RBG05dxymYwn8dsfJvOiKoJyEnIdXts7ziDH3WfJd5fSEHUJX0zaRGNyfHUd6Ng82cRsl3t9yPz
	aSSiWrcEeYztqpgmpyE3O6VGvYUUcxkpK1eZRfbY4cTUA0ecoWBzg0JPgEdh0/xy3eA3t75T+vm
	uFONTs3Qcd17o/t+x3kkai8UMr+AkIE8Q9WmIDwYWGri0RVQAxA==
X-Received: by 2002:a17:903:38cf:b0:298:42ba:c437 with SMTP id d9443c01a7336-29d6848f252mr104944845ad.50.1764915420227;
        Thu, 04 Dec 2025 22:17:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF1PWOM7eO8T0mI71RM9pRlNw2s5iGdFGEO38X35ZYLBc56M0oZfbuHAFiUklmP4+mopL57Tw==
X-Received: by 2002:a17:903:38cf:b0:298:42ba:c437 with SMTP id d9443c01a7336-29d6848f252mr104944545ad.50.1764915419610;
        Thu, 04 Dec 2025 22:16:59 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae99eab5sm37735695ad.51.2025.12.04.22.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 22:16:58 -0800 (PST)
Date: Fri, 5 Dec 2025 14:16:54 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] fsstress: allow multiple suboptions to -f
Message-ID: <20251205061654.gyoz2nvtokzgux5p@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251204215317.GE89454@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204215317.GE89454@frogsfrogsfrogs>

On Thu, Dec 04, 2025 at 01:53:17PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I got bitten by fsstress's argument parsing recently because it turns
> out that if you do:
> 
> # fsstress -z -f creat=2,unlink=1
> 
> It will ignore everything after the '2' and worse yet it won't tell you
> that it's done so unless you happen to pass -S to make it spit out the
> frequency table.
> 
> Adapt process_freq to tokenize the argument string so that it can handle
> a comma-separated list of key-value arguments.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Looks and tests good to me, it even works with:
  "-f rmdir=10,link=10,creat=10,mkdir=10,rename=30 -f stat=30 -f unlink=30 -f truncate=20"

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  ltp/fsstress.c |   43 +++++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 14 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 00773cc004bfac..c17ac440414325 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -1792,23 +1792,38 @@ opendir_path(pathname_t *name)
>  void
>  process_freq(char *arg)
>  {
> -	opdesc_t	*p;
> -	char		*s;
> +	char		*token;
> +	char		*argstr = strdup(arg);
> +	char		*tokstr = argstr ? argstr : arg;
>  
> -	s = strchr(arg, '=');
> -	if (s == NULL) {
> -		fprintf(stderr, "bad argument '%s'\n", arg);
> -		exit(1);
> -	}
> -	*s++ = '\0';
> -	for (p = ops; p < ops_end; p++) {
> -		if (strcmp(arg, p->name) == 0) {
> -			p->freq = atoi(s);
> -			return;
> +	while ((token = strtok(tokstr, ",")) != NULL) {
> +		opdesc_t	*p = ops;
> +		char		*s = strchr(token, '=');
> +		int		found = 0;
> +
> +		if (!s) {
> +			fprintf(stderr, "bad argument '%s'\n", token);
> +			exit(1);
> +		}
> +
> +		*s = '\0';
> +		for (; p < ops_end; p++) {
> +			if (strcmp(token, p->name) == 0) {
> +				p->freq = atoi(s + 1);
> +				found = 1;
> +				break;
> +			}
>  		}
> +
> +		if (!found) {
> +			fprintf(stderr, "can't find op type %s for -f\n", token);
> +			exit(1);
> +		}
> +
> +		tokstr = NULL;
>  	}
> -	fprintf(stderr, "can't find op type %s for -f\n", arg);
> -	exit(1);
> +
> +	free(argstr);
>  }
>  
>  int
> 

