Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBB270808
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765385684; cv=none; b=cSPBXzaAPdKHzH1+0e9SQ88YobjdMcpRulyte6TDDLHHtUxXkm2CKlxlPQLKtNW2jjVt54C/92o8T8zVqY9YbqkwT7FdciIFH+8IjvWMcJb343AmAdAo5rRW1QRf82grp0OnqZko3pyRrSODYSXnuYYupLKmI1Li0wB+JNb2w+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765385684; c=relaxed/simple;
	bh=RWif5k9X7e2Em/JwIWI4F0pwn4FDIJ4yF5brYKl4m6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlD5fc+hQmGWK+UQbGO3feuvjoBElQWICeKt4gBdtf02Y+wXvepG70OcHJcawx4TXOWPHyTu12eflYIDi7zEfxtVDVsEUcXGp7ToSj91psO55CTtf7N6f8GU17D2TsLhVg4aJorLF+BScK3LJYXimgdlW3VIZSBb+bPDdrGOpHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5CE67227A87; Wed, 10 Dec 2025 17:54:38 +0100 (CET)
Date: Wed, 10 Dec 2025 17:54:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251210165438.GA9489@lst.de>
References: <20251210142305.3660710-1-hch@lst.de> <20251210164859.GB7725@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210164859.GB7725@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 10, 2025 at 08:48:59AM -0800, Darrick J. Wong wrote:
> mkfs doesn't enforce that when you're creating a zoned filesystem on
> non-zoned storage:
...
> (The mkfs enforcement does work if you have an actual zoned storage
> device since mkfs complains about changes in the zone sizes.)

Ugg, and I thought only my horrible hacks caused that..

> 
> > to avoid getting into trouble due to fuzzers or mkfs bugs.
> >
> > Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> How many filesystems are there in the wild with rump rtgroups?

I suspect very, very few as zoned mode on non-zoned devices is not a
widely advertised feature, and then you'd also need wiredly sized device
or manual override to get it.  And then scrub would complain about it.

> Given that runt zoned rtgroups can exist in the wild, how hard would it
> be to fix zonegc?

Very nasty.  We can't ever GC into one.

