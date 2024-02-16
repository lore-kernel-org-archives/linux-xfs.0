Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F266514A8E
	for <linux-xfs@vger.kernel.org>; Fri, 16 Feb 2024 06:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708063657; cv=none; b=Z66mKhqob5V0nPDuv0DriH4HXmSLLUq5ZOVFzXpfkCPC++5+lua4RMyc4xzLBLq9HcYsaK0IUY7V3kUQJb0FeX71schA2mtvxGWsiX7ViHcjyqoOxWgUidd0DxPxyOcrJG67aCcoFngrRvR53MHgRlAGzUCuV6RaRtQG6K33R6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708063657; c=relaxed/simple;
	bh=U04wk+0W85SbFi+/BMG96/EGMtXpZ4yhD4zKhCk/51w=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tPxgwkbLSaLMu56wlvhyLe5x3RUIhliS8hGlgvaa1+9nXxkDUhSL5wfXiylWT2cN16P5nuP4kVFGlhEj8/Dh89GUJl+/kfbcowBlCBt6bvGhF5KMHeXoYM04Q6d0Hm2u1Mwby99yHeuPN8sja56aqfYjfqqQc3cNXqioOnX5bJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kqH9k++C; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqH9k++C"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6077444cb51so20297587b3.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 22:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708063655; x=1708668455; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3jfwmJzlihpeqJsyg1QU7sAxw4D/j0HY4WrYv8mMarg=;
        b=kqH9k++CYO0e/r8Pj1w6q8tCmrqhX3IYN1X+zJ337hYKcVp1+/3nEotjcDVwupwMLh
         /WsXLsIXPItVnPb/2Tg/Q4m/ipn80QiwXMtNc8Ic4RO0u1zBdiUZl9LiNq3T5izMzkTb
         3k6k4yPCuT1jS1zY5vRUYD+JZwN0JFgxLVD4nzy9YLeN1WXIXVnquBnW89o3St/t9Idb
         OuaF14w3RXbDivtM4eX65kSk1soq8IJ6z9O7C/NixXb/LhdqnLZYdSNk5mHXDGsEL3oR
         HSx6iOYqSCE4IkEbb7TO+0tExEGk1CC5eBIGvCcn+hjZIFEE1FJL5nxlvwVOCuVWCiqL
         7U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708063655; x=1708668455;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3jfwmJzlihpeqJsyg1QU7sAxw4D/j0HY4WrYv8mMarg=;
        b=Tfh7SUC2NswuEXhQoNWqV80FKjvcMajJhmprL0Y0Fp3C+7SNACo3/hyUtud0gLdlzD
         M8tIueh0J+b4njU08JS7NiGtWsLD/XBj0JqFOeUtxbRczJFIDFR5rd+pephTJ2oDEEKG
         Nj9ks58DXPTS+CxbbBg9/OyMjE59yrr6M7y75cPt6AS0td5s5CRqso/SFyYDzWY8gLrB
         jW5tfLoFntMuc7gVT7dKpyACJ9yNHpqqZ2A0mrvVHd/X81xlIPqhG3PoU7J/6HhUUfSJ
         nWTkvm7SfL45QeURebtndDW3sQkioZGBMc+fLiMAfTKbo+/F5zrjBMeN9uwKHSb3gfBC
         IUaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtEMh/mHJ5hSpaVIOqo0eou65lDXe2PWh0uDascb0xVUBl+97kSUsBjYOTc/bauX9EXsjML5kegv1+YK9GWU76n84Qrg9rKnFS
X-Gm-Message-State: AOJu0Ywe01BI6gyAPtulIaLxeUeIZ5EnViUmI/Qo+P0ue+teSgrbzh22
	zsEMYZznVtxBdGkVnYq+VluxMFmE8DQ2RD+BFAOZWStqVEXT6jjCRQuSIuVe/P/gSlFgfZimYuk
	NXw==
X-Google-Smtp-Source: AGHT+IFWwzWWjeXWKZhFQnt9h+ixZ5qv2MVfhWOavvb6T0AnfYUNlaTcCHxs/e9Uv0QVVC9gJGLerA==
X-Received: by 2002:a81:52c9:0:b0:607:e909:beac with SMTP id g192-20020a8152c9000000b00607e909beacmr2044239ywb.18.1708063654791;
        Thu, 15 Feb 2024 22:07:34 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id x190-20020a0dd5c7000000b00607fd619a78sm79596ywd.37.2024.02.15.22.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 22:07:34 -0800 (PST)
Date: Thu, 15 Feb 2024 22:07:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Christoph Hellwig <hch@lst.de>
cc: Chandan Babu R <chandan.babu@oracle.com>, 
    "Darrick J. Wong" <djwong@kernel.org>, Hugh Dickins <hughd@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, linux-xfs@vger.kernel.org, 
    linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 05/20] shmem: export shmem_get_folio
In-Reply-To: <20240129143502.189370-6-hch@lst.de>
Message-ID: <2f97998a-91b2-1db0-bcee-824e38e98cc5@google.com>
References: <20240129143502.189370-1-hch@lst.de> <20240129143502.189370-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 29 Jan 2024, Christoph Hellwig wrote:

> Export shmem_get_folio as a slightly lower-level variant of
> shmem_read_folio_gfp.  This will be useful for XFS xfile use cases
> that want to pass SGP_NOALLOC or get a locked page, which the thin
> shmem_read_folio_gfp wrapper can't provide.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mm/shmem.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ad533b2f0721a7..dae684cd3c99fb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2137,12 +2137,27 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	return error;
>  }
>  
> +/**
> + * shmem_get_folio - find and get a reference to a shmem folio.
> + * @inode:	inode to search
> + * @index:	the page index.
> + * @foliop:	pointer to the found folio if one was found
> + * @sgp:	SGP_* flags to control behavior
> + *
> + * Looks up the page cache entry at @inode & @index.
> + *
> + * If this function returns a folio, it is returned with an increased refcount.

If this function returns a folio, it is returned locked, with an increased
refcount.

(Important to mention that it's locked, since that differs from
shmem_read_folio_gfp().)

Hugh

> + *
> + * Return: The found folio, %NULL if SGP_READ or SGP_NOALLOC was passed in @sgp
> + * and no folio was found at @index, or an ERR_PTR() otherwise.
> + */
>  int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
>  		enum sgp_type sgp)
>  {
>  	return shmem_get_folio_gfp(inode, index, foliop, sgp,
>  			mapping_gfp_mask(inode->i_mapping), NULL, NULL);
>  }
> +EXPORT_SYMBOL_GPL(shmem_get_folio);
>  
>  /*
>   * This is like autoremove_wake_function, but it removes the wait queue
> -- 
> 2.39.2
