Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EF8156875
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 22:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724970875; cv=none; b=JjrMSr6ZsKVmt3tqGl6kSt7lGx9hbrcW/Xprq3g4YjhyqbvxslSVGQabpBGy8ZqawKXXobfpnncnQ+v7Lihjmnl0uV7x5aMIo8iS0chNH9d3rxnParstIFwyTxo/Rf1m8D2HVq8JOdWQpAZEGIsOh7Gwgd4CEFGOWHLLDuVXNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724970875; c=relaxed/simple;
	bh=vh0GAlA/4nTVCB8rmeP6plCfxlSCBBfY0CmRwCjKCsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIqhoiZUzjQdfE/SMyjhBDscV0vszZNvoqVmQX7/I79uogLD6C92p1Auhz89GrwUyXNRoXcOhoP70zIW+Yt3iv4Kk2pPWl5cFL1t8qZIV2zCpbB0A8E3Igli+0rNHWXaZEIS/Y9Q273wdwnCFkReUc751XTkD3GMrqK4ZsvoW8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kZFapnXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kZFapnXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B09C4CEC1;
	Thu, 29 Aug 2024 22:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724970875;
	bh=vh0GAlA/4nTVCB8rmeP6plCfxlSCBBfY0CmRwCjKCsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kZFapnXFY3+9d4xxyJttKNoymOH2KzRm3R8UOHbKjddIrrMKDsIdjGOxsd9G01P0C
	 b0rzh+mQQjaRUhbnOu2KkMONKhObInCgYuItkkvl2lx7p5mv2L9+CLNPpIEE0UdyfI
	 r8tKema14CiHOFfwS+14fzbbe8/NQilj+kocpLIpI1zGbT+rPftK++rlq6GM3LZ6JR
	 XbuvXa6B+fqWNTk1ZZhXc2Ua0K6i3K+LaMPdgogpVcFQTkaz9bQ37jGcUJtNA5z623
	 0+oZ7KMQ43VfHRGl+kdPLoINeSVFmF6Rz8eeaMtJZ9+X39M2ZTOy9BSsetM9/iejlS
	 MOBlxA5rspgqg==
Date: Thu, 29 Aug 2024 15:34:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
Message-ID: <20240829223434.GS6224@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
 <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs>
 <20240828041424.GE30526@lst.de>
 <Zs/XUl2ImQHFxhKP@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs/XUl2ImQHFxhKP@dread.disaster.area>

On Thu, Aug 29, 2024 at 12:05:06PM +1000, Dave Chinner wrote:
> On Wed, Aug 28, 2024 at 06:14:24AM +0200, Christoph Hellwig wrote:
> > On Tue, Aug 27, 2024 at 04:35:01PM -0700, Darrick J. Wong wrote:
> > > This helps us remove a level of indentation in xfs_iroot_realloc because
> > > we can handle the zero-size case in a single place instead of repeatedly
> > > checking it.  We'll refactor further in the next patch.
> > 
> > I think we can do the same cleanup in xfs_iroot_realloc without this
> > special case:
> > 
> > This:
> > 
> > > +	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> > > +	if (new_size == 0) {
> > > +		kfree(ifp->if_broot);
> > > +		ifp->if_broot = NULL;
> > > +		ifp->if_broot_bytes = 0;
> > > +		return;
> > 
> > becomes:
> > 
> > 	if (new_max == 0) {
> > 		kfree(ifp->if_broot);
> > 		ifp->if_broot = NULL;
> > 		ifp->if_broot_bytes = 0;
> > 		return;
> > 	}
> > 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
> 
> I kinda prefer this version; I noticed the code could be cleaned
> up the way looking at some other patch earlier this morning...

As I pointed out to Christoph in this thread already, this change won't
age well because the rt rmap and refcount btrees will want to create
incore btree root blocks with zero records and then create btree cursors
around that.  This refactoring series, incidentally, comes from the
rtrmap series.  Cursor initialization will try to access ifp->if_broot,
which results in null pointer deref whackamole all over xfs_btree.c if
we do that.

I'm working on a better solution than that, which might be pointing
if_broot to a zeroed out rodata xfs_btree_block object and amending
xfs_iroot_free not to delete anything that's not a heap pointer.

We don't need that here yet because the bmap btree code only sets
new_max==0 when it's tearing down the ondisk btree prior to converting
to FMT_EXTENTS, but I'd rather not change this patch now just to revert
it a month from now back to what I originally posted.

--D

> -Dave.
> 
> -- 
> Dave Chinner
> david@fromorbit.com
> 
