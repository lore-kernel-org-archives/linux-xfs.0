Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD673EFD3C
	for <linux-xfs@vger.kernel.org>; Wed, 27 May 2026 12:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779885856; cv=none; b=oZ/L5relMBQdze9c017fIFQ+WVVHzudendGVA6v7XcsWJzbU/VSvaOGGmO3yBUMqqKLcIp+cQ5KbnpIPUBwK3C624Swl6XNyu06RKTy0OnNPFZ3+o1aJ7Bl9ed2hPHCchV4IDm+ySJpeyK42/nQtxnagIOwKAKrIj/edM4QSgQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779885856; c=relaxed/simple;
	bh=g8NdrjnNcyoG4ew2+8iJ5RJri+CDUsMVgd7Y04xecwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfGVrRXO6nGZF2v6hDv5ZKi+NQhD2mELltc/tFkcM0yoPoqrwVx99jB2gw6XpoHzVFzCCRWPtccpFdjRfWDBysmSLtSyUvC3ljDQUgSEPM8u43YKpE2wEf9++JH4cnxtFmFFsDF3RYCEOm7DPJY32ILV54dEHg/pm74LQNFXs5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=btoxbbwJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="btoxbbwJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=g8NdrjnNcyoG4ew2+8iJ5RJri+CDUsMVgd7Y04xecwo=; b=btoxbbwJt+cIx63nhxVIdZxdtf
	lHxRxsbhCehbLlnvVI6DchUxfwYbOuA9tz2idcMSdaWdxu0sEPszfA7omgsz2iXGVXZImfX8EYmHe
	6ByLWwoXxCrzV85jMXg26L4BZHehABqKGbfiMaH7qyqYVz0WA55C6Q8D/fap8V05OSY+ONx602ANr
	NNnm4kFbNIgRgAhkVxjrMfwEQ4QhbvSXcL/1VzR/CypfI4Hw9EDfF7MiPtk6KaRVPIH+XdAGq4M+F
	boBkQwSn91jzykbFEKgekFxrrsIXh81jmR+HUhk2OVgO6SZ2js/SqnGFEjUTo7jIKwdlivjFJVfcx
	CZVJrsQw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSDcM-000000047eH-0CRC;
	Wed, 27 May 2026 12:44:14 +0000
Date: Wed, 27 May 2026 05:44:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsprogs: mkfs.xfs replace assert on 0 size file with
 error and usage
Message-ID: <ahbnHnGL0U4Sj7aF@infradead.org>
References: <20260525090543.4178496-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525090543.4178496-2-lukas@herbolt.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 11:05:44AM +0200, Lukas Herbolt wrote:
> Running mkfs.xfs on zero size file ends up with assert() and coredump.
> It would be better the print error message and usage.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

It would be nice to add a generic xfstests case to try mkfs on
zero size files, and maybe also weird things like character devices
and sockets to test the error handling in case you're looking for
another little project in this area.
