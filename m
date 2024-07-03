Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E89517BB6
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jul 2024 03:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719978304; cv=none; b=qhFstwTyMPV4ORHoRUNtEPZTwR5NMsD2EtB7gZwIio72luxAw3+VkxDq5DOrRNpAAlqJiKXjoUu+X4dipIVAaEDS3Im9Xe6HUIKWewKOCnqXXDqlnbRAVWoZ5a8ADj8USEdbJTZZg76ez0ZdnQqZS8LH3lk8tm9C8g79TScyS2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719978304; c=relaxed/simple;
	bh=YVH/tUpUOZKubtGSlNUeRCs7jCxoRiapv0bM/5VENEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uv1dFiyNdtT0qzJjuGIUgLYy0Mq5x9/1ix7GBn13z5yPgBsLivuktoDzM/uDWNrrfV5d0ks0PjFJXX0uC/7sG5K8eZ/VnCPiDkks1O7NpIO2crbY78agZBEcIgFtc/7V289PA7qrKhqhYE0nRxkU6m4dSMCZ2q008eE3M2EDKbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ny5fI2h+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ny5fI2h+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D57C32781;
	Wed,  3 Jul 2024 03:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719978304;
	bh=YVH/tUpUOZKubtGSlNUeRCs7jCxoRiapv0bM/5VENEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ny5fI2h+rAAdIXRxJaJhxJ0LvqbXQG6WYNe7mnvRyGCyoymdYu66zkn54yLg8dso0
	 wNIe5sSUG4Ho5aPwIbevRU1yHlVPyVj+5Hi77hF2PMSjLytYlONbBCdp+hx3tXpaVM
	 dYOfIOu0StV9wKzJLEnKt9d2YPcqiuCoGAou285VuprO6GEPTS+caApV9X0va47aGA
	 WTLOvHueajTQGM9Ju5uyqEhBk1vROz2mu4R9kQ89I2lPfYS8iMG/vs9SEreVm5BRmu
	 cWtEULIgEga3AeKOXQ+r57Ve5ImK+YgucZge+uH8WgedgAdZPoyjYUATFLj/HcyDwn
	 nJZnj/x+N98dw==
Date: Tue, 2 Jul 2024 20:45:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/8] xfs_scrub: don't trim the first agbno of each AG for
 better performance
Message-ID: <20240703034503.GW612460@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
 <171988118237.2007602.9576505614542313879.stgit@frogsfrogsfrogs>
 <20240702053019.GG22804@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702053019.GG22804@lst.de>

On Tue, Jul 02, 2024 at 07:30:19AM +0200, Christoph Hellwig wrote:
> On Mon, Jul 01, 2024 at 06:02:36PM -0700, Darrick J. Wong wrote:
> > Therefore, we created a second implementation that will walk the bnobt
> > and perform the trims in block number order.  This implementation avoids
> > the worst problems of the original code, though it lacks the desirable
> > attribute of freeing the biggest chunks first.
> > 
> > On the other hand, this second implementation will be much easier to
> > constrain the system call latency, and makes it much easier to report
> > fstrim progress to anyone who's running xfs_scrub.  Skip the first block
> > of each AG to ensure that we get the sub-AG algorithm.
> 
> I completely fail to understand how skipping the first block improves
> performance and is otherwise a good idea.  What am I missing?

Actually, I think this patch doesn't have a good reason to exist on its
own anymore.  The goal of this patch and the next one is to improve
responsiveness to signals and smoothness of the progress bar by reducing
the number of bytes per FITRIM call, but I think limiting that to 11GB
per call is sufficient without the "skip the first block" games.

Those games once was the magic method for getting the kernel to use the
by-block discard algorithm instead of the by-length algorithm, but most
of the deficiencies in both algorithsm have been fixed now.

So in the end the only reason for this patch to continue existing is so
that we only issue one log force and lock one AGF per FITRIM call.  The
next patch exists to constrain latencies.

I think I'll combine these two patches into a single patch that avoids
having FITRIM requests cross AGs and breaks the requests into 11G chunks
to improve latency.

--D
