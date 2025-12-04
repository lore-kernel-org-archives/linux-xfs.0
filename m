Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB117C77
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 10:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764842459; cv=none; b=LNfxs7RzH2zTdEKtJ15aMeRbqRY/OyaMvZsuXSyZb4Id7RiI7dxNToh7Yc9Ofj1NDHvJoElLINl2hnTh/aBuiquJWGKnoSanqgemuCMclKjC1btaYKs2tlClI7IZtmJAR0zyF+t7gv1J1dIfxgUh9AdQwzSoV8Km2EcQn7cszEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764842459; c=relaxed/simple;
	bh=4iNewMg/3G+mbRPoiYEduBd37h6D+nzmHNXi3f+n2s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mk7tLFMtU0ZDIN0eepzdLfcbWTFoXfJ0SAk17eovc5BRdcvMt6PkVp/QIwCWL7NrFPIpTZi3B/ry3bM/KPOqN64ebwHHOK43oRuFfNhbmudHYnEWkoQ3v6B831tMVpp5D+tM7DMvXfUhcWt2bsyjzonoim4vTw2o07oNOgBwATo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UBXsxgog; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=j6nbXIzS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UBXsxgog";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="j6nbXIzS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764842456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=57vJt1tmEBydOdonRBlLvkgCQIzYBGVZZXEpAM4tN08=;
	b=UBXsxgogfQkih6Fp0ChKRzM80hKRQu/GzoI7ikJhf7tvf8eV8F6Rid58z3bb2wcLh6NB1R
	bF3x3FNavgGUqLE8UTFC1QzknOjRygC7ALOneaDXOipO/z9jQu5b40CaB37iZhdBq2KPv9
	K/5MbvLMcuTtglEcWPdjsCL/FVjCQjI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-_9zR7HlDOPubweXJZye5Dw-1; Thu, 04 Dec 2025 05:00:55 -0500
X-MC-Unique: _9zR7HlDOPubweXJZye5Dw-1
X-Mimecast-MFC-AGG-ID: _9zR7HlDOPubweXJZye5Dw_1764842454
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso5310135e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 04 Dec 2025 02:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764842454; x=1765447254; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=57vJt1tmEBydOdonRBlLvkgCQIzYBGVZZXEpAM4tN08=;
        b=j6nbXIzSRNib+/nwN7Hjk4+rBBy7DIcpLjF7eqNimK/hMbam9mdEGvcvqBWNPT/PzJ
         3Uqjg4lkA21tMWAfdqXDzL0v6usPRxuMws5H+8IaI0E7ZWMv98V98Xu1vMTWGiq50qv0
         iCYoOtqVs5B1LDv+dDKGPBaSIffZHwG/6AQNSGMDWu/J4SgjtAfvq6xayj93LGUJ/WD2
         pCM/klIJ01DqBg37AxBxMt6DLrGBVH4bbAIBMwR4ck7uw4uJS2+XnPxhWPhZPNHfkkMg
         F1p0PTAK0cSzNxLGviZl6rWQKmQP+KViiqpnCdUe7NS+D9WZ8W3aAcIBaeG4DKPJxzVM
         EzQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764842454; x=1765447254;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=57vJt1tmEBydOdonRBlLvkgCQIzYBGVZZXEpAM4tN08=;
        b=WXI9mTQhiPxRSmzGAGVExrfM6j9o+NKeHE4+fSumlByHujdFXZDoooYKUXf621JrgO
         sZ1zgj9bcSObO+2IOu0Ud5RrBhEVS7bEUiz2CG6ERvmnAB76QpdPRJysKCnt+Cnph2zw
         unZXSyZkvDeRe0Oh/QzPmdJg3qNJs8D8HKBXI3hkbQ9/s7bBdCYmohdusHxv2BcBNNMe
         7MBUTLgWWL2nNorVurAI+6YK8Q+i/jBez6VaBSIF92I/ITAl+yXV1knBcZd8mLXwM7RG
         GftoiQsnQKnZs6Yx34+2IZkI8oSkTPQvZOKK+06udTWZWAW97Lyqp70xU7HUIN5+Q80J
         Ceig==
X-Gm-Message-State: AOJu0Yy8ae8c+16m3BNzkGufuBpX4ksAcGiYnRURnas+B0xoMoPzdiGz
	iYcWQJB0QhFXq7zCrjC6Gbh0+TEyjxlhuFxYQLPb7/zA810k973UEuUXIwD4+kfn/eH9l9R4g+7
	ylbdhevnyg64ELt8F2no+Q+A4E0GKyjUbI50bBI2az1HfmJBerF9flRZnnhVX
X-Gm-Gg: ASbGnct8oH+HYTNWCG+FAgorVyqYvpUrW3Y51YHaCt1FLUyYTliiw4Jz23UwKLBz97P
	q+CYdVXLHignMgDpGzDtJjdGRie4R+1XT9qpyt7jSm9VrGf37bq0G/Nd3yIwlYJZ3LZ+DzZQo8x
	C9RhyxXAn0kIjshSXuHMsu1VajnpDgFiyKjMsYTsCGa4RYMK+zKAvfvnizPrSk3RN/OthQZmo3a
	t/43Gcly70Cr/raOm5GH8W1P2Oi2EeYi2knvshhPAD3cWTgWusVNvGhONy3n2IS9eb56ri8fCy1
	//uzZQYSY5KCtqSkwhTrNRA7W6h0DMcZzoB/TzRbPIsPCcGbprHxWmeKqqmrQrrrlM4godMO4X8
	=
X-Received: by 2002:a05:600c:4743:b0:477:5b0a:e616 with SMTP id 5b1f17b1804b1-4792f244d1bmr16935195e9.5.1764842453845;
        Thu, 04 Dec 2025 02:00:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDmYiBaO2Y6FiNAQescEeLXvtxJyS+2XkLc6d6WMtZJDB16ZJlNd0wHTQEtYkl4gnw1m8gWQ==
X-Received: by 2002:a05:600c:4743:b0:477:5b0a:e616 with SMTP id 5b1f17b1804b1-4792f244d1bmr16934575e9.5.1764842453029;
        Thu, 04 Dec 2025 02:00:53 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4793093a9dcsm26191495e9.7.2025.12.04.02.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 02:00:52 -0800 (PST)
Date: Thu, 4 Dec 2025 11:00:51 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org, 
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org, hans.holmberg@wdc.com, 
	preichl@redhat.com
Subject: Re: [PATCH 23/33] xfs: convert xfs_buf_log_format_t typedef to struct
Message-ID: <2vhe7x2wsydpko2n272dppoqk6kxe7ejkx2lwpmg6pa56mmnzf@f64b4gg4dpuv>
References: <cover.1764788517.patch-series@thinky>
 <qptxxayqxie4vwryddds36sofs44zufqo3wes6j4dfehl2jxoq@3ioxr4fnyynb>
 <20251204093202.GC19971@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204093202.GC19971@lst.de>

On 2025-12-04 10:32:02, Christoph Hellwig wrote:
> On Wed, Dec 03, 2025 at 08:09:48PM +0100, Andrey Albershteyn wrote:
> > Convert xfs_buf_log_format_t to struct and retab arguments for new
> > longer type.
> 
> I think all these patches should go before the removal?

oh right, will move them before

> 
> > 
> > Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  include/xfs_trans.h      | 10 +++++-----
> >  logprint/log_print_all.c | 18 +++++++++---------
> >  2 files changed, 14 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/xfs_trans.h b/include/xfs_trans.h
> > index d7d3904119..a3e8a000c9 100644
> > --- a/include/xfs_trans.h
> > +++ b/include/xfs_trans.h
> > @@ -46,11 +46,11 @@
> >  };
> >  
> >  typedef struct xfs_buf_log_item {
> > -	xfs_log_item_t		bli_item;	/* common item structure */
> > -	struct xfs_buf		*bli_buf;	/* real buffer pointer */
> > -	unsigned int		bli_flags;	/* misc flags */
> > -	unsigned int		bli_recur;	/* recursion count */
> > -	xfs_buf_log_format_t	__bli_format;	/* in-log header */
> > +	xfs_log_item_t			bli_item;	/* common item structure */
> 
> This should be struct xfs_log_item.

hmm, I think this one (and xfs_buf_log_item_t) wasn't propagated to
xfsprogs. I see your commit in kernel but that's from 2019. 

> 
> > diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
> > index 39946f32d4..bbea6a8f07 100644
> > --- a/logprint/log_print_all.c
> > +++ b/logprint/log_print_all.c
> 
> And this clashed with the series I had, which also splits things up.
> But I guess we should just do the quick conversion given that you've
> done all the work and I was too slow.
> 

If you have more cleanups I can also include them, I want to prepare
everything for soonish v6.18 release and include that fix for
xfs_quota (which I will probably send today, not sure if reporter
will send the fix).

-- 
- Andrey

