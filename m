Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F59B55E6C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784576; cv=none; b=QITPxHiWFH7sX1HNLHg+JhNUFxsC7upX/ySwzP5XN0VotvSGvQHDC9nEDML2qhCWzXzbeZcoR/9rBBXPsHMFApOHk1aXgB9NuMjB36RpMlQVzasfHzIz1Ms6Gh6PcBBJ8EuUV3sEZ8OrbIvA+YklEbwrvRntbRPeWAVXw5+7tTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784576; c=relaxed/simple;
	bh=0FtzGvqVbYFmN7GMdlBX+qWbmEc8QxImSt8+4v3LFEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dHgXcN1qrbWoosC0hM40HXYZWAvRjeHjQkGHUjH5qnF0TS8WkqsDcz2aDUghDROX8B7FkPQFcRR0yorPoeiyHEeqXO6gr+heZ5HVwXb6ytbzafL9yY0gzH0egHU1AbkOFT42Co8d1RmkcfE5NUF+hmyOGbIJMiDgy1ddlTZJ9xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MKKIEBR0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKKIEBR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710784573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QrQMbiWszmtJVUZZia3Tysbn/H6xa9ajIREFO0TRHiQ=;
	b=MKKIEBR0qvNR6qdzO/8waM04Wd2qrHwTLXX0FjDpcrhz5cQ6VVJ1CpQdkSBJvdFyE28s/+
	w746IXTZ3XmYMK3gZn4bjHYKdLp5c8zaJ4b+tVWdtg3kkDpTBs6OYXl2yeHKUCHWyAuEKl
	fcCV87/Q2rDg6vTcSlBQi25m2zgTM/M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-m0xI5Gd5NCCa7ij7YFBemQ-1; Mon, 18 Mar 2024 13:56:12 -0400
X-MC-Unique: m0xI5Gd5NCCa7ij7YFBemQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41407d66b11so11025405e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 10:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784570; x=1711389370;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QrQMbiWszmtJVUZZia3Tysbn/H6xa9ajIREFO0TRHiQ=;
        b=WmZCJrD4a5J9VwdlVSP15fsMr44rox4ND6V9L6m+zzUL8wGKukw/W9TItsJMPGoWg4
         egMh3YFC/889GA7r/i/aEYXyRk28WSS1ZII7PfvqWr4LvDBHWlbp+/1mdLygRpZjP/VE
         uvfsLScCTTZLI0AGQHmzDu9kgp8UyvwaXcyCz0in08JJPCIi2vwCOXQDCnY9jZ960Okt
         tlwpAtpYRMf8i7PsOUlsolW8hKl7FGedgfILf6h4LrMyqSemFWGUFzndGuz207giZez2
         s3pq99Ers04GtB6P3rjkgdsZnnZcuaKg6SFhn5RGFNFMXe5eOOihQEb0J39FgZQlBmNf
         1A6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUbFH9+Ungl76TYxxmqgAmyFc5KoZYafmsOapuGpY5TnYjHnp6bEAWANizpI+sNnu7lP02tJST3s4BzVPtltyWCBTz0aMcRzxRZ
X-Gm-Message-State: AOJu0YyVX+3i+PWa1t1QlmDGqLhFI1auDRF4jxSqvNcOAfpLAJXTPmmz
	j3EePcRDbUyl+8IdpTzPpE6UeKvu06xGaenaJvRRmJgp/PLbRwFHcGhrPO90Z3ik/KVGYarnLm/
	oj1AThAuyMovPwIpYFaJWoypmhLA6sJ3JOkN94tdU1L0X8V236Js2Y4yjN9RemUDR
X-Received: by 2002:a05:600c:190a:b0:413:30dc:698a with SMTP id j10-20020a05600c190a00b0041330dc698amr139902wmq.25.1710784570112;
        Mon, 18 Mar 2024 10:56:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDD/I8FOZXWT0V/bqbSkWFY/a9NMAOlO3XQS0wwQPWuzvaXp4QniddUZMMkEaWAXV8P1rExg==
X-Received: by 2002:a05:600c:190a:b0:413:30dc:698a with SMTP id j10-20020a05600c190a00b0041330dc698amr139879wmq.25.1710784569539;
        Mon, 18 Mar 2024 10:56:09 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c314f00b0041408e16e6bsm7937522wmo.25.2024.03.18.10.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:56:09 -0700 (PDT)
Date: Mon, 18 Mar 2024 18:56:08 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 39/40] xfs: don't bother storing merkle tree blocks for
 zeroed data blocks
Message-ID: <aql6oqq5tzhemldls4c72i43wsxuwvp2jgfa2szfxkkshynoid@zxblqyeyhopz>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246533.2684506.10607368938981182877.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246533.2684506.10607368938981182877.stgit@frogsfrogsfrogs>

On 2024-03-17 09:33:34, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that fsverity tells our merkle tree io functions about what a hash
> of a data block full of zeroes looks like, we can use this information
> to avoid writing out merkle tree blocks for sparse regions of the file.
> For verified gold master images this can save quite a bit of overhead.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

> ---
>  fs/xfs/xfs_verity.c |   37 ++++++++++++++++++++++++++++++++++---
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
> index abd95bc1ba6e..ba96e7049f61 100644
> --- a/fs/xfs/xfs_verity.c
> +++ b/fs/xfs/xfs_verity.c
> @@ -619,6 +619,20 @@ xfs_verity_read_merkle(
>  	xfs_verity_merkle_key_to_disk(&name, block->offset);
>  
>  	error = xfs_attr_get(&args);
> +	if (error == -ENOATTR) {
> +		u8		*p;
> +		unsigned int	i;
> +
> +		/*
> +		 * No attribute found.  Synthesize a buffer full of the zero
> +		 * digests on the assumption that we elided them at write time.
> +		 */
> +		for (i = 0, p = new_mk->data;
> +		     i < block->size;
> +		     i += req->digest_size, p += req->digest_size)
> +			memcpy(p, req->zero_digest, req->digest_size);
> +		error = 0;
> +	}
>  	if (error)
>  		goto out_new_mk;
>  
> @@ -676,12 +690,29 @@ xfs_verity_write_merkle(
>  		.value			= (void *)buf,
>  		.valuelen		= size,
>  	};
> -	const char			*p = buf + size - 1;
> +	const char			*p;
> +	unsigned int			i;
>  
> -	/* Don't store trailing zeroes. */
> +	/*
> +	 * If this is a block full of hashes of zeroed blocks, don't bother
> +	 * storing the block.  We can synthesize them later.
> +	 */
> +	for (i = 0, p = buf;
> +	     i < size;
> +	     i += req->digest_size, p += req->digest_size)
> +		if (memcmp(p, req->zero_digest, req->digest_size))
> +			break;
> +	if (i == size)
> +		return 0;
> +
> +	/*
> +	 * Don't store trailing zeroes.  Store at least one byte so that the
> +	 * block cannot be mistaken for an elided one.
> +	 */
> +	p = buf + size - 1;
>  	while (p >= (const char *)buf && *p == 0)
>  		p--;
> -	args.valuelen = p - (const char *)buf + 1;
> +	args.valuelen = max(1, p - (const char *)buf + 1);
>  
>  	xfs_verity_merkle_key_to_disk(&name, pos);
>  	return xfs_attr_set(&args);
> 

-- 
- Andrey

