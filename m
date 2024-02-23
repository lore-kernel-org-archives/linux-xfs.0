Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCAC140391
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708709285; cv=none; b=BA+1jhIzomW7HUt70oho+nhP0B3145wReBJRJod8l57NWXunfimAYQl/p9uLgHQgUkMkGt9/z2ngoiIvABtOc92PS8UcC5OznlQbPr8BNolz6Q5m8U0VhXMfvZDAUtCahWuNPQBpTh6wKLs12p+v0w2OGoFlDWhP0z0FjdMmvco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708709285; c=relaxed/simple;
	bh=eSkVc9Df0KBHfzDjK6IlyB7Jvmyq82VC/i5RLfkouaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlVO6rce6mYbIyfQ+JBpHoaR+jjplhQ6XL/t13bPvsuboMk2tG0dwhaba2mpy+7I2lt0vF6CZZZVr3GlKQA3mxPSeQweSvCMltZ5wmTzqWcC3f/VADbt5UtzaH4jo8CercX9MVHYMkacYiOBLILFtXti+nF5xiviJ7zh6IuK6f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gFFEB8ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gFFEB8ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCBFEC433C7;
	Fri, 23 Feb 2024 17:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708709284;
	bh=eSkVc9Df0KBHfzDjK6IlyB7Jvmyq82VC/i5RLfkouaQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gFFEB8evFz95LzQ7MXElycYs723ubEy+RnLJjmdwqudfc7KE7314zd4jJgq6XoNZa
	 ymHFpvn0+dl4a4I2JxdRBr5bxDW6N0Yt9Mz7GCTaDaASRsXShn126XXGAg3qM++7yj
	 jtErMn4z9X99E/K1zzpq7HqvzkBTy2xw5slWtA45Nr3TvH7on8UMe+M0qsEe8K6DBI
	 Gc38Un2wSi6btOq6UX1MLe5c+kVs79GCD22K9uvlLp9mmMl+BKCEKn81Ig7GQpCvne
	 /OgqRS3s8EfuyGk8MRGeAtS2aSZG3WXfhKFK1tzwWhKoW1brgmovS+jCnox8ZReoxz
	 1yw8EEt7C7NdQ==
Date: Fri, 23 Feb 2024 09:28:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: split xfs_mod_freecounter
Message-ID: <20240223172804.GX616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-5-hch@lst.de>
 <20240223170953.GQ616564@frogsfrogsfrogs>
 <20240223171855.GB4579@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223171855.GB4579@lst.de>

On Fri, Feb 23, 2024 at 06:18:55PM +0100, Christoph Hellwig wrote:
> On Fri, Feb 23, 2024 at 09:09:53AM -0800, Darrick J. Wong wrote:
> > > -	lcounter = (long long)mp->m_resblks_avail + delta;
> > > -	if (lcounter >= 0) {
> > > -		mp->m_resblks_avail = lcounter;
> > > +		xfs_warn_once(mp,
> > > +"Reserve blocks depleted! Consider increasing reserve pool size.");
> > 
> > Hmm.  This message gets logged if the __percpu_counter_compare above
> > returns a negative value and we don't have a reserve pool.  I think
> > that's a change from the current code, where running out of m_frextents
> > returns ENOSPC without generating (misleading) log messages about the
> > reserve pool.
> 
> Yes, I'll need to fix that up.
> 
> > without all the reserve pool machinery that fdblocks has.  The original
> > code to implement m_frextents did exactly that, but Dave really wanted
> > me to optimize this for icache footprint[1] so we ended up with (IMO)
> > harder to understand xfs_mod_freecounter.
> 
> FYI, I have uses for reserved frextents a bit down the road, so
> I'll make use of that.  Without that splitting them would seem nicer
> to me.

Oh, ok.  I agree that keeping the combined function makes more sense if
you'll be adding a reserve pool for rtextents.

--D
