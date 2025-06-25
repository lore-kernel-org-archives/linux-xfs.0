Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9717420DD42
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 08:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750839639; cv=none; b=nAfvpLRNmPV3m05YnlyoSIlKLFySpbqIqRDdh/34MzLjEgN79IZSMvUIeYHwB65/dnz8SpjeAuKtNX0nWibkMCjwaZ1cDtWBkRaq4SgSTzOi0fftlxEXd1IlbEqUIXXzMVlGGzyU86Ngde/dQJXPAkyhhfpVFQ2mrkh5nZumj0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750839639; c=relaxed/simple;
	bh=uftoQ1E5yC3GidayMJV7SO+t48znJGcD9LswRd0lKmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qnA39fZNJ6gdZPvMYoXOqBEPlZC5cAY2INLYdD+GTD4PkLVlNB6fRsk5GX08TT2uuUSYthTMYLmRbQ/fererN3dH0EppoAUFvyzVYAX8eTNaLUIN+lZU7MqLtE0kkab44ujY9rViFEaPD5j2HVtauyEfsoFEN6f3UlMUjryCxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bTqWZrYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bTqWZrYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32522C4CEEA;
	Wed, 25 Jun 2025 08:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750839639;
	bh=uftoQ1E5yC3GidayMJV7SO+t48znJGcD9LswRd0lKmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTqWZrYUup37XmE6zGO6cytHT8z//KtUWRCXezAMSJvoQqgSxqlpOi3u+ZZc1s3m1
	 XaGX+E+h0OSD25BoGtLjOu6qHiCrpUxtsQI9zixvlLs4GdBniixD7pvByy55BkviLK
	 Jm+/laVXlloQta5Xhh6G346rQTwjC2rzD2KqwpmJLetwODSSuZgEzkXQqz8YsvCZgH
	 RmqbEOOfTcko4eGgbqGVvXpET4WR4GHk8NKl9HNtjnxyKEig6DN25tZ7dGO7fjXM0i
	 ZC+rnnWqkhSkJC8YZts/6jAkV7axLvv6+j4IePd+d3N6N7j2ggaNra9eVMf+RG66Xo
	 C4zELxPYLij4g==
Date: Wed, 25 Jun 2025 10:20:35 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH 1/2] xfs: replace iclogs circular list with a list_head
Message-ID: <tyu7x2ha543tu32auj4k32ot3lroqzm2epqn6e42hs54k3k3ox@4ubdiogmywqy>
References: <20250620070813.919516-1-cem@kernel.org>
 <20250620070813.919516-2-cem@kernel.org>
 <aFoKgNq6IuPJAJAv@dread.disaster.area>
 <39xujXwbUGTy3j2E9pH6kGvaRPmJbSuo2peOANlQ21_G69mQy2f2TQX2zhXE2fEvknjHBViVbuVkacBo3jLZ1w==@protonmail.internalid>
 <20250624135740.GA24420@lst.de>
 <b5q3uuhkn2jqcjgg6qcv6z444bftoec7dwxh4qoxbj64z2vnfv@gogvtu75o4qj>
 <Xov06u5kQ-s2ZQXaFz0nUaYULne1GqJm_OEkG120aRXgOlMUgpYtYZ6I7noAjsto67svKHEFCMLeooos3iYkdg==@protonmail.internalid>
 <20250625062157.GA9641@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625062157.GA9641@lst.de>

On Wed, Jun 25, 2025 at 08:21:57AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 24, 2025 at 08:17:05PM +0200, Carlos Maiolino wrote:
> > > 	struct xlog {
> > > 		...
> > > 		struct xlog_in_core	*l_iclog;
> > > 		struct xlog_in_core	*l_iclogs[XLOG_MAX_ICLOGS];
> > > 	};
> >
> > 	Thanks for the tip hch, but wouldn't this break the mount option? So far
> > 	the user can specify how many iclogs will be in memory, by allocating
> > 	a fixed array, we essentially lock it to 8 iclogs, no?
> >
> > Cheers, and thanks again for the review.
> 
> Well, if you look at the helper I whiteboard coded below it only walks
> the array until the number of specified.

Sorry hch, my MUA miscolored your past message and I completely ignored it due
its color, won't happen again.

> As long as the maximum numbers
> of iclogs is relatively slow and/or the default is close to the maximum
> this seems optimal.  If we every support a very huge number or default
> to something much lower than the default a separate allocation would
> be better here, but that's a trivial change.

Well, unless we decide in the future to increase the number of iclogs, this
seems doable, and the iclogs pointers array will fit into its own cache line,
eliminating the problem pointed by Dave.

I can do the work if we agree this can be useful somehow, at this point I'm
wondering if change this will actually improve anything :/

What you think? Is it actually worth redoing it this way, with a fixed array for
the iclogs pointers?

hch, Dave ^

Cheers.

> 
> 
