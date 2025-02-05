Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129FD1DD526
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 22:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738793143; cv=none; b=N5SydzjAWzL31MF9FhMHjz/+si3s0+cO1VJIMuKvSy7hlfO56qbq31ll85INexyW93ywufLEcuRb+ThOFT/bvgOom8SNfRqqwz6en4iO90F6iv3imaM8pzoj4lGmp1QOXIhF7LeebHR2KJDaC2BwUJ2OH22RYg92kbh8UaaI54E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738793143; c=relaxed/simple;
	bh=itpOpzBn/bvpSc+LAMcy3iUODma0z+EJ8n2okgFSodc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jsxF4DLsJSaNoZk+9T4TN3de4faTry68Z6xVP9HGVx8x7Bj+Q2VDsE5pH5Q2gYsbSrZxgDPa+bS3p6Vu8GEFRwSwbfcPJI0NZCr0u+c12VgLykGbPpgOawmo6G9M4u63iZxU3YPb9WMN+1v+9Wl5Nox8sqNde9NK92AsTW7dg9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTAwbxMD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTAwbxMD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71101C4CED1;
	Wed,  5 Feb 2025 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738793142;
	bh=itpOpzBn/bvpSc+LAMcy3iUODma0z+EJ8n2okgFSodc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tTAwbxMDM3Cea8l/cFZNpN+B9hmFwT1t2heTz07GxwlW6pL/psB8me6rxRxIl37ss
	 9ZZexRHQvxJPZ0zKyMQdz5fluF6U0aqSjI+aa9CRgLBsVJXW6JerQBfS+YfYQIx2A9
	 sk17iz/iqMybuaQY8brTNi85pwa/ZFO+nfahXuzMBbeM/2hLP8jVCfTWP63v8VtxdO
	 nDlcpEn2ji25sitNfwujRnS6D+UhAiJCAR7amj0hs7s5EpS9TBPr2mBbNJGJN76dfX
	 tRmgWdXZdeqZgHyhUTT+XRGuisjVmc8+wf4VysVGgcyfetNvP1RWsVlsP/Vvx641dZ
	 b+fWVovJW0nvg==
Date: Wed, 5 Feb 2025 14:05:41 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-ID: <20250205220541.GF21808@frogsfrogsfrogs>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-2-hch@lst.de>
 <Z6PTPoYfyn-1-hHr@dread.disaster.area>
 <20250205211659.GC21808@frogsfrogsfrogs>
 <Z6Pd9wG2sqVZSKjQ@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6Pd9wG2sqVZSKjQ@dread.disaster.area>

On Thu, Feb 06, 2025 at 08:53:59AM +1100, Dave Chinner wrote:
> On Wed, Feb 05, 2025 at 01:16:59PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 08:08:14AM +1100, Dave Chinner wrote:
> > > On Wed, Feb 05, 2025 at 05:28:00PM +0100, Christoph Hellwig wrote:
> > > > Fix the brand new xfstest that tries to swapon on a recently unshared
> > > > file and use the chance to document the other bit of magic in this
> > > > function.
> > > 
> > > You haven't documented the magic at all - I have no clue what the
> > > bug being fixed is nor how adding an inodegc flush fixes anything
> > > to do with swap file activation....
> > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
> > > >  1 file changed, 17 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > index 69b8c2d1937d..c792297aa0a3 100644
> > > > --- a/fs/xfs/xfs_aops.c
> > > > +++ b/fs/xfs/xfs_aops.c
> > > > @@ -21,6 +21,7 @@
> > > >  #include "xfs_error.h"
> > > >  #include "xfs_zone_alloc.h"
> > > >  #include "xfs_rtgroup.h"
> > > > +#include "xfs_icache.h"
> > > >  
> > > >  struct xfs_writepage_ctx {
> > > >  	struct iomap_writepage_ctx ctx;
> > > > @@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
> > > >  	struct file			*swap_file,
> > > >  	sector_t			*span)
> > > >  {
> > > > -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
> > > > +	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
> > > > +
> > > > +	/*
> > > > +	 * Ensure inode GC has finished to remove unmapped extents, as the
> > > > +	 * reflink bit is only cleared once all previously shared extents
> > > > +	 * are unmapped.  Otherwise swapon could incorrectly fail on a
> > > > +	 * very recently unshare file.
> > > > +	 */
> > > > +	xfs_inodegc_flush(ip->i_mount);
> > > 
> > > The comment doesn't explains what this actually fixes. Inodes that
> > > are processed by inodegc *must* be unreferenced by the VFS, so it
> > > is not clear exactly what this is actually doing.
> > > 
> > > I'm guessing that the test in question is doing something like this:
> > > 
> > > 	file2 = clone(file1)
> > > 	unlink(file1)
> > > 	swapon(file2)
> > > 
> > > and so the swap file activation is racing with the background
> > > inactivation and extent removal of file1?
> > 
> > Yes, I think hch is referring to this:
> > https://lore.kernel.org/fstests/2c9ff99c2bcaec4412b0903e03949d5a3ad0d817.1736783467.git.fdmanana@suse.com/
> > 
> > > But in that case, the extents are being removed from file1, and at
> > > no time does that remove the reflink bit on file2. i.e. even if the
> > > inactivation of file1 results in all the extents in file2 no longer
> > > being shared, that only results in refcountbt updates and it does
> > > not get propagated back to file2's inode. i.e. file2 will still be
> > > marked as a reflink file containing shared extents.
> > 
> > Right, but the (iomap) swapfile activation code only errors out if the
> > filesystem gives it a mapping that is marked as shared.  So the reflink
> > flag isn't relevant here.
> > 
> > How about this for a better comment:
> > 
> > "Ensure inode GC has finished so that unlinked clones of this file have
> > been truncated and inactivated fully.  This is to ensure that walking
> > the swap file does not find any shared extents."
> 
> Even talking about it in terms on "inodegc" seems like
> misdirection to me. Now I understand what this flush is working
> around, it is clear to me that swapon could race the same way with
> any other operation that removes extents from cloned files (e.g.
> hole punch, truncate, etc).
> 
> however, from a user perspective, the only one that matters -right
> now- is unlink because of the deferred processing of extent removal.
> 
> But even that isn't a guarantee - if something else has that cloned
> file open, then the unlinked inode won't be queued for inodegc
> and so swapon will still fail regardless of the inodegc flush.
> 
> Hence I think this needs to explain the race with extent removal and
> cloned files, then explain that the inodegc flush is a workaround
> that applies only to a specific corner case w.r.t. unlinking clones
> before swapon is run. 
> 
> Something like:
> 
> /*
>  * Swap file activation is can race against concurrent shared extent

"..can race..."

>  * removal in files that have been cloned. If this happens,
>  * iomap_swapfile_iter() can fail because it encountered a shared
>  * extent even though an operation is in progress to remove those
>  * shared extents.
>  *
>  * This race becomes problematic when we defer extent removal
>  * operations beyond the end of a syscall (i.e. use async background
>  * processing algorithms). Users think the extents are no longer
>  * shared, but iomap_swapfile_iter() still sees them as shared
>  * because the refcountbt entries for the extents being removed have
>  * not yet been updated. Hence the swapon call fails unexpectedly.
>  *
>  * The race condition is currently most obvious from the unlink()
>  * operation as extent removal is deferred until after the last
>  * reference to the inode goes away. We then process the extent
>  * removal asynchronously, hence triggers the "syscall completed but
>  * work not done" condition mentioned above. To close this race
>  * window, we need to flush any pending inodegc operations to ensure
>  * they have updated the refcountbt records before we try to map the
>  * swapfile.

Yes, this is a good explanation.

>  */
> 
> This explains the race condition we are working around, and it gives
> enough information to document that any other refcountbt updates we
> defer to background processing (either removals or inserts!) are
> going to need to be synchronised here.

There shouldn't be any refcount increments involving the swapfile
because the mm already took IOLOCK_EXCL for us.  But yes, there could
someday be more asynchronous decrements elsewhere in the filesystem.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
