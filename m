Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208087;
	b=RcaUZaR3U2GxvFIbAXUXw4Jb8UfDQVZvd3ClzzB4ipOaA5oAmq1l6lFp7GCAwiyaKuWT
	 6ubb4cWUUPRwt6HrccxBO++EzxsdS5VUN4KO8eeHwqQcIfSiTab+GFi0fAlyDyleiSYBS
	 ANlH+2ga0hHmu6SFk01qLElGagzY1tTN638vIFtcc2T1tfMC6qXjcjji3/uTDIhOepYs+
	 QOwZpI81r4mxVOB7rjuZX9C9bt/V+/rmkJXr1mGFaym5OfzZgilf75QA/muM4x/W3cwf1
	 BMQivR2E3l8ywXEwAcvpRh+yZAF2Vd262CMawuNIKXxkris8xYna2B1nvLsRvIWMUIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208087;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
	b=L91vuIa/vlHqRXDBEWvOjvV5sELh3mVrrBWzah9umLcpwof0BjN99TLSbePk8V4RevUC
	 1tDgL+h4Yk0Y5YY4VaYLa8v8qbh89rg88NEao0A2sBoMsBaUZFM/1q6KQsalX+FhPc99c
	 mCg5PLg6NMqaxT+8pfeLyYNTqNKT2FDzTZVSa35ceaZ3PGBjnC0YdA4RfL29xwokhj/V1
	 dYiLjqi/55qHkCRN/DcTPnxlAIGDlhiuPaHumKLZlNP6DPupLKfnGuyXGlvuycJH3bZJP
	 pkDVgSl2zeHu/32enW7u/XiPL/3cT0eNtv5/ZEGggV6OorvQNA20EPcILzWrtqmYp3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=SQlFBLtW;
	arc=none smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1F6606A31E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 17:21:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D1F6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=SQlFBLtW
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6774639a8a4so1186405d50.0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 10:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793208086; x=1793812886; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
        b=SQlFBLtWetvrAOGwtD51xhjKHJMBmuVVhKXJUHggsefbsTBeA9lSUtBHLEvFQVQpwk
         5rxgza6m/fEullx3LCe/5EOf9NitilOHi/ZmD+JZoZrLhue8TEStDNUqIv6MnHIQn4BL
         ASJwtOkabzww4BdFogItYgHjFyEYahE+mlqAedNSjHJcjtmSyL93pQIFRzgVKyVw/q9Q
         81abU0Nq7hvVg258F3rlDeN1MY2edyUC5XbswXKuXMO7fBepqm0oxBuoEywcY0tTHB7W
         viLo1aeiP6zlrKoB9h1bFeSUMb6NEqE315HFQ0S5k0SQT/BxI3ijsPyYAnSyXqISjRVX
         A9cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793208086; x=1793812886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gKWv/vfGN+v0zoryVVsOrqbU4hq0g1uoOUtfYF5rLd4=;
        b=OSiRirOKXJVlJ9smxrB/rXhB8zanYTHLAYSlle7CxAz0Fhrvdcvjv2Cc2CmvrdJKAx
         BC0uiGmUh/vp+eF290a0vb8q3DSQrIR+BVbc3og+0TVlNbXxbrctZ3Itk9efb9HeAtjS
         v+okAqGaWnbZa7UiEYkcnQ00FKRPLY0ZkEsNIbXTuhemRDaHtcwGCKXPzUdaxBAV1Bc3
         RJ7YSwsa8N3Cxl/m8DkzPd8EIZ8cAP0LmTHVWvzZ763zuNVbqrY+IpdCmwgLT9T9Sq4Y
         Cl2GM5IIRETiQ+U8RhgULTTCUijVjQd1KPJCLG974Tk5Xk48VW3Mj9g4Nyc1Sytp/5FC
         UoEQ==
X-Forwarded-Encrypted: i=1; AKwUvBzlGyuhKGWu03LRxIr0S2D/PYX5IGNIUNaiYI5CvXkp8FX2D7g+WUCYxnFDyALgHZkXRBpiMpmPo9M=@vger.kernel.org
X-Gm-Message-State: AFq9FYKfbQ3v/TO1TSSRSZIfdZo52siJSJLEpidY/TM0UxfhhZtm9/jr
	S51ZBKCI3SUN2C0Hq5eV9Y3xDdu9o0OkeXXUfDrgvLu314Li9U+GtdMsP857c0uVT/0=
X-Gm-Gg: AYBFou2f5hkmwj2dU7LPQP6SHAZg3kE+A4xWHGup2204t7F60QvKCWxl2/fqSbiuBct
	cgBfeSAXv8zXm81dPZKfjAJkwjU35c2rPHEbOcXtxXjFVLNq/+icZZU89guvhN/uZblAc5hcCks
	RggY7ytAd7UvbNe1OkQrQl15LQ+F+AqaSspD4Cx4TVME/FKmD3SECSBZw/zvFuloUjZUxC49Vpx
	y+WlVE+TAb5Gw7jDhVA7VJglz/U4EEsKnxypc7/kNUZlpZfrXDWLonens4QPp7gBL+nCE42pv5W
	uhk97HIq0ByVVp1wpuNOP47JxCrQF7uKMe04c+2Eg1n1iFpbjlJ6LoJF52YQMyRK/jGDQV4uexX
	DsDsdDjVSYv/7YsviN48GKU6R3UOsjmijtbbT7uWOzamC97oh6IR029Scs90zpvU2s6dQQtFEo/
	sCoIqP9NznptVEvjVC+fDyIVcZT+8HLA1dcqzSWMJXBD0c/YwmQc7wbc+tW6vWAqc7pFBY9ngMi
	r5AjPaJxhxmHxgTl/lI7Q553YRAb9ICSZzLJMdmaYElPd9Ekd3FLZizTsvyOTz/MTVX1WDkttPw
	uEy132ND7/w3yf46jrV12NuyvW05
X-Received: by 2002:a05:690e:1183:b0:678:fa71:301c with SMTP id 956f58d0204a3-67a7b992b9amr1910178d50.7.1793208085931;
        Wed, 28 Oct 2026 10:21:25 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a0c31cfsm2144554d50.9.2026.10.28.10.21.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:21:25 -0700 (PDT)
Date: Wed, 28 Oct 2026 13:21:24 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matt@readmodwrite.com, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <auIvFBlNU5N_PVyd@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
 <20261027150002.318916-1-dipiets@amazon.it>
 <auISZ5w318zwUZuc@cmpxchg.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auISZ5w318zwUZuc@cmpxchg.org>

On Wed, Oct 28, 2026 at 11:19:08AM -0400, Johannes Weiner wrote:
> On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> > 
> > Hi Johannes,
> > 
> > Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> > before these two patches land, so Andrew parked v6 at the tail of
> > mm-unstable and dropped its Cc: stable until then.
> > 
> > Are you still planning to work on 1/2 and 2/2, and if so, do you have
> > a rough ETA? Or would you rather post them as a separate series as
> > they are? If anything is needed on my side to move them forward, I'm
> > happy to help.
> > 
> > For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> > no performance difference on my benchmark with or without them.
> > 
> > [1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/
> 
> I'll work on this today, will have patches before EOD. Sorry for
> dropping this.

https://lore.kernel.org/all/20261028171719.2043421-1-hannes@cmpxchg.org/
