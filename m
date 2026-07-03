Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEDC3D3D00;
	Fri,  3 Jul 2026 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783081969; cv=none; b=G0rNUc1i/3amjxonQCguYRtKD0pUqdURZn4AzAgFVdMRDFZJVGXW1VP7T3ldI3FTlPIy0NVpkxxPlllyEzdSXZ1REO0qDQfGKZXQF02dfwDL806NQ0hf08BsXPMm2D9WGrscnF/Nt0d2jbRnAUgyv+LkYYDXyadI8cvCKnG2+pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783081969; c=relaxed/simple;
	bh=Bm7eSnB+dxF/5g+HO6w6wKVkE6oAVCzXh+W4IhWY2Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJ5SWkJ9QZyRmjERw2mnSGgbM5dc6e0xZaJsbbLl19VILtJGG+QnsKViUIcqitCYr1knu9q+13r2tJpKEoDQrx/rPpzTd6o2OJwiyFKnCFNllg3136m4JsvwstS0v/6VzIm1rXCtaHrQIH3XDtwUMqIzjrf8jfqMfJWDbvgF4DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4E3CB68BFE; Fri,  3 Jul 2026 14:32:32 +0200 (CEST)
Date: Fri, 3 Jul 2026 14:32:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, brauner@kernel.org, hch@lst.de,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260703123231.GA25849@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702164339.GI9392@frogsfrogsfrogs> <CAJnrk1ZRQaFseAnz3zm31oR3KmQWje5HDJjhNbAQSAQyK9_PMA@mail.gmail.com> <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJnrk1bj4pLpAzLhehrbDJuKWa=WMq-3XOAm9dhsEVDF9WCBPQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 02, 2026 at 06:21:00PM -0700, Joanne Koong wrote:
> I think this is a good idea. If no one has an objection, I'll make
> this change for v3.

No strong opinions and thus no objection from me.

