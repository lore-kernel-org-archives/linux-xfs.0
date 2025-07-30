Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B52D663B
	for <linux-xfs@vger.kernel.org>; Wed, 30 Jul 2025 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753884741; cv=none; b=MSuRLJB5wQn9zOsS0UIoiSatPq51F5oJbrWhnRSpFIECNnb2K6IE0ovz5ksi0cKdHaGsyHVRYD1TB/suE1wCHw5clzAz6fIEWc6SCN5qqH0yzHviY2XWBEvgWD1DrsoLj4S0Vp2mMmeSLyMPEVmWhJ+wQH0o61cI9KNWC8b3r/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753884741; c=relaxed/simple;
	bh=xJqePm6uQYsDNiy+7bgMnH9nkwThEbpkKteCfwJ0R4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FntHbBhaJ7RBjm+ibe4/YGWaiFpRyTU+kL0tttqubYvaPDTemj8EbpCm1i5JeQ+uAYsqVgGupOcPHkHeGIZG8a8cc02dRJwXm1Pt7lTMyexp6D3BRf6j0A8JbZfO+0bBbihjqlKF5+CCVVkX41ynLPIivQCHs9nrJ5E54EEyyMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EFAC68B05; Wed, 30 Jul 2025 16:12:07 +0200 (CEST)
Date: Wed, 30 Jul 2025 16:12:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [6.17-rc0 regression] WARNING: CPU: 15 PID: 321705 at
 fs/xfs/xfs_trans.c:256 xfs_trans_alloc+0x19b/0x280
Message-ID: <20250730141206.GA11784@lst.de>
References: <aImAfw5TLefSY9Ha@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aImAfw5TLefSY9Ha@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 30, 2025 at 12:16:31PM +1000, Dave Chinner wrote:
> Christoph, looks like this is one for you - these transactions
> previously got caught in sb_start_intwrite() before the freeze state
> warning check (i.e. modifications get blocked once freeze starts, so
> never get to the warning whilst the fs is frozen). The new code
> checks the freeze state and emits the warning before the transaction
> can (correctly) account/block on freeze state via
> sb_start_intwrite().

Yeah, the WARN_ON should move down.  I'll prepare a patch.

