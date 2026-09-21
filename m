Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E324ABBA4;
	Mon, 21 Sep 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002488; cv=none; b=qY9RMJNZFGtYrrl91ajzBQDi400nQKsFCs26keA9YH4pUm5jfxlYuCc9XjG+Ctf/EhxARAM78feP/7Q8Hy4vG6BdVq2UcUgukDqVlyaJdqiijyMGBJU3yAbIYJJ5jERuVkniq+jo23psweXQBZojgk4IqkYpd93XLwhoGhrJyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002488; c=relaxed/simple;
	bh=5QFCQFDjhODdCLpKEyO/gl47cnBEBVJqDp1CjaSJ2oQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtReMFAEcs3XUryGjJE6ttaBFBwyslkPEX2L+xaIcZWy/lpjI6am1vqzujqw+yM7O+HfcNE4WUjiMKOdi+BpoiHQbL/R8ssduES8p3pvhB2ljLe6lGYwpUZy0ZSVJ0yWm/Q7h76HTI4Zjc552QKvr5GpP4YOFHd8MaxNBebIpg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hZV6kriX; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hZV6kriX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rqlA/SOMNSxfDcyCsYYeHxoxozBGMH/JHbYHaj8T/5M=; b=hZV6kriX7nqpeD/vjJn13zCehc
	wy+WRvLpFUrnbR1i/8VFcEoU5fZ7P6IcO9HAiDwPU9Y3O7Vi37TYKqkOsKC8m3optDaKOtQbNv6IT
	ss2cjl+f1umh9Hz7JB32YovekERtB+qlR5Zoc9KHxly8LajlE/poezIBAxnUIUhKgljsaondbbotN
	oJ3CzqukXTdvGU21l7pvC47RYEO4i6ijn+5ATuopSr3czOxQ41MUDtEvUuozy/Q+v25aoljs6CSxD
	JfUM9ogMtmPDJSN2F7tvwgbZ7cYDp46i4HVwS7JWjigCWQETbOicNdi+7OwXZhAfCMI2FLfuHT4Sk
	chYdPHTQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8fPc-00000004Tjk-3iUT;
	Mon, 21 Sep 2026 14:54:32 +0000
Date: Mon, 21 Sep 2026 15:54:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
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
Message-ID: <arFFKGrpPwtTkoCi@casper.infradead.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org>
 <arFBWvzXPYrKuIYi@cmpxchg.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arFBWvzXPYrKuIYi@cmpxchg.org>

On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
> +++ b/mm/page_alloc.c
> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>  			 * reserves as failing now is worse than failing a
>  			 * high-order atomic allocation in the future.
>  			 */
> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> +			if (!page &&
> +			    ((alloc_flags & ALLOC_OOM) ||
> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

Would this be slightly neater?

static inline bool may_access_reserves(unsigned int alloc_flags)
{
	if (alloc_flags & ALLOC_OOM)
		return true;
	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
		return true;
	return false;
}

[...]

-			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
+			if (!page && may_access_reserves(alloc_flags))
 				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);

