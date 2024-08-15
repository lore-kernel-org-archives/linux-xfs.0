Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B7317625E;
	Thu, 15 Aug 2024 05:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723701149; cv=none; b=SjasrXdqMe7xpKESg/187AL+INPYhGL2k2dTkuzocqZ+HswP1sq82AAiaf+kDcGF/XPYcXQDJKrWjM5ieDbS865LKT7gYknpiLIkWHDEgL/7Guhd2IqQb0KjW1+568QXYe37x84FJAocmOqKGrThgzQ935KrwF6Y9mHvA+ZgXus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723701149; c=relaxed/simple;
	bh=/vherpvzLbNQPYH3OUZgJuhhFrctNdizp6VJWmncDL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UTKfpZhqq3iH6FUv/74bsPkfDsOyFpmF+2lEhyfd7XADcSr+VegBqCUQw8TrMH8H3AvFrwKFeVJdoDZD9suyqJnoqmrETBHqwoi53McLb6dpVXKOijUiJhf99BacNv/TBmwsrYtzSSu+svXKFQHlcTJXyyAMAvdkU5fvf3xJiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CB9BC227A87; Thu, 15 Aug 2024 07:52:21 +0200 (CEST)
Date: Thu, 15 Aug 2024 07:52:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: linux-xfs@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
	axboe@kernel.dk, martin.petersen@oracle.com
Subject: Re: [bug report] raid0 array mkfs.xfs hang
Message-ID: <20240815055221.GA13120@lst.de>
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com> <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com> <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 14, 2024 at 03:00:06PM +0100, John Garry wrote:
> -       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio, 
> flags);
> +       __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio, 
> flags, limit);

Please fix the overly long line while touching this.

>  {
> +
> +       sector_t limit = bio_write_zeroes_limit(bdev);
>         if (bdev_read_only(bdev))
>                 return -EPERM;

Can you add a comment explaining why the limit is read once for future
readers?  Also please keep an empty line after the variable declaration
instead of before it.

