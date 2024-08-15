Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B191726AFB;
	Thu, 15 Aug 2024 06:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723702879; cv=none; b=aUUvODAXg2TjBamCK2i24VdhM5ZUApGwfMzIUE1pcx75ZVbXblui8PuUnQaRoyyPO4COTz/7RVKgASzIZQTWSX0ROjZBYfLHhueaPvErrXoYavfWEaFDUKGSfLJlzFJQnnhgeiW3HL3FBQtmXkrkfGh/zc2kQ45WO33bOebaJ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723702879; c=relaxed/simple;
	bh=M1c2R0U+oOYNkhyyAeBFOjvWT/E97J8pRh4Ab/CNAMM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8uBj8sUBbEF6MJzViXbuGuQgBFfQcQjQiP/LJlZxDvY52D40kpGM8FF2/dyKv/jk9UWfEDWMMuoaJfxcN9SkWd7gg4Xwj0A+irNyvydUnIbDsuIGZx1eq48tEgb8iy+SD3jyXYMz1V2n4CESlKyojpEQ5mlick4zRbi0GLOcWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8B111227A8E; Thu, 15 Aug 2024 08:21:12 +0200 (CEST)
Date: Thu, 15 Aug 2024 08:21:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org, axboe@kernel.dk,
	martin.petersen@oracle.com
Subject: Re: [bug report] raid0 array mkfs.xfs hang
Message-ID: <20240815062112.GA14067@lst.de>
References: <8292cfd7-eb9c-4ca7-8eec-321b3738857b@oracle.com> <4d31268f-310b-4220-88a2-e191c3932a82@oracle.com> <ea82050f-f5a4-457d-8603-2f279237c8be@oracle.com> <20240815055221.GA13120@lst.de> <b7f5db41-5995-4221-b2c4-4faa48fd1fd8@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7f5db41-5995-4221-b2c4-4faa48fd1fd8@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Aug 15, 2024 at 07:19:50AM +0100, John Garry wrote:
> static inline unsigned int bdev_write_zeroes_sectors(struct block_device 
> *bdev)
> {
> 	struct request_queue *q = bdev_get_queue(bdev);
>
> 	if (q)
> 		return q->limits.max_write_zeroes_sectors;
>
> 	return 0;
> }
>
> According to the comment in bdev_get_queue(), it never is never NULL.

Probably because no one got around to remove it.  There never was a
need to check the return value, but lots of places did check it.
I removed most of them as did a few others when touchign the code,
but apparently we never got to this one.
