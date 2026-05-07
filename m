Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AF53E1D11
	for <linux-xfs@vger.kernel.org>; Thu,  7 May 2026 11:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778153787; cv=none; b=dzgTQQ0+dSQbgAiRsLhzQoxU9nElXkFh6Iybrl7/HFuYShpYfWiueEO5PMqhNnagEfHiCEq57tyG5yQjIIWQafSfpTlwm+slM9+z0/dUWD7e1RTGEQ0GCHJWupfBB4EfOhoRwz0gpliL0OVjLBzlyVcRIdlCTEy7IVoGy2Us73Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778153787; c=relaxed/simple;
	bh=aIzSRFpzbZKrZAg0CdLRwPfMtjsPOTrzXfZBVf8TcrM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I2/M155nXZG7QTQPWIeu+GXCkCKVSZIC27v125+yDwmyoPaV9rQLxbFQc2ik+IQm0gVFlMRFc5zLgfEfGgyf5LkYO8T703Ytu+M2ku0DeZwSa7acocJvQKqh3K1LigCkYuQ/cq3X+zNlykgND2VI8b2uDlKe5WS2M2yp+Dw86Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CcWg6z93; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CcWg6z93"
Date: Thu, 7 May 2026 13:36:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778153782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4NFNbXeizyMJeFRyQ0zqvAkaI3oQ1Ivi1F4fsjx4hM4=;
	b=CcWg6z93RLUAYOt6b8PebBFtG6LN8/BiZ3sSNGleI1EaK7j0gCO+4B0ilPburpo+69Vhrv
	OUxIYztOTU3K1GYUBlU/SHwgoLiFkLG739RZ1ECv8AQ6dQUwgqNMapHh0R/UxR18YcwpIv
	0jXaIcNmItuy5W0ilFuVQ+MDzVVSrdk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] block: pass a minsize argument to bio_iov_iter_bounce
Message-ID: <7a24ulsyoczubsjc2y4rkv7tkgqzpo7ehkkljdytyo6tzqdw24@avwve4kr7tzy>
References: <20260507050153.1298375-1-hch@lst.de>
 <20260507050153.1298375-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507050153.1298375-2-hch@lst.de>
X-Migadu-Flow: FLOW_OUT

On Thu, May 07, 2026 at 07:01:47AM +0200, Christoph Hellwig wrote:
> When bouncing for block size > PAGE_SIZE file systems that require
> file system block size alignment (e.g. zoned XFS), the bio needs to
> be big enough to fit an entire block.

Not related to the patch but I am wondering why we don't need this for
non-zoned bs > PS configurations.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

-- 
Pankaj
