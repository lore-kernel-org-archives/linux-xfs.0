Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23182652B0
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774016283; cv=none; b=FDgUjJF18iMj1N5SRjZyZRMRT5PoqcAjvPcOVendSvragthPruXLcKlym5mIHbS0G2KD6efpmWdGLGBVMQCKlkeQ11VijKV61bwuO0VzU9DuHGxoiHIPiYwrTMBjZaVzeHb0XnN9VpKs0MNaRYB5RXsCwQjQcjtgcNDUXxWPAYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774016283; c=relaxed/simple;
	bh=T+RsT2xG0uni2wMeeBE1ad0GqkRYfkQ7kf/ZYYKdv+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gH4G4g/9vzOXdcaOUfijQMAmVS+B7mPDBxXTs8OsXWUGuOWtcI72kL+gfanIb4NTtqoMyX4w6dGhp8Kr9tUykwt2Ch5Wq8Si7tbsz2xrbmAeXzRwe2oPp/EvLDwk6jcucP8FDY3FMTNDZ4tYgXAOykQpgxMzVtS2pzAy11pmNlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EXFUHoGQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UHcq5+Mg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EXFUHoGQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UHcq5+Mg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774016281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IO+R/+SZqWAXK1qkgxq+BIGEkctgqKbCaUvJR40m7t0=;
	b=EXFUHoGQd//1AkLtYnWphW6S0/ZIBEKhxIHn8mVprgnszl/y8Erzs8gbfqJ+Uy5XXu02vb
	kEh7PaCAnaGLLxMXklgi2Is02VOTwRfB/9cM6HhDTsrKBVMoW/eh+EdTrK9d6jcQlXjmDq
	yYCo717kXaIRRSL4po9EYdIZyPr4gfw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-x6IXOE-bM2a1GFWkESAlcg-1; Fri, 20 Mar 2026 10:17:59 -0400
X-MC-Unique: x6IXOE-bM2a1GFWkESAlcg-1
X-Mimecast-MFC-AGG-ID: x6IXOE-bM2a1GFWkESAlcg_1774016279
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-43b3da235dbso610466f8f.1
        for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774016279; x=1774621079; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IO+R/+SZqWAXK1qkgxq+BIGEkctgqKbCaUvJR40m7t0=;
        b=UHcq5+MgZu0Zod8pX511hFR5J6jAMaQgxVPyaQMo92ep3QMTlqFKh5z2dgEC7wU/lw
         NLp2nnfAkOt3m2VDVjliD5kMC6NFjNaFHYk4cSL7bqIye+1At5L9U+0q1SFs7aowXNlf
         +xHcJmXyPmgXhJdjg/+b6FNrD5xNJ1O7uEAT+gK9Qrgo3O3V381GARSOpk3V89X/JdJN
         1Fjox4+OC9p9SXunDyIk5kOrQEZaj1BfBBoycT/F+YIKQ5ElgREW2CW3WS3HvWsXtWez
         WUchY/4vrLTUxihBBEppEAuA3doVnYbMF3IJTB7btVHxq0GXSh1FYttpYjvboTQ8gOai
         QPZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774016279; x=1774621079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IO+R/+SZqWAXK1qkgxq+BIGEkctgqKbCaUvJR40m7t0=;
        b=Lgjtd0jgQhBtJbZKGqyzFINiEuDMTqUalsNfYYKl6184tXyy6Vs79kW2XuE3IwCSIA
         q0Lud4gFE73O4gKPkkDgd1lj3ZnGIhu6csJNqGYbgwo2F0lTi3bWU+UyCzEdHD8pLmCZ
         CQTRsSoPeCRVPy5JN77PYdiV4XB+YhVYHItPtdeRrbrzfqEkyEGQC0w4voYKmioXxnuS
         4loovXAe469ScyANDceYNh1FBq6PO/EgHD6gJh+FKhvJTQGZr8wRcUOhq//wKqZLDhda
         1uy2qGFStMgkZ47shUXUcQMn49h3eiazsdlzPqsGvxU+Md5ag0l7Tsj6UyLi/VpW3U3U
         bx2A==
X-Gm-Message-State: AOJu0YxC0jKJX4Me6Gs1qfaLK3I7HIUKgYTj04VNuvpBsLVsamlzWhGF
	1zfmUx0eqm79J2XX7LmGjilHRCMDAvoayna5U806W0J0h7QxSvSk2F6J3pyzBbdWaU++4gH70lX
	lddwlOSEJeZ/4zukCC4k39mCDhEXm2q2HdgwCB50lpthEQfoSyodRHBFqpRd3
X-Gm-Gg: ATEYQzwKDsFN+fI7TCgnvGkyJhx+7u/PBxgje411to8xGvUkoYXEBj2Av2IELP3itwq
	EcTBW7r5XaAnhmZvL9Zs5+3vD3DKPmotWc5FZONx5LzvpND7Gk5zrzmyeaxBOMTF34uyNxkUYWc
	UTZuSUVTKWEuWHwVFxoalNFV3b7G3Uyo8keYd0njJWGV/aLr2COuLWYyUhmkVvd5IkeYnEgMOIu
	QQ1HmKYTck2f/lkOorx2/7cyD+q17zl3PjHUrcFdWnWFD6OdymQXwbhDtv/p/3RPqwR+kOhH2WH
	cfSfp40YsBqIpuQtHUmg6TGq/tCuCZYRZFqDoCv/IPwDziPXI9OgQG7H8pI5rgiWJI3/4F5WMZe
	DC23ocgJ4bBc=
X-Received: by 2002:a05:6000:4013:b0:43b:4960:60f2 with SMTP id ffacd0b85a97d-43b64291854mr5471279f8f.47.1774016278573;
        Fri, 20 Mar 2026 07:17:58 -0700 (PDT)
X-Received: by 2002:a05:6000:4013:b0:43b:4960:60f2 with SMTP id ffacd0b85a97d-43b64291854mr5471218f8f.47.1774016278033;
        Fri, 20 Mar 2026 07:17:58 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64711f58sm7262817f8f.29.2026.03.20.07.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 07:17:57 -0700 (PDT)
Date: Fri, 20 Mar 2026 15:17:56 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: tbecker@redhat.com
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix printing of cache.c_maxcount.
Message-ID: <7zchkodqlc6x4olqqlnkbvqcdflcxbwxpiyby5z25kuo7zgwi7@ghdett26fzxp>
References: <20260320132734.2621943-1-tbecker@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320132734.2621943-1-tbecker@redhat.com>

On 2026-03-20 10:27:34, tbecker@redhat.com wrote:
> From: Thiago Becker <tbecker@redhat.com>
> 
> c_maxcount is usigned, but is being printed as signed.
> 
> Signed-off-by: Thiago Becker <tbecker@redhat.com>
> ---
>  libxfs/cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index af20f385..e6443fa6 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -85,7 +85,7 @@ cache_expand(
>  {
>  	pthread_mutex_lock(&cache->c_mutex);
>  #ifdef CACHE_DEBUG
> -	fprintf(stderr, "doubling cache size to %d\n", 2 * cache->c_maxcount);
> +	fprintf(stderr, "doubling cache size to %u\n", 2 * cache->c_maxcount);
>  #endif
>  	cache->c_maxcount *= 2;
>  	pthread_mutex_unlock(&cache->c_mutex);
> -- 
> 2.53.0
> 
> 

looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

