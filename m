Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0EA1F95C
	for <linux-xfs@vger.kernel.org>; Tue, 15 Jul 2025 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752594932; cv=none; b=iCUYxAV1SfoOio5850p5UJeJAnuVhNv1+4E+V7MHifdTDx/bkyMfkn6ZbMAlRnBdOihcXE1DK/I9Hq9BxbtH40DoZYp9YGWfxqH9+hwFRkwKnjbpAntLK6c+eWdFTbAfie7tbVeMy/1TmCtTbrcoojeKAhxe+yv5sp4Ro9/3du8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752594932; c=relaxed/simple;
	bh=lD6gQrElj+TT9i1xEIwnpaVBvXND4WI3GouZTRZK6SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVD8/yyuPjtFiRodtHJKBh9tfvrjHd0qnZjOSSGTQmxBn16Pj3qdgMIw1wwovB3IO/wLp6A3oldNOkNLypnjB8x1JBp/B8fBze3LH3Jdvxl7NEUexHhpLMQ0DIDNfDrdESBuADySyG1XumuW21POFLZL1SH0+EoSlyPb0baPvwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=INmej0b4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="INmej0b4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2CEC4CEF1;
	Tue, 15 Jul 2025 15:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752594932;
	bh=lD6gQrElj+TT9i1xEIwnpaVBvXND4WI3GouZTRZK6SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=INmej0b4/lwegd8ZZUd4DsrO4Wi4KWSdQp+AhgPtL2gogy70MvS95TKZ4e479Lc4b
	 E9xgTho0klpZ4IUwITmVP4FTzTJXZNWKCnY+3SzmbmzQ1GvULDmLhZ2DqYiUniO78J
	 RBJAMiotJaqDO31paeHG1TIcJd6rUUoNS2r2JzIXx2WUyZ3VJLVbMwqgtX6RzzXnC7
	 A0j/pv3GakSPQgg259OWwhgiJQXZfSzJiyycgNhtkqi7UhqfvCWmZHRbo+hdM089aB
	 liPAs91C3u5lEIybwWKqW/8eCBKT00Wy2gOC17Ge0uQO+kM6vv+kVbWtOavkhA+MJs
	 WHnnReiZbQdVw==
Date: Tue, 15 Jul 2025 08:55:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't use xfs_trans_reserve in
 xfs_trans_reserve_more
Message-ID: <20250715155531.GB2672049@frogsfrogsfrogs>
References: <20250715122544.1943403-1-hch@lst.de>
 <20250715122544.1943403-3-hch@lst.de>
 <20250715144944.GU2672049@frogsfrogsfrogs>
 <20250715153500.GA29642@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715153500.GA29642@lst.de>

On Tue, Jul 15, 2025 at 05:35:00PM +0200, Christoph Hellwig wrote:
> On Tue, Jul 15, 2025 at 07:49:44AM -0700, Darrick J. Wong wrote:
> > > +	if (blocks && xfs_dec_fdblocks(tp->t_mountp, blocks, rsvd))
> > > +		return -ENOSPC;
> > > +	if (rtextents && xfs_dec_frextents(tp->t_mountp, rtextents) < 0) {
> > 
> > xfs_dec_frextents is checked for a negative return value, then why isn't
> > xfs_dec_fdblocks given the same treatment?  Or, since IIRC both return 0
> > or -ENOSPC you could omit the "< 0" ?
> 
> No good reason, I'll make sure they use the same scheme.  I don't care
> which one, so if you prefer the shorter one I'll go for that.

I have no particular preference either way.

--D
