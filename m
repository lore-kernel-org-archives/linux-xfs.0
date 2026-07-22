Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1595B3C4562
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jul 2026 09:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712033; cv=none; b=Z6OGpb1TUG3ie77gy+2cOfX6qMnPz9wBZH6U4JquDJbl39LlI/2txQhHf+5E+HeHL48ahMx9NN4XFfgs2DYCtbf5XLX8QKBUdnGAiLAEu6Tfl6AGZbLA8cSCGn54z5bRehzcSzvRJgPOUrL3QGUMzhkBwK//WATLuL578beEtsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712033; c=relaxed/simple;
	bh=k75e8/dxfaI6cJfEomx2jfqCkSV0x8uoC/dOsg5hphc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QaCitIeMVnH7Cg34e9Ne/pl/IulVk3E60TJb+c0HUsO+6lTlbHiVTHk7k4KWk8n7Y0U9bHIXsRJUlmSqyVAqI8Xe1zXQbB3VP0OcmE5sshhCq8I0lcW/WrH08ULkmpchIQzBoe2faTb9nBICVKb8ksARZa+EwOBGsR717e6Ivks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 771CB68C4E; Wed, 22 Jul 2026 11:20:28 +0200 (CEST)
Date: Wed, 22 Jul 2026 11:20:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: improve log context annotations
Message-ID: <20260722092028.GA31991@lst.de>
References: <20260720094609.2191633-1-hch@lst.de> <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc> <amAKAmIoTvoa6SY7@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amAKAmIoTvoa6SY7@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 22, 2026 at 10:08:34AM +1000, Dave Chinner wrote:
> Honestly, I'd prefer to kill the annotations and replace them with
> asserts that the lock is held so there's actual runtime validation
> that catches errors when they occur. These lock annotations don't
> tell you that the locking is correct, just that the function
> manipulates a lock.

Well, very strong disagreement here, as compile time annotations
are much more poweful as they are statically verified.

> The sparse annotations have always been more of an annoyance and
> reactive, because we only use them sporadically to suppress errors.

And the difference is that with the clang context annotations we
now have a reliably architected way to enforce them, which get
picked up all over the kernel.

The spare checks are gone, so there is no point in discussing them
any more.

