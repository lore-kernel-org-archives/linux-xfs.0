Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29541F8900
	for <linux-xfs@vger.kernel.org>; Thu, 14 Nov 2024 08:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731574112; cv=none; b=l72CoOkXNp29T7W6kyJ3PKdI9xP0rh9JAqRpVBo7RioP97N/T2J4o0Kd4UdgVKh3AXb0ypnrBfNnDINjNM9p0eFHZKgOVHvBaPUaQvXMQtRaGVJDzGT9fL3VHWO7dL/2djbExb9V5s3AELTU/AKXE6nRuXQRUoUwG7SWHht6QHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731574112; c=relaxed/simple;
	bh=V6/KQ0li6Ny0bpEuGC81eDuROkamiyt1qWcwlkaoG5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLeWWjwMsnv5W0dbenD+DggBou6lrkVG+S0XY81bfpvOgKttrDsTa3nboom24TswPu244ycHdwOOKmIsaS2bavkmVNxWMYPveTAAv16SgVSbrDFFNPtFUcq0jUAXdQYlB3hFYN62dPT5DUY4C3uiAbQmgdBruiGr35RpoEyR7yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDNpOSDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDNpOSDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38AEC4CED6;
	Thu, 14 Nov 2024 08:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731574112;
	bh=V6/KQ0li6Ny0bpEuGC81eDuROkamiyt1qWcwlkaoG5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MDNpOSDI+j9UdsruxV/RBfG3Le0euH+rUv2Lbmdx2A8cTruKRfJLR/hBzV/jF2URo
	 ouf+f1Ldo0Cc5ga+eXGxO/+Nzyc6KfBUjHMVAUiQp4anUZ4wjSPLrJGeVxl6VfSOA6
	 tuQ5bdN4hAF+dxJXuf5RSIENShnPAbvW1Obv6YyCKfOiDEsfPXAL4F2Syi1rGTTurf
	 TPOmzn1ayWM2QBi3AY/21KFKvTiCl9lYo815ZvVa7jsZKB3i0jMqrOVIeV1MCquzp+
	 h54b7lHHdAeR4IU/gASSm2Q8jlUFnzUyh5W6qr5PqafRXoiL/OLwHLK74GJYTgv2Gi
	 BriDOl/GcxLrA==
Date: Thu, 14 Nov 2024 09:48:27 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, xfs <linux-xfs@vger.kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULLBOMB v5.7] xfs: metadata directories and realtime groups
Message-ID: <bvtlyg525coelkshh4sjnlbuazvijc7gnp2pyhfy4yvvvwj323@vmazu2zxfgbm>
References: <20241114062447.GO9438@frogsfrogsfrogs>
 <ZzWcG5sC7VvGC6mf@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZzWcG5sC7VvGC6mf@infradead.org>

On Wed, Nov 13, 2024 at 10:43:39PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 13, 2024 at 10:24:47PM -0800, Darrick J. Wong wrote:
> > Hi Carlos,
> > 
> > Please pull these fully reviewed patchsets for kernel 6.13.  This
> > patchbomb corrects numerous paperwork errors in the v5.5 submission so
> > that we can pass linux-next linter.
> > 
> > I have corrected my stgit wrapper program to invoke git checkpatch
> > before issuing pull requests.  Despite its name, this means I now have
> > automated checks for tagging errors in git commits.  Freeform text
> > fields that require a lot of parsing cleverness to check and that can be
> > corrupted easily buc*********.
> > 
> > This is now being resent as a v5.7 because hch pointed out that I got
> 
> My 2cents here:  don't change what's in linux-next for these kinds
> of nit picky warnings.  Linus hates last minutes rebaseѕ, and having
> two patches attribute to your instead of me and a missing hex
> digit in a Fixes tag isn't worth the hazzle.
> 
> But I've added him just in case I'm wrong.

I do agree, indeed Linus mentioned to me he doesn't like the last-minute rebases
to fix these kind of issue. He mentioned it last time I rebased for-next to fix
a short hash id.

I am not really sure about the timeline here. I'd certainly not do a last minute
rebase anymore, but I was assuming that we'd have 2 weeks from the 6.13 release,
to actually send Pull requests. So, in my mind would be ok to rebase it now, and
let it cook in linux-next until let's say next Friday 22nd, before sending them
to Linus.

But now I'm assuming rebases fall into the same rule you mentioned to me before
hch? About having everything 'ready' in linux-next before the release is
announced?

Anyway, let's wait to see what Linus prefers, I'll stand by now and leave it
as-is.

Carlos

> 
> > 
> > The following excerpted range diff shows the differences between last
> > week's PRs and this week's:
> > 
> >   1:  62027820eb4486 !   1:  0fed1fb2b6d4ef xfs: fix simplify extent lookup in xfs_can_free_eofblocks
> >     @@ Commit message
> >          this patch, we'd invoke xfs_free_eofblocks on first close if anything
> >          was in the CoW fork.  Now we don't do that.
> >      
> >          Fix the problem by reverting the removal of the i_delayed_blks check.
> >      
> >          Cc: <stable@vger.kernel.org> # v6.12-rc1
> >     -    Fixes: 11f4c3a53adde ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
> >     +    Fixes: 11f4c3a53adde1 ("xfs: simplify extent lookup in xfs_can_free_eofblocks")
> >          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >          Reviewed-by: Christoph Hellwig <hch@lst.de>
> >      
> >       ## fs/xfs/xfs_bmap_util.c ##
> >      @@ fs/xfs/xfs_bmap_util.c: xfs_can_free_eofblocks(
> >       		end_fsb = xfs_rtb_roundup_rtx(mp, end_fsb);
> >   2:  cd8ae42a82d2d7 =   2:  3aeee6851476d4 xfs: fix superfluous clearing of info->low in __xfs_getfsmap_datadev
> > ...
> >  68:  dcfc65befb76df !  68:  eae72acae5a564 xfs: clean up xfs_getfsmap_helper arguments
> >     @@ Commit message
> >          fsmap irec structure that contains exactly the data we need, once.
> >      
> >          Note that we actually do need rm_startblock for rmap key comparisons
> >          when we're actually querying an rmap btree, so leave that field but
> >          document why it's there.
> >      
> >     -    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >     +    Signed-off-by: Christoph Hellwig <hch@lst.de>
> >          Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >     +    [djwong: fix the SoB tag from hch, somehow my scripts replaced it...]
> >          Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> >      
> >       ## fs/xfs/xfs_fsmap.c ##
> >      @@ fs/xfs/xfs_fsmap.c: xfs_fsmap_owner_to_rmap(
> >       	}
> >       	return 0;
> >  69:  87fe4c34a383d5 =  69:  f106058ca77fa9 xfs: create incore realtime group structures
> > ...
> >  83:  1029f08dc53920 !  83:  12693186fbb282 xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
> >     @@
> >       ## Metadata ##
> >     -Author: Darrick J. Wong <djwong@kernel.org>
> >     +Author: Christoph Hellwig <hch@lst.de>
> >      
> >       ## Commit message ##
> >          xfs: factor out a xfs_growfs_rt_alloc_fake_mount helper
> >      
> >          Split the code to set up a fake mount point to calculate new RT
> >          geometry out of xfs_growfs_rt_bmblock so that it can be reused.
> >  84:  fc233f1fb0588a =  84:  52690d80b09ca5 xfs: use xfs_growfs_rt_alloc_fake_mount in xfs_growfs_rt_alloc_blocks
> > ...
> > 110:  b91afef724710e ! 110:  d4918d151be0bd xfs: don't merge ioends across RTGs
> >     @@
> >       ## Metadata ##
> >     -Author: Darrick J. Wong <djwong@kernel.org>
> >     +Author: Christoph Hellwig <hch@lst.de>
> >      
> >       ## Commit message ##
> >          xfs: don't merge ioends across RTGs
> >      
> >          Unlike AGs, RTGs don't always have metadata in their first blocks, and
> >          thus we don't get automatic protection from merging I/O completions
> > 111:  d162491c5459f4 = 111:  54a89f75c4d972 xfs: make the RT allocator rtgroup aware
> > ...
> > 139:  13877bc79d8135 = 139:  c70402363d6d27 xfs: port ondisk structure checks from xfs/122 to the kernel
> > 
> > Apologies for the last minute churn and paperwork stress.
> > 
> > --D
> ---end quoted text---
> 
