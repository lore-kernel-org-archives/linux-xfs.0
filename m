Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752507AbeCFCUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Mar 2018 21:20:47 -0500
Date: Mon, 5 Mar 2018 18:15:39 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180306021539.GF18989@magnolia>
References: <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
 <20180227210313.GK19312@magnolia>
 <20180228224351.GA31332@bfoster.bfoster>
 <20180228232032.GK19318@magnolia>
 <20180301172832.GA34164@bfoster.bfoster>
 <20180301205541.GE12763@magnolia>
 <20180302131206.GA38614@bfoster.bfoster>
 <20180303135949.GA2767@bfoster.bfoster>
 <20180305222430.GE18989@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180305222430.GE18989@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On Mon, Mar 05, 2018 at 02:24:30PM -0800, Darrick J. Wong wrote:
> On Sat, Mar 03, 2018 at 08:59:50AM -0500, Brian Foster wrote:
> > On Fri, Mar 02, 2018 at 08:12:07AM -0500, Brian Foster wrote:
> > > On Thu, Mar 01, 2018 at 12:55:41PM -0800, Darrick J. Wong wrote:
> > > > On Thu, Mar 01, 2018 at 12:28:33PM -0500, Brian Foster wrote:
> > > > > On Wed, Feb 28, 2018 at 03:20:32PM -0800, Darrick J. Wong wrote:
> > > > > > On Wed, Feb 28, 2018 at 05:43:51PM -0500, Brian Foster wrote:
> > > > > > > On Tue, Feb 27, 2018 at 01:03:13PM -0800, Darrick J. Wong wrote:
> > > > > > > > On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> > > > > > > > > On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > > > > > > > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > ...
> > > > Going forward, I want the number of unpacked kernels to decrease as
> > > > quickly as possible.  I understand that distro kernel maintainers are
> > > > not willing to apply the packing patch to their kernel until we come up
> > > > with a smooth transition path.
> > > > 
> > > 
> > > I agree wrt to upstream, but note that I don't anticipate including the
> > > padding fix downstream any time soon.
> > > 
> > > > I don't want to support fixing agfls to be 118 units long on 64-bit
> > > > unpacked kernels and 119 units long on 32-bit unpacked kernels, and I
> > > > only want to support the packed kernels with their 119 unit long agfls.
> > > > An AGFL that starts at 0 and ends at flcount-1 is compatible with packed
> > > > and unpacked kernels, so the v2 patch I sent last night removes the
> > > > delicate per-case surgery in favor of a new strategy where the mount
> > > > time and unmount time helpers both look for agfl configurationss that
> > > > are known to cause problems, and solves them all with the same solution:
> > > > moving the agfl list towards the start of the block.
> > > > 
> > > 
> > > The purpose of the patch I sent was not for upstream unpacked support
> > > going forward. Upstream has clearly moved forward with the packed
> > > format. The goal of the patch was to explore a single/generic patch that
> > > could be merged upstream/downstream and handle compatibility cleanly.
> > > 
> > 
> > FWIW, here's a new variant of a bidirectional fixup. It's refactored and
> > polished up a bit into a patch. It basically inspects the agf when first
> > read for any evidence that the on-disk fields reflect a size mismatch
> > with the current kernel and sets a flag if so. agfl gets/puts check the
> > flag and thus the first transaction that attempts to modify a mismatched
> > agfl swaps a block into or out of the gap slot appropriately.
> > 
> > This avoids the need for any new transactions or mount time scan and the
> > (downstream motivated) packed -> unpacked case is only 10 or so lines of
> > additional code. Only spot tested, but I _think_ it covers all of the
> > cases. Hm?
> 
> Just from a quick glance this looks like a reasonable way to fix the
> agfl wrapping to whatever the running kernel expects.  I tried feeding
> it to the xfstest I wrote to exercise my agfl fixer[1], but even with
> changing the test to fill the fs to enospc and delete everything I
> couldn't get it to trigger reliably.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/commit/?h=djwong-experimental&id=f085bb09c839da69daf921da33f5d13c80c9f165

Ok, I got it to trigger by updating that xfstest to fragment the free
space after mounting.  According to the test results on 4.16-rc4 it
fixes the deliberately tweaked agfls to work without complaint, so could
you please write this up as a proper patch?

--D

> 
> --D
> 
> > Brian
> > 
> > --- 8< ---
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index c02781a4c091..1cbf80d8481f 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2053,6 +2053,115 @@ xfs_alloc_space_available(
> >  	return true;
> >  }
> >  
> > +static int
> > +xfs_agfl_ondisk_size(
> > +	struct xfs_mount	*mp,
> > +	int			first,
> > +	int			last,
> > +	int			count)
> > +{
> > +	int			active = count;
> > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > +
> > +	if (count && last >= first)
> > +		active = last - first + 1;
> > +	else if (count)
> > +		active = agfl_size - first + last + 1;
> > +
> > +	if (active == count + 1)
> > +		return agfl_size - 1;
> > +	if (active == count - 1 || first == agfl_size || last == agfl_size)
> > +		return agfl_size + 1;
> > +
> > +	ASSERT(active == count);
> > +	return agfl_size;
> > +}
> > +
> > +static bool
> > +xfs_agfl_need_padfix(
> > +	struct xfs_mount	*mp,
> > +	struct xfs_agf		*agf)
> > +{
> > +	int			f = be32_to_cpu(agf->agf_flfirst);
> > +	int			l = be32_to_cpu(agf->agf_fllast);
> > +	int			c = be32_to_cpu(agf->agf_flcount);
> > +
> > +	return xfs_agfl_ondisk_size(mp, f, l, c) != XFS_AGFL_SIZE(mp);
> > +}
> > +
> > +static int
> > +xfs_agfl_check_padfix(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agbp,
> > +	struct xfs_buf		*agflbp,
> > +	struct xfs_perag	*pag)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
> > +	__be32			*agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > +	int			agfl_size = XFS_AGFL_SIZE(mp);
> > +	int			ofirst, olast, osize;
> > +	int			nfirst, nlast;
> > +	int			logflags = 0;
> > +	int			startoff = 0;
> > +
> > +	if (!pag->pagf_needpadfix)
> > +		return 0;
> > +
> > +	ofirst = nfirst = be32_to_cpu(agf->agf_flfirst);
> > +	olast = nlast = be32_to_cpu(agf->agf_fllast);
> > +	osize = xfs_agfl_ondisk_size(mp, ofirst, olast, pag->pagf_flcount);
> > +
> > +	/*
> > +	 * If the on-disk agfl is smaller than what the kernel expects, the
> > +	 * last slot of the on-disk agfl is a gap with bogus data. Move the
> > +	 * first valid block into the gap and bump the pointer.
> > +	 */
> > +	if (osize < agfl_size) {
> > +		ASSERT(pag->pagf_flcount != 0);
> > +		agfl_bno[agfl_size - 1] = agfl_bno[ofirst];
> > +		startoff = (char *) &agfl_bno[agfl_size - 1] - (char *) agflbp->b_addr;
> > +		nfirst++;
> > +		goto done;
> > +	}
> > +
> > +	/*
> > +	 * Otherwise, the on-disk agfl is larger than what the current kernel
> > +	 * expects. If empty, just fix up the first and last pointers. If not,
> > +	 * move the inaccessible block to the end of the valid range.
> > +	 */
> > +	nfirst = do_mod(nfirst, agfl_size);
> > +	if (pag->pagf_flcount == 0) {
> > +		nlast = (nfirst == 0 ? agfl_size - 1 : nfirst - 1);
> > +		goto done;
> > +	}
> > +	if (nlast != agfl_size)
> > +		nlast++;
> > +	nlast = do_mod(nlast, agfl_size);
> > +	agfl_bno[nlast] = agfl_bno[osize - 1];
> > +	startoff = (char *) &agfl_bno[nlast] - (char *) agflbp->b_addr;
> > +
> > +done:
> > +	if (nfirst != ofirst) {
> > +		agf->agf_flfirst = cpu_to_be32(nfirst);
> > +		logflags |= XFS_AGF_FLFIRST;
> > +	}
> > +	if (nlast != olast) {
> > +		agf->agf_fllast = cpu_to_be32(nlast);
> > +		logflags |= XFS_AGF_FLLAST;
> > +	}
> > +	if (startoff) {
> > +		xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > +		xfs_trans_log_buf(tp, agflbp, startoff,
> > +				  startoff + sizeof(xfs_agblock_t) - 1);
> > +	}
> > +	if (logflags)
> > +		xfs_alloc_log_agf(tp, agbp, logflags);
> > +
> > +	pag->pagf_needpadfix = false;
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Decide whether to use this allocation group for this allocation.
> >   * If so, fix up the btree freelist's size.
> > @@ -2258,6 +2367,12 @@ xfs_alloc_get_freelist(
> >  	if (error)
> >  		return error;
> >  
> > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > +	if (error) {
> > +		xfs_perag_put(pag);
> > +		return error;
> > +	}
> >  
> >  	/*
> >  	 * Get the block number and update the data structures.
> > @@ -2269,7 +2384,6 @@ xfs_alloc_get_freelist(
> >  	if (be32_to_cpu(agf->agf_flfirst) == XFS_AGFL_SIZE(mp))
> >  		agf->agf_flfirst = 0;
> >  
> > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> >  	be32_add_cpu(&agf->agf_flcount, -1);
> >  	xfs_trans_agflist_delta(tp, -1);
> >  	pag->pagf_flcount--;
> > @@ -2376,11 +2490,18 @@ xfs_alloc_put_freelist(
> >  	if (!agflbp && (error = xfs_alloc_read_agfl(mp, tp,
> >  			be32_to_cpu(agf->agf_seqno), &agflbp)))
> >  		return error;
> > +
> > +	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> > +	error = xfs_agfl_check_padfix(tp, agbp, agflbp, pag);
> > +	if (error) {
> > +		xfs_perag_put(pag);
> > +		return error;
> > +	}
> > +
> >  	be32_add_cpu(&agf->agf_fllast, 1);
> >  	if (be32_to_cpu(agf->agf_fllast) == XFS_AGFL_SIZE(mp))
> >  		agf->agf_fllast = 0;
> >  
> > -	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
> >  	be32_add_cpu(&agf->agf_flcount, 1);
> >  	xfs_trans_agflist_delta(tp, 1);
> >  	pag->pagf_flcount++;
> > @@ -2588,6 +2709,7 @@ xfs_alloc_read_agf(
> >  		pag->pagb_count = 0;
> >  		pag->pagb_tree = RB_ROOT;
> >  		pag->pagf_init = 1;
> > +		pag->pagf_needpadfix = xfs_agfl_need_padfix(mp, agf);
> >  	}
> >  #ifdef DEBUG
> >  	else if (!XFS_FORCED_SHUTDOWN(mp)) {
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index e0792d036be2..78a6377a9b38 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -353,6 +353,7 @@ typedef struct xfs_perag {
> >  	char		pagi_inodeok;	/* The agi is ok for inodes */
> >  	uint8_t		pagf_levels[XFS_BTNUM_AGF];
> >  					/* # of levels in bno & cnt btree */
> > +	bool		pagf_needpadfix;
> >  	uint32_t	pagf_flcount;	/* count of blocks in freelist */
> >  	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
> >  	xfs_extlen_t	pagf_longest;	/* longest free space */
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
