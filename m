Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4B436F8EF;
	Fri, 29 May 2026 04:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028494; cv=none; b=Z8Uk2u7LlSaQRypuVkrIbzZWjBl5Ck9x3Tqjq6VTgTsIdD37zZ3nHs3KJWT/ZxcYBTj7qxNtaYepwbzK9Tcvhr0StPkN/zgsnthaTG49gdqB7e3eFi9Hti4FDSYAPzg7NfIZ76FGee8m7RKquYnbB7T/WsA/pxXKopqrYSX/QSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028494; c=relaxed/simple;
	bh=qb7jRSDzpu5h1teRd+0aA58MMxQVTZJhi0c0fCrBz7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+9t8dk5uKmgL4uPBFdUks4nmYbxZtUw7pQzYuvWQzc3KYZD0xQExJLZwRho91gJoXthqdqrF1vsFKu/CWSJKWYKc02tzycDehlmtqUANkSBAaPKADvaJz4UBLA6mmOusAQEZvO/TZRHbiYeCMLX6PJZA0xVlUaER2/ulI3QRlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7BN2xft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7BN2xft"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E4F851F00893;
	Fri, 29 May 2026 04:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780028493;
	bh=87hs9v+nh5eg+nfqJtYaj/91vZgEo6ekWlw32VFBofU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A7BN2xfteiz8cDTMXkkYIewkAw0dlJWxSnPXbDESp2tXZKHnPXe2U8cgvjz6oLNlD
	 1m6wRsPjOMv2P28NQZrfwPpFaLGVM4hQO/V4lgdpaZr7gMeYIh0Yi8IU+x79HekPTo
	 lHfKswSd8vlllZIJhMU/hIwxJPHFKSGDNdw1Nz+sL/bcE/2ki0ptLNdumfSQNSnwLi
	 EpyaWlzwE4KZEQYgvsp6gX3MInl7jR8B1mTtdaR3qoCPJ7ceVZt8c6n1Zz/t61ZadU
	 oymhSwPkBgEBilpmOTef5BFyc+X4u+7HNraAQWgrZc0tPXmEdgJLpqPmhcpbaTDeaQ
	 NZH9Xr3VNQsbw==
Date: Thu, 28 May 2026 21:21:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <20260529042131.GA6070@frogsfrogsfrogs>
References: <20260520185202.GD9544@frogsfrogsfrogs>
 <20260520190112.GE9544@frogsfrogsfrogs>
 <ahPiIAJNwjiZ9PTR@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahPiIAJNwjiZ9PTR@infradead.org>

On Sun, May 24, 2026 at 10:46:08PM -0700, Christoph Hellwig wrote:
> On Wed, May 20, 2026 at 12:01:12PM -0700, Darrick J. Wong wrote:
> > +_mkfs_xfs_supported()
> 
> Can you add a top of function comment explaininging this helper?

Done:

# Figure out if the supplied mkfs.xfs options are supported.  A device
# or file path must be specified as one of the options, though it will
# not be written.

> > +{
> > +	local mkfs_opts=$*
> > +
> > +	$MKFS_XFS_PROG -f -N $MKFS_OPTIONS $mkfs_opts
> > +	local mkfs_status=$?
> > +
> > +	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
> > +	# $mkfs_opts, try again without $MKFS_OPTIONS
> > +	if [ $mkfs_status -ne 0 -a -n "$mkfs_opts" ]; then
> > +		$MKFS_XFS_PROG -f -N $mkfs_opts
> > +		mkfs_status=$?
> > +	fi
> 
> Do we want this for a helper like this?  The automatic dropping of
> options has been a major source of mess, and if we're using a helper
> that checks to see if mkfs works, returning false and then _notrun()ing
> would seem like the saner option in general.

I copy-pasted it from the other helper, but now that I've written the
doc comment I agree with you that we should only determine if the
passed-in option set actually works.

Digression: I wonder if _scratch_mkfs_xfs_supported should have a
"-f" in its $XFS_MKFS_PROG invocations?

--D
