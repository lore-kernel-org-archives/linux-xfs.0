Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AB732E6BC
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 13:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790085382; cv=none; b=vBBbc4VZHaiiqz52i2uRHs/9XWaMQvQkHpmDfcKBO4RLuzPt/k857Ud0cvMgDs2cnfzR952WSHuuk8+Vt3fpfM6aGJKtVf9TSCA6DyDEs0Cbaikb9L+wag+MIVGMeqlfc75bpUZdaYkYEU2NAQdpUbfXIlO4kX+fFudxXwkFd7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790085382; c=relaxed/simple;
	bh=qtDivFE1nRVXw+3uzHe9eEkXALgMbbD+fmnKuWndtLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+Ui7AOfb2QanDtboxa+iWmDTkmP4cAAgkHVuZQ/G3kMCdI1FHcqNnMMUHoOp0iIibPn+EwnypmPBFSI8nD+Zhsj4RAtKtFrJxCmqACVZnm+gWSvP1Vjh855aVwt9bAcya0BRN2F1XkbemoEDls+DibHADQcdgocjH8XLdeN6SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=WujKLC1p; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="WujKLC1p"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93c1c71fc6dso39518085a.0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 06:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790085376; x=1790690176; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hGu1NCAbAsmG5udT7RRBzA29qW1Tatxi7P64YgMVTYo=;
        b=WujKLC1pLyMIV7C1PC6+pxhnVRNf6NhqS9lptVEWycA+sHsFcxBLI6rKYNrly90pUc
         eHKMglOylGOpMfQLV52xt81UZJLoN+8WqyENe/SqFgAjcMN05B/0VKIQeHKvrexixmhL
         /v/KiGiL5Ew4YebxmXAGPKmKYavtlx93y4mnrx+DCGOcDcML9NdUuHDfXhD8b+gFcU+Z
         C4Jni3U4IkuahUyPXO6h2BU+/E+3NUgt/yD0b9YlRCzbAElY+u2ztZGa2kLZFXudZ/QX
         7j/dQhKaY4r0xf6hJtwXTpuds1cneMbkswH9+AxszBFr+4QfLncJlHw9mWF4tQUglOnl
         AS/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790085376; x=1790690176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hGu1NCAbAsmG5udT7RRBzA29qW1Tatxi7P64YgMVTYo=;
        b=g24JL1vpPR9QMqycWzk6CWC2uKLWJpycffk8cgh1Vpd5oXGgHugMeenFPwF/tErYtr
         za7gwyHkN/ulhWa0YsscANMnY5TxUozSh9pD8ktfOy3Pc/xEsl2SSsVq4dH4K9R3sAMN
         QSCScGTHaT4qN8AbKyjpyGixr78eaVpbhJKZmUub4hqShFxoM9dNnzh4nPC10UoDA+qp
         pkAiZAkTd2BQCCbdU4S0WxFxRg2N9K5Ng+X9XUCc5KHxCOXyZEh1Od0pIukBl8/1Ivje
         EMyKHUOBHXRamzfAUOyrjDuDF4WJf7N8OFuR30GqzmO4NIxwD03W4IFTP+L5tWh2MEDV
         8EXg==
X-Forwarded-Encrypted: i=1; AKwUvByNF4rvQa+8rwOb3UW80+u8JyAwpbp6bXr0nypsjjFyYtpkBeS+C8Xq8BlSMisZ1lJLDs2lFiPWTCo=@vger.kernel.org
X-Gm-Message-State: AFuF++lhgGBluXHD1TePS5P2R6V+QqyorOnOHk3OPkYeBs3+V/zGTC1s
	EJesWVpAb6ip0bFywO7AGiS+l2zxIf4g7RCYV2ZUSfCYTtj4RGMjGBa8Fgou9Ygj3x0=
X-Gm-Gg: AYBFou1u9FB423w45zH/NgKxhR7lVLnwtkyIs8e4X9cQubdfbK4GbLDOb7f/iLOZaEQ
	y771tYBiJjM5y3wDBtMti3TSXFsPsFoNw0a4R/h3ZHnSJFf2jGY1tUOvkAqpHs5Rs36pIqFauNw
	uo4q/e8BXUocxXp32ra2RwDOXd/g4Teu/TqBwNNnNaAr79Y0fFmFGyfntXB9G0mc7VCF3pKu9OI
	sIQpZZ/1/Qyv5ZNksKW7apYQ9M0rOUP8tnAvKA9+ec/GQsGyBrEn4xgg6fiTKZXtjl9xC/oCdON
	mnyMYHt9JHmhSeLkz58jeFTmuyLh9JcHVyeVIuPc4PK4DAzJ3nlcyAoT5IFMA6mA5ZD108QXHBJ
	R+UgHjvhewE9p/asltsZ5wk+oq9X6qN6GK7+4Xr18991K7+Ugs1gffkVsQZO+4OzZ1ZEwYkT2Zx
	tYDKF79gQCH4uXrTmVRwL4BZf2tqmiY+TLoNFCMr1Wj2HR38E+OMbCFzQKWUGhaP/HOvXd
X-Received: by 2002:a05:620a:444a:b0:939:c7dc:8712 with SMTP id af79cd13be357-93c17e489a1mr426789785a.15.1790085376405;
        Tue, 22 Sep 2026 06:56:16 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c1d17afcfsm151272285a.20.2026.09.22.06.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 06:56:15 -0700 (PDT)
Date: Tue, 22 Sep 2026 09:56:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <arKI_AwXQxicc_iH@cmpxchg.org>
References: <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org>
 <arFUPOi6gadAvD3E@cmpxchg.org>
 <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>

On Tue, Sep 22, 2026 at 01:52:41PM +0200, Vlastimil Babka (SUSE) wrote:
> 
> 
> On 9/21/26 5:58 PM, Johannes Weiner wrote:
> > On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
> >> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
> >>> +++ b/mm/page_alloc.c
> >>> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >>>  			 * reserves as failing now is worse than failing a
> >>>  			 * high-order atomic allocation in the future.
> >>>  			 */
> >>> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> >>> +			if (!page &&
> >>> +			    ((alloc_flags & ALLOC_OOM) ||
> >>> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
> >>>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
> >>
> >> Would this be slightly neater?
> >>
> >> static inline bool may_access_reserves(unsigned int alloc_flags)
> >> {
> >> 	if (alloc_flags & ALLOC_OOM)
> >> 		return true;
> >> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
> >> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
> >> 		return true;
> >> 	return false;
> >> }
> 
> I think it should be named e.g. may_access_highatomic_reserves() as
> may_access_reserves() is rather generic and would seem to imply an
> ALLOC_RESERVES match (see 2/2).

Note that it doesn't actually check ALLOC_HIGHATOMIC itself. It's just
the hail-mary AFTER trying the primary migratetype. So the name still
doesn't look right, and rmqueue_buddy() reads kind of awkardly:

if (alloc_flags & ALLOC_HIGHATOMIC)
	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
if (!page) {
	page = __rmqueue(..., migratetype, ...);

	/* Allow OOM and order-0 atomic */
	if (!page && may_access_highatomic_reserve())
		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
}

It would have to be may_access_highatomic_reserve_as_last_resort() or
something?

Hm, this is a mess. Looking closer, I think there is more breakage,
name aside.

You suggest in 2/2 to use the same helper in unusable_free. But I
think that's broken. My 2/2 does not look like the full fix either:

The fundamental problem is including the highatomics reserves in the
watermark check for any allocations that first prefer a different
migratetype - "regular memory". Any time we do this, we allow those
allocations to draw down regular memory to 0 based on the presence of
the highatomic reserves. And when reclaim, swap etc. come along there
is nothing left for them. ALLOC_NO_WATERMARKS e.g. permits ignoring
the wmarks but doesn't grant access to highatomic *freelists*.

So I think there are two choices:

(1) Let *everything* with some sort of reserve access fall back to
highatomic, or

(2) Only allow ALLOC_HIGHATOMIC to include highatomic reserves in
their watermarks check. With limited opportunistic fallback to the
highatomics *freelists*, like the order-0 atomics above.

My intuition is that (1) might weaken the highatomic reserves to the
point of uselessness, and we should probably go with (2):

watermarks:
if (alloc_flags & ALLOC_HIGHATOMIC)
	unusable_free += zone->nr_free_highatomic

freelists:
if (alloc_flags & ALLOC_HIGHATOMIC)
	page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
if (!page) {
	page = __rmqueue(..., migratetype, ...);
	/* Opportunistic fallback for order-0 atomics */
	if (!page && opportunistic_highatomic_fallback())
		page = __rmqueue_smallest(..., MIGRATE_HIGHATOMIC);
}

> > I tend to be hesitant with single-use abstractions, but no objection
> > if people think this is better.
> 
> True but single-use ALLOC_MASK_ATOMIC is also not that great, and the
> usage makes the code hard to decipher. And see my reply to 2/2.

There is one small upside, which is that it pairs with the
ALLOC_HIGHATOMIC check that precedes it. The comment says "order-0
atomics" get a hail mary, but there is no order check. That order-0
comes out of the sequence of events here: we first check highatomic,
which is order > 0 && atomic. If that, and the native type, fail, we
do the hail mary for atomic, which must be by definition order-0.

If you abstract that privilege into a generic "can access highatomic
reserves" without an order check, it tempts refactors that cause bugs
like the above.
