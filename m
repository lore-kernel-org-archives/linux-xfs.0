Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B21F83B8D75
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765394306; cv=none; b=bm8FffcJcii+Aw2vkccSTErIubz+fyW6b47ztkYdaNkPdDWNHyRbY3yHm5hg6v3cJdZENYhMtTOGuiveYGnQGI/4fdcSVDH8pZQs8BvsbfO5/iwTvwt+CjdQvpTyCVH122jSP+lHr9YVAucW5T16qZDAGdANCiKBK34zBUbn5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765394306; c=relaxed/simple;
	bh=dODmr4Q3/tJkKW1aZw3c83xao+89PTFHSgBtXZWdcho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsLn20OCpARTxKZ5eDSPgmmGOO7jhtyllcS9mrTtCJuZpV2/JH8FU9ifUIv+67gThUii3AdQNf+tYhsK06MlGoUykj5RzzrZSSjgtPlu6eSWWsv4gZeimumQY4fUHaj4WJ431avswH9z9rDcC9UtBb/HZiIxjBinnbpc7JRRXOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4SJ4Mkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4SJ4Mkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D9E6C4CEF1;
	Wed, 10 Dec 2025 19:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765394306;
	bh=dODmr4Q3/tJkKW1aZw3c83xao+89PTFHSgBtXZWdcho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P4SJ4MkrcRF50KwC2W0UVIDuVpt088S7gleIfqOjhg8W0VPGTXq41+Fy1NQDRzfyy
	 BnhkzxJpk6oVdM8RS8PxjTuRcye6KZsMaJeApFNp2rSkiJ9wVRLIXbv/6hRTMqQM68
	 Ex3iZspIa+UjPKIXRd3YPQI3UGeV0Aq2q69x5uEnEEHqxCJhQ8XJvT5LjdAO0VHu6o
	 2hODnvRlsuKvHwSFau4M7i1YwFh1sn80asxOznCQZWjZsvSNk/aGAWPJzdV+dklD53
	 FHV5kJX7gjsW3/0iq/MnQNsyKea8Y/CFJivcnEFOilLcIeDM6JFmBuP5WVh/o0o21l
	 6eahhPDc5j/RQ==
Date: Wed, 10 Dec 2025 11:18:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: validate that zoned RT devices are zone aligned
Message-ID: <20251210191825.GD7725@frogsfrogsfrogs>
References: <20251210142305.3660710-1-hch@lst.de>
 <20251210164859.GB7725@frogsfrogsfrogs>
 <20251210165438.GA9489@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210165438.GA9489@lst.de>

On Wed, Dec 10, 2025 at 05:54:38PM +0100, Christoph Hellwig wrote:
> On Wed, Dec 10, 2025 at 08:48:59AM -0800, Darrick J. Wong wrote:
> > mkfs doesn't enforce that when you're creating a zoned filesystem on
> > non-zoned storage:
> ...
> > (The mkfs enforcement does work if you have an actual zoned storage
> > device since mkfs complains about changes in the zone sizes.)
> 
> Ugg, and I thought only my horrible hacks caused that..
> 
> > 
> > > to avoid getting into trouble due to fuzzers or mkfs bugs.
> > >
> > > Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > How many filesystems are there in the wild with rump rtgroups?
> 
> I suspect very, very few as zoned mode on non-zoned devices is not a
> widely advertised feature, and then you'd also need wiredly sized device
> or manual override to get it.  And then scrub would complain about it.

<nod>

> > Given that runt zoned rtgroups can exist in the wild, how hard would it
> > be to fix zonegc?
> 
> Very nasty.  We can't ever GC into one.

How nasty is it, exactly?  AFAICT,

 * The zone targetting code (aka the zone we copy into) then has to
   know to avoid a runt endzone?

 * Thresholding gets weird because they don't apply right to the runt
   zone, which means the victim selection is also off.

 * The code that reserves zones for gc or other ENOSPC handling then has
   to ensure it never picks a runt zone to avoid corner case problems

Any other reasons?  Given that zoned is still experimental I think I'm
ok with adding this restriction, but only after some more thorough
understanding. :)

Also does growfs need patching so that it doesn't create a runt zone?

--D
