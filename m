Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FD3939B1
	for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2026 23:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791330047; cv=none; b=JBuLdfGEO/nV21o7R9kgBZEotuvlSj85ImZh7zjSH5yLLoMx+/wty397/AbD3cAjq10npu++3EOLpIo+91m/mq5Vt2gBfAXu5J2/iHH6x0IbJ7svULuss+x1ikI1Z4bEaCKsXQlD4/ePQlg8mhi0cKYxS7iL/moiJzc7ky7sRqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791330047; c=relaxed/simple;
	bh=BW9grY6ZFJxMr3pJBP8dun/mZ/nYH6aQydc74BG/xZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4cpEVmyC60Gt5S/bY95gHGAhwKIrK64bD+3vEcUvo2B8IaLbLqcImUmWg1EMRBtIs40j5e5rwVXXbydQsUf7WRkyovv1HPUWEJ8PMwthtVeI1qvF+zKTDK9WncE2AHFeroHrYZeSEjfCHoUxplqVLo64T51uPj+W07FDOt6M+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qb0vRDbI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qb0vRDbI"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2F1891F0089B;
	Tue,  6 Oct 2026 23:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791330046;
	bh=jWjaCOqMtT7YF0rcmcS7eTpk0GEV6HBO4ulWrkxWnxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qb0vRDbILmodN6cMIRKLixn83Sfkr4cnMhtPCGgV1PXbcdSwHQA9rRRusL5XIHpc5
	 eQ63FCMUJpf4II7Ym1m7SPE9fNOHO4a7xYs/hJ7dS+IVVeUL27kMVWiA2NVGFhXi39
	 thMHOgfW+Y/tdiXF9iWdm+7SNujQTxvdTpQaet7YFREHsqM8ZXAfumn5SGtkmyBE6r
	 vJdauvd+YE4/5C6o7o0YOH7Vbn7EhNW6L9mO/8kJJnOGeKwhYG968KJIaXY2Mqhmui
	 BDCnlKuJBFOSJSv9vY8899hd3sg4G0QJ5FdVb1vGaNgQVWjR9Tl1TD8QIxxD4SnUfU
	 AHKYQof47j7dg==
Date: Tue, 6 Oct 2026 16:40:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Norbert Szetei <norbert@doyensec.com>
Cc: Dave Chinner <dgc@kernel.org>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix exchange-range-to-eof file size exchange
Message-ID: <20261006234044.GS1615495@frogsfrogsfrogs>
References: <20261006050914.GU2705364@frogsfrogsfrogs>
 <asSiXW4XxBl8Kivw@dread>
 <20261006150001.GY2705364@frogsfrogsfrogs>
 <6363D9F4-4DD0-4E63-90C0-38721B244783@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6363D9F4-4DD0-4E63-90C0-38721B244783@doyensec.com>

On Tue, Oct 06, 2026 at 10:12:17PM +0200, Norbert Szetei wrote:
> > On Oct 6, 2026, at 17:00, Darrick J. Wong <djwong@kernel.org> wrote:
> > 
> > On Tue, Oct 06, 2026 at 06:25:17PM +1100, Dave Chinner wrote:
> >> On Mon, Oct 05, 2026 at 10:09:14PM -0700, Darrick J. Wong wrote:
> >>> From: Darrick J. Wong <djwong@kernel.org>
> >>> 
> >>> Norbert Szetei posted a patch containing an incomplete description of a
> >>> bug in XFS_IOC_EXCHANGE_RANGE's TO_EOF flag.  The bug tricks
> >>> exchange-range into modifying a file so that it has shared blocks
> >>> starting beyond EOF, which is never allowed because files never have
> >>> written data beyond EOF, and you can only share written data blocks.
> >>> This is key to all the incorrect behavior that follows.
> >> ....
> >>> 
> >>> Having confused the file sizes, the PoC uses a second exchange-range
> >>> call on what looks like a non-reflinked single-block file.  Because the
> >>> file size is set incorrectly, exchange-range thinks it's exchanging the
> >>> full contents of two files and clears the reflink flag on the broken
> >>> file.
> >> 
> >> Hmmm, another "exchrange reflink flag coherency" bug.
> >> 
> >> Aside from fixing this specific issue, how can we prevent
> >> other/future logic bugs from failing to set the reflink flag
> >> appropriately and so never expose such a bug to userspace again?
> >> 
> >> I'm thinking that we should not try to swap the reflink flag along
> >> with the extents. Instead, if one of the files had the reflink flag
> >> set before the swap, then we scan scan the extents of both files
> >> after the swap for shared extents and set the reflink flags for each
> >> file appropriately.  EXCHRANGE isn't really performance sensitive,
> >> so the cost of the refcount scans shouldn't be an issue.
> >> 
> >> Setting the flags this way means it doesn't matter what file shared
> >> extent(s) ends up in, the inode(s) that owns it(them) will always
> >> have the reflink flag set correctly. Hence there is no way to use
> >> EXCHRANGE creatively to expose this "didn't COW when it should have'
> >> class of corruption bugs ever again...
> > 
> > That is what Norbert's patch actually does.  If you think removing
> > xfs_exchmaps_clear_reflink and all the stuff that calls it is a good
> > idea (and it probably is!) then let's move that discussion and review to
> > that patch's thread.
> 
> I realized the patch I proposed is not complete on its own either.
> XFS_IOC_SWAPEXT swaps the reflink flags as well, in xfs_swap_extents()
> (xfs_bmap_util.c:1704), which my patch does not touch. The test guarding it
> 
>         /* Verify all data are being swapped */
>         if (sxp->sx_offset != 0 ||
>             sxp->sx_length != ip->i_disk_size ||
>             sxp->sx_length != tip->i_disk_size) {
> 
> only proves the requested length matches i_disk_size, and i_disk_size does
> not bound the inode's mappings, so xfs_swap_extent_rmap() leaves mappings
> behind and the flags are traded anyway.

<nod> Could you repost your original patch but with this chunk removed
as well, please?  I no longer think that cross referencing every data
fork mapping with the refcount data on every exchrange is worth the
trouble.

--D

> N.
> 
> > That enables an extending write of the broken file to rewrite the
> >>> shared block that's just past EOF.  This has become known colloquially
> >>> as refluxfs.
> >>> 
> >>> Once the file sizes are set correctly, the second exchange-range no
> >>> longer thinks that it's doing a full-contents swap, so it won't clear
> >>> the reflink flag on either of its file arguments.
> >>> 
> >>> Link: https://lore.kernel.org/linux-xfs/1E196589-DEBE-40AC-AFEA-D420DAAB067F@doyensec.com/
> >>> Reported-by: Norbert Szetei <norbert@doyensec.com>
> >>> Cc: <stable@vger.kernel.org> # v6.10
> >>> Fixes: 966ceafc7a4371 ("xfs: create deferred log items for file mapping exchanges")
> >>> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> >>> ---
> >>> fs/xfs/libxfs/xfs_exchmaps.c |    8 ++++++--
> >>> fs/xfs/xfs_exchrange.c       |   10 ++++++----
> >>> 2 files changed, 12 insertions(+), 6 deletions(-)
> >>> 
> >>> diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
> >>> index 6a66b6075e0af4..c9d9464e9d39f5 100644
> >>> --- a/fs/xfs/libxfs/xfs_exchmaps.c
> >>> +++ b/fs/xfs/libxfs/xfs_exchmaps.c
> >>> @@ -987,6 +987,7 @@ xfs_exchmaps_init_intent(
> >>> const struct xfs_exchmaps_req *req)
> >>> {
> >>> struct xfs_exchmaps_intent *xmi;
> >>> + struct xfs_mount *mp = req->ip1->i_mount;
> >>> unsigned int rs = 0;
> >>> 
> >>> xmi = kmem_cache_zalloc(xfs_exchmaps_intent_cache,
> >>> @@ -1006,9 +1007,12 @@ xfs_exchmaps_init_intent(
> >>> }
> >>> 
> >>> if (req->flags & XFS_EXCHMAPS_SET_SIZES) {
> >>> + loff_t off1 = XFS_FSB_TO_B(mp, xmi->xmi_startoff1);
> >>> + loff_t off2 = XFS_FSB_TO_B(mp, xmi->xmi_startoff2);
> >>> +
> >>> xmi->xmi_flags |= XFS_EXCHMAPS_SET_SIZES;
> >>> - xmi->xmi_isize1 = req->ip2->i_disk_size;
> >>> - xmi->xmi_isize2 = req->ip1->i_disk_size;
> >>> + xmi->xmi_isize1 = off1 + (req->ip2->i_disk_size - off2);
> >>> + xmi->xmi_isize2 = off2 + (req->ip1->i_disk_size - off1);
> >>> }
> >> 
> >> I think this really needs a comment to explain why the calculation
> >> is structured this way. I think it is trying to set the file sizes
> >> to the "destination offset" + "swap length from other file" because
> >> the ranges in each file might be different lengths, but I could be
> >> wrong...
> > 
> > That's correct.  I'll add that as a code comment.
> > 
> > --D
> > 
> >> 
> >> Cheers,
> >> 
> >> Dave.
> >> -- 
> >> Dave Chinner
> >> dgc@kernel.org
> 
> 
