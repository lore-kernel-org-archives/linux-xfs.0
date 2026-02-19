Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CCC33F8D4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771511945; cv=none; b=YOIgmPSXxadL1IFAAeCKX0Iz7nFGKxn4ZTAEoetIcw1B+mFownqMl+OI66znl2F3m+GEvLnA6K4e7Em/u+krI1mDyaV5j9dZZk4T+NquWLUlUd4enhjODq4Z1+hMO+r3O5F6wFxPf5vPWc6tR1nc3R6u6N0gjIR1IIsbJddEaKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771511945; c=relaxed/simple;
	bh=hCUdqdVshUNpKJ6Web4N76YggE/6UrANGx8QiLFPLC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LL96w0IBcNUAgj0dpHa/rm3tX7jXCFbmlgseaLskMRoABop9X86HWfg6NdmFbq6wCFcYcmDipNSjnym5MJmcP0JGAeer3g7yhLEwVRi7yxo14ym2YahfOuPntRnrdriDCdmkuCcbHoUOafgp21q7K0kr79DkOBw1gIt7nayfKOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b67J68fY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t1Ux0xFC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b67J68fY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t1Ux0xFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771511942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yOvhpaX9tHlMkNrihwcrkfHtkKySAiNqounN6tlAxUk=;
	b=b67J68fYxMalmYBr0Nd6VX5veOMUmVweBtCtMxwK1yg42ylg8scdY8Xes84m7lzl1tri3y
	x/ojzQvum/PKZTP2Luet9FHa/IWXbMKMLqAnQjcSUyaiwxO7rW5Ypg0yvCyzJGYpWqKIxb
	oCe/ttv4uvStQVGxC48kULcR8twlR1c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-73-Q8DMM062OFWutFrMRos5pw-1; Thu, 19 Feb 2026 09:39:00 -0500
X-MC-Unique: Q8DMM062OFWutFrMRos5pw-1
X-Mimecast-MFC-AGG-ID: Q8DMM062OFWutFrMRos5pw_1771511939
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836c819456so7718245e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771511939; x=1772116739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yOvhpaX9tHlMkNrihwcrkfHtkKySAiNqounN6tlAxUk=;
        b=t1Ux0xFCV1rW5RTJ8+lMNe/oLz/sKTovqAUbWiR1xnyjFhcTB6suXxfPPC7AXahwEZ
         pZReHIbwUOtp2IsB3grTGBGs0ziOHgDLblPT4WQRhFlrcDig+Zj5zhi1P/0VaRT4J3Gy
         KV0yFkN63Cw3sqgqkld/xk6ADgVVKLD0NGtf15Gt+pPVy5sNr6ux7pmcWvBMBus9GIWa
         7nwKow5JoM0ru9wt6aWZqdYVcZs/LuEvMdh+nbNs8/nBVBrxd2qT9qPTU2DzXQGLCrF3
         9wrX04/ky4lth05UfAx+1xrIVkBgmK/fpVgjpDdp+LedieWaeAuCgiXZVo7zWT1gJYI9
         5lsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771511939; x=1772116739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yOvhpaX9tHlMkNrihwcrkfHtkKySAiNqounN6tlAxUk=;
        b=jyjwynDLIk1wtBCunCALB/la3fBIj2l/BoOP6nJj7FoTBLzKMVyy7nciPHQrFytoRd
         rR5UuBbRP0jb3dgZMJt7rG8ouRay+sUYsXSyCUCJRWPlcQz8MMuvs9c5CZ/Fni3MqQ8l
         LqGxJTaotEeE2jHH85M/eQt3JObUlkNrmy1o3pbYIzYKsj+auU7NAvQjcQBr+VlY7uKR
         KScn1GwurhcbhCLuvXPknyvPMQgHEkLqSHfIqCdcki0EwCmlFvQLXCA4iwMvVSM0epsU
         IyB9ibkGPwwONmyZ8VUCQBKhtA2M8CVlxkUUOSPhFeuwLBQf937l1EleNaKi3BOOFKGd
         n+fA==
X-Forwarded-Encrypted: i=1; AJvYcCUE55ORd67Ql/owCN6/Ji+YL7GZIxmkLXmFdoEFRS/BiQq6ihprhpqFFUOcefPEx4FfCsUzBURlm48=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW40zhajXZPrkPW44VW2l07hvYuJjChzxNFyuyNirrqp5JI2qM
	Hy+XkgCTyng31UacnJrtwUR+OgktDxESI0Mll/4cam8byHwUhlI8cbT19TMvf4n26CWJa+J9ccA
	t9rxABZoaEjhD8SDMPev0gqgKQ3gpT84zkyQM6K9WQAhWN/0gDqyNtNycolTaVgoRub+K
X-Gm-Gg: AZuq6aLQEm+h/3NgInn/6atp2TgPcWWw+/lNrZ7oiADUKBYYvPlpF5VJ4ygz/fqja90
	YrZkfIzRzkrZLxQfqEHfOFHg5fQWVbZB7M70uZWLDIlQNi61tz/NrwIWMB3ny6wAuBivNxcQI7+
	foYwr1L+JexQKXCMjJpSyC2QNs7zTTR1YIBk+rFBeIVUu5wA8Xr8akdqSeoVLOqqtMw1g3CdOon
	KjjUNuk48a49y/Ldn63dPwTJWg8WgZfGlf2KQYhDX9U/0K8tmWuggGHzmW9IDCFZG5l149thjeh
	8gBD8fT6v7R42a9eygufFYW0n0Le8E2GS9vTWcVeb4LSVqLmBf41OAq71Ln9SZn2T15FOxrTcw8
	AB7uKdBSWRUs=
X-Received: by 2002:a05:600c:3b8b:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4837104307amr424149535e9.3.1771511938911;
        Thu, 19 Feb 2026 06:38:58 -0800 (PST)
X-Received: by 2002:a05:600c:3b8b:b0:471:14af:c715 with SMTP id 5b1f17b1804b1-4837104307amr424148955e9.3.1771511938404;
        Thu, 19 Feb 2026 06:38:58 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839e82f8bfsm41235955e9.1.2026.02.19.06.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 06:38:58 -0800 (PST)
Date: Thu, 19 Feb 2026 15:38:57 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <5ueyigipyfwqvysmx6ejqxpclu3oiy7wwpftnfsnyanu7z2abq@dnceynnumjh3>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-29-aalbersh@kernel.org>
 <20260218064429.GC8768@lst.de>
 <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx>
 <20260219061122.GA4091@lst.de>
 <4cmnh4lgygm4fj3fixsgy3b7xp2ayo3jirvspoma6qxusdgluu@nyamffhaurej>
 <20260219134101.GA12139@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219134101.GA12139@lst.de>

On 2026-02-19 14:41:01, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 10:51:14AM +0100, Andrey Albershteyn wrote:
> > > > fs block size < PAGE_SIZE when these tree holes are in one folio
> > > > with descriptor. Iomap can not fill them without getting descriptor
> > > > first.
> > > 
> > > Should we just simply not create tree holes for that case?  Anything
> > > involving page cache validation is a pain, so if we have an easy
> > > enough way to avoid it I'd rather do that.
> > 
> > I don't think we can. Any hole at the tree tail which gets into the
> > same folio with descriptor need to be skipped. If we write out
> > hashes instead of the holes for the 4k page then other holes at
> > lower offsets of the tree still can have holes on bigger page
> > system.
> 
> Ok.
> 
> > Adding a bit of space between tree tail and descriptor would
> > probably work but that's also dependent on the page size.
> 
> Well, I guess then the only thing we can do is writes very detailed
> comments explaining all this.
> 

I have a comment right above this function:

+/*
+ * In cases when merkle tree block (1k) == fs block size (1k) and less than
+ * PAGE_SIZE (4k) we can get the following layout in the file:
+ *
+ * [ merkle block | 1k hole | 1k hole | fsverity descriptor]
+ *
+ * These holes are merkle tree blocks which are filled by iomap with hashes of
+ * zeroed data blocks.
+ *
+ * Anything in fsverity starts with reading a descriptor. When iomap reads this
+ * page for the descriptor it doesn't know how to synthesize those merkle tree
+ * blocks. So, those are left with random data and marked uptodate.
+ *
+ * After we're done with reading the descriptor we invalidate the page
+ * containing descriptor. As a descriptor for this inode is already searchable
+ * in the hashtable, iomap can synthesize these blocks when requested again.
+ */
+static int
+xfs_fsverity_drop_descriptor_page(
+	struct inode	*inode,
+	u64		offset)

I will rephrase the first sentence to make it clear that this could
happen for larger page sizes too.

-- 
- Andrey

