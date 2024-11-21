Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0511D446A1
	for <linux-xfs@vger.kernel.org>; Thu, 21 Nov 2024 04:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732161629; cv=none; b=WafKKE0x1VO5asLZPnQNwmotodIqtc/BfXmv3keo7mbHhWqQiOoNtUDmzP+bbF0qvzIPjMgKEcyE5Hi/XVxNBIsF+p3AaASdNovH2KIx69+JfA2e/RIZ8NR8UI24vf3/ARG60H5KNfnoYDOhWVpGNVIYRWsWMbx2g0HcNPf4PQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732161629; c=relaxed/simple;
	bh=4fX2Y0ROOmjUq0zlhKqXfbsTGm9o/OY9On0X69cB/cw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RBzh0aqugAipLlLcQkPQBi8/heKdvh2DBqrmoNRpZ+xcSxK7Rvg0ZcMhzDDav5YbFzLX6GMvET4LIWATSzQ17EPu6DMKtTrWFqr3DoowQTYLYGMw0bEehiOfDneyA56raC/LPvjlzDLHOqHhGmUz9ckH/RyoEfxDEhWNS+Fw/pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gr2lxpAw; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gr2lxpAw"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2ea4d429e43so407526a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 20 Nov 2024 20:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1732161627; x=1732766427; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NGJRybQ2+vW733jh/4DInxsKZI6lQPTJCRJT6uJj9OQ=;
        b=gr2lxpAw3N/uoBh71E+H2pqbHNwx1lN3wqORpgCTLYmfQr03nnS+vP/Pt/YZVsmvSq
         5pqx3IY4RTTFqIdp6oXwdGkLUcpx0A9BKp1jb0ZhKkqDpZdLUV223iwc0qSc9IaXaFG0
         LCgLlOTldm1rmVx4EbhXSROm7+jjDd8zIpK6pkxWVyMnBdfNahVjITknPsoCAaXsEDoN
         b6PkNvIigPkrWUWEhrH+pMKokGHz/VM5vgQWeHquWE9FegNr+Hfa3bYwzySGuwdhplUB
         qPSVOQEBsZ0BVjWimFg3vJMQHaFCPmbe+zmepxOuQ/OLzbaCMgCtpLW7VKUy31TJ5kCC
         dXmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732161627; x=1732766427;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGJRybQ2+vW733jh/4DInxsKZI6lQPTJCRJT6uJj9OQ=;
        b=jJmJ69NepjQrnHO39hrDXKusR8qXip5aGnXLn185677K8Aghi6og5nQSbfD5ObW/1G
         7zrFraQwjAf68JLt38LnkN7u+6aLKGu3OCfRZF3nLsJcS8iF+5jeedh7EV5cM430io4b
         VL1gyxRvujwPTqvMuJhqZAPeFO7DXpW8Z5vgrybwFbGPsp4KEngTNG5u4QyKzA1VfGv9
         mqgjftjmx2pMhz2ShDuvLRiahEZ6n8gvrKK0ejlWXmHX0sMQ6FRwtFStK1EUfiZw1nxF
         rePhIkW3tUSn6mWbJApqeADjgj09ksT23xj6wSFgNlQ6bUq6L56+IXUA/J1m9VmZ23+3
         A9UQ==
X-Forwarded-Encrypted: i=1; AJvYcCWOEWC3AS9leN6AmClaCx+e9lTjhnsDhD8YOpFpSePpPCM/BARRTdtuK34B52lpH9PykEWvjbg+Rx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyK/xExz25IwoJCBAH2Ya05UfXXBmvVKGBkJzsD63J3tfSnlwH1
	YdP8WWuPYOGP+IhtK97OcrktJeEQU2dko96o+7NJOOlmE9GZ27MG4sajMueXMDvEshzCJ+T7hgH
	N
X-Google-Smtp-Source: AGHT+IHcsF4KFzpTjDrrRAkc0fofcdtKa2+7NXJFBh7RzFthDZjTXVnW3J473qOssfuIbQequausLA==
X-Received: by 2002:a17:90b:4b49:b0:2ea:8565:65bc with SMTP id 98e67ed59e1d1-2eaca7c8d4fmr5810974a91.23.1732161627245;
        Wed, 20 Nov 2024 20:00:27 -0800 (PST)
Received: from dread.disaster.area (pa49-180-121-96.pa.nsw.optusnet.com.au. [49.180.121.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21288400bcfsm3419415ad.271.2024.11.20.20.00.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 20:00:26 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tDyMh-000000018DP-3FqA;
	Thu, 21 Nov 2024 15:00:23 +1100
Date: Thu, 21 Nov 2024 15:00:23 +1100
From: Dave Chinner <david@fromorbit.com>
To: Long Li <leo.lilong@huawei.com>
Cc: djwong@kernel.org, chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com,
	cem@kernel.org
Subject: Re: [PATCH] xfs: eliminate lockdep false positives in
 xfs_attr_shortform_list
Message-ID: <Zz6wV-KpCOkKS0lF@dread.disaster.area>
References: <20240622082631.2661148-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240622082631.2661148-1-leo.lilong@huawei.com>

[cc Carlos]

This still needs to be fixed.

On Sat, Jun 22, 2024 at 04:26:31PM +0800, Long Li wrote:
> xfs_attr_shortform_list() only called from a non-transactional context, it
> hold ilock before alloc memory and maybe trapped in memory reclaim. Since
> commit 204fae32d5f7("xfs: clean up remaining GFP_NOFS users") removed
> GFP_NOFS flag, lockdep warning will be report as [1]. Eliminate lockdep
> false positives by use __GFP_NOLOCKDEP to alloc memory
> in xfs_attr_shortform_list().
> 
> [1] https://lore.kernel.org/linux-xfs/000000000000e33add0616358204@google.com/
> Reported-by: syzbot+4248e91deb3db78358a2@syzkaller.appspotmail.com
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  fs/xfs/xfs_attr_list.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 5c947e5ce8b8..8cd6088e6190 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
>  	 * It didn't all fit, so we have to sort everything on hashval.
>  	 */
>  	sbsize = sf->count * sizeof(*sbuf);
> -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> +	sbp = sbuf = kmalloc(sbsize,
> +			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
>  
>  	/*
>  	 * Scan the attribute list for the rest of the entries, storing

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Carlos, can you please pick this patch up? We're still getting new
lockdep false positives being reported from this issue, and this is
the correct fix to make right now.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
