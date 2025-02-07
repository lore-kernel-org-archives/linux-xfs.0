Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C8063D
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738905638; cv=none; b=qA6RbelIxzgJ7Kl3mVKPJe3NN1/v8u0PP1y3r3Oi8pySRhCYcP1Oq7+zhdp/jwtOT26ueuZAD7Jzk1mzhddRpLYusi0HG3V78OSYM1ZmgxIKYGCZA/SgXajYBiwtHRkq2Ut1HNq0x1gj5HuhE0gQy8MGwuoLPkESeSrXfmk6ei8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738905638; c=relaxed/simple;
	bh=7aV0JWUXfuD4oUZUX42z+m65SacZiw5aslMvZ1KNnXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fTvemiEObpliHzCo9X+lgbWebcB3QrA96ZVxwBqXCaMoPsg3wpxJXR0cNQsvcxXxHc6RAQlt8MjoXGd6DRloW0XQDfh0W88m7HzH4x5f1QqQvMmMMO/vm3cwWdyg2PvR4sgLORK2qaBwHvMMaqczy1uDQAO/gn9DRJUE7Z7fUoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=szJnkz7e; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="szJnkz7e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=T4CcN+ReAjd2vfYzwhz9XBCJhW9mQteytQFwTTut6Os=; b=szJnkz7ez38MiyeofTZPumZ+Cd
	g0M+SDhmn876PTmBva0KWWYX6dNTRetLqaeYwu6g+4KKPI57ykTToOfn6evEmSUoq0g7TL0OB39no
	HzRz32Z/lAVQa6Lj/Z4Uqhj7y9o5sQFJYq9iXDqT/wSQMVqzfoZ7mtMhAM1BKdqgnckPq31Isf5FW
	0XB5K6Ajq1Y4A+aS+pmwRVJtkAwF9sjlZKmKDu1Lc4f0ymsi6jD+YpWRKvlpsAkObd7D9AM/YTuoe
	D6Sn4BtXN4zGhPPXJ5UxYA/CYd4QY0vBl9F6vBJYhI2JPk/LHpbDR0UGAqjJM172iU3JEiT9KMnnU
	MVCIw1Lg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgGn6-00000008MIw-2mFA;
	Fri, 07 Feb 2025 05:20:36 +0000
Date: Thu, 6 Feb 2025 21:20:36 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/27] xfs_repair: tidy up rmap_diffkeys
Message-ID: <Z6WYJOYV6Puf2kSy@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088295.2741033.4604651348658562209.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088295.2741033.4604651348658562209.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:53:07PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Tidy up the comparison code in this function to match the kernel.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Or do you want to use the fancy cmp_int() helper?

