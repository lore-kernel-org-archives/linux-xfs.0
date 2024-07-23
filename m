Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB95154445;
	Tue, 23 Jul 2024 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721744420; cv=none; b=fj4DmotErUNbcUt9yecvBzQvf93cncMToWMCvG+0F7PfKq47Vo9NSTizuoKaRd5aJMg1c2TgKw8bEPRMMjPu/oDXmaPS//4LvMPxzv8olUWzcP3boMqTpbVGfoihRz+immm0pZpFP1o6bsSswZvfxTV1Pj3q4PZ6oJjiLzBW+IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721744420; c=relaxed/simple;
	bh=k8MkasEWqPPLlfhQnkVlS3uEQDsPBKNFZLIke04wrG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=clgWi60RGGI582n7FCpBpNzmdC+C1+5B1pRpPrW0//C+UFRuEauCHd+WZxs/zYwkyszYH2/T5B25v+BhVwM+E6trh/Bn7XGhuXa+FE9frMj2NFFMH3gn1GplbJV4si9uVJDd7Q2z6idO32FZj9459GCxcZSNz3ug3/yABvygt/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A1ED068AA6; Tue, 23 Jul 2024 16:20:13 +0200 (CEST)
Date: Tue, 23 Jul 2024 16:20:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240723142013.GA20652@lst.de>
References: <20240723000042.240981-1-hch@lst.de> <20240723035016.GB3222663@mit.edu> <20240723133904.GA20005@lst.de> <20240723141724.GB2333818@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723141724.GB2333818@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 23, 2024 at 10:17:24AM -0400, Theodore Ts'o wrote:
> > an allocation group (or block group in extN terms) to a specific size
> > and then want a log that is larger than that, changing the AG size
> > is generally a bad idea, and a clear warning to the user is simply the
> > better interface.
> 
> Is it just "a bad idea", or "it won't work"?

Changing the AG size could work (assuming the file system size is
big enough, beause if it's not it obviously can't).

> I can imagine that
> sometimes we want to have tests that do things that are generally a
> bad idea, but it's the best way to force a particular corner case to
> happen without having to run the test gazillions of times?

If the test is written under the assumption of an AG size or number
of AGs, the expected output will change.  So maybe the could would
run, sorta.  But it would test something else and the test would
always fail.

