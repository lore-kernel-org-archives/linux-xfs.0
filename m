Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A991DD894
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 10:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738922649; cv=none; b=T/pkpxMWOroUu0cifpvvI9Gbc8vc2PJ7lrLcuPRHlj9IXBGYXysoEy9Jsus8z1PSxED7l0HJnx8pBO3111dmnrTS/T0caU9yIMBZV9qXzBHvx+JdR0pkVZnheMpAcVZS/hV9KG8oz0KgIaZn5ss+jLbL667jyfAepsy/8s2oMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738922649; c=relaxed/simple;
	bh=Mh2YeNC48U0+HdfkGipx+my7jY76BxagTlTatxItLE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMopUAPTFP7jep+xJNj9aDYBmh23+slNe41BeuiXwAPyl3/zfVkiMLACTeV03VKYxFjxxeYIe3zZ6hkoNxe9DTSyx1uaHusMquHLBQXkZ+SekVG7vOhzEWiw4rEtryolACrgtdoUSrp9OdbFawojsfS2+oURxbzI9Rrvi92F4Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c02bQWyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c02bQWyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB1C4CED1;
	Fri,  7 Feb 2025 10:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738922649;
	bh=Mh2YeNC48U0+HdfkGipx+my7jY76BxagTlTatxItLE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c02bQWyk9FFz050eE49ySLvqdzMgb9MAy8RC0H6RiyOe2Nl/EdSFGt3vTPBIl259i
	 0lIDiKt0bgL6iAI24yhVG3Fl42gxvZB2UnmZQOXUqQMpAHVFhPF6qsVL3AtetHd8lZ
	 4gzILLzWWu3cF6MWZyhyjLnPE2luZIN5ajgu7m82GqVPw8jldtK5TDXqKdEpsZic++
	 L6ym3+l7b99aJuNJ13xuxFc8fuwUk4PZqEricoS++YfrqpW+kyHus3zsvUEMLsI2iK
	 quBmBkLMiSjG0FPGDYqz0dLqSmJ+Ba4/l2X+HRIUIhWqtPSIh+pM7jMf4TmoFeSAGV
	 N6BTRDIjhzVpw==
Date: Fri, 7 Feb 2025 11:04:06 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>, 
	Daniel Gomez <da.gomez@samsung.com>, Pankaj Raghav <p.raghav@samsung.com>, gost.dev@samsung.com
Subject: Re: [PATCH] mkfs: use stx_blksize for dev block size by default
Message-ID: <323gt6bngrysa3i6nzgih6golhs3wovawnn5chjcrkegajinw7@fxdjlji5xbxb>
References: <20250206-min-io-default-blocksize-v1-1-2312e0bb8809@samsung.com>
 <Z6WMXlJrgIIbgNV7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6WMXlJrgIIbgNV7@infradead.org>

On Thu, Feb 06, 2025 at 08:30:22PM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 07:00:55PM +0000, da.gomez@kernel.org wrote:
> > From: Daniel Gomez <da.gomez@samsung.com>
> > 
> > In patch [1] ("bdev: use bdev_io_min() for statx block size"), block
> > devices will now report their preferred minimum I/O size for optimal
> > performance in the stx_blksize field of the statx data structure. This
> > change updates the current default 4 KiB block size for all devices
> > reporting a minimum I/O larger than 4 KiB, opting instead to query for
> > its advertised minimum I/O value in the statx data struct.
> 
> UUuh, no.  Larger block sizes have their use cases, but this will
> regress performance for a lot (most?) common setups.  A lot of
> device report fairly high values there, but say increasing the

Are these devices reporting the correct value? As I mentioned in my discussion
with Darrick, matching the minimum_io_size with the "fs fundamental blocksize"
actually allows to avoid RMW operations (when using the default path in mkfs.xfs
and the value reported is within boundaries).

> directory and bmap btree block size unconditionally using the current
> algorithms will dramatically increase write amplification.  Similarly

I agree, but it seems to be a consequence of using such a large minimum_io_size.

> for small buffered writes.
> 

Exactly. Even though write amplification happens with a 512 byte minimum_io_size
and a 4k default block size, it doesn't incur a performance penalty. But we will
incur that when minimum_io_size exceeds 4k. So, this solves the issue but comes
at the cost of write amplification.
