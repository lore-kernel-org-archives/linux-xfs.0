Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18011DB366;
	Tue,  3 Jun 2025 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748961395; cv=none; b=qxK6bo3KZKtdY5ACnKM6dlxA9OLE0n480ftqXFdM8uIAbM0ulSQp23el+pARMDKrGp15nAfnFcWkHiQJ5/cwSFbtc1kQITvjM/3+A0nKRGrhatNi0i2IiaPW/NtbUTnTqmssmoo6WQc4EC9bCPnVT42T47QtUIEIlZ9JnE0Xlec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748961395; c=relaxed/simple;
	bh=GQIzcpu0ccYCJ80lAGD95mI52Q+fpOYZP8Hn0QuNdvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhrohYqCQ7gpZTjpl5RVX/f/q/Zym3nPBZq7r6ravdUtsDSR7a25jRQRUEywcAC1SvngDZYRRVZ2V3+B2eMNRkeihpoOoCxM8d0kHoakhUSaA2CeMHR/FbMmsUsgdS3rs4OUyOzYsYou00+/PoUU7JwcV2mRPfV4JAAO6VdrMws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XC2aUy7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XC2aUy7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD1C0C4CEED;
	Tue,  3 Jun 2025 14:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748961394;
	bh=GQIzcpu0ccYCJ80lAGD95mI52Q+fpOYZP8Hn0QuNdvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XC2aUy7FXNKBwzCDC2fKF+HEMMa/fjeiPg53BmX4TdgUBTy+VppgngS3JG4RjkzwS
	 dMXurwfwQd/n1eCXAITvxPuvnGpWfQ4D3G2fJBGVdBBCUc++n5YFX4If3P3cPOiugb
	 cd0v8fL1360XgrpiKdBO2+WjxHJsQaTCd0l6DmTVZ9hA6xFgLwd6dXE000Z3Kgi7EE
	 DqitOSsIX6mX+ybm6zEPI0w7IS0HWg4ILbWvVcX8fzowj8SevYoUmUWTcpeNSPgAU3
	 3uEr1Db/Lhy+VD1LMONJqa0dI7/q+WKveH8DjtmvPLAnUlzat7aUPrc1Bm9OfCmkR7
	 eRg2+HoJXO4Ug==
Date: Tue, 3 Jun 2025 07:36:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs/259: try to force loop device block size
Message-ID: <20250603143634.GG8303@frogsfrogsfrogs>
References: <174786719374.1398726.14706438540221180099.stgit@frogsfrogsfrogs>
 <174786719445.1398726.2165923649877733743.stgit@frogsfrogsfrogs>
 <aDAFRGWYESUaILZ6@infradead.org>
 <20250528222226.GB8303@frogsfrogsfrogs>
 <aD0xdHHKmfLmAOXb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aD0xdHHKmfLmAOXb@infradead.org>

On Sun, Jun 01, 2025 at 10:07:00PM -0700, Christoph Hellwig wrote:
> On Wed, May 28, 2025 at 03:22:26PM -0700, Darrick J. Wong wrote:
> > Welll... the only reason I patched the loop driver to turn ovn directio
> > by default is because writeback throttling for loop devices keeps
> > getting turned on and off randomly.  At this point I have NFI if
> > throttling is actually the desired behavior or not.  It makes fstests
> > crawl really slowly.
> > 
> > On one hand it seems bogus that a loopbacked filesystem with enough
> > dirty pages to trip the thresholds then gets throttled doing writeback
> > to the pagecache of the loop file, but OTOH it /is/ more dirty
> > pagecache.  Ultimately I think non-directio loop devices are stupid
> > especially when there are filesystems on top of them, but I bet there's
> > some user that would break if we suddenly started requiring directio
> > alignments.
> > 
> > Maybe RWF_DONTCACHE will solve this whenever it stabilizes.
> 
> Well, I'm all for using direct I/O loop devices by default.  But having
> non-standard kernel hacks for that is pretty silly.  Can we just make
> xfstests use direct I/O by default so that everyone uses the same
> configuration?

I guess we could just modify _create_loop_device to set directio from
creation and fall back to pagecache io if need be, instead of the weird
"create it then try to change the mode" dance that we do now.  Does that
sound better?

--D
