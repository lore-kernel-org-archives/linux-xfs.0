Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BB2449B18
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 09:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784625405; cv=none; b=sWwZSjrVs5cE2VrhrN8PepRMyfJgNZzBdX7SsxlBgAGoLwFcJTiFgNKUH8os+mpIAX6iOrDUjrLlnnR2AmwGOCtR2XhCGiXHFlow5Mriuezb7Afnh2hPsuHYPTOGvYfVbIO7Bn9W796Nd3MCWehQoo1Mh4wBpG+qY4xTKKJebRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784625405; c=relaxed/simple;
	bh=2vr0+gl5jVe0W2dEBDOgVTn6wq7u7hhtrxQxpo/OEmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZ2czHN/YMPTedluG0eJaC2Or9ld1rVuAmUwhPhBRhOQWWBiCWi3BBBQONaO6Eu8E0uOUTlN0jBfcANJ6zZ901krGpGkT7ke2VOQXcn1oBmSx3qefhtu1H104NT7QWJETl3FuM7htWygZK34zwqd4Ht0GZnMqh6bPEQpFIParrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEQ8DNVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEQ8DNVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284461F00A3E;
	Tue, 21 Jul 2026 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784625404;
	bh=iYZHzbXvRktOCvJ/TsPijt4Lb8ZSLa/7Bf1rNaDhzaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dEQ8DNVJwxluDeK7Qhq+zcIw9ka0ezEM7Mc6i47vkN6ihUKg3eJRxD8xjoina6ZH7
	 VsHkdBY4XtBbLj6tcKfOdlWMWUfhplTnINmRx3jCftkM20UR9vgqKSj3jdk2j+KvCK
	 ude8qelQ91j6JnZsDkQWNBQcfxgrujDbtfWrVJrxVAzbSK71B3lVR/1F/QlTIyr0Fk
	 V1UuRB4UDmvHwgPfc+PHn+tjSd8skgV1fsfH7dTSwCLXjg49E8Guq3h2Ddu65SoHM+
	 IvgjOu1NZyc4lc1PxCxMTPUegSTHTuxO97+bPOcYKiq2DF8qTY7/UDv8pROiaDsR+x
	 nAn2hVnkOzlgg==
Date: Tue, 21 Jul 2026 11:16:40 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, dgc@kernel.org
Subject: Re: improve log context annotations
Message-ID: <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>

On Mon, Jul 20, 2026 at 11:45:37AM +0200, Christoph Hellwig wrote:
> Hi Carlos,
> 
> this series improves the lock annotations in the XFS code.
> 
> Note that right now this is all mostly unused - the less stringent sparse
> lock context checks got disabled when the clang version was merged, and
> we're not quite ready to enable the latter yet due to our conditional
> locking in the ilock helper and the locking contexts transferred to the
> transaction for the inode and dquot locks, but I'm working on that.
> 
> In the meantime having these corrected at least serves as useful
> documentation.

Thanks. Those all look good for me. But I'm adding Dave to the thread as
he has much more expertise with lockdep than me and I'd appreciate his
input.


> 
> Diffstat:
>  xfs_extent_busy.c |    4 ++--
>  xfs_icache.c      |    3 ++-
>  xfs_log.c         |   33 +++++++++++++++++++++------------
>  xfs_log_cil.c     |    3 ++-
>  xfs_log_priv.h    |    4 ++--
>  xfs_mru_cache.c   |    2 +-
>  xfs_trans_ail.c   |    4 +++-
>  xfs_zone_alloc.c  |    2 ++
>  8 files changed, 35 insertions(+), 20 deletions(-)
> 
