Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56304 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966296AbeCAGhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Mar 2018 01:37:31 -0500
Date: Wed, 28 Feb 2018 22:37:23 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180301063723.GN19312@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180227193548.GF3479@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org

On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile     |    1 
> >  fs/xfs/xfs_fixups.c |  310 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/xfs_fixups.h |   26 ++++
> >  fs/xfs/xfs_mount.c  |   21 +++
> >  fs/xfs/xfs_super.c  |   10 ++
> >  5 files changed, 367 insertions(+), 1 deletion(-)
> >  create mode 100644 fs/xfs/xfs_fixups.c
> >  create mode 100644 fs/xfs/xfs_fixups.h
> > 
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index b03c77e..f88368a 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
> >  				   xfs_extent_busy.o \
> >  				   xfs_file.o \
> >  				   xfs_filestream.o \
> > +				   xfs_fixups.o \
> >  				   xfs_fsmap.o \
> >  				   xfs_fsops.o \
> >  				   xfs_globals.o \
> > diff --git a/fs/xfs/xfs_fixups.c b/fs/xfs/xfs_fixups.c
> > new file mode 100644
> > index 0000000..0cad7bb
> > --- /dev/null
> > +++ b/fs/xfs/xfs_fixups.c
> > @@ -0,0 +1,310 @@
> > +/*
> > + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#include "xfs.h"
> > +#include "xfs_fs.h"
> > +#include "xfs_shared.h"
> > +#include "xfs_format.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_alloc.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_fixups.h"
> > +
> > +/*
> > + * v5 AGFL padding defects
> > + *
> > + * When the v5 format was first introduced, there was a defect in the struct
> > + * xfs_agfl definition that resulted in XFS_AGFL_SIZE returning different
> 
> XFS_AGFL_SIZE() no longer exists as of the previous patch. It might be
> better to size refer to "the agfl size" generically.
> 
> > + * values depending on the compiler padding.  On a fs with 512-byte sectors,
> > + * this meant that XFS_AGFL_SIZE was 119 on i386, but 118 on x64.  Commit
> > + * 96f859d52bcb1 ("libxfs: pack the agfl header structure so XFS_AGFL_SIZE is
> > + * correct") changed the definition to disable padding the end of the
> > + * structure, and was accepted into Linux 4.5.  Since then, the AGFL has
> > + * always used the larger size (e.g. 119 entries on a 512b sector fs).
> > + *
> > + * Unfortunately, pre-4.5 kernels can produce filesystems with AGFLs that wrap
> > + * at the smaller size, and those kernels are not prepared to handle the
> > + * longer size.  This typically manifests itself as an AGF verifier corruption
> > + * error followed by a filesystem shutdown.  While we encourage admins to stay
> > + * current with software, we would like to avoid this intermittent breakage.
> > + *
> > + * Any v5 filesystem which has a feature bit set for a feature that was
> > + * introduced after Linux 4.5 will not have this problem, as such kernels
> > + * cannot be mounted on older kernels.  v4 filesystems are also unaffected.
> > + *
> > + * Therefore, we add two fixup functions -- the first runs at mount time to
> > + * detect a short-wrapped AGFL and fix it; the second runs at unmount, freeze,
> > + * or remount-ro time to move a wrapped AGFL to the beginning of the list.
> > + * This reduces the likelihood of a screwup to the scenario where you have (a)
> > + * a filesystem with no post-4.5 features (reflink, rmap), (b) the AGFL wraps,
> > + * (c) the filesystem goes down leaving a dirty log, and (d) the dirty
> > + * filesystem is mounted on an old kernel.
> > + */
> > +
> 
> While the mount vs. unmount time fixups serve different purposes and
> have different conditions, do we really need two separate fixup
> implementations? E.g., if we have to unwrap the AGFL at unmount time,
> why not just reuse that fixup at mount time (when needed) as well? I
> suspect the difference would only be the length of what we can consider
> valid in the agfl at the time.

TBH I rewrote the whole thing (again...) so that we move all the list
items to the front of the agfl block no matter what problem we detect.
I also added more ascii art to describe the two other things that the
unmount fixer has to detect (list hits the end of the block at unmount)
and (empty list has pointers touching the end of the block).  It seems
to have passed the quick run so I'll send it out right after this.

I think my email receiving is broken.

--D

> 
> > +/*
> > + * Decide if we need to have the agfl wrapping fixes applied.  This only
> > + * affects v5 filesystems that do not have any features enabled that did not
> > + * exist when the agfl padding fix went in.
> > + *
> > + * Features already present when the fix went in were finobt, ftype, spinodes.
> > + * If we see something new (e.g. reflink) then don't bother.
> > + */
> > +#define XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED \
> > +		(~(XFS_SB_FEAT_RO_COMPAT_FINOBT))
> > +#define XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED \
> > +		(~(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> > +		   XFS_SB_FEAT_INCOMPAT_SPINODES))
> > +#define XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED \
> > +		(~0)
> > +static inline bool xfs_sb_version_needs_agfl_wrap_fixes(struct xfs_sb *sbp)
> > +{
> > +	return xfs_sb_version_hascrc(sbp) &&
> > +		!xfs_sb_has_incompat_feature(sbp,
> > +			XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED) &&
> > +		!xfs_sb_has_ro_compat_feature(sbp,
> > +			XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED) &&
> > +		!xfs_sb_has_incompat_log_feature(sbp,
> > +			XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED);
> > +}
> > +
> > +/*
> > + * Fix an AGFL wrapping that falls short of the end of the block by filling the
> > + * gap at the end of the block.
> > + */
> > +STATIC int
> > +xfs_fixup_freelist_wrap_mount(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agfbp,
> > +	struct xfs_perag	*pag)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_agf		*agf;
> > +	struct xfs_buf		*agflbp;
> > +	__be32			*agfl_bno;
> > +	xfs_agnumber_t		agno;
> > +	uint32_t		agfl_size;
> > +	uint32_t		flfirst;
> > +	uint32_t		fllast;
> > +	int32_t			active;
> > +	int			offset;
> > +	int			len;
> > +	int			error;
> > +
> > +	if (pag->pagf_flcount == 0)
> > +		return 0;
> > +
> > +	agfl_size = xfs_agfl_size(mp);
> > +	agf = XFS_BUF_TO_AGF(agfbp);
> > +	agno = be32_to_cpu(agf->agf_seqno);
> > +	flfirst = be32_to_cpu(agf->agf_flfirst);
> > +	fllast = be32_to_cpu(agf->agf_fllast);
> > +
> > +	/* Make sure we're either spot on or off by 1. */
> > +	active = fllast - flfirst + 1;
> > +	if (active <= 0)
> > +		active += agfl_size;
> > +	if (active == pag->pagf_flcount)
> > +		return 0;
> > +	else if (active != pag->pagf_flcount + 1)
> > +		return -EFSCORRUPTED;
> > +
> 
> So we're not attempting to cover the case where the agfl has 1 more
> block than the agfl size (i.e., the case where an fs goes back to a
> kernel with an unpacked header)?
> 
> I'm wondering whether using the unmount algorithm in both places (as
> noted above) would also facilitate this mechanism to work both ways
> (unpacked <-> packed), provided particular conditions are met. I suppose
> that could be considered regardless, but the less variance the better
> IMO.
> 
> > +	/* Would this have even passed muster on an old system? */
> 
> Comment doesn't really explain what is going on here..?
> 
> > +	if (flfirst >= agfl_size - 1 || fllast >= agfl_size - 1 ||
> > +	    pag->pagf_flcount > agfl_size - 1)
> > +		return -EFSCORRUPTED;
> > +
> 
> I take it these are checks for whether the agfl was previously corrupted
> based on the unpacked size? FWIW, it might be a bit more clear to use an
> old/unpacked_agfl_size variable to declare intent (here and in some of
> the comments and whatnot that follow).
> 
> > +	/*
> > +	 * Convert a 40-byte-padded agfl into a 36-byte-padded AGFL.
> > +	 * Therefore, we need to move the AGFL blocks
> > +	 * bno[flfirst..agfl_size - 2] to bno[flfirst + 1...agfl_size - 1].
> > +	 *
> > +	 * Reusing the example above, if we had flfirst == 116, we need
> > +	 * to move bno[116] and bno[117] into bno[117] and bno[118],
> > +	 * respectively, and then increment flfirst.
> > +	 */
> 
> Kind of a strange example to use given that it doesn't mention
> wrapping.. this only triggers if the agfl was previously wrapped, right?
> 
> > +	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
> > +	if (error)
> > +		return error;
> > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > +
> > +	len = (agfl_size - flfirst - 1) * sizeof(xfs_agblock_t);
> > +	memmove(&agfl_bno[flfirst + 1], &agfl_bno[flfirst], len);
> > +	offset = (char *)&agfl_bno[flfirst + 1] - (char *)agflbp->b_addr;
> > +	be32_add_cpu(&agf->agf_flfirst, 1);
> > +
> > +	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > +	xfs_trans_log_buf(tp, agflbp, offset, offset + len - 1);
> > +	xfs_trans_brelse(tp, agflbp);
> > +	agflbp = NULL;
> > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST);
> > +
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Fix an AGFL that touches the end of the block by moving the first or last
> > + * part of the list elsewhere in the AGFL so that old kernels don't trip over
> > + * wrapping issues.
> > + */
> > +STATIC int
> > +xfs_fixup_freelist_wrap_unmount(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_buf		*agfbp,
> > +	struct xfs_perag	*pag)
> > +{
> > +	struct xfs_mount	*mp = tp->t_mountp;
> > +	struct xfs_agf		*agf;
> > +	struct xfs_buf		*agflbp;
> > +	__be32			*agfl_bno;
> > +	xfs_agnumber_t		agno;
> > +	uint32_t		agfl_size;
> > +	uint32_t		flfirst;
> > +	uint32_t		fllast;
> > +	int			offset;
> > +	int			len;
> > +	int			error;
> > +
> > +	agfl_size = xfs_agfl_size(mp);
> > +	agf = XFS_BUF_TO_AGF(agfbp);
> > +	agno = be32_to_cpu(agf->agf_seqno);
> > +	flfirst = be32_to_cpu(agf->agf_flfirst);
> > +	fllast = be32_to_cpu(agf->agf_fllast);
> > +
> > +	/* Empty AGFL?  Make sure we aren't pointing at the end. */
> > +	if (pag->pagf_flcount == 0) {
> > +		if (flfirst >= agfl_size || fllast >= agfl_size) {
> 
> When would either field be >= agfl_size? Isn't that where they wrap?
> 
> > +			agf->agf_flfirst = cpu_to_be32(1);
> > +			agf->agf_fllast = 0;
> > +			xfs_alloc_log_agf(tp, agfbp,
> > +					XFS_AGF_FLFIRST | XFS_AGF_FLLAST);
> > +		}
> > +		return 0;
> > +	}
> > +
> > +	/* If we don't hit the end, we're done. */
> > +	if (flfirst < fllast && fllast != agfl_size - 1)
> > +		return 0;
> > +
> > +	/*
> > +	 * Move a start of a wrapped list towards the start of the agfl block.
> 
> FWIW, this and the subsequent comments kind of gave me the impression
> that the agfl would be "shifted" towards the start of the block. The
> code doesn't do that, but rather rotates the start/head of the agfl to
> the tail and adjusts the pointers (changing the effective order). That
> seems technically Ok, but I had to grok the code and read back to
> understand the comment rather than the other way around.
> 
> > +	 * Therefore, we need to move the AGFL blocks
> > +	 * bno[flfirst..agfl_size - 1] to bno[fllast + 1...agfl_size - flfirst].
> > +	 * Then we reset flfirst and fllast appropriately.
> > +	 *
> > +	 * Reusing the example above, if we had flfirst == 117 and fllast == 4,
> > +	 * we need to move bno[117] and bno[118] into bno[5] and bno[6],
> > +	 * respectively, and then reset flfirst and fllast.
> > +	 *
> > +	 * If it's just the last block that touches the end, only move that.
> > +	 */
> > +	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
> > +	if (error)
> > +		return error;
> > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > +
> > +	if (fllast == agfl_size - 1) {
> > +		/* Back the AGFL off from the end of the block. */
> > +		len = sizeof(xfs_agblock_t);
> > +		agfl_bno[flfirst - 1] = agfl_bno[agfl_size - 1];
> 
> What if the agfl is full (flfirst == 0)?
> 
> > +		offset = (char *)&agfl_bno[flfirst - 1] - (char *)agflbp->b_addr;
> > +		be32_add_cpu(&agf->agf_fllast, -1);
> > +		be32_add_cpu(&agf->agf_flfirst, -1);
> > +	} else {
> > +		/* Move the first part of the AGFL towards the front. */
> > +		len = (agfl_size - flfirst) * sizeof(xfs_agblock_t);
> > +		memcpy(&agfl_bno[fllast + 1], &agfl_bno[flfirst], len);
> > +		offset = (char *)&agfl_bno[fllast + 1] - (char *)agflbp->b_addr;
> > +		agf->agf_flfirst = 0;
> > +		agf->agf_fllast = cpu_to_be32(pag->pagf_flcount - 1);
> 
> Similar question here as above.. it looks like the copy may be a no-op,
> but we still reset flfirst/fllast (which may also be fine, but
> unnecessary).
> 
> The more interesting case here is flcount == 1 and flfirst == fllast,
> where it looks like we'd wrongly reset first/last (and perhaps copy more
> than we should..?).
> 
> Ugh. Remind me again why we can't just detect a mismatch, fail the mount
> and tell the user to repair? :P Random thought... have we considered
> anything less invasive/more simple for this issue than low level buffer
> manipulation? For example, could we address the unpacked -> packed case
> by just allocating a block to fill the gap at the end of the wrapped
> agfl? Perhaps that could even be done more discreetly in
> xfs_alloc_fix_freelist() when we already have a transaction set up, etc.
> That wouldn't help going the other direction, but maybe we could
> consider similar logic to free an extraneous block and then worry about
> protecting users who won't upgrade broken kernels separately if that
> really continues to be a problem.
> 
> Brian
> 
> > +	}
> > +
> > +	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > +	xfs_trans_log_buf(tp, agflbp, offset, offset + len - 1);
> > +	xfs_trans_brelse(tp, agflbp);
> > +	agflbp = NULL;
> > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST);
> > +
> > +	return 0;
> > +}
> > +
> > +typedef int (*xfs_agf_apply_fn_t)(struct xfs_trans *tp, struct xfs_buf *agfbp,
> > +		struct xfs_perag *pag);
> > +
> > +/* Apply something to every AGF. */
> > +STATIC int
> > +xfs_fixup_agf_apply(
> > +	struct xfs_mount	*mp,
> > +	xfs_agf_apply_fn_t	fn)
> > +{
> > +	struct xfs_trans	*tp;
> > +	struct xfs_perag	*pag;
> > +	struct xfs_buf		*agfbp;
> > +	xfs_agnumber_t		agno;
> > +	int			error;
> > +
> > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata, 0, 0, 0, &tp);
> > +	if (error)
> > +		return error;
> > +
> > +	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> > +		error = xfs_alloc_read_agf(mp, tp, agno, 0, &agfbp);
> > +		if (error)
> > +			goto cancel;
> > +		if (!agfbp) {
> > +			error = -ENOMEM;
> > +			goto cancel;
> > +		}
> > +		pag = xfs_perag_get(mp, agno);
> > +		error = fn(tp, agfbp, pag);
> > +		xfs_perag_put(pag);
> > +		xfs_trans_brelse(tp, agfbp);
> > +		if (error)
> > +			goto cancel;
> > +	}
> > +
> > +	return xfs_trans_commit(tp);
> > +cancel:
> > +	xfs_trans_cancel(tp);
> > +	return error;
> > +}
> > +
> > +/* Fix AGFL wrapping so we can use the filesystem. */
> > +int
> > +xfs_fixup_agfl_wrap_mount(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!xfs_sb_version_needs_agfl_wrap_fixes(&mp->m_sb))
> > +		return 0;
> > +
> > +	return xfs_fixup_agf_apply(mp, xfs_fixup_freelist_wrap_mount);
> > +}
> > +
> > +/* Fix AGFL wrapping so old kernels can use this filesystem. */
> > +int
> > +xfs_fixup_agfl_wrap_unmount(
> > +	struct xfs_mount	*mp)
> > +{
> > +	if (!xfs_sb_version_needs_agfl_wrap_fixes(&mp->m_sb))
> > +		return 0;
> > +
> > +	return xfs_fixup_agf_apply(mp, xfs_fixup_freelist_wrap_unmount);
> > +}
> > diff --git a/fs/xfs/xfs_fixups.h b/fs/xfs/xfs_fixups.h
> > new file mode 100644
> > index 0000000..fb52a96
> > --- /dev/null
> > +++ b/fs/xfs/xfs_fixups.h
> > @@ -0,0 +1,26 @@
> > +/*
> > + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> > + *
> > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version 2
> > + * of the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it would be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write the Free Software Foundation,
> > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > + */
> > +#ifndef	__XFS_FIXUPS_H__
> > +#define	__XFS_FIXUPS_H__
> > +
> > +int xfs_fixup_agfl_wrap_mount(struct xfs_mount *mp);
> > +int xfs_fixup_agfl_wrap_unmount(struct xfs_mount *mp);
> > +
> > +#endif /* __XFS_FIXUPS_H__ */
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 98fd41c..eb284aa 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -46,7 +46,7 @@
> >  #include "xfs_refcount_btree.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_extent_busy.h"
> > -
> > +#include "xfs_fixups.h"
> >  
> >  static DEFINE_MUTEX(xfs_uuid_table_mutex);
> >  static int xfs_uuid_table_size;
> > @@ -875,6 +875,16 @@ xfs_mountfs(
> >  	}
> >  
> >  	/*
> > +	 * Make sure our AGFL counters do not wrap the end of the block
> > +	 * in a troublesome manner.
> > +	 */
> > +	error = xfs_fixup_agfl_wrap_mount(mp);
> > +	if (error) {
> > +		xfs_warn(mp, "Failed to fix agfl wrapping.  Run xfs_repair.");
> > +		goto out_log_dealloc;
> > +	}
> > +
> > +	/*
> >  	 * Get and sanity-check the root inode.
> >  	 * Save the pointer to it in the mount structure.
> >  	 */
> > @@ -1128,6 +1138,15 @@ xfs_unmountfs(
> >  	xfs_qm_unmount(mp);
> >  
> >  	/*
> > +	 * Make sure our AGFL counters do not wrap the end of the block
> > +	 * in a troublesome manner for old kernels.
> > +	 */
> > +	error = xfs_fixup_agfl_wrap_unmount(mp);
> > +	if (error)
> > +		xfs_warn(mp, "Unable to fix agfl wrapping.  "
> > +				"This may cause problems on next mount.");
> > +
> > +	/*
> >  	 * Unreserve any blocks we have so that when we unmount we don't account
> >  	 * the reserved free space as used. This is really only necessary for
> >  	 * lazy superblock counting because it trusts the incore superblock
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 624a802..d9aa39a 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -50,6 +50,7 @@
> >  #include "xfs_refcount_item.h"
> >  #include "xfs_bmap_item.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_fixups.h"
> >  
> >  #include <linux/namei.h>
> >  #include <linux/dax.h>
> > @@ -1206,6 +1207,15 @@ xfs_quiesce_attr(
> >  	xfs_reclaim_inodes(mp, 0);
> >  	xfs_reclaim_inodes(mp, SYNC_WAIT);
> >  
> > +	/*
> > +	 * Make sure our AGFL counters do not wrap the end of the block
> > +	 * in a troublesome manner for old kernels.
> > +	 */
> > +	error = xfs_fixup_agfl_wrap_unmount(mp);
> > +	if (error)
> > +		xfs_warn(mp, "Unable to fix agfl wrapping.  "
> > +				"This may cause problems on next mount.");
> > +
> >  	/* Push the superblock and write an unmount record */
> >  	error = xfs_log_sbcount(mp);
> >  	if (error)
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
