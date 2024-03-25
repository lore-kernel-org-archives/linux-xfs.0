Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0A313BC05
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711389245; cv=none; b=EMzCL3pahpiFfN1jEq4isxvJXrkrCZAbXq0xBnVlqsB+n+8clPcvf3aCnLd+AkvlWz9f6AJTL6A+rlG2rrA+EhluqQiJsVqyk/wbI9cFVnFmgeRwf8VfgNZqoO8ckMxCJXfUfwZEvYYO+JeHfuNDVfzR0Ks5bSjp2ya2H2/MQnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711389245; c=relaxed/simple;
	bh=QuPWzQvUuh8crIGzC9WvTG26Fk19wPl7WCIu8GHp1Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ml4qLcJAbyYp9gL4lmFNef5DCTjNGkofo2b+1lfI7hnaxirxqqZdFXXC5gwtPk2HE49CKdxU5H7XqBzHUU3c0XL4v9aBjUPRORNKJHIjHf6fo44w/SAeqT6r0pidrUcvnedyIGumMEpbDqEQhqzP4OLqVEkoZEJR6NJttFiX+aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=UryULHQb; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="UryULHQb"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4V3L2w0nhjz9spR;
	Mon, 25 Mar 2024 18:46:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1711388792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LeW/80LLELbDXG6lmTnctliU3e5K4P0PV8m9dTnX9II=;
	b=UryULHQbJ1hmsv392a66CH18gFV15LlyAZm5bMoryXIR7MtTDZToXZZ631w54ymNMaIP6S
	i8TdXP+oknMUZZcBBeYtPZRcr48NHQCt5REEvMNI6Jc2VcIGJkaYLGa+BwzfnQ0ldQUTEN
	pNXVIhxangMss1la5Jo5I3QV3WWKpasVREz18cIxnYeUpO3OM/FmC6o3qiCtAjFz6QYu/D
	lcXTDuZ9xexJxaKvombo1nbdR4nPPJ61eS+Vh/ZabgU8RX+v1v/lOOLerArMquS/cytEMu
	JyVutDDJP8f/jc9PLQyux4t3h7znVn8LrsdrZaQo/7dUqfRcdpE4TD6RrF29UQ==
Date: Mon, 25 Mar 2024 18:46:29 +0100
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, 
	kernel@pankajraghav.com, mcgrof@kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS
 usage
Message-ID: <y6sfzed3vgrgx4rmguee5np262d66iq7r7cr6k7lapth5bgk5j@v6tig3qf333p>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>

> 
> The first part of the series (fs/xfs/kmem.[ch] removal) is straight
> forward.  We've done lots of this stuff in the past leading up to
> the point; this is just converting the final remaining usage to the
> native kernel interface. The only down-side to this is that we end
> up propagating __GFP_NOFAIL everywhere into the code. This is no big
> deal for XFS - it's just formalising the fact that all our
> allocations are __GFP_NOFAIL by default, except for the ones we
> explicity mark as able to fail. This may be a surprise of people
> outside XFS, but we've been doing this for a couple of decades now
> and the sky hasn't fallen yet.

Definetly a surprise to me. :)

I rebased my LBS patches with these changes and generic/476 started to
break in page alloc[1]:

static inline
struct page *rmqueue(struct zone *preferred_zone,
			struct zone *zone, unsigned int order,
			gfp_t gfp_flags, unsigned int alloc_flags,
			int migratetype)
{
	struct page *page;

	/*
	 * We most definitely don't want callers attempting to
	 * allocate greater than order-1 page units with __GFP_NOFAIL.
	 */
	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
...

The reason for this is the call from xfs_attr_leaf.c to allocate memory
with attr->geo->blksize, which is set to 1 FSB. As 1 FSB can correspond
to order > 1 in LBS, this WARN_ON_ONCE is triggered.

This was not an issue before as xfs/kmem.c retried manually in a loop
without passing the __GFP_NOFAIL flag.

As not all calls to kmalloc in xfs_attr_leaf.c call handles ENOMEM
errors, what would be the correct approach for LBS configurations?

One possible idea is to use __GFP_RETRY_MAYFAIL for LBS configuration as
it will resemble the way things worked before.

Let me know your thoughts.
--
Pankaj
[1] https://elixir.bootlin.com/linux/v6.9-rc1/source/mm/page_alloc.c#L2902
