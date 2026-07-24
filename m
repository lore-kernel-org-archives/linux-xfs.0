Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA88525487C;
	Fri, 24 Jul 2026 06:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784874111; cv=none; b=YYEPfrF+PpwN48EbhEoOVjyk0p4a+IFO4B0yVlNAZuXO8k+wIA1xKAbQnRfD6EhqTV0zJi11Kgm+e2/YcVlzuBQr/pUsQTtLyH9b5MN3QX5It/KGqT5ntOh4NlIhTKT+BpRmSY8PIARMkvQsGihPHDYgp+5joHZARMK9wYqrs58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784874111; c=relaxed/simple;
	bh=ZmxkhjfQPpKoAMVOPxntwopNUXVRbxNAcLRK9cBs18g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSM14/zHdlTfqEDpfYpVWt1Qy+FkizFnavwDZqBJKKrREyegVhBuUKbMlJZMWkLZIj8pYPwvPuOuXjuOF8ke2y6nsvTgaGWx2KLrSuGzZfiUeF75YXVMfoZwUIRgluvdgG2mXwPw0Po2DRLvIqZA/Gx2Yqo0L6kN4OtMtMnmEhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4784368BEB; Fri, 24 Jul 2026 08:21:47 +0200 (CEST)
Date: Fri, 24 Jul 2026 08:21:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: use BIO_COMPLETE_IN_TASK for bounce
 buffered read I/Os
Message-ID: <20260724062146.GB4953@lst.de>
References: <20260723145000.116419-1-hch@lst.de> <20260723145000.116419-19-hch@lst.de> <20260723205849.GH2901224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723205849.GH2901224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 23, 2026 at 01:58:49PM -0700, Darrick J. Wong wrote:
> Hmm, so I guess the advantage here is that instead of chaining together
> a lot of ioends to do all the read completion stuff serially, we can
> instead process them all in parallel(ish) since we don't really need to
> grab ILOCKs and stuff like that, right?

Yes.

