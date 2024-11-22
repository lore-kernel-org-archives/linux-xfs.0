Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1782282FA;
	Fri, 22 Nov 2024 12:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732278887; cv=none; b=Ed9s4amwXMA3JfrYO39SkEMOWgG/ZrBpkzHcsmVGnWL3irOkDj5zVqVWutcVyq21kNNDlv6nJOBvssOmGZl0ICUBHyRcI2opUrUwmZHysULJB14hJm3Kjdtn/97N7WdJuWv5ECLcYbOnMeR/m+TnaP2Xf0KE3/QXJuDl0WRWVD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732278887; c=relaxed/simple;
	bh=vsRS/0uGc+CsrwswQNtOOB9khziFXXSwzn6ym28O8Wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCGuS3dGZiifWRQrXy1WMW8pmRw9qxhfT2IfYiH0cSjBxaq341JDb0H/i2ChEDPX7NllWLfKqCtddo7P3JS1CM8dIVhTtXNl42nhZTvGct5SAdO8qfHvomsBhNsh1ED457F7q9xtpORG3igIy8L6u6hoDUNa2hbm1hoTSsKsplc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CDA4C68D0A; Fri, 22 Nov 2024 13:34:42 +0100 (CET)
Date: Fri, 22 Nov 2024 13:34:42 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122123442.GB26198@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <Zz8nWa1xGm7c2FHt@bfoster> <20241121160415.GT9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121160415.GT9425@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 21, 2024 at 08:04:15AM -0800, Darrick J. Wong wrote:
> > IIRC it was to accommodate the test program, which presumably used
> > discard for efficiency reasons because it did a lot of context switching
> > to different point-in-time variations of the fs. If the discard didn't
> > actually zero the range (depending on the underlying test dev), then at
> > least on XFS, we'd see odd recovery issues and whatnot from the fs going
> > forward/back in time.
> 
> Yes, that's my recollection too -- performing a logwrite replay of an
> old mark means that you can end up with blocks with the correct fs uuid
> but an LSN that's higher than anything in the log.  Recovery will then
> skip the block replay, which is not correct.
> 
> I suppose we could fix log recovery to treat incoming block LSNs that
> are higher than the log head as if there were no block contents at all.
> OTOH going backwards in time isn't usually a concern...right?

It's probably the best we can do.  Recover as far as everything validated
and then give up.

> 
> > Therefore the reason for using dm-thin was that it was an easy way to
> > provide predictable behavior to the test program, where discards punch
> > out blocks that subsequently return zeroes.
> 
> Yep.  The test needs to reset the block device to a zeroed state.
> Discards get us there quickly, but only if discard_zeroes_data==1.
> Hence bolting dm-thinp (where this is guaranteed) onto the logwrites
> tests.

discard_zeroes_data was unfortunately always broken as no standard
gives you any such guarantee.  The best you get is a guarantee that
it returns zeroes if it actually deallocated the block, but if it
deallocates a given block or not is a black box.

> 
> > I don't recall all the specifics, but I thought part of the reason for
> > using discard over explicit zeroing was the latter made the test
> > impractically slow. I could be misremembering, but if you want to change
> > it I'd suggest to at least verify runtimes on some of the preexisting
> > logwrites tests as well.
> 
> Not sure -- I think BLKZEROOUT will cause allocations and real disk
> writes if we're not careful.

If the device reports a queue/write_zeroes_max_bytes it supports a hardware
offload.  That could still write zeroes to the media if the device
is stupid enough, but hopefully not many are.

