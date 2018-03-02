Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1423618AbeCBNMJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 08:12:09 -0500
Date: Fri, 2 Mar 2018 08:12:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180302131206.GA38614@bfoster.bfoster>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
 <20180227210313.GK19312@magnolia>
 <20180228224351.GA31332@bfoster.bfoster>
 <20180228232032.GK19318@magnolia>
 <20180301172832.GA34164@bfoster.bfoster>
 <20180301205541.GE12763@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180301205541.GE12763@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On Thu, Mar 01, 2018 at 12:55:41PM -0800, Darrick J. Wong wrote:
> On Thu, Mar 01, 2018 at 12:28:33PM -0500, Brian Foster wrote:
> > On Wed, Feb 28, 2018 at 03:20:32PM -0800, Darrick J. Wong wrote:
> > > On Wed, Feb 28, 2018 at 05:43:51PM -0500, Brian Foster wrote:
> > > > On Tue, Feb 27, 2018 at 01:03:13PM -0800, Darrick J. Wong wrote:
> > > > > On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> > > > > > On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > ...
> > > > > > > diff --git a/fs/xfs/xfs_fixups.c b/fs/xfs/xfs_fixups.c
> > > > > > > new file mode 100644
> > > > > > > index 0000000..0cad7bb
> > > > > > > --- /dev/null
> > > > > > > +++ b/fs/xfs/xfs_fixups.c
> > > > > > > @@ -0,0 +1,310 @@
> > ...
> > > > > Now let's say that we run for a while and want to unmount, but our AGFL
> > > > > wraps like this:
> > > > > 
> > > > >          0   1   2   3   4   5   6   7   8   9
> > > > > Header | T | U | V |   |   |   |   | Q | R | S |
> > > > >                  ^-- fllast          ^-- flfirst
> > > > > 
> > > > > We don't know that the next kernel to mount this filesystem will have
> > > > > the "4.5 agfl padding fix" applied to it; if it does not, it will flag
> > > > > the AGF as corrupted because flcount is 6 but in its view the distance
> > > > > between flfirst and fllast (which omits bno[9]) is 5.  We don't want
> > > > > it to choke on that, so the unmount fixer moves all the records between
> > > > > flfirst and the end (Q, R, and S) towards the start of the block and
> > > > > resets flfirst/fllast:
> > > > > 
> > > > >          0   1   2   3   4   5   6   7   8   9
> > > > > Header | T | U | V | Q | R | S |   |   |   |   |
> > > > >          ^-- flfirst         ^-- fllast
> > > > > 
> > > > 
> > > > Could we use this basic algorithm at mount time as well? I know it
> > > > wouldn't be _exactly_ the same operation at mount time as it is for
> > > > unmount since slot 9 is a gap in the former case, but afaict the only
> > > > difference from an algorithmic perspective is the length of the shift.
> > > > 
> > > > IOW, if we were to parameterize the length of the shift and have the
> > > > mount fixup call the unmount algorithm, would it not also address the
> > > > problem?
> > > 
> > > Yes, I believe that would work.  I think it would be more efficient in
> > > the patch below to memmove the entries instead of put_freelist'ing them
> > > individually.
> > > 
> > > If the agfl is completely full then fix_freelist ought to trim it down
> > > by at least one element.  The algorithm then becomes:
> > > 
> > > if mounting and flfirst < fllast:
> > > 	return 0
> > > if flcount == agfl_size:
> > > 	assert !mounting
> > > 	fix_freelist()
> > 
> > Not sure I follow where the fix_freelist() came in, but I think we need
> > to be careful here. What if flfirst == 118 and that slot is garbage?
> > Don't we need to fix up the agfl before we can allow any traditional
> > operations to proceed?
> 
> This got confusing, so you might notice in the v2 patch that I separated
> this out...
> 
> > > 	assert flcount < agfl_size
> > > if flfirst < fllast:
> > > 	return 0
> > > movelen = agfl_size - flfirst
> > > if active == flcount - 1:
> > > 	movelen--
> > > memmove(&agflbno[fllast + 1], &agflbno[flfirst], movelen)
> > > flfirst = 0
> > > fllast = fllast + movelen
> > > 
> > ...
> > > > > > 
> > > > > > So we're not attempting to cover the case where the agfl has 1 more
> > > > > > block than the agfl size (i.e., the case where an fs goes back to a
> > > > > > kernel with an unpacked header)?
> > > > > 
> > > > > We don't know how the next kernel to touch this filesystem will define
> > > > > XFS_AGFL_SIZE -- it could be a 4.5+ kernel (same agfl size), a 32-bit
> > > > > pre-4.5 kernel (same agfl size), or a 64-bit pre-4.5 kernel (small agfl
> > > > > size).
> > > > > 
> > > > 
> > > > I don't think I was clear.. I'm envisioning whether we could come up
> > > > with a patch that would generically fix up the agfl on disk to be sane
> > > > relative to the current kernel. This patch covers the case of a packed
> > > > agfl kernel mounting an unpacked on-disk agfl. It would be nice if we
> > > > could implement something that also handled a packed on-disk agfl to an
> > > > unpacked agfl kernel (for easier backport to unpacked kernels, for
> > > > e.g.).
> > > 
> > > If we're going to touch an old kernel's source at all I'd rather we
> > > backport both the packing fix and this fixer-upper.
> > > 
> > 
> > Not sure I parse... the "old kernel" is essentially the rhel example
> > where we apparently have deliberately maintained the unpacked format to
> > avoid this incompatibility problem. If we had a patch that generically
> > converted on-disk format (packed or unpacked) to the current kernel
> > (packed or unpacked), we could merge that patch to upstream, stable as
> > well as distro kernels that might not include the agfl packing fix and
> > eliminate compatibility problems between them (even if the packing fix
> > comes in out of order).
> 
> ...I wonder if we've gotten to the 'talking past each other' point, but
> let me try one more time.
> 
> Going forward, I want the number of unpacked kernels to decrease as
> quickly as possible.  I understand that distro kernel maintainers are
> not willing to apply the packing patch to their kernel until we come up
> with a smooth transition path.
> 

I agree wrt to upstream, but note that I don't anticipate including the
padding fix downstream any time soon.

> I don't want to support fixing agfls to be 118 units long on 64-bit
> unpacked kernels and 119 units long on 32-bit unpacked kernels, and I
> only want to support the packed kernels with their 119 unit long agfls.
> An AGFL that starts at 0 and ends at flcount-1 is compatible with packed
> and unpacked kernels, so the v2 patch I sent last night removes the
> delicate per-case surgery in favor of a new strategy where the mount
> time and unmount time helpers both look for agfl configurationss that
> are known to cause problems, and solves them all with the same solution:
> moving the agfl list towards the start of the block.
> 

The purpose of the patch I sent was not for upstream unpacked support
going forward. Upstream has clearly moved forward with the packed
format. The goal of the patch was to explore a single/generic patch that
could be merged upstream/downstream and handle compatibility cleanly.

IOW, I considered what I thought will be necessary to handle
compatibility downstream and attempted to incorporate that with an
upstream fix because then the patch is straightforward and safe to
backport (upstream acceptance mostly justifies inclusion downstream).
Then it is possible to create a set of downstream systems, going
forward, that are explicitly 100% upstream compatible.

So upstream is technically fine without a packed -> unpacked variant, to
suggest otherwise wasn't really the intent. Perhaps a BUILD_BUG_ON() or
some such that asserts a packed agfl would be effective to prevent blind
backporting to unpacked upstream kernels (and rhel could just drop that
bit) and would have documented that more clearly.

> The fixup patch requires that the kernel already include the packing
> fix.  Its goals are:
> 
> a) At mount time, ensure that all AGFLs which are not compatible with a
> packed kernel are made compatible with a packed kernel.
> 
> b) At unmount time, ensure all AGFLs are compatible with packed kernels
> and unpacked kernels.
> 
> Therefore, the first step for a kernel maintainer is to ensure that the
> packing fix is applied (which it will be for any 4.5+ kernel).  The
> second step is to apply this fixer patch.
> 

I'm pretty clear on what the patch does at this point. ;)

I agree on goal A in principle. It is generally sane for newer kernels
to expect weird/broken formats that could be caused by older kernels and
rectify them. There is a convenience value for users upgrading from
broken kernels. As noted above, the purpose of my patch was to try and
further genericize the implementation to make it useful for downstream
(and perhaps more simple/less code).

I don't see the value in B. The approach is not 100% effective so it
doesn't allow those who have to support unpacked kernels to support any
use case that they couldn't before. It seems to be motivated by the
existence of essentially stale[1] stable kernels, but we may have
already released more[2] kernels since v4.5 that would never get the
unmount fix than we had unpacked kernel releases in the first place.
Those newer stale kernels can continue to break the older stale kernels
regardless of the existence of B.

So in other words, the only way the B variant of problems truly
disappear is for those stale/unpacked kernel users to upgrade. As such,
B mostly seems like a placebo, requres 2-3x more code than is necessary
for A (particularly if we consider an on-demand fixup to elminate the
need for a mount time scan) and as a result I'm having a hard time
justifying doing anything at all here so long as these fixes remain
artificially squashed together. At the end of the day it's not my
decision but that's the only remaining feedback I can offer on the v2
patch (having skimmed it).

Brian

[1] Unless I'm mistaken, anybody still on a stale/stable unpacked
upstream kernel should have a minor release update readily available
that includes the padding fix.

[2] AFAICT, the same logic around the stale unpacked kernels applies to
future stable non-unmount-fix-capable kernels were we to take this
approach.

> --D
> 
> > Otherwise, we need a separate unpacked -> packed fixup for packed
> > kernels (i.e., this patch) and a packed -> unpacked fixup for unpacked
> > kernels and to make sure they are used in the right places. Trying to
> > see if we could avoid this kind of dependency matrix was one of the
> > objectives around the hack I posted previously. I'm not married to that
> > particular implementation, but I'm much less concerned about
> > inefficiency (even if it dictates a mount time fixup over a runtime one)
> > in comparison to simplicity and flexibility. Perhaps we can accomplish
> > something similarly flexible via direct buffer manipulation..?
> > 
> > FWIW, I've appended another variant of the previous hack that is less
> > brute force, but I think is still able to convert back and forth. The
> > tradeoff is essentially that it no longer uses the same generic
> > algorithm.
> > 
> > Brian
> > 
> > --- 8< ---
> > 
> > static int
> > xfs_agfl_ondisk_size(
> > 	struct xfs_mount	*mp,
> > 	int			first,
> > 	int			last,
> > 	int			flcount)
> > {
> > 	int			active;
> > 	int			size;
> > 	int			agfl_size = XFS_AGFL_SIZE(mp);
> > 
> > 	if (last >= first)
> > 		active = last - first + 1;
> > 	else
> > 		active = agfl_size - first + last + 1;
> > 
> > 	if (active == flcount + 1)
> > 		size = agfl_size - 1;
> > 	else if ((active == flcount - 1) ||
> > 		 first == agfl_size || last == agfl_size)
> > 		size = agfl_size + 1;
> > 	else if (active == flcount)
> > 		size = agfl_size;
> > 	else
> > 		return -EFSCORRUPTED;
> > 
> > 	return size;
> > }
> > 
> > int
> > xfs_agfl_fixup(
> > 	struct xfs_trans	*tp,
> > 	struct xfs_buf		*agbp,
> > 	struct xfs_perag	*pag)
> > {
> > 	struct xfs_mount	*mp = tp->t_mountp;
> > 	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > 	int			agfl_size = XFS_AGFL_SIZE(mp);
> > 	int			ofirst, olast, osize;
> > 	int			nfirst, nlast;
> > 	struct xfs_buf		*agflbp;
> > 	__be32			*agfl_bno;
> > 	xfs_agblock_t		bno = -1;
> > 	int			tidx = -1;
> > 	bool			empty = false;
> > 	int			logflags = 0;
> > 	int			error;
> > 
> > 	ofirst = nfirst = be32_to_cpu(agf->agf_flfirst);
> > 	olast = nlast = be32_to_cpu(agf->agf_fllast);
> > 	osize = xfs_agfl_ondisk_size(mp, ofirst, olast, pag->pagf_flcount);
> > 	if (osize < 0)
> > 		return osize;
> > 	if (pag->pagf_flcount == 0)
> > 		empty = true;
> > 
> > 	/* sizes match, nothing to do */
> > 	if (osize == agfl_size)
> > 		return 0;
> > 
> > 	/* size mismatch, read the agfl.. */
> > 	error = xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno),
> > 				    &agflbp);
> > 	if (error)
> > 		return error;
> > 	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > 
> > 	/*
> > 	 * If the on-disk agfl is smaller than what the kernel expects, the last
> > 	 * slot of the on-disk agfl is a gap with bogus data. Allocate the first
> > 	 * valid block from the agfl, manually place it in the gap and fix up
> > 	 * the count.
> > 	 */
> > 	if (osize < agfl_size) {
> > 		ASSERT(!empty);
> > 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
> > 		if (error)
> > 			goto out_relse;
> > 
> > 		pag->pagf_flcount++;
> > 		be32_add_cpu(&agf->agf_flcount, 1);
> > 		logflags |= XFS_AGF_FLCOUNT;
> > 		tidx = agfl_size - 1;
> > 		goto done;
> > 	}
> > 
> > 	/*
> > 	 * Otherwise, the on-disk agfl is larger than what the current kernel
> > 	 * can manage. If the agfl was empty, we just fix up the first and last
> > 	 * pointers. If not, move the inaccessible block in the last slot to the
> > 	 * next valid, open slot.
> > 	 */
> > 	nfirst = do_mod(nfirst, agfl_size);
> > 	if (empty) {
> > 		nlast = (nfirst == 0 ? agfl_size - 1 : nfirst - 1);
> > 		goto done;
> > 	}
> > 	if (nlast != agfl_size)
> > 		nlast++;
> > 	nlast = do_mod(nlast, agfl_size);
> > 	tidx = nlast;
> > 	bno = be32_to_cpu(agfl_bno[osize - 1]);
> > 
> > done:
> > 	if (nfirst != ofirst) {
> > 		agf->agf_flfirst = cpu_to_be32(nfirst);
> > 		logflags |= XFS_AGF_FLFIRST;
> > 	}
> > 	if (nlast != olast) {
> > 		agf->agf_fllast = cpu_to_be32(nlast);
> > 		logflags |= XFS_AGF_FLLAST;
> > 	}
> > 	if (bno != -1) {
> > 		int	startoff;
> > 
> > 		agfl_bno[tidx] = cpu_to_be32(bno);
> > 		xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > 		startoff = (char *) &agfl_bno[tidx] - (char *) agflbp->b_addr;
> > 		xfs_trans_log_buf(tp, agflbp, startoff,
> > 				  startoff + sizeof(xfs_agblock_t) - 1);
> > 	}
> > 	if (logflags)
> > 		xfs_alloc_log_agf(tp, agbp, logflags);
> > 
> > out_relse:
> > 	xfs_trans_brelse(tp, agflbp);
> > 	return error;
> > }
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
