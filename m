Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D238716BE20;
	Thu, 15 Aug 2024 05:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723700539; cv=none; b=NoT2JkP2gRA9+h/XRa/Qcc3wxS9uP9F+BhUHHBzotyZICFUPh9BjGllL4fcRQgHl6NZlHS8k4ke81AbRSHM5H58DQ26qHEd0ggLIWrv6yg+uq7W3quxF1opHh0sjheG0JdfJat+48bzBapnBP3ayqEVK0WTCqgJ6WCC4S8MN73E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723700539; c=relaxed/simple;
	bh=+RsYryd49I5xvPZ9WQUndwiv1DTUsY+RawTW5CqgD7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rcn2ljkXRsCipgTBSVIGCEQ5MjY6KxNHPg4dijMqYj/wEhKHn+Vlw7afz7MpSS6bsDhzrznU6u3NpTWfqnssF5Thv1Qm84U0XGR6+bPD9dtuiOl4XTgmZ1HRiDxwbTuPkQERwoV926lZmcVPUbBnrhgEVOdRK3Eah241Nw0kGmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4B209227A87; Thu, 15 Aug 2024 07:42:11 +0200 (CEST)
Date: Thu, 15 Aug 2024 07:42:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, linux-xfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, hch@lst.de, axboe@kernel.dk
Subject: Re: [bug report] raid0 array mkfs.xfs hang
Message-ID: <20240815054211.GA12998@lst.de>
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com> <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com> <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com> <ZrzDP5c7bRyh7UnE@kbusch-mbp> <yq1wmkjtb1t.fsf@ca-mkp.ca.oracle.com> <441fb8d7-422d-440c-9e12-ab58a0401cad@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <441fb8d7-422d-440c-9e12-ab58a0401cad@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 14, 2024 at 06:25:39PM +0100, John Garry wrote:
> On 14/08/2024 15:52, Martin K. Petersen wrote:
>>
>> Keith,
>>
>>> Your change looks fine, though it sounds odd that md raid is changing
>>> queue_limit values outside the limits_lock. The stacking limits should
>>> have set the md device to 0 if one of the member drives doesn't
>>> support write_zeroes, right?
>>
>
> And even if we had used the limits lock to synchronize the update, that 
> only synchronizes writers but not readers (of the limits).

Readers are blocked by freezing the queues (for most drivers) or
doing the internal mddev suspend for md.

So I suspect kicking off a workqueue to do the limits update will
be the right thing going ahead.  For now we'll just need to hack
around by doing single reads of the field.
