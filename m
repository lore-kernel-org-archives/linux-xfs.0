Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AA2066D6
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 14:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097170; cv=none; b=PhAZLjyRIE64dZgKcr5UYmBTI0CuceYBOJOUmmao7XroRiMAdS7fbrbPiRY/bkC+ltozIOwoCL6TTJb++6FA0gaLRlUVnrpOp/cU/hAAiN5t4GykcURj+KnLIwmXMK21hdxsQW9v0cfGfDq2aKMKX5KQGNSQoCgYHEUiLnXu56A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097170; c=relaxed/simple;
	bh=qV0lBjst/jPtyohhGjiyIgKJusBezJX6dQ4kbpL4k1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCzfiYYLyiaPC3YE7hWxfhNX+BcOT5RzTjE5yNHVZj3r6LavjM9s55qOV3+4eMmsVtzt7FIvZbuIAwMOXfdlUESiN4N+SmcGmOufHJUB4qkuXFdD/YjgYo0oRPxcI1LxBqvNImOZIDA6DQ+b5Ipdv/RC52kHMCrpMzytIZDMhs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B8C568D05; Tue,  4 Mar 2025 15:05:58 +0100 (CET)
Date: Tue, 4 Mar 2025 15:05:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: remove the kmalloc to page allocator
 fallback
Message-ID: <20250304140557.GA15778@lst.de>
References: <20250226155245.513494-1-hch@lst.de> <20250226155245.513494-7-hch@lst.de> <20250226172231.GQ6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226172231.GQ6242@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 09:22:31AM -0800, Darrick J. Wong wrote:
> > +	if (!IS_ALIGNED((unsigned long)bp->b_addr, size)) {
> > +		ASSERT(IS_ALIGNED((unsigned long)bp->b_addr, size));
> 
> Depending on the level of paranoia about "outside" subsystems, should
> this be a regular xfs_err so we can catch these kinds of things on
> production kernels?

I'll switch to WARN_ON_ONCE.

