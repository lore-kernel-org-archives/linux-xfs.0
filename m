Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECF644AB64;
	Thu, 24 Sep 2026 22:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790289385; cv=none; b=EsZ41QFyl5HqFuRgt6EEBCOW4VK8H4Pfrlbdr1nQ4A4NsdovU3d2P4itppadADvOd5WnVgq1WAA/pwlsBFUEf2v982cZH9QPbX8tBd9XHivExXl7YfuEhY2iPUFmRdsftvMIOlLU1oob6nCnmF4TxYkD/N5O97rOfaVmP28G75E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790289385; c=relaxed/simple;
	bh=f+Y2zBdHwooikCuT6+kNpHr2IOsCvatB3zQCIYcbK1g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B8lsXkjhEwAnR3y6e6cfz1R+wCN5HLG09s3bxZFfqhdvUUIVRWhLWdUtRBagNH7DzaeHicL/RLqnOGyVXCOdZG6dyJql6pImH2l7MVrEVbPLe2Vj8vkW9BQ7rX4rC2KNNPGIDu0qOXDOY8XPzH1L8Wu5Y4hgDUtedL9bnYSscJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gMWsVbHj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gMWsVbHj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D5F821F00899;
	Thu, 24 Sep 2026 22:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790289380;
	bh=oO7pTbzOQg3p6Qohgo7dMSkUQxFRRkTdpH1EKi/kSbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gMWsVbHjI834shGtzLDCJYDtQ/4UNtFv28WaxNqgehr4uSk5Qi0ElXhbZLgtPItCp
	 Oi5dzmdXt/Go84KZeg1aTgvQ6qiLILfnR0JIi7red0yLzgevWzxZwRkAMd9qEc+8kH
	 7MDNoDSmA81s01ugXkcDGJJbcXhC/423JYFv7RbFd+v3UFbW9RBWdp+pj7T5xENCXr
	 x/pyGE23z83kgMdOmAaKOv865pGl4/xQqtP4bCGslm0ja7Ozdecba9bh0WRyono5kS
	 UE+MWLTLr4DtHNwGp5MDJuw45CQt6GbzwO+tdAGlpROf/tcV+5L+lt/+VceRhwbx63
	 QX0/GMZwu9Acg==
Date: Thu, 24 Sep 2026 15:36:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <20260924223620.GM2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-5-parri.andrea@gmail.com>
 <20260924185317.GK2705364@frogsfrogsfrogs>
 <20260924203013.9967-2-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924203013.9967-2-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 10:30:08PM +0200, Andrea Parri wrote:
> On Thu, Sep 24, 2026 at 11:53:17AM -0700, Darrick J. Wong wrote:
> > > Cc: stable@vger.kernel.org
> > 
> > Cc: <stable@vger.kernel.org> # v6.12
> 
> Fixed for v3.
> 
> > > @@ -582,8 +578,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
> > >  		/* zero out from the end of the write to the end of the block */
> > >  		pad = pos & (fs_block_size - 1);
> > >  		if (pad)
> > > -			ret = iomap_dio_zero(iter, dio, pos,
> > > -					     fs_block_size - pad);
> > > +			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);
> > 
> > I think this is the original cause of the bug, right?  We might have
> > already had a nonzero ret, and the assignment here blows that away.
> > Right?
> 
> Right.  When iomap_dio_bio_iter_one() fails we break out of the loop
> with ret < 0 and fall through to the tail zeroing, and this assignment
> replaced that error with iomap_dio_zero()'s 0.
> 
> > If the answer to that is yes, then
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Thanks, picked up for v3.
> 
> > (I should probably whine about how changing the function signature of
> > iomap_dio_zero should be a separate patch to make it more obvious what's
> > the actual fix...)
> 
> Fair point.  FWIW, before 10553a91652d iomap_dio_zero() returned void
> and neither call site touched ret; that commit made it return int and
> added both "ret = iomap_dio_zero(...)" assignments.  So the signature
> change here is really undoing the part of 10553a91652d that introduced
> the bug, and keeping it in one patch makes the stable backport
> self-contained.  If you'd still prefer a one-line fix followed by the
> void conversion, I'm happy to split it.

I'd prefer that, though I don't have a strong opinion.  Someone in
another multiverse could have come along and decided "URrgghg,
iomap_dio_zero doesn't need a farking return value!" and accidentally
fixed this bug.

Eh, whatever, just leave it as it is. :)

--D

> Thanks!
>   Andrea
> 
