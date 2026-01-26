Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CF12F691A;
	Mon, 26 Jan 2026 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769431666; cv=none; b=r/ALa8BGBZWx7A4Y0JzU/P3fGxzieZ9jsDYxwmDt99OC0SBhCH9YA1pEjTLwLOh11dIwvoCrpGAEzAdvi3g1WMAjw+xTrkJ4wxPlJTM80r2prDFR56K7PcaTps42oEaiBAg9C8bAlBkpLVqxCXuSYEKK1Rzl/7RCwnKxNN/IhBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769431666; c=relaxed/simple;
	bh=q4U70EY99U47cCnwnXIU3OxWzPgJ8CIws7VweKmxtHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ER39fHTB6jqkAla6IcqjoRRER6oyRAVAk+wyrFPJNXBdrDlvH9qyi8BkNNlm4x6dkRnRnEO8FFWv6fKl6wRNC81LIZ9CWvW7z3F+ottvmCYMAEn2EaU1QYgz8PZum8QOjU8vvV0AkKaQN3WotSqn5wMxDXdTg7/xLH0bvdqSP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E4379227AAF; Mon, 26 Jan 2026 13:47:39 +0100 (CET)
Date: Mon, 26 Jan 2026 13:47:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Qu Wenruo <wqu@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: bounce buffer direct I/O when stable pages are required v3
Message-ID: <20260126124738.GA28035@lst.de>
References: <20260126055406.1421026-1-hch@lst.de> <CACzX3At3fS19fmp8wOq29rHK-yw0KFp1bAvTdo9NC9eQj4E=pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACzX3At3fS19fmp8wOq29rHK-yw0KFp1bAvTdo9NC9eQj4E=pw@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jan 26, 2026 at 04:24:03PM +0530, Anuj gupta wrote:
> As Keith suggested, here are the QD1 latency numbers (in usec)

Thanks a gain for the benchmarks!

I'd be curious what improvement you see with the iomap-pi series on
Optane, as that drops one of the context switches on read again,
and the less efficiently managed one at that:

git://git.infradead.org/users/hch/misc.git iomap-pi
https://git.infradead.org/?p=users/hch/misc.git;a=shortlog;h=refs/heads/iomap-pi

Otherwise the only thing we can do to get data integrity and performance
is better interfaces.  I think for reads we could do that relatively
easily with a version of Joanne's kernel-managed buffer rings that can
only be mapped into userspace read-only.  Writes will be more difficult
for anything that isn't a trust-worthy kernel provided buffer
unfortunately, but then again the write degradation is less.

