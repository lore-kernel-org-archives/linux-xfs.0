Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7DB4D8D8A
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784646107; cv=none; b=DbZV6QGAEgBZrrz684/PreZ7JNOJCcnwXUCbAz+YO2RT+xTUrpetcXoDwf5Hm098fpkn0Eoj3TETs5mNrPduX3x7jKCU0UAwWf8ifATg67XN013rIi1uR/Q2a77cAP2d9axJlvzZWQCCm1LS7U1g57QQGu7GG7iT/deSvLhxupk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784646107; c=relaxed/simple;
	bh=yDHYzQ4c4JLDFAYdyT0FAPgNawRpXhXvPfO9plAB95o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7QWhPg+XH2a6jvnbCDOpEDGlZlH46e/S6pbIS+S09pUf5hKm0hSHNw7RDxoupE+W1XChSquRYQ8FnQqz8ntEy+57j/pzAPZxHtwnbNpdwIAPPXPcCHFxrYoPsj+7gCbMSBgRlKSKlFKZZMBY4hU6MvegSSDv43Msi7hnn0KJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6DA6768D1F; Tue, 21 Jul 2026 17:01:43 +0200 (CEST)
Date: Tue, 21 Jul 2026 17:01:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	dgc@kernel.org
Subject: Re: improve log context annotations
Message-ID: <20260721150142.GA14984@lst.de>
References: <20260720094609.2191633-1-hch@lst.de> <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al84nDC0BvHr33Kz@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 21, 2026 at 11:16:40AM +0200, Carlos Maiolino wrote:
> Thanks. Those all look good for me. But I'm adding Dave to the thread as
> he has much more expertise with lockdep than me and I'd appreciate his
> input.

More review is always good.  But as a reminder for the audience:
lockdep and the lock context annotations are two totally seaprate
things.  The former verifies the locking state at runtime, while
the latter is about compile-time enforcement for the cases where
that is possible.

