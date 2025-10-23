Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4AFD1474CC
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 15:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761231753; cv=none; b=EOQqY7QAKg/HczauF2dg5genQw03L6Qhg0qYIkyIATIUFahoD/xqlTNI/od1SXvdvAnBDRQR46GapCS89C4o4xTl9ZDWIwcieXHHMe2d85CQSTaEg8spJjrqO4hFPWmQ6XwlWLqaByH9LMzDXSIBuT+AGOxPpG10QvDgY3H7HP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761231753; c=relaxed/simple;
	bh=sTBxkHODSz/thYQFlwZfj+rrMxwY7Jb1gnoOq20mMfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dzOMzEYiMJWWCgJQ2neF6NWRrixtIg+l7MdjDqCxoBtyw2IMl22f1fTh4E7p4ZvQYyKU9OaaW5hJB1y6mu6wTOiinI3teoehvQsB4oj+CqYGcVfVRL+jcjTYlkeEXiIegXWuaPDbmFs8x5MXPeDnRYayX7nZVCoQi1FN16T0iks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUiBoA4/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUiBoA4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4735AC4CEE7;
	Thu, 23 Oct 2025 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761231753;
	bh=sTBxkHODSz/thYQFlwZfj+rrMxwY7Jb1gnoOq20mMfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUiBoA4/zleiHhPWRLL0tpZwjSQJoRpC98Fux821ggyvz813EM2B1vvlSBLpFXQLz
	 my4nvgMJidbS67v0IiV4k4G6HBWQYKQWL9bUbVLnNmlJRv2iqXQmKH82dNVBr5R5g8
	 1UDDk2u+0p02+b0lcaVepanUDrTNlCw9VCjIIxzFg/mILJLrXx6PwBcyxwLzaX/y0O
	 ck0m7TusEZ5Q5p0Ekhz646qK8tJq2RHGGVYiSnI5OndWIqm1Mlx2Ho9qOgPY05jzBZ
	 9ZmMSCajI5vJj0ik9ktj0SFlRyhKp95Pqh3oPeutvDbUHs68gud13kglFYE/h/U3Od
	 hPRNJEfXYSsHw==
Date: Thu, 23 Oct 2025 08:02:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <20251023150232.GI4015566@frogsfrogsfrogs>
References: <20251017060710.696868-1-hch@lst.de>
 <20251017060710.696868-2-hch@lst.de>
 <20251023061622.GP3356773@frogsfrogsfrogs>
 <20251023062829.GA29564@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023062829.GA29564@lst.de>

On Thu, Oct 23, 2025 at 08:28:29AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 22, 2025 at 11:16:22PM -0700, Darrick J. Wong wrote:
> > > +		/*
> > > +		 * If the zone is already undergoing GC, don't pick it again.
> > > +		 *
> > > +		 * This prevents us from picking one of the zones for which we
> > > +		 * already submitted GC I/O, but for which the remapping hasn't
> > > +		 * concluded again.  This won't cause data corruption, but
> > 
> > "...but that I/O hasn't yet finished."
> 
> It's really the remapping after the I/O that has to finish, but given
> that we talk about I/O earlier, maybe your wording is less confusing.

The word 'again' at the end of the sentence tripped me up.  I think the
word you want there is "yet" (because "again" implies that this isn't
the first time we've remapped the space, which isn't true) but you could
also end the sentence wit` "concluded".

--D
