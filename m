Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA8632B9BB;
	Tue, 27 Jan 2026 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769496803; cv=none; b=OxVVChqLIzE69Bh2W9ZpYhU7UgDfgFVZHiXgx1M0zb619qzKnfLsJ0FJsq5s8wohwCSQ3Nm0UH/pdtcJ5G6E8Vr1pgCJ+FLWPXotEfOkfKbAzz70T5EgWRiPv73AKrBSzjQuVbHcksxyKBUGTt6QNhcKPDcEQqJG4rPJP5ZUX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769496803; c=relaxed/simple;
	bh=XEr5GHCVHsI2M8riZolTx8OxlUlm2gkQwA66r+61pPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lLy9OJkjDO+sPN3/bOlC4ZRr82qPZfp0EoAPD4hOBSDLc+Dst2ieKsAICEE30ltc5UvDMVO8Z2E5UArdVB7QgsdoNU2AT++oscDe3aHhg+jpGepWB3hlhXFmLew9ljPRXgfIllMZWgX3O1KDYLYSkXLn/PppRGKBLYswXvmDEvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 096DA227AAE; Tue, 27 Jan 2026 07:53:19 +0100 (CET)
Date: Tue, 27 Jan 2026 07:53:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Chris Mason <clm@meta.com>, Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
Message-ID: <20260127065318.GA26234@lst.de>
References: <20260114130651.3439765-4-hch@lst.de> <20260125000314.561545-1-clm@meta.com> <aXfO_ghd0yoKK8dm@kbusch-mbp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXfO_ghd0yoKK8dm@kbusch-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 01:30:54PM -0700, Keith Busch wrote:
> I think you're right that ring wrap can't distinguish full vs. empty here.
>  
> > A common solution is to track a separate count, or to sacrifice one slot
> > so head == tail always means empty, and head == tail-1 means full.
> 
> The buffer size is a power of two, so I suggest just let scratch_head
> and scratch_tail only increment without modulo, and rely on the unsigned
> int wrapping. We can get the actual offset by masking the head with the
> scratch size.

I actually added a available tracking member yesterday.  It turns out
this simplified the code quite a bit, but so does your version.  I've
kicked off QA on it, which I'd have to redo for this version.

https://git.infradead.org/?p=users/hch/xfs.git;a=shortlog;h=refs/heads/xfs-zoned-fixes

