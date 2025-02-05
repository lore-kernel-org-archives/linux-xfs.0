Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C2204C1A
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 21:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738790220; cv=none; b=Jt1VVrzEqhEH0Dqj8Oar7GdaJo3m3brl94d+TYkGz0KxO588HRl6MSHTi2liKfQsCLgwCVfJl0o9Uf2h4I9dtU1mPC2cbEtGhZxfl463Wu1F4lnR04gHFsKWy8R5JQXJvoFvnHQkyPl1DdbDN25EETkAyEmtOAY4tD0VQKTA2yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738790220; c=relaxed/simple;
	bh=2I6d2FnutGNGAKchM4YOmeotfNxdfXZQRAvpFvzyPDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OMNTcvB2buYD+7+kyO16t6N4G+ytlVDjNh5lK3bszHTLt7uFj7sGXYECHIZ/hbvDl5uKgOUqvOhqs/N54ixI8jc68V3JkzsFWqPUGlW0+YmaGw9gbbQeDmYjOk8rD1Dvth1LgXldrPPZQPY7Xy8C2LSLCnL9aI4d54PInD6JNKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAYmU4Dt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAYmU4Dt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2374C4CED1;
	Wed,  5 Feb 2025 21:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738790219;
	bh=2I6d2FnutGNGAKchM4YOmeotfNxdfXZQRAvpFvzyPDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZAYmU4DtqbQzkLRna6APo+PfyT0uKPkj3/qgFSaPi5cRo8yfl+XDoqtB7rgUYRQKS
	 v8TtoqTu6jNyi/lhyA1pGbAzWaajXKaZQ39cPQO+dBACBjCDoi9cCL6FIQu6XwLLIx
	 l8mDosiiPPlBl+2cznBK2Mmo+Gg2NHyWVLlmhbSAwoGnz+r7VQuyP3+s+Aea/oYMJa
	 cKcm4Xfd6nET23k9ypLbhShLdymO4f7DpWhjRlcG80DI5cZKDFyB0q3h0FZI3t66tq
	 6g2yKzAJbCs3wEVnJydl+qm+vpfRIQQW6ZB6qhGLaHQxmbLqhvAqVrHa1zRaQmszEZ
	 LO4nnFwyO9cOg==
Date: Wed, 5 Feb 2025 13:16:59 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-ID: <20250205211659.GC21808@frogsfrogsfrogs>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-2-hch@lst.de>
 <Z6PTPoYfyn-1-hHr@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6PTPoYfyn-1-hHr@dread.disaster.area>

On Thu, Feb 06, 2025 at 08:08:14AM +1100, Dave Chinner wrote:
> On Wed, Feb 05, 2025 at 05:28:00PM +0100, Christoph Hellwig wrote:
> > Fix the brand new xfstest that tries to swapon on a recently unshared
> > file and use the chance to document the other bit of magic in this
> > function.
> 
> You haven't documented the magic at all - I have no clue what the
> bug being fixed is nor how adding an inodegc flush fixes anything
> to do with swap file activation....
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 69b8c2d1937d..c792297aa0a3 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -21,6 +21,7 @@
> >  #include "xfs_error.h"
> >  #include "xfs_zone_alloc.h"
> >  #include "xfs_rtgroup.h"
> > +#include "xfs_icache.h"
> >  
> >  struct xfs_writepage_ctx {
> >  	struct iomap_writepage_ctx ctx;
> > @@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
> >  	struct file			*swap_file,
> >  	sector_t			*span)
> >  {
> > -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
> > +	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
> > +
> > +	/*
> > +	 * Ensure inode GC has finished to remove unmapped extents, as the
> > +	 * reflink bit is only cleared once all previously shared extents
> > +	 * are unmapped.  Otherwise swapon could incorrectly fail on a
> > +	 * very recently unshare file.
> > +	 */
> > +	xfs_inodegc_flush(ip->i_mount);
> 
> The comment doesn't explains what this actually fixes. Inodes that
> are processed by inodegc *must* be unreferenced by the VFS, so it
> is not clear exactly what this is actually doing.
> 
> I'm guessing that the test in question is doing something like this:
> 
> 	file2 = clone(file1)
> 	unlink(file1)
> 	swapon(file2)
> 
> and so the swap file activation is racing with the background
> inactivation and extent removal of file1?

Yes, I think hch is referring to this:
https://lore.kernel.org/fstests/2c9ff99c2bcaec4412b0903e03949d5a3ad0d817.1736783467.git.fdmanana@suse.com/

> But in that case, the extents are being removed from file1, and at
> no time does that remove the reflink bit on file2. i.e. even if the
> inactivation of file1 results in all the extents in file2 no longer
> being shared, that only results in refcountbt updates and it does
> not get propagated back to file2's inode. i.e. file2 will still be
> marked as a reflink file containing shared extents.

Right, but the (iomap) swapfile activation code only errors out if the
filesystem gives it a mapping that is marked as shared.  So the reflink
flag isn't relevant here.

How about this for a better comment:

"Ensure inode GC has finished so that unlinked clones of this file have
been truncated and inactivated fully.  This is to ensure that walking
the swap file does not find any shared extents."

> So I'm kinda clueless as to what this change is actually
> doing/fixing because the comments and commit message do not describe
> the bug that is being fixed, nor how the change fixes that bug.

I wasn't too clear on how the xfs_inode_buftarg() call was magic, it
just had a lot of parentheses.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
