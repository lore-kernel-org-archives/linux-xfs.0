Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1A42B9A7
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709160008; cv=none; b=TiOS/YfxPX9EaIyP1MgyjbVl10MqMOWWaSQGSRVSOpd6eDWH2p0/AFBxfe5TLrEM9xWQFGTXzs+Hc2gK4b2L9TOdbFWCztVPIEzM+ZxB9obRGbbyMScewj+Jv7ehiiZWfkziNSEw6zrbGJIBk63d9I6JQ2ODlIfRZXDpgcsjeT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709160008; c=relaxed/simple;
	bh=lvStYpt+L6TckmoMQb/PwPNE/50tgYB1QvcBXVwnuxg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=H0jDHQARHGtX0igqwYsEOjFbX3uVocKw1XAmFmLOtOCmlSKDg5+Bt54lj0PJpe/mtNIr88W1nvmLu48dXnbXjTZojrPicEuzgTEvgTYDy/EuKjRPdL+AIXKBqK0EQD+giKv82+1eEzbbXT5DKg8tR2C6IyY+m9OnN6XOeWPtIS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=JwUltaEN; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="JwUltaEN"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3C8A9418B5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1709160006; bh=FGNKmdc6dA/qTi4hpgJgh+dTTUy8sXGrpgo/mxNKHFQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JwUltaENPXq3/q1lZ0jpLpCFE4JhIWl5obZEVhRLuhpVlsp/ZwjG2jOkaPh93wGnB
	 pdclby9NNIzvj2AoULeoTCQvWmTIT8sXXe0Hy3lXYpCGZhmr7nkXWXJTNu6gXksa1B
	 ACyDvpEPlSa0T5n2+BxX6TIZZCgCS6gfukZcDdRLLetumvmlzxFu64mTixPZYM2ouF
	 z1OckeC0uEdFE70aJaJggu4FKrOlyBq2EIoNB3UmoUCH7mKlW3vkVsXzXjfBuYIYnW
	 RAMb/xJwXFWKow+hfF06KbnXc/GIlGO2o0ztvHEOAK5ZdSAUhPE80EWw6Oo7U5bqOY
	 iCG80naGvXnMg==
Received: from localhost (unknown [IPv6:2601:280:5e00:625::646])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3C8A9418B5;
	Wed, 28 Feb 2024 22:40:06 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Akira Yokosawa <akiyks@gmail.com>, Chandan Babu R
 <chandan.babu@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, Stephen Rothwell
 <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Akira Yokosawa
 <akiyks@gmail.com>
Subject: Re: [PATCH 1/2] kernel-doc: Add unary operator * to $type_param_ref
In-Reply-To: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
References: <fa7249e6-0656-4daa-985d-28d350a452ac@gmail.com>
Date: Wed, 28 Feb 2024 15:40:05 -0700
Message-ID: <878r34p60q.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Akira Yokosawa <akiyks@gmail.com> writes:

> In kernel-doc comments, unary operator * collides with Sphinx/
> docutil's markdown for emphasizing.
>
> This resulted in additional warnings from "make htmldocs":
>
>     WARNING: Inline emphasis start-string without end-string.
>
> , as reported recently [1].
>
> Those have been worked around either by escaping * (like \*param) or by
> using inline-literal form of ``*param``, both of which are specific
> to Sphinx/docutils.
>
> Such workarounds are against the kenrel-doc's ideal and should better
> be avoided.
>
> Instead, add "*" to the list of unary operators kernel-doc recognizes
> and make the form of *@param available in kernel-doc comments.
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Link: [1] https://lore.kernel.org/r/20240223153636.41358be5@canb.auug.org.au/
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> ---
> Note for Chandan
>
> As both of patches 1/2 and 2/2 are needed to resolve the warning from
> Sphinx which commit d7468609ee0f ("shmem: export shmem_get_folio") in
> the xfs tree introduced, I'd like you to pick them up.

This change seems fine to me; I can't make it break anything.  I can't
apply the mm patch, so either they both get picked up on the other side
or we split them (which we could do, nothing would be any more broken
that way).  For the former case:

Acked-by: Jonathan Corbet <corbet@lwn.net>

Thanks,

jon
