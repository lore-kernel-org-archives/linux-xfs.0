Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49926 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161716AbeCAVAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 16:00:48 -0500
Date: Thu, 1 Mar 2018 12:55:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180301205541.GE12763@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
 <20180227210313.GK19312@magnolia>
 <20180228224351.GA31332@bfoster.bfoster>
 <20180228232032.GK19318@magnolia>
 <20180301172832.GA34164@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301172832.GA34164@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On Thu, Mar 01, 2018 at 12:28:33PM -0500, Brian Foster wrote:
> On Wed, Feb 28, 2018 at 03:20:32PM -0800, Darrick J. Wong wrote:
> > On Wed, Feb 28, 2018 at 05:43:51PM -0500, Brian Foster wrote:
> > > On Tue, Feb 27, 2018 at 01:03:13PM -0800, Darrick J. Wong wrote:
> > > > On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> > > > > On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> ...
> > > > > > diff --git a/fs/xfs/xfs_fixups.c b/fs/xfs/xfs_fixups.c
> > > > > > new file mode 100644
> > > > > > index 0000000..0cad7bb
> > > > > > --- /dev/null
> > > > > > +++ b/fs/xfs/xfs_fixups.c
> > > > > > @@ -0,0 +1,310 @@
> ...
> > > > Now let's say that we run for a while and want to unmount, but our AGFL
> > > > wraps like this:
> > > > 
> > > >          0   1   2   3   4   5   6   7   8   9
> > > > Header | T | U | V |   |   |   |   | Q | R | S |
> > > >                  ^-- fllast          ^-- flfirst
> > > > 
> > > > We don't know that the next kernel to mount this filesystem will have
> > > > the "4.5 agfl padding fix" applied to it; if it does not, it will flag
> > > > the AGF as corrupted because flcount is 6 but in its view the distance
> > > > between flfirst and fllast (which omits bno[9]) is 5.  We don't want
> > > > it to choke on that, so the unmount fixer moves all the records between
> > > > flfirst and the end (Q, R, and S) towards the start of the block and
> > > > resets flfirst/fllast:
> > > > 
> > > >          0   1   2   3   4   5   6   7   8   9
> > > > Header | T | U | V | Q | R | S |   |   |   |   |
> > > >          ^-- flfirst         ^-- fllast
> > > > 
> > > 
> > > Could we use this basic algorithm at mount time as well? I know it
> > > wouldn't be _exactly_ the same operation at mount time as it is for
> > > unmount since slot 9 is a gap in the former case, but afaict the only
> > > difference from an algorithmic perspective is the length of the shift.
> > > 
> > > IOW, if we were to parameterize the length of the shift and have the
> > > mount fixup call the unmount algorithm, would it not also address the
> > > problem?
> > 
> > Yes, I believe that would work.  I think it would be more efficient in
> > the patch below to memmove the entries instead of put_freelist'ing them
> > individually.
> > 
> > If the agfl is completely full then fix_freelist ought to trim it down
> > by at least one element.  The algorithm then becomes:
> > 
> > if mounting and flfirst < fllast:
> > 	return 0
> > if flcount == agfl_size:
> > 	assert !mounting
> > 	fix_freelist()
> 
> Not sure I follow where the fix_freelist() came in, but I think we need
> to be careful here. What if flfirst == 118 and that slot is garbage?
> Don't we need to fix up the agfl before we can allow any traditional
> operations to proceed?

This got confusing, so you might notice in the v2 patch that I separated
this out...

> > 	assert flcount < agfl_size
> > if flfirst < fllast:
> > 	return 0
> > movelen = agfl_size - flfirst
> > if active == flcount - 1:
> > 	movelen--
> > memmove(&agflbno[fllast + 1], &agflbno[flfirst], movelen)
> > flfirst = 0
> > fllast = fllast + movelen
> > 
> ...
> > > > > 
> > > > > So we're not attempting to cover the case where the agfl has 1 more
> > > > > block than the agfl size (i.e., the case where an fs goes back to a
> > > > > kernel with an unpacked header)?
> > > > 
> > > > We don't know how the next kernel to touch this filesystem will define
> > > > XFS_AGFL_SIZE -- it could be a 4.5+ kernel (same agfl size), a 32-bit
> > > > pre-4.5 kernel (same agfl size), or a 64-bit pre-4.5 kernel (small agfl
> > > > size).
> > > > 
> > > 
> > > I don't think I was clear.. I'm envisioning whether we could come up
> > > with a patch that would generically fix up the agfl on disk to be sane
> > > relative to the current kernel. This patch covers the case of a packed
> > > agfl kernel mounting an unpacked on-disk agfl. It would be nice if we
> > > could implement something that also handled a packed on-disk agfl to an
> > > unpacked agfl kernel (for easier backport to unpacked kernels, for
> > > e.g.).
> > 
> > If we're going to touch an old kernel's source at all I'd rather we
> > backport both the packing fix and this fixer-upper.
> > 
> 
> Not sure I parse... the "old kernel" is essentially the rhel example
> where we apparently have deliberately maintained the unpacked format to
> avoid this incompatibility problem. If we had a patch that generically
> converted on-disk format (packed or unpacked) to the current kernel
> (packed or unpacked), we could merge that patch to upstream, stable as
> well as distro kernels that might not include the agfl packing fix and
> eliminate compatibility problems between them (even if the packing fix
> comes in out of order).

...I wonder if we've gotten to the 'talking past each other' point, but
let me try one more time.

Going forward, I want the number of unpacked kernels to decrease as
quickly as possible.  I understand that distro kernel maintainers are
not willing to apply the packing patch to their kernel until we come up
with a smooth transition path.

I don't want to support fixing agfls to be 118 units long on 64-bit
unpacked kernels and 119 units long on 32-bit unpacked kernels, and I
only want to support the packed kernels with their 119 unit long agfls.
An AGFL that starts at 0 and ends at flcount-1 is compatible with packed
and unpacked kernels, so the v2 patch I sent last night removes the
delicate per-case surgery in favor of a new strategy where the mount
time and unmount time helpers both look for agfl configurationss that
are known to cause problems, and solves them all with the same solution:
moving the agfl list towards the start of the block.

The fixup patch requires that the kernel already include the packing
fix.  Its goals are:

a) At mount time, ensure that all AGFLs which are not compatible with a
packed kernel are made compatible with a packed kernel.

b) At unmount time, ensure all AGFLs are compatible with packed kernels
and unpacked kernels.

Therefore, the first step for a kernel maintainer is to ensure that the
packing fix is applied (which it will be for any 4.5+ kernel).  The
second step is to apply this fixer patch.

--D

> Otherwise, we need a separate unpacked -> packed fixup for packed
> kernels (i.e., this patch) and a packed -> unpacked fixup for unpacked
> kernels and to make sure they are used in the right places. Trying to
> see if we could avoid this kind of dependency matrix was one of the
> objectives around the hack I posted previously. I'm not married to that
> particular implementation, but I'm much less concerned about
> inefficiency (even if it dictates a mount time fixup over a runtime one)
> in comparison to simplicity and flexibility. Perhaps we can accomplish
> something similarly flexible via direct buffer manipulation..?
> 
> FWIW, I've appended another variant of the previous hack that is less
> brute force, but I think is still able to convert back and forth. The
> tradeoff is essentially that it no longer uses the same generic
> algorithm.
> 
> Brian
> 
> --- 8< ---
> 
> static int
> xfs_agfl_ondisk_size(
> 	struct xfs_mount	*mp,
> 	int			first,
> 	int			last,
> 	int			flcount)
> {
> 	int			active;
> 	int			size;
> 	int			agfl_size = XFS_AGFL_SIZE(mp);
> 
> 	if (last >= first)
> 		active = last - first + 1;
> 	else
> 		active = agfl_size - first + last + 1;
> 
> 	if (active == flcount + 1)
> 		size = agfl_size - 1;
> 	else if ((active == flcount - 1) ||
> 		 first == agfl_size || last == agfl_size)
> 		size = agfl_size + 1;
> 	else if (active == flcount)
> 		size = agfl_size;
> 	else
> 		return -EFSCORRUPTED;
> 
> 	return size;
> }
> 
> int
> xfs_agfl_fixup(
> 	struct xfs_trans	*tp,
> 	struct xfs_buf		*agbp,
> 	struct xfs_perag	*pag)
> {
> 	struct xfs_mount	*mp = tp->t_mountp;
> 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> 	int			agfl_size = XFS_AGFL_SIZE(mp);
> 	int			ofirst, olast, osize;
> 	int			nfirst, nlast;
> 	struct xfs_buf		*agflbp;
> 	__be32			*agfl_bno;
> 	xfs_agblock_t		bno = -1;
> 	int			tidx = -1;
> 	bool			empty = false;
> 	int			logflags = 0;
> 	int			error;
> 
> 	ofirst = nfirst = be32_to_cpu(agf->agf_flfirst);
> 	olast = nlast = be32_to_cpu(agf->agf_fllast);
> 	osize = xfs_agfl_ondisk_size(mp, ofirst, olast, pag->pagf_flcount);
> 	if (osize < 0)
> 		return osize;
> 	if (pag->pagf_flcount == 0)
> 		empty = true;
> 
> 	/* sizes match, nothing to do */
> 	if (osize == agfl_size)
> 		return 0;
> 
> 	/* size mismatch, read the agfl.. */
> 	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
> 				    &agflbp);
> 	if (error)
> 		return error;
> 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> 
> 	/*
> 	 * If the on-disk agfl is smaller than what the kernel expects, the last
> 	 * slot of the on-disk agfl is a gap with bogus data. Allocate the first
> 	 * valid block from the agfl, manually place it in the gap and fix up
> 	 * the count.
> 	 */
> 	if (osize < agfl_size) {
> 		ASSERT(!empty);
> 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
> 		if (error)
> 			goto out_relse;
> 
> 		pag->pagf_flcount++;
> 		be32_add_cpu(&agf->agf_flcount, 1);
> 		logflags |= XFS_AGF_FLCOUNT;
> 		tidx = agfl_size - 1;
> 		goto done;
> 	}
> 
> 	/*
> 	 * Otherwise, the on-disk agfl is larger than what the current kernel
> 	 * can manage. If the agfl was empty, we just fix up the first and last
> 	 * pointers. If not, move the inaccessible block in the last slot to the
> 	 * next valid, open slot.
> 	 */
> 	nfirst = do_mod(nfirst, agfl_size);
> 	if (empty) {
> 		nlast = (nfirst == 0 ? agfl_size - 1 : nfirst - 1);
> 		goto done;
> 	}
> 	if (nlast != agfl_size)
> 		nlast++;
> 	nlast = do_mod(nlast, agfl_size);
> 	tidx = nlast;
> 	bno = be32_to_cpu(agfl_bno[osize - 1]);
> 
> done:
> 	if (nfirst != ofirst) {
> 		agf->agf_flfirst = cpu_to_be32(nfirst);
> 		logflags |= XFS_AGF_FLFIRST;
> 	}
> 	if (nlast != olast) {
> 		agf->agf_fllast = cpu_to_be32(nlast);
> 		logflags |= XFS_AGF_FLLAST;
> 	}
> 	if (bno != -1) {
> 		int	startoff;
> 
> 		agfl_bno[tidx] = cpu_to_be32(bno);
> 		xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> 		startoff = (char *) &agfl_bno[tidx] - (char *) agflbp->b_addr;
> 		xfs_trans_log_buf(tp, agflbp, startoff,
> 				  startoff + sizeof(xfs_agblock_t) - 1);
> 	}
> 	if (logflags)
> 		xfs_alloc_log_agf(tp, agbp, logflags);
> 
> out_relse:
> 	xfs_trans_brelse(tp, agflbp);
> 	return error;
> }
> 
