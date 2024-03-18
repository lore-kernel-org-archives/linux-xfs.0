Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4F055E46
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 17:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710784375; cv=none; b=k1P0CbHaTacWCpscHhaQ84UiF5rjTZfQckjgLZPUfXLNF3jr9QhQf+yosZHZPBa5J0eAPx2u/5ECDFjZCIsvt8QeLIaOUQpmyt6weV0PvQBpMa4vshjrZbR3bZBxUy12RMsmeWyTXuKOzxvgdW5xAGCO4VvGaQZsEjcvFlACnvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710784375; c=relaxed/simple;
	bh=fS/Il+cK3HtI9bAeGxWw+BBtB0/QjJLvVKLFtR8tR+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6VG3PQp6SZi4/eTEcCeRfpeBonYMT/kxOkYKBVVyWPlnNIEXCF6H8HASMpHxZ7JtCgMW8/adKi2xYxh6s+08Le/ibQneswNL80ZDJ4EhVmrcK9WPW1spdv7P1AwQ18gNDXuvVCf3/PwVqe9m1DLS0By5CPUjOE3dTsxxSwNeno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H428t0ty; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H428t0ty"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710784373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rAbeI/yN1CujlA/Yp2t7bafFqLrYgHBFMsaR1Wk9Jl0=;
	b=H428t0tyJvhdgwM8lMNH6ZJv7Kfdym7iI+7IufWc+qg8JFDroqjRAZcKkvW/dbD/l9QVS3
	PgldtnRDEKEf/xIcTjlqvz1EnQeMXSKjMsT8S5RbRdKrwrwa4gKQo4MPD69wbsnzIPqCfs
	dmyKbDDyBQpzuG9ssChR7mwAMHS4dZY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-6mQlLqFQNTqEodVs0dXLWg-1; Mon, 18 Mar 2024 13:52:51 -0400
X-MC-Unique: 6mQlLqFQNTqEodVs0dXLWg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33ed22facfeso1716402f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 10:52:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710784370; x=1711389170;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAbeI/yN1CujlA/Yp2t7bafFqLrYgHBFMsaR1Wk9Jl0=;
        b=DqIj6sKO/u1X7xbDtAbVmJv4PE27WgZEA8NGe96iMg2cP2u+kKmgBhe3q3G+Mo7MY0
         gYS31CzR+K2sP0GRBgE2NzYiQXG2GcoD2AMzu8//qYxv/MQTqLRJ+J5iU04zCm5/oXJM
         EiuasOzwM6H8L3+g8R0+rd0xHlW/IjIJtyWKNz6hkD2Q9bvTQU+V1eImxf/sG+ZAdgPx
         pVvMeHE3MwTlAFaQTiahtKPwOmesbSN5t/GndbOnaOIpL4BpbNYn2mUN9XuZrVVA7bpG
         do/5WlX86WQ2RxUrG5VqimqwKIDJ5cLAGGPriEFBoyrn/j5lQdtwrXxzISKQ3M80R0an
         Y2Ew==
X-Forwarded-Encrypted: i=1; AJvYcCX2rXs4v0nMPgSYxwARZUtMIHLJ47s84x+qpiyS3FPqZn3LG5HYE/ENWHZVmMx8Nwz7uqbqL9CAXgXLwkSCQWrk1r2/1cJ+Wmua
X-Gm-Message-State: AOJu0YxR42jPCsNC8e+DJtUpHy8QspRLgJJ2MnUcWKrVrP6vZCiPsshp
	MQxQyAC+aWv/EQvZLI0zjpL0gj3f3uJolXSenaFUFvoAYmzMI6cYXMAZ50G0sD1ZQjcKhLF61uD
	MYjq/R4oVYRPQJHyJIXDiGLfXwswSVCvGj+VCl4pHK0gwo3OM3mo897Gz
X-Received: by 2002:adf:fdcc:0:b0:33e:c3ca:e9ff with SMTP id i12-20020adffdcc000000b0033ec3cae9ffmr8924114wrs.61.1710784369809;
        Mon, 18 Mar 2024 10:52:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFy65n4nPmyObvMmHt58bqd/Rqxh6Qm3q5Bx3DsIXra1l+xAjekqM6JmSqoP5kkpnEFHwCAqA==
X-Received: by 2002:adf:fdcc:0:b0:33e:c3ca:e9ff with SMTP id i12-20020adffdcc000000b0033ec3cae9ffmr8924098wrs.61.1710784369301;
        Mon, 18 Mar 2024 10:52:49 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id bs26-20020a056000071a00b0034185c5ffbcsm77268wrb.117.2024.03.18.10.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 10:52:48 -0700 (PDT)
Date: Mon, 18 Mar 2024 18:52:48 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/40] xfs: don't store trailing zeroes of merkle tree
 blocks
Message-ID: <vo4rc3vopl4u77u2bmva3onln2ssmixuvq3gsdffltdr6a6nuj@mppvl5hbmvd3>
References: <171069245829.2684506.10682056181611490828.stgit@frogsfrogsfrogs>
 <171069246485.2684506.6805355726574585050.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171069246485.2684506.6805355726574585050.stgit@frogsfrogsfrogs>

On 2024-03-17 09:32:47, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As a minor space optimization, don't store trailing zeroes of merkle
> tree blocks to reduce space consumption and copying overhead.  This
> really only affects the rightmost blocks at each level of the tree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

> ---
>  fs/xfs/xfs_verity.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
> index 32891ae42c47..abd95bc1ba6e 100644
> --- a/fs/xfs/xfs_verity.c
> +++ b/fs/xfs/xfs_verity.c
> @@ -622,11 +622,6 @@ xfs_verity_read_merkle(
>  	if (error)
>  		goto out_new_mk;
>  
> -	if (!args.valuelen) {
> -		error = -ENODATA;
> -		goto out_new_mk;
> -	}
> -
>  	mk = xfs_verity_cache_store(ip, key, new_mk);
>  	if (mk != new_mk) {
>  		/*
> @@ -681,6 +676,12 @@ xfs_verity_write_merkle(
>  		.value			= (void *)buf,
>  		.valuelen		= size,
>  	};
> +	const char			*p = buf + size - 1;
> +
> +	/* Don't store trailing zeroes. */
> +	while (p >= (const char *)buf && *p == 0)
> +		p--;
> +	args.valuelen = p - (const char *)buf + 1;
>  
>  	xfs_verity_merkle_key_to_disk(&name, pos);
>  	return xfs_attr_set(&args);
> 

-- 
- Andrey

