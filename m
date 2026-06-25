Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DF7283FFB;
	Thu, 25 Jun 2026 13:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392620; cv=none; b=KidXp2zqbI4gqSQu8/UTSldtcsHmes1CritFb2wzUj9RpDjNOnIe2ywxAv/+mWku8toNYykynO9K+YqL5lUPyBDALLaRmUGX4x+25RlvZuchPEFp6uBt1xS1ojPEKa5CeYJOn0LTMX/s/n0C9X+zB9mPoq/rOAKTvRLfN8bzSs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392620; c=relaxed/simple;
	bh=XoVVAF/QR0fNRc8rAp3TxbaqOXY7dRbfus88K+EQKPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRJ4hXzV3zPYvEYQyWQt8ACASYAoi1s2CylKBER7a8nN+05VjJ1EGEy8Sjq17yeEhpIRR9q8M8Rq++zhTcZYXC8N286fw0tZnDoWv6k3eA9MFI2CQ5r1dppOnXjMM8OCKL1aJ2O+6YWvE2wf9yl2KIiNdjVo0/Q59KS5pBKYqPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C36268B05; Thu, 25 Jun 2026 15:03:36 +0200 (CEST)
Date: Thu, 25 Jun 2026 15:03:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: hch@lst.de, willy@infradead.org, djwong@kernel.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/3] iomap: convert to in-iter ->iomap_next()
 model
Message-ID: <20260625130336.GD22620@lst.de>
References: <20260625024723.1611000-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625024723.1611000-1-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 24, 2026 at 07:47:20PM -0700, Joanne Koong wrote:
> A few questions:
> * is this roughly the in-iter direction you had in mind?

I like it.

> * is removing the indirect call still worth it? My understanding is that
>   indirect calls are cheap on modern eIBRS hardware and the conversion adds
>   some per-filesystem boilerplate, so I'm unsure if it carries its weight. If
>   not, do you think the in-iter model is still worth having on its own?

Indirect calls have always been relatively slow, even without spectre.
So if we can easily avoid them that's always a win.  That doesn't mean we
should do stupid things just to avoid them, but I think we have a win/win
here.

