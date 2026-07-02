Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2E4BCAC8;
	Thu,  2 Jul 2026 14:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000990; cv=none; b=uHjntAjsQm7MEnHr9uL4kSGjnFM+toJx2TuiFpjXnrTmuYiLh7NOJIVToXYO0nngB4MowRwZOZm0EMcePMDu5AVJbWWmAorn1MhAgn08XKK6qJzi+7vXmIq7qy/PlfGGM91OFTzNkpTVPmqmjrx0tOEabdBCZ88UTZj6BuH8T98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000990; c=relaxed/simple;
	bh=30xaTO0qBkoU72F9kA1fyon8ERv2F7RmZ2yq3lG5cpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spu68WD/TTqILB2Z+WWaONNNTIJGiQa4r89XAKjfX4FOQlZm+22pKo6kPM12/9xOO0d+ivauBHY7frBSyyPf4UEHX+cvAxE1J6Te5KO8iQg7PUul6FrIZYuBNdSCg1idfXOF3zJi/x9NzCpqqaRD3/yQIoYuGDQYLoFrvbylz/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5938F68C4E; Thu,  2 Jul 2026 16:03:02 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:03:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260702140301.GB21339@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-3-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-3-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -	 * The retry mechanism is based on the ->iomap_begin method returning
> +	 * The retry mechanism is based on the ->iomap_next method returning

Nit: Maybe the drop the "->" in preparation of the last patch that would
make it slightly misleading with the ops struct removal?

> +static int
> +xfs_direct_write_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> +			NULL);
> +}

I wonder if we want a "simple" version of iomap_process that only takes
a begin callback, as most current ops seems to be that way.  Then again
between needing at least one longer function name it's probably not
helping much with readability.  So not sure, just dropping it here if
anyone has a good idea or storng opinion.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
