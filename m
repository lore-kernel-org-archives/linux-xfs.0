Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8443D47D4;
	Fri, 15 May 2026 04:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778819294; cv=none; b=lRNJSfxCytzTZwX2UUJEF7naflaus6ZzGYRYYMhDS0Mz5/bmi/b3GqhUcT3mJpGd8Te7CNXdveujeMRGCw7ex3gbsCeVbLub9j1DQJP8WlzJn+gOJt6dKkZMM0ui0a4xeRnsIIhNa0SnbXRG2jOf6eSXmPTvATKKoIchi8aCrws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778819294; c=relaxed/simple;
	bh=Ai+s3mA4MJ45x2uYdXZkie7GJNClSXjP9mPQtGZpeOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lYDMP4qIdfVJS4Il17PKaUv0YQ5X88g6X3mIuYrMH6AsxA88sYG4n0hdcg/3fvCg82AB9LuU9xhfYxDnEe4G1wr02OsWS7dnxR+O26gDH+T8W4EV2eAzqgfbvlKw6L+cmn/tGuUF8N5Q8GoFpeGpUzJDDksKxxzS6H60mOWYjhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E21476732A; Fri, 15 May 2026 06:28:01 +0200 (CEST)
Date: Fri, 15 May 2026 06:28:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: fix block layer bounce buffering for block size > PAGE_SIZE v2
Message-ID: <20260515042801.GA3433@lst.de>
References: <20260507050153.1298375-1-hch@lst.de> <683792db-32fc-4765-9ba6-3712af01676c@kernel.dk> <30acedd3-e994-4810-8952-613b7d0bd9ca@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30acedd3-e994-4810-8952-613b7d0bd9ca@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, May 13, 2026 at 01:56:09PM -0600, Jens Axboe wrote:
> > Can we get some Fixes tags on these, please?
> 
> Looked myself to not delay this any further, both marked with:
> 
> Fixes: 8dd5e7c75d7b ("block: add helpers to bounce buffer an iov_iter into bios")

Sorry.  The tag looks correct.

