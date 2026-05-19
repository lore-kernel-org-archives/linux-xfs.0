Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8129A3E16B6;
	Tue, 19 May 2026 08:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779179884; cv=none; b=ewdlXaXVMBMRZpq493MxQFUFUL+hL2ZaVO/Ra6oB7bDoQBbAjeA0MHzh7Zwbx7V2REMh+0lX5Cyf28Q4VAgYUP+rYD2KIq63sH0pOBNHVZtQ3V0USwq0JZ+we99xAtzwOu8WDAmzA7IUI+7WrAgSaMddsUDV6Wr3/+4KpsHoVnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779179884; c=relaxed/simple;
	bh=IRcubO9lSYj+lwKu4iiTm9OHdi+rVDmK39IJpqVxxO0=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AJ4JyoAi7rj3zN59Y/eu9i6QF/IhOK2uuhWFW3P/zD6qVfaxRwGP+nUpY1ZJU7/t3Q7i1YG7y732/zDOTVb0XVjuaD2jll76x/HKJEjBXRxrx+mo0LvbdVDH7E0NLyLNkwBmrUcj5/Q0sqjwcrIABnNRQU951DvBk4SeBTaU8tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7019968C4E; Tue, 19 May 2026 10:37:59 +0200 (CEST)
Date: Tue, 19 May 2026 10:37:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <20260519083758.GA15916@lst.de>
References: <20260518062514.506071-1-hch@lst.de> <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc> <agtbqjAxUsCsLwyr@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agtbqjAxUsCsLwyr@zlang-mailbox>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 19, 2026 at 03:03:37AM +0800, Zorro Lang wrote:
> On Mon, May 18, 2026 at 02:27:42PM +0200, Carlos Maiolino wrote:
> > On Mon, May 18, 2026 at 08:24:53AM +0200, Christoph Hellwig wrote:
> > > The fsverity test generic/759 could be used to reproduce a regression in
>                               ^^^
>                               579

Yeah.

> Hmm... Generally, we state which case was copied/forked from in the introductory
> comments of the case and in the commit log. If you want to specifically mention
> the original author, I think we can add a dedicated line in the commit log, for
> example:

If Eric is fine with that I can stick to the normal rule.

> What do you and others think?

I don't really care at all.  I just want to make sure I don't smub
everyone involved with this the wrong way :)

