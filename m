Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793200755;
	b=cXRQ6gmxgO4P9UlRwv4RPzeMNYQxsNpT3Hf4A/Y/e6i35EDbCcIdKvpP//COTGmaxxsM
	 I8F9isy8wnLIvk4TummYYl6/B3GnWA/0uPFBPj6mkqPHWiFqPIyYDwWxWEbz/mlFwwAAM
	 hffesScho/vlhLiRw58JkcHnKPT/Kdt2W/ieExGWzg0OKAlQl0CFyp6c+ZN6Cwbi36efV
	 O0euGB6VxPpJ4rpwhPQKCiB91p4oxlP0pB+SlCjoJwyT3hlnz1SDfmxuDBSUDaNwDAfO9
	 XLepPjrEk6PMnjWjQixS0ia49o+p4Z68YxfihdAVyZtN/UbUnS+JWLOkd5bGfaYvcLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793200755;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
	b=0aq6GTjGLOFLqJG/kxAkVMOrwileLChAFmYrsYRPO+TIqTPQqmoAUTvHqyDID5Uq8zy+
	 3Bjb1qtMLj6ITvTyzZKbsAGTe5FFYKNeUDBJ0ukkSL4b75h28iIOgRhtdY+unVkSklpEE
	 /7w6FinGLBctTfisKsHWxoi8AIOB+ximXG8ijDb7wFk11MLcygon2Fg4B9i5lMYSvEaGg
	 D4v409CJFBqZzu+oiAqHLKACAlYcElPDLzXLafS9+V3Ts5Vqgu2yN/hNF6PLXTwpwc+7Q
	 9IZo7sSFOdn9hhS3vqVLvMLOW+0Eec+HuMzh3ZObCT4bpPdj69bBsZVOueCX/WhK9kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmpxchg.org;
	spf=pass smtp.mailfrom=cmpxchg.org;
	dkim=pass header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=nhK8cGaG;
	arc=none smtp.remote-ip=74.125.224.51
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC93606A31D
	for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 15:19:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EC93606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=nhK8cGaG
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6798eb0d190so800356d50.3
        for <linux-xfs@vger.kernel.org>; Wed, 28 Oct 2026 08:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793200748; x=1793805548; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
        b=nhK8cGaGFswEzQzn6jxV8d7rWrcdufVj9AiZWeEMEA/Wupaev46NciUKgGJUUt3ByL
         uao2VGURsbYEidWyayLH3DVOhUbQRhSYSuzIu28/fAoxmcIG0WedVAvdu5647p5yknP8
         kWlj+kneMmtUzA/yOYN4x6liHGLFt1vXF82qlxKhaZtv3f+2egWqfsBb2ENt6uJ2RXAK
         NM3tLDc6FE8jxJ7UEeKozD6X9whokC1ta0k/a68oKBzaoD7h1PjK5rMScjVHyC+rtG+2
         yJm2ktJusv8LTxfcvqDJq5ure6P22NbWO1Uf2DYmUx2A/mXHzlRtHpSXAc+UmBBZ4N7H
         mldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793200748; x=1793805548;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
        b=cqvMpK36EOmqZQhc7AhWKfAc+SeXQHpRzQPY2jwA/TIwKos1KU7h/3oifGl1UKWHAv
         E5YbAwQQ5IqSnYT9NV4YuBYTHrlL5GBLzl49ojY+7tVg7JmvlMtKu/OrGAh6NJ1QUYUy
         JvaUPyOPD3AfHnKo3R5cU7c/5j/jMvDcxby49odbejuQMDKnYAow+o+yV+lwdyxIZG2x
         5dEQpYqk3npi15eyMhFSuqgeqpliwAFee0smACA2x1ZlTe3y7uV4Yz/0wSVRpC3vVrOL
         RG1CzsZE/76VyL1FHYUZzzvPzwe+g8jjx+bnETAL4cG9H6V1lolfbzwPa5TPI2soVEKK
         IgqQ==
X-Forwarded-Encrypted: i=1; AKwUvBz8E0+r67z7OceC5Cvat9J2XkClb7gEnUBwP1VpMSj8jWK3btfgMHLlfsYLv+Au3lNiTPVbjw1QSoY=@vger.kernel.org
X-Gm-Message-State: AFq9FYKd+/OfidkEAvMUZoKN1E1y9ctKXcsp8pF4yA++/CxQn1kB7VQE
	WoBDDABHWJcPM9Q2qFoD1mMTCddG/F3DcgUy8MbHNBtWbN6tiQ5i508rX43gGhCxHxM=
X-Gm-Gg: AYBFou1hDNzRbpD2v6gh/y2RVJnsJrIiHlrSxmWFsqLVsoHEzOkE9Jran5S2VD2KOz/
	PoFiz++RNMyeo0EdWwZdNJDCM4LIpyCP95GAkGbH2Wy62FPhUXC4VY60v9bMOA2bKF3IUeCeCx3
	iVaodpTONo4eZaX9yLuKb1F1TE+OFDR3ysrHByrQKFhSZFQ4l7Tnro1D2rJsKVtBCWXeaUTTrTh
	979Nv83x+7zr8A+mGNqDrAw2HvVD5o6n1Zux1LpPDJcrs9djiMZsdPtuKRJXs+EPgRrvSx+JknC
	tonWV4E1EfVvAsj6S8L1Lz7utHRns7Az70mCdQV8VbEpE4KIjd9BQHrYj8GkuMvFZ/m4+Eol+UF
	qkcj7YvkAFziHH94JRPu4VB26TqSqj+4eBIHDWpUKB1xYuyitpPfYaCd+7AfhNPe9mJv73S+lea
	cAO11B0JRyLr29IvDCGxFLUmOfe7v5LPb/kAEEz6KM8NJ1v3XDkgm1/8Wo12cW70OEWnjk84r72
	2sEtBl1gvQaVUDP05bQfeq/jQ5z2QXM0J8BGkRW5Zj9sP/+cfQMUoMop6ecKtjj9KD43y1XQJXJ
	CU/gmT3OtXQ/RnANiEU4FFZZYgYr
X-Received: by 2002:a05:690e:438e:b0:671:4cca:b8ce with SMTP id 956f58d0204a3-67a7bcdc2f1mr1541191d50.61.1793200748154;
        Wed, 28 Oct 2026 08:19:08 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a19ac69sm1870050d50.21.2026.10.28.08.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:19:07 -0700 (PDT)
Date: Wed, 28 Oct 2026 11:19:03 -0400
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
Message-ID: <auISZ5w318zwUZuc@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
 <20261027150002.318916-1-dipiets@amazon.it>
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
In-Reply-To: <20261027150002.318916-1-dipiets@amazon.it>

On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> 
> Hi Johannes,
> 
> Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> before these two patches land, so Andrew parked v6 at the tail of
> mm-unstable and dropped its Cc: stable until then.
> 
> Are you still planning to work on 1/2 and 2/2, and if so, do you have
> a rough ETA? Or would you rather post them as a separate series as
> they are? If anything is needed on my side to move them forward, I'm
> happy to help.
> 
> For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> no performance difference on my benchmark with or without them.
> 
> [1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/

I'll work on this today, will have patches before EOD. Sorry for
dropping this.
