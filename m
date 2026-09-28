Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5CE495032;
	Mon, 28 Sep 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589403; cv=none; b=nyRa29zZsUgB7W9+h5Cz4Njg5UwiBxPekaCaknYfpHjfBfRklM9RrOdM5BFNcwE1qW0/WOuwynLsyH+YqwIe1lF6ZOyk5f/VYO6Xl4q+aCISAmsu2k6/eTrp11VcNrB+50SZgANL2uTxVNM3f6ol5qpV31QDQjWByK0rSVwP11Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589403; c=relaxed/simple;
	bh=PDZ7qsE9yFi3kX6TZMq89a+GGJS4Bz7kWM51eIcnwgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JgrNn7PiGcTn2DQ0oHIrCaMPd9hF6xPthsgzpA0dPDpD0TnAAaGbess9a+heC1leOP+KrGxZQlZ2tF5ysfQ0bPUIOxd+nrPz/gAXlyQPp+lpTh07BRQWkv+0R1ecZHdMhBA4NKGGqunpWeOcKNpLRHHSBCmk2qIl67jocXy9qHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHFK6O1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHFK6O1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37041F000FF;
	Mon, 28 Sep 2026 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790589400;
	bh=qtrbeGRwxHL6siskw58qvWcWiS4n4ac2l9kkgSMicBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gHFK6O1gRIt13hebfAZFtU/GtLGNuJMaMGSfIVPiLsMit536P0ACwzkPmu7Vjp0ll
	 v348oVqnpqvTZMOt6xrc8z4ok81eGg54ece7dLxg00tYHzwJgVjAz7jqdTPBuTowEs
	 URMGxKbCXI4PSLJl1QbaIAc5DzHqwYia1HTu+wX8r1K/XymbcitfFMM6aN5h/5pWLQ
	 uJwKg1wZmPMAUpfq/cGdhV1/Gd56FBy1rhTRRRj+/FMvG0jRFxgGqkQ8qpDECvxGlQ
	 1TBUt0TACWjE0rAAv58XBh06HH3crw5hwUezwUvqMjGqarovSOPgqpLvMN2O/WE2It
	 Sek6p/C8XGqlQ==
Date: Mon, 28 Sep 2026 17:56:33 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test libxfs handling of missing RT devices
Message-ID: <aro5YDvkdqfspAer@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260925051519.3002168-1-hch@lst.de>
 <arkF56Qtd-kQS9jH@zlang-mailbox>
 <20260928065816.GA21053@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928065816.GA21053@lst.de>

On Mon, Sep 28, 2026 at 08:58:16AM +0200, Christoph Hellwig wrote:
> FYI, Sashiko complained that this might break when using external
> log devices.  I'll give that a try and will most like respin for that.

Sure, I'll drop this one, wait the next version :)

> 
> 
