Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AE813441E
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713291307; cv=none; b=i9I/6ub29vli2OP9tIlQgPFHO9fODQCGQTrKKdGEcUf9IWb1+EP+OsDUoW/oS6EXtiEJy04y77EoluYOwGrDzwBEki0572Dpxw+6nKrxPVN3701f79mT0zTl0nBFZi9cZ4iK1Np3byilCqYe6CFkXmk2iEJ51bDADm8Rjl8alas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713291307; c=relaxed/simple;
	bh=tlX+6WB7VSyipzOl5jt/p2kQoaMlXWTQlLolUYpgSI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkPzYYpLmmm1NR83W7W9M1MHeBGY719GZVOiJPRdhrtDlwsAbgpo9QUsp/ANPD/K4RXep4A8WTxV+6FZ7Re00FTzha0a/8Uz1YPb6g6mF9Dv1aBm7OZe1r3wpZWQTfzU0Vui/10deyi4LaqDLN7NRXke3SQSYJlbYXQ3FB946n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKkMrwyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKkMrwyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7614DC113CE;
	Tue, 16 Apr 2024 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713291307;
	bh=tlX+6WB7VSyipzOl5jt/p2kQoaMlXWTQlLolUYpgSI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKkMrwyyLxxVUHw31X6e93zBereX4HmnoMwYNA36GW/ifN1HgTp92P3/uBRBzao6t
	 dR6n58cbWTrSZ0bcRlNf/uLitcQk/KLHj7KsMb1bqJo22KVU7NUJ9DOUNILj5eEr5V
	 Ka848h5Whg8qbcq+22ygyY5RVcme4F/Aze5w2hHSg8xa9jkk18XC+5BF3U+d52kLtX
	 MFxQkAXzu6tHYU3MpwSGXrxrHA8aDy+54f9Y2kwg6Dc++gSp2sdavOZQBkkbg0zLxE
	 GHo8ubapugwFgZE+ZfCSu1Md9tp+TqPsZM8Pmu5l6rq3nr8bdNuzbtmot9TI2rFHh/
	 PX1NPdlM6awcQ==
Date: Tue, 16 Apr 2024 11:15:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: allison.henderson@oracle.com, linux-xfs@vger.kernel.org,
	catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: remove some boilerplate from xfs_attr_set
Message-ID: <20240416181506.GW11948@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029202.253068.8909364981150861497.stgit@frogsfrogsfrogs>
 <Zh4L7GHePxopGrNy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4L7GHePxopGrNy@infradead.org>

On Mon, Apr 15, 2024 at 10:26:04PM -0700, Christoph Hellwig wrote:
> On Mon, Apr 15, 2024 at 06:36:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > In preparation for online/offline repair wanting to use xfs_attr_set,
> > move some of the boilerplate out of this function into the callers.
> > Repair can initialize the da_args completely, and the userspace flag
> > handling/twisting goes away once we move it to xfs_attr_change.
> 
> Not a huge fan of moving more into the weird attr_change wrapper
> that feels entirely misnamed and out of place.  But if this gets us
> moving on the parent pointers it looks good enough:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

> I'll probably do a pass on the higher level attr API at some point
> anyway to sort much of this out.

I look forward to seeing it. :)

--D
