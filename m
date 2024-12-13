Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28721684AC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067726; cv=none; b=IHonizszMrqB8YNQTFggEQh5F5KrjMCg+8YlfLdUI8ThL//t93ztP/+PZ+8JBHqybQ0PQmXQ/2zmvQCRgiI6iMNkmRJS34mbuRc4Nl86npV1sDrUUNfg3kQxq12P3uOvAsk0gepNQ9w1l3SOAmWGnflPpPLKXH70ErlXQtYoStY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067726; c=relaxed/simple;
	bh=JMe6MIkkqjgO2bUpKruwc3ToBucR3DtBznJ80J6tmuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC7AWCxdwl/67jdcbOJha9rQhPwdmnzBWpj3IG4BInMzy9jAYDOxYpDRoKNJi+Wm84RsErI5erzf58s6zZHoHz5wQDpuMd1ji78NcfKVE9XOTJL1Tjpk3g6/ppVdcihzDddagLaxkJkwpU2uFc2yB8UYOcReE+s5gyIwCTlw5Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 603EE68BEB; Fri, 13 Dec 2024 06:28:41 +0100 (CET)
Date: Fri, 13 Dec 2024 06:28:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: don't call xfs_can_free_eofblocks from
 ->release for zoned inodes
Message-ID: <20241213052841.GN5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-22-hch@lst.de> <20241212221523.GF6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212221523.GF6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 02:15:23PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:54:46AM +0100, Christoph Hellwig wrote:
> > Zoned file systems require out of place writes and thus can't support
> > post-EOF speculative preallocations.  Avoid the pointless ilock critical
> > section to find out that none can be freed.
> 
> I wonder if this is true of alwayscow inodes in general, not just zoned
> inodes?

Maybe I'm missing something, but AFAICS always_cow still generates
preallocations in xfs_buffered_write_iomap_begin.  It probably shouldn't.

Btw, the always_cow code as intended as the common support code for
zoned and atomic msync style atomic writes, which always require hard
out of place writes.  It turns out it doesn't actually do that right
now (see the bounce buffering patch reviewed earlier), which makes it
a bit of an oddball.  I'd personally love to kill it once the zoned
code lands, as just running the zoned mode on a regular device actually
gives you a good way to test always out of place write semantics,
which ended up diverging a bit from the earlier version after it hit
the hard reality of hardware actually enforcing out of place writes.

