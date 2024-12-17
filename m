Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FF812C475
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734464640; cv=none; b=hz6XxQEmw+vnXKwUNcApRP2OvzjE2errwx3eFhX3Zq68GhS2gyi5HuB/SI4NWnRPcaikQ5dGCboZHYwl7rTGlH55bC0tULOQJ9u4zRk1bKhhKRww6zCs24rxbsHCjGQaKASzFDzE/2R9gcWpz1pYKwiy6xe29c41jMk59vFAVXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734464640; c=relaxed/simple;
	bh=gmQht9aaUTAtN0gdXHNKrlo/D1UFS1/+23IGG9z7w6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2EGshJjySTmqJVstYu5LWqpsUZIkfy0KF/OIZvfw+Ys1oxUuUW191eMZ3h3JMqqUyy8vanHhIjBm3cdJnm7ujbnyVe8Jyr9hk+KbYdAHmeoPN7QNRnayE5HANkuANcTwVx8iyhKeYduomEjkuUdqWx3oqWcJ3eUMhqZPuVt/GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/g2s7D5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/g2s7D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB33C4CED3;
	Tue, 17 Dec 2024 19:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734464640;
	bh=gmQht9aaUTAtN0gdXHNKrlo/D1UFS1/+23IGG9z7w6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i/g2s7D5Br6UW9htAE5rLCm0T5iht5g4+TtvJJd+ixVK5mTFdd9qTdG5r8raAH58p
	 4UpNshNcgUtdU+zrOT9d3tljjyYot4rH2ZGbc4M4F+mENhubuMqDkexwQNFp13Iei+
	 DBMYYsFn8jru5ZQz0HvbRto7BWQm6G1zG/bo4mAlmcGqFKvCNP/M3ko99Bz0oD1YuL
	 HKbOtWwmDzLaZUlEzK4h9j6whhKOruq/eQvF3g2iXWYkz7c5YMkS1gg59SvI/M0JtF
	 TSnMsNeJBbwT6l2dFZBphXfKF10H6J1Czl6GDq1ahtVGw9ROCDFwDG/j1U4GOGaDYw
	 DElMGCEY17CLA==
Date: Tue, 17 Dec 2024 11:43:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: refactor the inode fork memory allocation
 functions
Message-ID: <20241217194359.GO6174@frogsfrogsfrogs>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
 <173405122193.1180922.17980274180527028926.stgit@frogsfrogsfrogs>
 <Z1vOqMD-yROh6gY1@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1vOqMD-yROh6gY1@infradead.org>

On Thu, Dec 12, 2024 at 10:05:28PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 04:58:30PM -0800, Darrick J. Wong wrote:
> > -	ifp->if_broot = kmalloc(size,
> > -				GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> > -	ASSERT(ifp->if_broot != NULL);
> > +	broot = xfs_broot_alloc(ifp, size);
> > +	ASSERT(broot != NULL);
> 
> Maybe use the chance to drop this somewhat silly assert?  If a NOFAIL
> allocation fails we're in deep trouble, and the NULL pointer dereference
> a bit below will catch it anyway.

Will do.  Thanks for reviewing!

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> 
