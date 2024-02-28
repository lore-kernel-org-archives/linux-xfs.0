Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981404085D
	for <linux-xfs@vger.kernel.org>; Wed, 28 Feb 2024 18:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709145709; cv=none; b=OfhDkwYMu8/YD5kai4TQ5nMKZAhN/dOVSOqjfuSnA8fobTP5otXlGjvAtT5IWw95lKiEHESUZXqMiwNeF6ekthGVcYPCGeJRSe1RLWicD7b3GvZ0ylkjL6g6vNem+zOZ4jShk1uJVr5DM9K3YgI6djSS4ufW3FY9rWfEOfraPgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709145709; c=relaxed/simple;
	bh=OEV7Xr54MLqGu6dTvLxH4H0DczQnPVtgWXGhgwJw+fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZEXJqZrhRnn3lzWtqJUbY0lxK+UAcgdLwyMKzcOoG4f6PdB47um0UfagOPBll2JpOcfi7C6MQdTs4ruYNhfVLuyKDcE8VuFF586OSHdj1rhkDdgR9B05BeEmSVGbJpvBxSxcks3ilPLjAydpIacTrDYGvtNEzEtGWZ3LJfjuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QAuSu4pu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QAuSu4pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24290C433F1;
	Wed, 28 Feb 2024 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709145709;
	bh=OEV7Xr54MLqGu6dTvLxH4H0DczQnPVtgWXGhgwJw+fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QAuSu4pulU4MmvRCj+Zi1LOoKWYpZVd2Fm6/HwzX7RfZmrSsc25Y4K9U5RmLrt8mo
	 KmEjehNhpq3x7DnZkrEx7Khkp3eyy/lU4MUSV+iHOMfI4QW6qU8EGsBv3BNtsvRdHD
	 mN30EIuvzi00PrbP8v0jmkMBgKohPqvm7ZYYb4e3S1oIn+KxIsG9T4+UZMNu49+6oh
	 gyO7IEzpX7YjSl8Xv4zTxfQTtIqhMaP+mCIDx6jlTfmtgKqWL157rbD3xCGbP/cgCr
	 JpqAq7dKMyD+0n5bkePL1vZbGwI7aLZe+QxI1iE6iPcGUdbBkB7ogIKhkGo4OA955x
	 uzFqbwgKdfKJQ==
Date: Wed, 28 Feb 2024 10:41:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/6] xfs: create a new helper to return a file's
 allocation unit
Message-ID: <20240228184148.GP1927156@frogsfrogsfrogs>
References: <170900011118.938068.16371783443726140795.stgit@frogsfrogsfrogs>
 <170900011198.938068.6280271502861171630.stgit@frogsfrogsfrogs>
 <Zd4EztAQFfsyz6me@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd4EztAQFfsyz6me@infradead.org>

On Tue, Feb 27, 2024 at 07:50:38AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 26, 2024 at 06:20:20PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a new helper function to calculate the fundamental allocation
> > unit (i.e. the smallest unit of space we can allocate) of a file.
> > Things are going to get hairy with range-exchange on the realtime
> > device, so prepare for this now.
> > 
> > While we're at it, export xfs_is_falloc_aligned since the next patch
> > will need it.
> 
> No really exported, but only marked non-static fortunately.
> 
> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I'll change that to say that it's removing the static attribute.

Thank you for reviewing!

--D
