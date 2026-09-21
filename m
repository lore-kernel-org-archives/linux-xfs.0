Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA303F8250
	for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790001454; cv=none; b=duzwcqnKONFZ6hapwTOkMBn+j3Ft+kMQzLRaMi0n7jgAK2VSyiaxNG5sGFq+z7I8Jdpsci2UfG2wVlgpcaQkHy5wg9f8ZNZFbYjMD7f79RMeCcODunZMxAAD1N2nB+ISCWHLOneBBwqHa14TZnNyKJ+4d/zVLKUPNSR4jgirD44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790001454; c=relaxed/simple;
	bh=vu2KvWKFFA3N0wzDMJWi0oZ02CuH0BR9UkXp9PpwQsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aLGqmj2Lj1HIgjLvw0ngR/mP0nWq0JGBNeFBGEV0CBhtr2AWedGJDJ3umZFejpr5ESxzCHrs8sBN/2MpZU1acSNZdM4+T8rio+8aqIrY2E+3KucddrZtumKIBpsnHSfq6Y/uUi6CaJ39w1ENNPrceC3qhSPnoRw9uM+uReu5Cug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=gGjAZSOE; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="gGjAZSOE"
Received: by mail-qk2-f41.google.com with SMTP id d75a77b69052e-532d63f434fso5243241cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Sep 2026 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790001450; x=1790606250; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2vUrOHpknLsQODHI2VwdgOODmPETkIBd14WWg0Q6gUI=;
        b=gGjAZSOEjIaxKx0rdVUPsz0SmRs3cCI08XIo7lwjSMAEXPTKAEcXmZWfEfW9Jht7oH
         7A3f7/UR2wrlWGhIMjUyeXMBZhb5+HiqYfFUa5XaNIDDTPJNjSKEVqr3fIplf2Dh1O4r
         1pSWQgbLLvt78yRTbyF6TGbE6SfDlihfWkHWPU0Me9nFoF2KFgjUy/k3G+sZ7dOCAS0E
         i34EpHTE0RXK+DzLa4XGsx7b26hET134pWpl/hCSYa57CnNu4VhKTr2l0FvCSvYjCBHf
         EpxF/E8EooECmNpNhBWyzFr7BRvmBk3c62TWnATpVP9a87EVkhOh6xZP7zc0OZjDm+AA
         ln2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790001450; x=1790606250;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2vUrOHpknLsQODHI2VwdgOODmPETkIBd14WWg0Q6gUI=;
        b=i26kJ9xWQr6/XzsCJnjbhj6ZMBql9BLpwNsLUmczb9qMU+M09luLCaRziRUpmqcYEh
         VcpBlWKcJpLUOPUA+YFShffH7VVcnd7Z2flrstXh+mh+3JX0f4rcbyeWTwR9pjMhoOoG
         sYbtqH6chvQjIYj71HSM4h3vERwLGoLtjD5DJCrbJsVdW+Ve2manGf2nMlmvf/kLWZ1d
         /10hFO9VjfA5NZzwRd3hMDX9ytkokvoj9k3m97n7ZWaFyFWHE1KQo5qYxPUe0hypCgKZ
         LaUsC7UkLyWwhbmeyx0bz4d3R2woFiyZkwJ2b8aE9TrOO2Yp4f1BR4Xaad/UbEfPp+nd
         rpLA==
X-Forwarded-Encrypted: i=1; AKwUvBxzujJV4/dpbNlE5kg8lZheX6pdbhFc/S3sn9SfZM1eHcQrX/XvWO4CwzfljTf+QfzvPTeyhkupFzU=@vger.kernel.org
X-Gm-Message-State: AFuF++kv7xSSbITp22y4hkfK51wcrWOcDAZoX2doHIWYeT2OcHf1ZSf3
	jSjFwfwpGZmvC945H3Edzu338KA4wY71A+C2jtLFKfLhpsTlhW7RmCDGE2DJI9tt900=
X-Gm-Gg: AYBFou267G7lzVqob5ElsbdU8O/4wOr2yMaKQXTzmNvwPjuGss2pU6VJvbmZYOVYjE7
	0mOietP+qJaAQAoYRSmiTLZ3mn/MUbJwl2DByiYGzxeEnmEjnH3gbLOSH8mEhKeQIXvO5WLG25e
	IogF1fT6XbKP8VkIPCmym+kNmM7zdnTCkKTE7bTHhafusMxpmROw6ivbCa62de3M7i5kVySTzuR
	IdsNIYgpN5AOmoMa8R5M06T/h/joCCKPvBkq8jwsiYjUK/ERJMIjo5WNKTWEovrC6KalU3BTrQ9
	e7qlmFNsUmKtP4DWNWEY5u+07Mrl/ztAw2GfR1apriBGMH0cMf2mSCI6TSLAW/3jS3WRh8AjbBM
	jc4XITZlqvya1Dc/k+kpxLz2puGWsl91KI0wUQWXLCuj/tD3qSFNBz9Cc4l6W3akrOxeecgbYeY
	Ry5Jok0T26mnWlrO5G+8N/OtjteR5BJX+VtGQ5EFm89Nr3H5SGUsuIgjE/TNu2WSd1CyAp
X-Received: by 2002:ac8:5e4f:0:b0:532:ca19:afc1 with SMTP id d75a77b69052e-532d8d8a849mr9913591cf.29.1790001450247;
        Mon, 21 Sep 2026 07:37:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae511210sm65434551cf.2.2026.09.21.07.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:37:29 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:37:25 -0400
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
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <arFBJdYaRx_iJNDA@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>

On Fri, Sep 18, 2026 at 09:05:40AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/16/26 17:58, Johannes Weiner wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 12fac9084c48..c79cc7aa4dff 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3246,7 +3246,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >  			 * reserves as failing now is worse than failing a
> >  			 * high-order atomic allocation in the future.
> >  			 */
> > -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> > +			if (!page && ((alloc_flags & ALLOC_OOM) ||
> > +				      ((alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC)))
> >  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
> >  
> >  			if (!page) {
> > diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> > index b9259deddb59..11714ddca254 100644
> > --- a/mm/page_alloc.h
> > +++ b/mm/page_alloc.h
> > @@ -60,6 +60,9 @@
> >  /* Flags that allow allocations below the min watermark. */
> >  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> >  
> > +/* Flag combination from GFP_ATOMIC */
> > +#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
> > +
> >  /*
> >   * Structure for holding the mostly immutable allocation parameters passed
> >   * between functions involved in allocations, including the alloc_pages*
> 
> Should work.
> 
> > 
> >> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> >> concerns can be dismissed and then indeed v4 is the better version.
> > 
> > It looks like a real issue to me, but one that already exists
> > independent of Salvatore's change.
> 
> But Salvatore's change (v4, not v5 IIUC) will make it worse because
> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
> with fallback will start eating the highatomic reserves too?
>
> In that case the fix for this should probably be part of the same PR to
> Linus and be also stable with Fixes: 281dd25c1a01

Yes, agreed on both.

Sorry for the delay - while poking around I found another oddity in
how the reserves are accessed.

I'll reply with two patches that I think we want to go in as fixes,
whether Salvatore's patch goes ahead or not.
