Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0243525DAE3
	for <linux-xfs@vger.kernel.org>; Fri, 28 Feb 2025 10:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740739127; cv=none; b=VYFotJFHXmPNgT94i48DYAgwWHV1psDLn/PTOmpEZyliCydsfWb9AtR6XAdz7zt3CGphz38DUPNBvZx6fqc3wn3aXGQTV+jxQCZxk+T5Z87TR+ZDmvhhFqj0pkNpCd9E5i0TAMdSir7932mMn4Saa5uw/6L8020TWkbR2imbJzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740739127; c=relaxed/simple;
	bh=2JjLTDK8Mb42ZtKmG63naEZCTZfH9kzO8b67eGVnr8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hN0pITLQoCtyaOPHc4kRZL8QIciCphpV2SwUMfty2ZKFwrIsBZlG7E12L2Czl9PQx8RJaAPUy7X3Q9d0EMs8EfGQ+ISI2fs726rMrTCwXZxdp87tAptaGgQ43fkUlt5aophpOvy+fARmNANlqAw9wat2RzASmvttvsdKOzWDXM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A5u7QlA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A5u7QlA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124DCC4CED6;
	Fri, 28 Feb 2025 10:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740739126;
	bh=2JjLTDK8Mb42ZtKmG63naEZCTZfH9kzO8b67eGVnr8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A5u7QlA39iu9Kl7yjwULjuUBiqblvaH+lXrpQ93s5O8XQ8qnGZWqw7iIoBdRg1yHj
	 cEIwDhwKVwPT5xHEYltP46NLajJUWceCKrR52LOTE4jnmzM0YvmS6cvhBLbaPHu2g1
	 95Yv+xhuxb9OJWoABZhr7/1NG5Z1WQzuHJGhwuJ121QjiDGYCQeWteJCFVksm0FagR
	 xccoJPIw/Gtunpz+TZl/W5ck5FyzQU4myooMrs2/uQJJ7dutZ438JEbJlSmbTvSDRd
	 oFvXRVfrpyFVDDenP4hJTR3xl6H94fDrLMcu/4DJinmqT0mDiowMRKgJVahIF/OkBq
	 2x7D7cUN4dXXQ==
Date: Fri, 28 Feb 2025 11:38:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, djwong@kernel.org, 
	linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 1/2] iomap: make buffered writes work with RWF_DONTCACHE
Message-ID: <20250228-kerzen-umgang-8e8b9df0bca2@brauner>
References: <20250204184047.356762-1-axboe@kernel.dk>
 <SujyHEXdLL7UN_WtUztdhJ4EVptQ0_LCUdvNOf1xxqSNH50lT37n_wi_zDG7Jrg8Ar87Nvn8D3HaH4B0KscrRQ==@protonmail.internalid>
 <20250204184047.356762-2-axboe@kernel.dk>
 <hij4ycssasmyuzawb2mhq44wec7ybquxxpgxqutbdutfmgaizs@cvpx2km2pg6j>
 <20250227-beulen-tragbar-2873bd766761@brauner>
 <Z8CBYyGvZ23iEU0w@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z8CBYyGvZ23iEU0w@infradead.org>

On Thu, Feb 27, 2025 at 07:14:43AM -0800, Christoph Hellwig wrote:
> On Thu, Feb 27, 2025 at 11:30:39AM +0100, Christian Brauner wrote:
> > > https://lore.kernel.org/linux-xfs/20250204184047.356762-1-axboe@kernel.dk/
> > 
> > vfs-6.15.iomap has a lot of iomap changes already so we should use a
> > shared tree we can both merge. I've put this on:
> 
> Note that we'll also need the earliest changes in vfs.iomap for the
> zoned xfs changes that are about to be ready.  So we might as well
> pull in the entire vfs.iomap branch.

Ok, then I'll just put the series into vfs-6.15.iomap and you can just
pull that in.
