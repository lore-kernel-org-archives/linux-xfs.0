Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2B22E92BA;
	Wed, 19 Aug 2026 07:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124680; cv=none; b=Vcm29OuXiHoGtLh6UcwqNH7+FfDPVXDwkE6xy7LSaujFjGSPhrLeu+ybwBrL09jf7c5ShI1fEwuE/Ac84j1POP7iMllet0SnKaaTUjhAi4sWooHkcAteaayRVDdv6hdNuZ1w6gvWpvMDvBfW9Xt5TUGmPkRKUppNR4J8DcqXj4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124680; c=relaxed/simple;
	bh=mXaqhz2GyeqxSV9fVPj0P3Bf8xTV4xez0mD+UFy4y5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbT+5Uakhx2cvi2SeHFAco9fZLT9Z3RI+X7liJFhZdeN4imJR2jLNQF3cNIhEO+0caLQA3xF8Be8I3RwUhwKXSEVliam91QYIVS318q8hsx9xJZwTvfADIxvbmD+ZDo/RIg6rHgfreJ6Z9+z1888ltQlwabWAketyox6DmC53+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27D8368C7B; Wed, 19 Aug 2026 09:31:14 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:31:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 6/6] xfs: introduce software write streams
Message-ID: <20260819073113.GB2332@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125641epcas5p4db010135831340515003215b57e12823@epcas5p4.samsung.com> <20260717125538.508925-7-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-7-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 06:25:38PM +0530, Kanchan Joshi wrote:
> Even when the underlying block device does not advertise write streams,
> XFS can choose do so, as that enables logical spatial isolation and
> dynamic AG-set based concurrency for the standard storage, excluding
> rtvolume.

Ok, this gets back to my previous point.  Pleadse just ignore the
hardware write streams in the initial patch, and then add the aligning
to hardware write streams later.

> +	nr_streams = bdev_max_write_streams(bdev);
> +	if (nr_streams > 0)
> +		return nr_streams;
> +	/*
> +	 * Enable software-only streams if hardware streams are not available.
> +	 * This helps to
> +	 * - improve isolation; reduce allocation interleaving.
> +	 * - improve concurrency using AG-set based steering within and across streams.

Overly long line.

> +	 */
> +	nr_ags = mp->m_sb.sb_agcount;
> +	if (nr_ags >= 16)
> +		ag_set_size = 4;
> +	else if (nr_ags >= 8)
> +		ag_set_size = 2;
> +	else
> +		ag_set_size = 1;
> +	nr_streams = nr_ags / ag_set_size;
> +	return min_t(uint16_t, nr_streams, XFS_SW_WRITE_STREAMS_MAX);

.. and this value should be cached somewhere.

>  	nr_streams = bdev_max_write_streams(mp->m_ddev_targp->bt_bdev);
> -	if (nr_streams) {
> -		mp->m_streams_in_use = bitmap_zalloc(nr_streams, GFP_KERNEL);
> -		if (!mp->m_streams_in_use) {
> -			error = -ENOMEM;
> -			goto out_shutdown_devices;
> -		}
> +	if (!nr_streams)
> +		nr_streams = XFS_SW_WRITE_STREAMS_MAX;
> +	mp->m_streams_in_use = bitmap_zalloc(nr_streams, GFP_KERNEL);
> +	if (!mp->m_streams_in_use) {
> +		error = -ENOMEM;
> +		goto out_shutdown_devices;
>  	}

and also be used here?

While we're at it, the stream allocator should probably go into
the buftarg to prepare for also adding it for the RT volume.
