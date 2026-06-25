Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780BE3E4510;
	Thu, 25 Jun 2026 12:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392222; cv=none; b=WLKRevz4xy8cLrToNfElF/SM7BorQZLAQnGnArsYLgSHX0frsH/jHr+Dr3uFeIIR9e74DSAL63TbVeizg2Q391kLky31R/gcO88JoAtR9WsQkOhMCQMdUrbJAumGWeOjRPayRjVdnNTOJKTGdN8Zn3KnUIpt9ngc0vPCBmSXrus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392222; c=relaxed/simple;
	bh=0UhWdM1joIE/qpPLjCxjgruZptLYJXc2kZohEHe3TRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M/CARL/yO/1JaXWXuyek+85Sd488MHlEcQ0yvw+RmcpS+y5yT5dwpTkCg/Oj1/zTSg03xw8NnUbVZ9f+8+XgNIO9Bef3X97z7E+G6sh1FnrK+5IbGrCG1VZeowFy4237Qc5/babb7fGHYeu50Usiy/kz/ue6msEiHW2ecp6/0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1A98568B05; Thu, 25 Jun 2026 14:56:57 +0200 (CEST)
Date: Thu, 25 Jun 2026 14:56:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: hch@lst.de, willy@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/3] iomap: add ->iomap_next() and
 iomap_process() helper
Message-ID: <20260625125656.GA22620@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com> <20260625024723.1611000-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625024723.1611000-2-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	/*
> +	 * Produce the next mapping (finishing the previous one if needed).
> +	 * Return 1 to continue iterating, 0 if the range is fully consumed,
> +	 * or a negative error on failure.
> +	 */
> +	int (*iomap_next)(const struct iomap_iter *iter, struct iomap *iomap,
> +			struct iomap *srcmap);

If you add function typedefs for all the other two methods I'd one one here
as well for consistency.  We'll need it anywone once the legacy ops are
entirely gone we can kill of the ops and just pass this function pointer.

As for the arguments:  I don't really see much of a point in passing
the iomap/scrmap separately vs just the iter.  Or am I missing something
here?

