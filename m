Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7ABE226529
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734624005; cv=none; b=huY1uPtKOSi1/5G9MIgmVlaJWnYsY+XTsGMdg/mWoBOk7uk8AlBb2UvZMd7+hQQsxsrrCU6jjZaFRrzVDFnyteTxc/Pp+FZLi/iWnYOnUrGJPtw6NDXRTqBkCuxfmPNqgNBQks9KYNlZW8a8Cd5+3ZR41tXBoSLelKS+gPmceUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734624005; c=relaxed/simple;
	bh=aAhBcOMVYBbUe3A3kirjkVjcgxvNLrDBWhPR4/6L6Zk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fe7qOtiVA+uSV29KpbmLDaaQM0YojBedTC6Xl+DGFEeAxUyhcge9jaIArf0ELBm5NCvqXlHCUFryZeMII1Q2NVtEhIHndGrgKBUpH1sUx0XJA6me21Q7coNbAbXN267cENhtverEdtu8e3xc8TFq6D8rric03TjlG1SQOIuqNEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jU/tEG1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jU/tEG1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E65AC4CECE;
	Thu, 19 Dec 2024 16:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734624005;
	bh=aAhBcOMVYBbUe3A3kirjkVjcgxvNLrDBWhPR4/6L6Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jU/tEG1uIEEAWPTjeSlim2Jh6Xw6sFb8ppbB7k2Apt/z0ucg/QR/Eyf7a/i04Ouda
	 uf9SI/5nOGZ3e5fQYx1yr4CHFg/SCf3VZJWnqH04ady4sMZVba/2Z9YxwMNJRxYIup
	 /g25gR7/eGZG6VwjePFH1J2rkpx4/7vHJD0GztaYjWOU8jk+bawNuzfFrcIE2A48kj
	 X2Xw+V3frDqP77sRU+V7dpFC3Xf1xPrfG8hkqAaMOipHyqsU1J6yct/aycV+FhlzDb
	 KHNxO/J2fnj6LD3NSzCAeVQwZZQ+lNlGnRowWxzlECPH5R5pZmXY7ZvN1FAMTeTqwB
	 560jlLDLhsAbg==
Date: Thu, 19 Dec 2024 08:00:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/43] xfs: add support for zoned space reservations
Message-ID: <20241219160004.GI6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-26-hch@lst.de>
 <20241213210140.GO6678@frogsfrogsfrogs>
 <20241215053135.GE10051@lst.de>
 <20241217165955.GG6174@frogsfrogsfrogs>
 <20241219055059.GA19058@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241219055059.GA19058@lst.de>

On Thu, Dec 19, 2024 at 06:50:59AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 17, 2024 at 08:59:55AM -0800, Darrick J. Wong wrote:
> > Hrmm, they're rt extents that are available "now", or "for cheap"...
> > 
> > XC_FREE_NOW_RTEXTENTS
> > 
> > XC_FREE_RTEXTENTS_IMMED
> > 
> > XC_FREE_RTEXTENTS_CHEAP
> > 
> > Eh, I'm not enthusiastic about any of those.  The best I can think of
> > is:
> > 
> > 	XC_FREE_RTEXTENTS_NOGC,	/* space available without gc */
> 
> I really hate that, as it encodes the policy how to get (or not) the
> blocks vs what they are.

Yeah, me too.  Want to leave it as XC_FREE_RTAVAILABLE?

> > > > going to use the greedy algorithm.  Later I see XFS_ZR_GREEDY gets used
> > > > from the buffered write path, but there doesn't seem to be an obvious
> > > > reason why?
> > > 
> > > Posix/Linux semantics for buffered writes require us to implement
> > > short writes.  That is if a single (p)write(v) syscall for say 10MB
> > > only find 512k of space it should write those instead of failing
> > > with ENOSPC.  The XFS_ZR_GREEDY implements that by backing down to
> > > what we can allocate (and the current implementation for that is
> > > a little ugly, I plan to find some time for changes to the core
> > > percpu_counters to improve this after the code is merged).
> > 
> > Ah, ok.  Can you put that in the comments defining XFS_ZR_GREEDY?
> 
> This is what I added earlier this week:
> 
> /*
>  * Grab any available space, even if it is less than what the caller asked for.
>  */
> #define XFS_ZR_GREEDY           (1U << 0)
> 
> Do you want the glory details on why we're doing it here as well?
> I guess it if can't be left as an exercise to the reader I'd probably
> rather place it in the caller.

Nah, that's enough to hint at what I should be looking for any time
there's a branch involving XFS_ZR_GREEDY.

--D
