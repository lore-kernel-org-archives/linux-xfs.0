Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D0971B29B7
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 15:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724943910; cv=none; b=rvVWFQ2DPyzA2jUb/sZ3Ulp7RLMiUtYdSjATo4jNAOs3+iwb5TJ33KBAaNMnL10j9R0tx2micBAjLG2hQkbaFaXHtHclYgoD3CVyFZ4DbFAxX7zAisy7W74v5TfuHwcrSY3Y34BD3Q0b8stMFVlwbOydJw+zyRCmTClYxLjItoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724943910; c=relaxed/simple;
	bh=hkK67Pa+UTw8SgpZObrB4L+YTrQEfv0f5ogPxL9+SAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VOJIVm0i/ZXSdTlMRrGKrE5wd1g/jZfVtqIwECY7aeIKCFDO0P9noe61fDT2slHP4KeUdY0duXnKfO+JrqkJpx9R6rNoT84KTTD71HbZQNPw/kQQ2vixZUpJmnJhLjZo5uEbAtMnTGF9nG/k3Sg/Tcy3PzkHBF+r9n/Anu8EDkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f7Qkb5W9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f7Qkb5W9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724943907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GEtXAsylG9E/XUImBTmGYjj17sWH4GzEv027Gz5kyGg=;
	b=f7Qkb5W9E0K3aMGReSIWuo1akefqSr/Cs+2hRQeLdj8UW2JfuZ1O/YXBg8RIln5uwPDe0E
	2BUu12z8DyGdf0s9Z4swYy7zv1Nw0FmCrLZVpQNMc9wwmgmLIc1xy1zqkUR9crXQu3CTkY
	B/6li+2+Se5VUQYwOpU/wgSgqxsJnT8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-554-enIIUyQGMdaCy63USwkcUQ-1; Thu,
 29 Aug 2024 11:05:03 -0400
X-MC-Unique: enIIUyQGMdaCy63USwkcUQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 34F6A1955BFA;
	Thu, 29 Aug 2024 15:05:01 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.95])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B42B919560AA;
	Thu, 29 Aug 2024 15:04:59 +0000 (UTC)
Date: Thu, 29 Aug 2024 11:05:59 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	djwong@kernel.org, josef@toxicpanda.com, david@fromorbit.com
Subject: Re: [PATCH 2/2] iomap: make zero range flush conditional on
 unwritten mappings
Message-ID: <ZtCOVzK4KlPbcnk_@bfoster>
References: <20240822145910.188974-1-bfoster@redhat.com>
 <20240822145910.188974-3-bfoster@redhat.com>
 <Zs1uHoemE7jHQ2bw@infradead.org>
 <Zs3hTiXLtuwXkYgU@bfoster>
 <Zs6oY91eFfaFVrMw@infradead.org>
 <Zs8Zo3V1G3NAQEnK@bfoster>
 <ZtAKJH_NGhjxFQHa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtAKJH_NGhjxFQHa@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Aug 28, 2024 at 10:41:56PM -0700, Christoph Hellwig wrote:
> On Wed, Aug 28, 2024 at 08:35:47AM -0400, Brian Foster wrote:
> > Yeah, it was buried in a separate review around potentially killing off
> > iomap_truncate_page():
> > 
> > https://lore.kernel.org/linux-fsdevel/ZlxUpYvb9dlOHFR3@bfoster/
> > 
> > The idea is pretty simple.. use the same kind of check this patch does
> > for doing a flush, but instead open code and isolate it to
> > iomap_truncate_page() so we can just default to doing the buffered write
> > instead.
> > 
> > Note that I don't think this replaces the need for patch 1, but it might
> > arguably make further optimization of the flush kind of pointless
> > because I'm not sure zero range would ever be called from somewhere that
> > doesn't flush already.
> > 
> > The tradeoffs I can think of are this might introduce some false
> > positives where an EOF folio might be dirty but a sub-folio size block
> > backing EOF might be clean, and again that callers like truncate and
> > write extension would need to both truncate the eof page and zero the
> > broader post-eof range. Neither of those seem all that significant to
> > me, but just my .02.
> 
> Looking at that patch and your current series I kinda like not having
> to deal with the dirty caches in the loop, and in fact I'd also prefer
> to not do any writeback from the low-level zero helpers if we can.
> That is not doing your patch 1 but instead auditing the callers if
> any of them needs them and documenting the expectation.
> 

I agree this seems better in some ways, but I don't like complicating or
putting more responsibility on the callers. I think if we had a high
level iomap function that wrapped a combination of this proposed variant
of truncate_page() and zero_range() for general inode size changes, that
might alleviate that concern.

Otherwise IME even if we audited and fixed all callers today, over time
we'll just reintroduce the same sorts of errors if the low level
mechanisms aren't made to function correctly.

> But please let Dave and Darrick chime in first before investing any
> work into this.
> 
> 

Based on the feedback to v2, it sounds like there's general consensus on
the approach modulo some code factoring discussion. Unless there is
objection, I think I'll stick with that for now for the sake of progress
and keep this option in mind on the back burner. None of this is really
that hard to change if we come up with something better.

Brian

