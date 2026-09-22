Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBB361DCB
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085621; cv=none; b=CQUqLZy7wCYDTQPjyALZjAgG1jJgvnpiDyX3dgp3JtF3m1wYqL5/SWtFhrcp+sFV5UkJkTKn/dzoVMqO1BaTYcdpB9O3hJJjqU30YHIc4EeEpR3XN79ksVVb+p5bNjsoQWp0Z0nH7T9xlCgyHFpY3/8uFqiAimBJSOo2YhUlA3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085621; c=relaxed/simple;
	bh=Ysf9kNQ+33PxVdJ0LMg2niyZFgqOnLKjhyylnUl8qTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aEcBbr9tH6Pr1sSBSRVqi8x2yOhSoc+p6XxZWI1OhvAsf3Quayz1O5F0sJZNSAKFvC+zE2gX0BpAeDDJmZvJJ6CkO3075zgEWqwUjTHgn/aNzlXYc4tSokU+uqcfjPgZ0Wm9wyzN0hu6l/wxjDQTsUe6PfFNgRuhSaTxja98PNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=cj7O5gEk; arc=none smtp.client-ip=74.125.230.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="cj7O5gEk"
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93be29bb454so475272985a.1
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 07:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790085618; x=1790690418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yVPAItgeW/MMs80EWUUxpddBeukv+Oab4KQ44WwQXwc=;
        b=cj7O5gEkRJ4IMPNvVXC4spsO4XZqIreKj/4TIEka7a2Tg2X69W3ijpeXyd1yJJfa6Y
         /EDSrpGD54UCGGnzQtNRkoGJADXwaJ9xhx0B9hkHKLwf91mL4RrjJQuvAnCr6GWQrgZy
         jRj2Rc+yKC+DSwBJAdjR0lGH3+22cHex3hSjhFeje8vbtTp7nQyLYGVbqJ6TcMP1KDW5
         LFSZS4sarD0yf6habVL5nm1pizHGRPz/i+fFLJT2HyKvhX6OP64PVbmjaZ4oCE8KPFwc
         gv8uzwp2v9IamQ0RQQNSkAsvc20TKsvLH4zskQXRm6ZWKb/wx3PxhWLp6AUDYu7llg62
         +MlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085618; x=1790690418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVPAItgeW/MMs80EWUUxpddBeukv+Oab4KQ44WwQXwc=;
        b=xcz4zP42HFDiG8kluxDceAZHDUgFRg6qpOT/OT1257SMSn2muReRquJEnvWurNx3rC
         G/7R9EkdboB/S3fzpmuvtdJXEhV5aLC0CHIMyyS8KlldnSk7qLFXJ9S+2s1DmsU33Hsj
         fyT+Wt1KN08zqY7jeprtguCM76kakRLVvQxLEulwin8dFvMHcTSIexl4uc+t6MjcBAmX
         6RQsB/HBgm0dKAxQ94YBq0kQqQ/nCdG/hohk3ynzClZ42f2mdpacZBDIe5U2BAAHqFTQ
         PnxMhiClaFSehhDo2FnXFF3HVv9uoPqcakkTQ3qxtUUiW9qlKdSqwiGT+PGIXELX0mXj
         mvLw==
X-Forwarded-Encrypted: i=1; AKwUvBx8ue4Ialvvk8U/zns+9mAXQun/IMWXiOYrXRm7ewjwVLM3H0Pvl+qhEoVxc8ui82AI0sv8FUsPYOU=@vger.kernel.org
X-Gm-Message-State: AFuF++kIyPLsNjdcvAoOOKBUzhw+ZLTRb4v1JnZXs8Fm4WyLKNTbsRzo
	4lp0Z8OnZltk/fEuuAs0NYqeifS2gwU0DcEutme0vXFZgmMoTmyh4pJhda1UmV6Wnyc=
X-Gm-Gg: AYBFou1az5iHVKW6B8wuHkTwxHVlWhaWTNQJba+M4kGnnnUNk6VE9jQjF83ROrJKsN3
	z8Wix+ZjRff8QGbwwL/VJlTwrAg+LZVD6hkIPdpc2qSNY5r916uyBnMiz+/gubgBbvGrW58G/pQ
	jd9ZXjHxj6ZRLdXMpZ6KX6kTwLiJxcM+Tv9531ar/BxbOaK29D0KcOcebqCslDqqjVVVLwQAosS
	IxgezVPY+Bs5KNKXi6Oh7xaHDmWOKWbcp2+bkiFrCVGDuRmTQXsEcMJAEoCf+UG+VynO17/3/Z4
	Syi2sQIQ2ja7bxD6pA+k+zio01yMHY476/t7q34ympUNEx6BrtRKbXopvQEK3QFUHKzRO+qeJbe
	Fyy632w9T242DBZO51s76JW4aUeVBMwzyVZqb2PjTDKo9luv8UO/9QJE3CqLp1ZLtmG9ZH3qlXl
	95FcoAWvGShBxpGfiuQb3sY09h2KNbd3V26zkRUS+WbuWv4aJqq1Vrr6MWICndFSszq9kE
X-Received: by 2002:a05:620a:298a:b0:93b:d7a0:d9f0 with SMTP id af79cd13be357-93c19a9ab32mr348786585a.74.1790085617903;
        Tue, 22 Sep 2026 07:00:17 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d23e22esm152156485a.40.2026.09.22.07.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 07:00:17 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:00:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
Message-ID: <arKJ8BXOXknpmiu4@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBr22V60BMmVpl@cmpxchg.org>
 <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>

On Tue, Sep 22, 2026 at 02:06:34PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/21/26 4:39 PM, Johannes Weiner wrote:
> > 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> > non-blocking allocations accesses reserves") stopped handing out
> > reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
> > min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
> > flag was left in ALLOC_RESERVES, which produces something odd:
> > 
> > With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
> > subtract the free highatomic pages for them. So in the slowpath, they
> > get to consume regular blocks below the min watermark by the number of
> > free highatomic pages. The highatomic reserve is capped at 1% of the
> > zone, which on any decently sized machine is a multiple of the min
> > watermark: GFP_NOWAIT can drain regular memory to zero.
> > 
> > The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
> > allocations under memory pressure. On a 32G box with an anonymous
> > working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
> > burst drove regular free memory in the 28G Normal zone (min=60M) to
> > 28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
> > table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
> > for tens to hundreds of milliseconds. The machine survives it, but not
> > by design: direct reclaimers eventually fail and start unreserving
> > highatomic blocks, until the allocation succeeds or the reserve is
> > gone and the OOM killer runs. That reserve exists for high-order
> > atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
> > consumer that was never entitled to the memory.
> 
> This suggests to me that a LLM review of 1/2 spotted this issue and also
> (or you) constructed a test doing the GFP_NOWAIT bursts to confirm the
> impact, but it has not been observed in production? But if it was, can
> we make it clear?

Yes, and yes. The test is manufactured, I just pushed it to stick to a
realistic sequence of events. But it wasn't observed in the wild.

> The change itself is fine and we don't need ALLOC_NON_BLOCK in
> ALLOC_RESERVES. But I wonder if we should also make the
> __zone_watermark_unusable_free() check more precise, by using
> may_access_highatomic_reserves() there instead of ALLOC_RESERVES?
> Which would mean that the function should however also evaluate
> ALLOC_HIGHATOMIC, and restrict the other checks to order=0, to be usable
> from both callers.

I responded to this in 1/2 because it had more context.
