Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB2755C29;
	Thu, 21 Nov 2024 16:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732205056; cv=none; b=ZnYex4Nwy6Bqziwl6dfSUr4x9aaSy2nqyToZ/HRY0XkvU9IxiwjLHiUBx5OVRTxauTKEYNl74hHko0AE0k8kGZm+xk1e/6nbS7gMhF+zO0Ea7//E9+xtHQJzoUjE9mGvRxlCBz9NoMtORwwZoPO5TdlHfgILJCmyKotjmwpM5VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732205056; c=relaxed/simple;
	bh=HJSzPSfUfKS7kLce85ECaVvJhuq9GxRRF3FYyUFhh7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8DggztE/2H/HzPsN62TIB7vXqswKp4XMuTVw6vc+Vl1y0w999jI4+seI6BOLxnXxLfPZadKY/zhCHA0fATKDNXQgiu5Km7n6F3XQI2dZ/1h+T5FfGvCoicCHEhuFuIaIcIjD6WwWhidBCY1dvIrxV7KPkvT9nXjLdXJfnRP9zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y2SDwF+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y2SDwF+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C7DC4CECC;
	Thu, 21 Nov 2024 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732205056;
	bh=HJSzPSfUfKS7kLce85ECaVvJhuq9GxRRF3FYyUFhh7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y2SDwF+sbd7or2qlwtYuJ9RcA1HzTLeGx1uB6Ca0j17B96l46zoRBvpwF3Rrqgyz/
	 lmD0sRqbzO9cmb0DsWi1F4RL/J8+BKxNCCC2W6X7PY2DOVNGVjDsfHaK4MOy7dxLMG
	 cMtgTdS+PO+Kb2xsslmsEvPiA5TWnFzkShTFz/qOMDD0KlsFToAvDLPGXkULQt2EAw
	 tPRauliV3s3+omrsLathFEb2fNsvEP8Qkt310evYL/OeOi6zgl4n4DmXUTz7QjH7Ws
	 3hvHMMVNA/l+TonaKqHE/+yhvOrqq5lQwid5l0XLTbHfSnm7pj7Y21wJOWngAPyve0
	 ZpDUf5N9YRVcA==
Date: Thu, 21 Nov 2024 08:04:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241121160415.GT9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz8nWa1xGm7c2FHt@bfoster>

On Thu, Nov 21, 2024 at 07:28:09AM -0500, Brian Foster wrote:
> On Thu, Nov 21, 2024 at 11:05:55AM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 21, 2024 at 05:56:24PM +0800, Zorro Lang wrote:
> > > I didn't merge this patch last week, due to we were still talking
> > > about the "discards" things:
> > > 
> > > https://lore.kernel.org/fstests/20241115182821.s3pt4wmkueyjggx3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#u
> > > 
> > > Do you think we need to do a force discards at here, or change the
> > > SCRATCH_DEV to dmthin to support discards?
> > 
> > FYI, I'm seeing regular failures with generic/757 when using Darrick's
> > not yet merged RT rmap support, but only with that.
> > 
> > But the whole discard thing leaves me really confused, and the commit
> > log in the patch references by the above link doesn't clear that up
> > either.
> > 
> > Why does dmlogwrites require discard for XFS (and apprently XFS only)?
> > Note that discard is not required and often does not zero data.  So
> > if we need data to be zeroed we need to do that explicitly, and
> > preferably in a way that is obvious.
> > 
> 
> IIRC it was to accommodate the test program, which presumably used
> discard for efficiency reasons because it did a lot of context switching
> to different point-in-time variations of the fs. If the discard didn't
> actually zero the range (depending on the underlying test dev), then at
> least on XFS, we'd see odd recovery issues and whatnot from the fs going
> forward/back in time.

Yes, that's my recollection too -- performing a logwrite replay of an
old mark means that you can end up with blocks with the correct fs uuid
but an LSN that's higher than anything in the log.  Recovery will then
skip the block replay, which is not correct.

I suppose we could fix log recovery to treat incoming block LSNs that
are higher than the log head as if there were no block contents at all.
OTOH going backwards in time isn't usually a concern...right?

> Therefore the reason for using dm-thin was that it was an easy way to
> provide predictable behavior to the test program, where discards punch
> out blocks that subsequently return zeroes.

Yep.  The test needs to reset the block device to a zeroed state.
Discards get us there quickly, but only if discard_zeroes_data==1.
Hence bolting dm-thinp (where this is guaranteed) onto the logwrites
tests.

> I don't recall all the specifics, but I thought part of the reason for
> using discard over explicit zeroing was the latter made the test
> impractically slow. I could be misremembering, but if you want to change
> it I'd suggest to at least verify runtimes on some of the preexisting
> logwrites tests as well.

Not sure -- I think BLKZEROOUT will cause allocations and real disk
writes if we're not careful.

--D

> Brian
> 
> 
