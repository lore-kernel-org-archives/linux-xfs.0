Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49D53358BE;
	Wed,  8 Apr 2026 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775625116; cv=none; b=eUz7GKm2bzPm5NjnAhEECqI+pBvIpcR6BSknguh9qVH6ZdSJ6bz7wERY5YWv7Mw7FD8yg4ITaDA5w+NHt0uxi4HTyuEnwZk+sgn6sVSXGVOA63dFF6qZ/E7UyhYbPzQgTD1YLfjoWj+DR/mWWmI2TsdXYZKn42N7aWyQxJL5tjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775625116; c=relaxed/simple;
	bh=o9GPvtgJ++k+I844T2/e4AmsIvqqMlEEeCsO0UJCfp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bdh5cfqio174Vrk1jVfIuqr8BZAsam7D8q75DVA5hAGQwg83WyFgQFPXz8mGJcCKHaGwc3uNVoF361AOFU33ULqXNHLIbeYerjD3rDha0KkOc8NR/dnhbmOrUys6Ksje0CowxqkCzhHc9YSH9AX+/ska72K4tYfxrFCjeI8sXto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0BA568C4E; Wed,  8 Apr 2026 07:11:49 +0200 (CEST)
Date: Wed, 8 Apr 2026 07:11:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] block: factor out a bio_await helper
Message-ID: <20260408051149.GA23717@lst.de>
References: <20260407140538.633364-1-hch@lst.de> <20260407140538.633364-4-hch@lst.de> <dbbd5553-1442-4a90-88cd-59348f81cbb7@acm.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbbd5553-1442-4a90-88cd-59348f81cbb7@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 07, 2026 at 07:59:57AM -0700, Bart Van Assche wrote:
>>   }
> The comment above bio_await() says that the callback function passed as 
> third argument submits the bio. The above code passes bio_end_cb as the
> "submit" argument. bio_end_cb() does something else than submitting a
> bio. How about renaming the "submit" argument of bio_await() into
> something else, e.g. "cb" or "callback" to make its role more clear?

It was called kick and Damien objected politely.  A direct completion
isn't really distinguishable from a submission anyway, submit_bio
could complete the bio with an error before doing much.

