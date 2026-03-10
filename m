Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B56301708
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 14:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153780; cv=none; b=TThbzfgRZaGfvkf4JgkojCW5lTk4jpyQaNM8nsCWMAGObH+SNxDtbYepRdxW0JWUwtD5OC6CpriN3Ga4tQW5/0fdM5G9wFsj0BKDW+0bEl21iZuz/9MSFZL8vzOCuwjv4bCEmTe7tUt7b94x/rbEgfKFlcVFC0GEtGe7dMLGY7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153780; c=relaxed/simple;
	bh=ulN49Zz6Uvce5EQ9S9G5wrSA/FkX6ZfXtBj/b3XcPks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkJI/0X/1wuUlpi25BW7HCuzjIMbLFT5uQFml8NU0eDwltFVTDW4ZaN/p27+VMxXvAyKVLG3H4Bw2nb5wwu/OvQc5E1wyYDcvVqjCYiLBVrUIsIJD/mVEnXhWs8gVBnRIyWjQKqRDpeAuM02bVJ8sHEuFi4nMAGln43AuYRIj2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wu6auwHR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mGu88KJC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wu6auwHR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mGu88KJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773153778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BMpkjIBAlArWoSNA1cagHtqrYddD4BAtLIKx0zMiI/c=;
	b=Wu6auwHR35+CvewBNjz4Y2soT3YOiRe29xV2QAAMRWj9PiGDJlsxAAZaH5fGBHFNdl1IKR
	q9KQc53P0Rc8iySp3DxwSVVP9xiXv30K+31Z1DLJM2lUkC+6hjpO2ixSBua24aGGPWQ4ro
	qR2NWFS6iW3AxnmukJ3sK6SFcZqC1SE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-nzzdWVxrPnWAxbsDOTf9gg-1; Tue, 10 Mar 2026 10:42:57 -0400
X-MC-Unique: nzzdWVxrPnWAxbsDOTf9gg-1
X-Mimecast-MFC-AGG-ID: nzzdWVxrPnWAxbsDOTf9gg_1773153776
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b934e96af9dso1493538266b.3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 07:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773153776; x=1773758576; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BMpkjIBAlArWoSNA1cagHtqrYddD4BAtLIKx0zMiI/c=;
        b=mGu88KJCD10p+zEzHwQJiTHmPvdzGKjcPI2EcpKLWCrWxbis4LERltzsUCqJYjTl1m
         GqwiVllxDhd+4s4hwxfhij1/vmhF2xBzxq0NVN81PHa0c7VRoGb3czdVIg1tsXKA/2BW
         +q8IdjTlhd4zwjRbia+k7GIf6Jx8OEfyy6Jkdk8KQi7Xu+kUkr5p4Db+gkVgiAP9eLRl
         f4OAt35S7zmS/REn6Tz8Sh1xTgtnZawQVZlbtlSEAG82DsTKhulEFMZJHxhdIUbX3HH0
         o1dL4mzFApXbdP/RJy8r9MipvSzb5XkCoaq/bnGrP//18RpXAAxzGGIYiLBuDJRQSQBu
         GnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773153776; x=1773758576;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BMpkjIBAlArWoSNA1cagHtqrYddD4BAtLIKx0zMiI/c=;
        b=NPojKNKr2UQ3ThHRNkwMmBe42gmDDcZ8u1bP9CFrf7NalS+NwKbs9WovudY9ZHR5jU
         Iz5RN5K3gLguLlPJH2l+JQRbknr37ZZ3/NspP8J7j9nXG/uWsZ4TRWMz14rBJg0933K6
         UjCmdOgsTQVFyupivQpN06Lm1cToLNhEOG+LGscijWxMjsXH/AYbyrVuMxvF8jAkSxLK
         t8khjRblV7HMp/qSXjKYlOdP7plazYS3ctgAuv27E0KH6ag7KoMkK6snQ7SfcKTzjAdc
         P4jLNVBc8JQip6jSpryayyPcZMUi7Ajoz7vv4en6eermjRsXuB/Ai8vrnZxjgCcR5rRf
         tgsA==
X-Forwarded-Encrypted: i=1; AJvYcCVvUyapgXW4fC3MyozNyEhTCTKykta9x7k5bMCE9qlORxkhZS6qlW4wFBmW90+K4H7B4CCEpspb0Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVJTxm/AJQXnGAVM4cts2WGaNS3Yk/MPGP20BVayksE2Y9ydzL
	wc/gNOB+ez4Y4MYzjsJ9M2D0kAWI7xHjY+DIDDFKdlgEfdkVZJ2enbDsFdWTHo6ujL7JyDBPHMU
	tSIUCs7pNsQINxtxtLxpe5513T5CjOmxOX9HymKqUVdcrUT9gRuQgTa/10/Mg
X-Gm-Gg: ATEYQzzN2fU/6IO0CVpTMWu7BLk5+rKtOuVkJh1eFb4J7lwlI9Bly3OxpVbF5E9O07U
	T0uavyXiCRwAKAiP5se32aFQJ580WNpwEO0U07cqmWpV4IO0wRjDidzMWasf2h2o1DxetQFXKAl
	A2QXG80uvqwUGcxsY3qB2ch9Lcocm/HtSowvavk3dcAVCbIRMi5l3bNh8HGdh7mmb0Cmprw26V3
	AVHhOjYeQztUoMO82wtV2IfMuVHPZWrWDuxywyQ1mR865jCfus09KCAhN6ItQPo5MaLo/kmzF2K
	sXxrkjL3+4E9vSJzXj0ErDNeofA1+nklT2r2abPvklw481vF26fpx9HyGd4CylAP8dVfiHqntdb
	cb55S7pIj8wI=
X-Received: by 2002:a17:907:98d:b0:b93:edc0:e2e8 with SMTP id a640c23a62f3a-b942e02c34cmr869671766b.48.1773153776100;
        Tue, 10 Mar 2026 07:42:56 -0700 (PDT)
X-Received: by 2002:a17:907:98d:b0:b93:edc0:e2e8 with SMTP id a640c23a62f3a-b942e02c34cmr869668766b.48.1773153775426;
        Tue, 10 Mar 2026 07:42:55 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b94dad4271esm420956866b.32.2026.03.10.07.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 07:42:55 -0700 (PDT)
Date: Tue, 10 Mar 2026 15:42:54 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 10/25] iomap: teach iomap to handle fsverity holes and
 verify data holes
Message-ID: <usl6wrms76zioxpq7xqzo26plpvw642pqrb2zxe4nysnmipm2o@ntl5ml3okjyq>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-11-aalbersh@kernel.org>
 <20260310010502.GB1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310010502.GB1105363@frogsfrogsfrogs>

On 2026-03-09 18:05:02, Darrick J. Wong wrote:
> > +		/*
> > +		 * Handling of fsverity "holes". We hit this for two case:
> > +		 *   1. No need to go further, the hole after fsverity
> > +		 *	descriptor is the end of the fsverity metadata.
> > +		 *
> > +		 *   2. This folio contains merkle tree blocks which need to be
> > +		 *	synthesized. If we already have fsverity info (ctx->vi)
> > +		 *	synthesize these blocks.
> > +		 */
> > +		if ((iomap->flags & IOMAP_F_FSVERITY) &&
> > +		    iomap->type == IOMAP_HOLE) {
> > +			/*
> > +			 * Don't cause lookup if we already have fsverity
> > +			 * context from the previous tree hole
> > +			 */
> > +			if (!ctx->vi)
> > +				ctx->vi = fsverity_get_info(iter->inode);
> > +			if (ctx->vi)
> 
> Is it an error if ctx->vi isn't set here? 

no

> We won't fill the folio
> with the zerohash, but we'll set uptodate anyway...
> 
> > +				fsverity_folio_zero_hash(folio, poff, plen,
> > +							 ctx->vi);
> > +			iomap_set_range_uptodate(folio, poff, plen);
> 
> ...though I suppose it's the case that the uninitialized folio contents
> will most likely cause fsverity to report data corruption so at least
> it's obvious.
> 
> OTOH it does seem a little strange to set uptodate having not
> initialized the folio contents.

This the first case described in the comment above:

+		 * Handling of fsverity "holes". We hit this for two case:
+		 *   1. No need to go further, the hole after fsverity
+		 *	descriptor is the end of the fsverity metadata.

fsverity will not read this part of the folio. I think this can be
zeroed, but I don't really see the point to do so as no one will
read it and we use this folio once, for reading the descriptor.

-- 
- Andrey

