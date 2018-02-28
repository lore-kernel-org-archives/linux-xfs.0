Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48118 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935384AbeB1Wny (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Feb 2018 17:43:54 -0500
Date: Wed, 28 Feb 2018 17:43:51 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: fix agfl wrapping
Message-ID: <20180228224351.GA31332@bfoster.bfoster>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
 <151935121574.21654.7158330354778549108.stgit@magnolia>
 <20180227193548.GF3479@bfoster.bfoster>
 <20180227210313.GK19312@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180227210313.GK19312@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 27, 2018 at 01:03:13PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 27, 2018 at 02:35:49PM -0500, Brian Foster wrote:
> > On Thu, Feb 22, 2018 at 06:00:15PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/Makefile     |    1 
> > >  fs/xfs/xfs_fixups.c |  310 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_fixups.h |   26 ++++
> > >  fs/xfs/xfs_mount.c  |   21 +++
> > >  fs/xfs/xfs_super.c  |   10 ++
> > >  5 files changed, 367 insertions(+), 1 deletion(-)
> > >  create mode 100644 fs/xfs/xfs_fixups.c
> > >  create mode 100644 fs/xfs/xfs_fixups.h
> > > 
> > > 
> > > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > > index b03c77e..f88368a 100644
> > > --- a/fs/xfs/Makefile
> > > +++ b/fs/xfs/Makefile
> > > @@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
> > >  				   xfs_extent_busy.o \
> > >  				   xfs_file.o \
> > >  				   xfs_filestream.o \
> > > +				   xfs_fixups.o \
> > >  				   xfs_fsmap.o \
> > >  				   xfs_fsops.o \
> > >  				   xfs_globals.o \
> > > diff --git a/fs/xfs/xfs_fixups.c b/fs/xfs/xfs_fixups.c
> > > new file mode 100644
> > > index 0000000..0cad7bb
> > > --- /dev/null
> > > +++ b/fs/xfs/xfs_fixups.c
> > > @@ -0,0 +1,310 @@
> > > +/*
> > > + * Copyright (C) 2018 Oracle.  All Rights Reserved.
> > > + *
> > > + * Author: Darrick J. Wong <darrick.wong@oracle.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * as published by the Free Software Foundation; either version 2
> > > + * of the License, or (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it would be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + *
> > > + * You should have received a copy of the GNU General Public License
> > > + * along with this program; if not, write the Free Software Foundation,
> > > + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> > > + */
> > > +#include "xfs.h"
> > > +#include "xfs_fs.h"
> > > +#include "xfs_shared.h"
> > > +#include "xfs_format.h"
> > > +#include "xfs_log_format.h"
> > > +#include "xfs_trans_resv.h"
> > > +#include "xfs_sb.h"
> > > +#include "xfs_mount.h"
> > > +#include "xfs_alloc.h"
> > > +#include "xfs_trans.h"
> > > +#include "xfs_fixups.h"
> > > +
> > > +/*
> > > + * v5 AGFL padding defects
> > > + *
> > > + * When the v5 format was first introduced, there was a defect in the struct
> > > + * xfs_agfl definition that resulted in XFS_AGFL_SIZE returning different
> > 
> > XFS_AGFL_SIZE() no longer exists as of the previous patch. It might be
> > better to size refer to "the agfl size" generically.
> 
> How about:
> 
> "...the agfl length calculation formula (at the time known as
> XFS_AGFL_SIZE)..."
> 

The formula formerly known as..? ;) Heh, sounds fine.

> > > + * values depending on the compiler padding.  On a fs with 512-byte sectors,
> > > + * this meant that XFS_AGFL_SIZE was 119 on i386, but 118 on x64.  Commit
> > > + * 96f859d52bcb1 ("libxfs: pack the agfl header structure so XFS_AGFL_SIZE is
> > > + * correct") changed the definition to disable padding the end of the
> > > + * structure, and was accepted into Linux 4.5.  Since then, the AGFL has
> > > + * always used the larger size (e.g. 119 entries on a 512b sector fs).
> > > + *
> > > + * Unfortunately, pre-4.5 kernels can produce filesystems with AGFLs that wrap
> > > + * at the smaller size, and those kernels are not prepared to handle the
> > > + * longer size.  This typically manifests itself as an AGF verifier corruption
> > > + * error followed by a filesystem shutdown.  While we encourage admins to stay
> > > + * current with software, we would like to avoid this intermittent breakage.
> > > + *
> > > + * Any v5 filesystem which has a feature bit set for a feature that was
> > > + * introduced after Linux 4.5 will not have this problem, as such kernels
> > > + * cannot be mounted on older kernels.  v4 filesystems are also unaffected.
> > > + *
> > > + * Therefore, we add two fixup functions -- the first runs at mount time to
> > > + * detect a short-wrapped AGFL and fix it; the second runs at unmount, freeze,
> > > + * or remount-ro time to move a wrapped AGFL to the beginning of the list.
> > > + * This reduces the likelihood of a screwup to the scenario where you have (a)
> > > + * a filesystem with no post-4.5 features (reflink, rmap), (b) the AGFL wraps,
> > > + * (c) the filesystem goes down leaving a dirty log, and (d) the dirty
> > > + * filesystem is mounted on an old kernel.
> > > + */
> > > +
> > 
> > While the mount vs. unmount time fixups serve different purposes and
> > have different conditions, do we really need two separate fixup
> > implementations? E.g., if we have to unwrap the AGFL at unmount time,
> > why not just reuse that fixup at mount time (when needed) as well? I
> > suspect the difference would only be the length of what we can consider
> > valid in the agfl at the time.
> 
> They're doing two different things.  I will use ASCII art to demonstrate
> the mount-time function:
> 

Yes, the question was whether we need to do two different things. For
example...

> Let's say the AGFL block has space for 10 items.  It looks like this:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header |   |   |   |   |   |   |   |   |   |   |
> 
> 
> When the fs is freshly formatted or repaired, the AGFL will look like:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header | A | B | C | D | E | F |   |   |   |   |
>          ^-- flfirst         ^-- fllast
> 
> Due to the padding problems prior to 4.5 ("4.5 agfl padding fix"),
> XFS_AGFL_SIZE would return 10 on 32-bit systems and 9 on 64-bit systems.
> Therefore, if the AGFL wrapped on a 64-bit kernel we would end up with:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header | D | E | F |   |   |   | A | B | C | ? |
>                  ^-- fllast      ^-- flfirst
> 
> Note that block 9's contents are undefined because we didn't write
> anything there.  Now the "4.5 agfl padding fix" has corrected
> XFS_AGFL_SIZE to return 10 in all cases, this looks like an AGF
> corruption because flcount is 6 but the distance between flfirst and
> fllast is 7.  So long as the list wraps and the mismatch is exactly one
> block we can fix this.  The mount time fixer in this patch does this by
> moving the records between flfirst and xfs_agfl_size (A, B, and C) to
> the end of the block to close the gap:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header | D | E | F |   |   |   |   | A | B | C |
>                  ^-- fllast          ^-- flfirst
> 
> If the count is off by more than 1 then the AGF is truly corrupt and we
> bail out.
> 
> Now let's say that we run for a while and want to unmount, but our AGFL
> wraps like this:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header | T | U | V |   |   |   |   | Q | R | S |
>                  ^-- fllast          ^-- flfirst
> 
> We don't know that the next kernel to mount this filesystem will have
> the "4.5 agfl padding fix" applied to it; if it does not, it will flag
> the AGF as corrupted because flcount is 6 but in its view the distance
> between flfirst and fllast (which omits bno[9]) is 5.  We don't want
> it to choke on that, so the unmount fixer moves all the records between
> flfirst and the end (Q, R, and S) towards the start of the block and
> resets flfirst/fllast:
> 
>          0   1   2   3   4   5   6   7   8   9
> Header | T | U | V | Q | R | S |   |   |   |   |
>          ^-- flfirst         ^-- fllast
> 

Could we use this basic algorithm at mount time as well? I know it
wouldn't be _exactly_ the same operation at mount time as it is for
unmount since slot 9 is a gap in the former case, but afaict the only
difference from an algorithmic perspective is the length of the shift.

IOW, if we were to parameterize the length of the shift and have the
mount fixup call the unmount algorithm, would it not also address the
problem?

> Since the AGFL no longer wraps at all, it doesn't matter if the next
> kernel to mount this filesystem has the "4.5 agfl padding fix" applied;
> all kernels can handle this correctly.
> 
> > > +/*
> > > + * Decide if we need to have the agfl wrapping fixes applied.  This only
> > > + * affects v5 filesystems that do not have any features enabled that did not
> > > + * exist when the agfl padding fix went in.
> > > + *
> > > + * Features already present when the fix went in were finobt, ftype, spinodes.
> > > + * If we see something new (e.g. reflink) then don't bother.
> > > + */
> > > +#define XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED \
> > > +		(~(XFS_SB_FEAT_RO_COMPAT_FINOBT))
> > > +#define XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED \
> > > +		(~(XFS_SB_FEAT_INCOMPAT_FTYPE | \
> > > +		   XFS_SB_FEAT_INCOMPAT_SPINODES))
> > > +#define XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED \
> > > +		(~0)
> > > +static inline bool xfs_sb_version_needs_agfl_wrap_fixes(struct xfs_sb *sbp)
> > > +{
> > > +	return xfs_sb_version_hascrc(sbp) &&
> > > +		!xfs_sb_has_incompat_feature(sbp,
> > > +			XFS_SB_FEAT_INCOMPAT_AGFL_WRAP_ALREADY_FIXED) &&
> > > +		!xfs_sb_has_ro_compat_feature(sbp,
> > > +			XFS_SB_FEAT_RO_COMPAT_AGFL_WRAP_ALREADY_FIXED) &&
> > > +		!xfs_sb_has_incompat_log_feature(sbp,
> > > +			XFS_SB_FEAT_INCOMPAT_LOG_AGFL_WRAP_ALREADY_FIXED);
> > > +}
> > > +
> > > +/*
> > > + * Fix an AGFL wrapping that falls short of the end of the block by filling the
> > > + * gap at the end of the block.
> > > + */
> > > +STATIC int
> > > +xfs_fixup_freelist_wrap_mount(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_buf		*agfbp,
> > > +	struct xfs_perag	*pag)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	struct xfs_agf		*agf;
> > > +	struct xfs_buf		*agflbp;
> > > +	__be32			*agfl_bno;
> > > +	xfs_agnumber_t		agno;
> > > +	uint32_t		agfl_size;
> > > +	uint32_t		flfirst;
> > > +	uint32_t		fllast;
> > > +	int32_t			active;
> > > +	int			offset;
> > > +	int			len;
> > > +	int			error;
> > > +
> > > +	if (pag->pagf_flcount == 0)
> > > +		return 0;
> > > +
> > > +	agfl_size = xfs_agfl_size(mp);
> > > +	agf = XFS_BUF_TO_AGF(agfbp);
> > > +	agno = be32_to_cpu(agf->agf_seqno);
> > > +	flfirst = be32_to_cpu(agf->agf_flfirst);
> > > +	fllast = be32_to_cpu(agf->agf_fllast);
> > > +
> > > +	/* Make sure we're either spot on or off by 1. */
> > > +	active = fllast - flfirst + 1;
> > > +	if (active <= 0)
> > > +		active += agfl_size;
> > > +	if (active == pag->pagf_flcount)
> > > +		return 0;
> > > +	else if (active != pag->pagf_flcount + 1)
> > > +		return -EFSCORRUPTED;
> > > +
> > 
> > So we're not attempting to cover the case where the agfl has 1 more
> > block than the agfl size (i.e., the case where an fs goes back to a
> > kernel with an unpacked header)?
> 
> We don't know how the next kernel to touch this filesystem will define
> XFS_AGFL_SIZE -- it could be a 4.5+ kernel (same agfl size), a 32-bit
> pre-4.5 kernel (same agfl size), or a 64-bit pre-4.5 kernel (small agfl
> size).
> 

I don't think I was clear.. I'm envisioning whether we could come up
with a patch that would generically fix up the agfl on disk to be sane
relative to the current kernel. This patch covers the case of a packed
agfl kernel mounting an unpacked on-disk agfl. It would be nice if we
could implement something that also handled a packed on-disk agfl to an
unpacked agfl kernel (for easier backport to unpacked kernels, for
e.g.).

> > I'm wondering whether using the unmount algorithm in both places (as
> > noted above) would also facilitate this mechanism to work both ways
> > (unpacked <-> packed), provided particular conditions are met. I suppose
> > that could be considered regardless, but the less variance the better
> > IMO.
> 
> In principle I suppose we could have a single function to handle all the
> rearranging, but I'd rather have two functions to handle the two cases.
> I'm open to refactoring the common parts out of the
> xfs_fixup_freelist_wrap_*mount functions.
> 

As noted above, I'm not really commenting on the function factoring here
as much as the use of multiple algorithms (using one would certainly
facilitate some mechanical refactoring).

> > > +	/* Would this have even passed muster on an old system? */
> > 
> > Comment doesn't really explain what is going on here..?
> 
> /*
>  * If the distance between flfirst and fllast mismatches flcount by more
>  * than 1, then there's more wrong with this agfl than just the padding
>  * problem.  Bail out completely, which will force the admin to run
>  * xfs_repair.
>  */
> 

*nod*

> > 
> > > +	if (flfirst >= agfl_size - 1 || fllast >= agfl_size - 1 ||
> > > +	    pag->pagf_flcount > agfl_size - 1)
> > > +		return -EFSCORRUPTED;
> > > +
> > 
> > I take it these are checks for whether the agfl was previously corrupted
> > based on the unpacked size? FWIW, it might be a bit more clear to use an
> > old/unpacked_agfl_size variable to declare intent (here and in some of
> > the comments and whatnot that follow).
> 
> Ok.
> 
> > > +	/*
> > > +	 * Convert a 40-byte-padded agfl into a 36-byte-padded AGFL.
> > > +	 * Therefore, we need to move the AGFL blocks
> > > +	 * bno[flfirst..agfl_size - 2] to bno[flfirst + 1...agfl_size - 1].
> > > +	 *
> > > +	 * Reusing the example above, if we had flfirst == 116, we need
> > > +	 * to move bno[116] and bno[117] into bno[117] and bno[118],
> > > +	 * respectively, and then increment flfirst.
> > > +	 */
> > 
> > Kind of a strange example to use given that it doesn't mention
> > wrapping.. this only triggers if the agfl was previously wrapped, right?
> 
> Right.  I used to have a check that if the list didn't wrap then we
> would just exit because no fixing is required... but it must've fallen
> out.  I agree that we don't want to rely on a subtlety here to stay out
> of here if the agfl wasn't initially wrapped.
> 
> > > +	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
> > > +	if (error)
> > > +		return error;
> > > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > > +
> > > +	len = (agfl_size - flfirst - 1) * sizeof(xfs_agblock_t);
> > > +	memmove(&agfl_bno[flfirst + 1], &agfl_bno[flfirst], len);
> > > +	offset = (char *)&agfl_bno[flfirst + 1] - (char *)agflbp->b_addr;
> > > +	be32_add_cpu(&agf->agf_flfirst, 1);
> > > +
> > > +	xfs_trans_buf_set_type(tp, agflbp, XFS_BLFT_AGFL_BUF);
> > > +	xfs_trans_log_buf(tp, agflbp, offset, offset + len - 1);
> > > +	xfs_trans_brelse(tp, agflbp);
> > > +	agflbp = NULL;
> > > +	xfs_alloc_log_agf(tp, agfbp, XFS_AGF_FLFIRST);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/*
> > > + * Fix an AGFL that touches the end of the block by moving the first or last
> > > + * part of the list elsewhere in the AGFL so that old kernels don't trip over
> > > + * wrapping issues.
> > > + */
> > > +STATIC int
> > > +xfs_fixup_freelist_wrap_unmount(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_buf		*agfbp,
> > > +	struct xfs_perag	*pag)
> > > +{
> > > +	struct xfs_mount	*mp = tp->t_mountp;
> > > +	struct xfs_agf		*agf;
> > > +	struct xfs_buf		*agflbp;
> > > +	__be32			*agfl_bno;
> > > +	xfs_agnumber_t		agno;
> > > +	uint32_t		agfl_size;
> > > +	uint32_t		flfirst;
> > > +	uint32_t		fllast;
> > > +	int			offset;
> > > +	int			len;
> > > +	int			error;
> > > +
> > > +	agfl_size = xfs_agfl_size(mp);
> > > +	agf = XFS_BUF_TO_AGF(agfbp);
> > > +	agno = be32_to_cpu(agf->agf_seqno);
> > > +	flfirst = be32_to_cpu(agf->agf_flfirst);
> > > +	fllast = be32_to_cpu(agf->agf_fllast);
> > > +
> > > +	/* Empty AGFL?  Make sure we aren't pointing at the end. */
> > > +	if (pag->pagf_flcount == 0) {
> > > +		if (flfirst >= agfl_size || fllast >= agfl_size) {
> > 
> > When would either field be >= agfl_size? Isn't that where they wrap?
> 
> Oops, you're right, that should be flfirst >= agfl_size - 1.
> 
> Or really,
> 
> old_agfl_size = agfl_size - 1
> if flfirst >= old_agfl_size or fllast >= old_agfl_size:
> 	blahblahblah
> 
> > 
> > > +			agf->agf_flfirst = cpu_to_be32(1);
> > > +			agf->agf_fllast = 0;
> > > +			xfs_alloc_log_agf(tp, agfbp,
> > > +					XFS_AGF_FLFIRST | XFS_AGF_FLLAST);
> > > +		}
> > > +		return 0;
> > > +	}
> > > +
> > > +	/* If we don't hit the end, we're done. */
> > > +	if (flfirst < fllast && fllast != agfl_size - 1)
> > > +		return 0;
> > > +
> > > +	/*
> > > +	 * Move a start of a wrapped list towards the start of the agfl block.
> > 
> > FWIW, this and the subsequent comments kind of gave me the impression
> > that the agfl would be "shifted" towards the start of the block. The
> > code doesn't do that, but rather rotates the start/head of the agfl to
> > the tail and adjusts the pointers (changing the effective order). That
> > seems technically Ok, but I had to grok the code and read back to
> > understand the comment rather than the other way around.
> 
> Yeah.  Sorry about the confusion, maybe it would be better if I took out
> these confusing comments and replaced it all with the ascii art above?
> 

I'm still hoping we can do something a bit more simple and flexible in
general, but that aside, the ascii art describes the associated
algorithms much better.

> > > +	 * Therefore, we need to move the AGFL blocks
> > > +	 * bno[flfirst..agfl_size - 1] to bno[fllast + 1...agfl_size - flfirst].
> > > +	 * Then we reset flfirst and fllast appropriately.
> > > +	 *
> > > +	 * Reusing the example above, if we had flfirst == 117 and fllast == 4,
> > > +	 * we need to move bno[117] and bno[118] into bno[5] and bno[6],
> > > +	 * respectively, and then reset flfirst and fllast.
> > > +	 *
> > > +	 * If it's just the last block that touches the end, only move that.
> > > +	 */
> > > +	error = xfs_alloc_read_agfl(mp, tp, agno, &agflbp);
> > > +	if (error)
> > > +		return error;
> > > +	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);
> > > +
> > > +	if (fllast == agfl_size - 1) {
> > > +		/* Back the AGFL off from the end of the block. */
> > > +		len = sizeof(xfs_agblock_t);
> > > +		agfl_bno[flfirst - 1] = agfl_bno[agfl_size - 1];
> > 
> > What if the agfl is full (flfirst == 0)?
> 
> I don't think we ever unmount with a full agfl -- we're guaranteed at
> least 118 items in the AGFL, and the maximum size the agfl will ever
> need is 8 blocks for each of bnobt, cntbt, rmapbt.
> 
> However, we could just detect a full agfl and free the end block.
> 

I suppose it's unlikely we'll ever see corner cases such as a completely
full or empty agfl. That said, I think the code needs to handle those
cases sanely. That could mean explicit checks and skipping the fixup for
all I care, just as long as we don't have memory corruption vectors and
whatnot if (when?) assumptions prove wrong.

> > > +		offset = (char *)&agfl_bno[flfirst - 1] - (char *)agflbp->b_addr;
> > > +		be32_add_cpu(&agf->agf_fllast, -1);
> > > +		be32_add_cpu(&agf->agf_flfirst, -1);
> > > +	} else {
> 
> This needs to check for flfirst > fllast.
> 
> > > +		/* Move the first part of the AGFL towards the front. */
> > > +		len = (agfl_size - flfirst) * sizeof(xfs_agblock_t);
> > > +		memcpy(&agfl_bno[fllast + 1], &agfl_bno[flfirst], len);
> > > +		offset = (char *)&agfl_bno[fllast + 1] - (char *)agflbp->b_addr;
> > > +		agf->agf_flfirst = 0;
> > > +		agf->agf_fllast = cpu_to_be32(pag->pagf_flcount - 1);
> > 
> > Similar question here as above.. it looks like the copy may be a no-op,
> > but we still reset flfirst/fllast (which may also be fine, but
> > unnecessary).
> > 
> > The more interesting case here is flcount == 1 and flfirst == fllast,
> > where it looks like we'd wrongly reset first/last (and perhaps copy more
> > than we should..?).
> > 
> > Ugh. Remind me again why we can't just detect a mismatch, fail the mount
> > and tell the user to repair? :P
> 
> Not all the distros included xfs_repair in the initrd or the logic to
> call it (as opposed to "fsck -y") if the root fs fails to mount, which
> means that if this wrapping problem hits a root filesystem then the
> administrator will have to reboot with a recovery iso and run xfs_repair
> from there.  That's going to generate a /lot/ of support work compared
> to us figuring out how to repair the filesystems automatically.
> 

Yeah, sorry. Good argument for the unpacked -> packed fixup.

> > Random thought... have we considered anything less invasive/more
> > simple for this issue than low level buffer manipulation? For example,
> > could we address the unpacked -> packed case by just allocating a
> > block to fill the gap at the end of the wrapped agfl?
> 
> The allocation could fail, in which case we'd be forced to resort to
> list manipulation.
> 

Yeah.. obvious tradeoff, but how likely is that? It seems a reasonable
tradeoff to me given there's still the repair path. Also note that we
don't have to necessarily allocate from the btrees.

(FWIW, I hacked around on this a bit and ended up with something
slightly different[1].)

> > Perhaps that could even be done more discreetly in
> > xfs_alloc_fix_freelist() when we already have a transaction set up,
> > etc.
> 
> Possible, though this will add more logic to every hot allocation call
> for something that only needs fixing at mount and at unmount.  I think
> there's a stronger argument for doing the unmount cleanup on every
> fix_freelist since that would eliminate the small chance that a new
> kernel crashes and gets recovered on an old kernel.
> 

Eh, I don't think that's anything we couldn't address if need be.  E.g.,
amortize the padding fixup against actual allocations, set/test a pag
bit to track the padding fixup, or check it on agf read and set a "needs
fixup" bit, etc.

> > That wouldn't help going the other direction, but maybe we could
> > consider similar logic to free an extraneous block and then worry
> > about protecting users who won't upgrade broken kernels separately if
> > that really continues to be a problem.
> 
> It is already a problem here.
> 

Then it should be able to stand alone as an independent patch (with
independent commit log that explains/justifies it, etc.).

Brian

[1] This is hacky and brute force, but the idea was to try and do
something that could work in either direction and reuse more existing
code. It basically just reads the on-disk entries "manually" and
reinserts them into a reinitialized (empty) agfl. Perhaps it could be
refactored into something that only rotates a given number of entries or
something of that nature. Anyways, just an experiment and probably
broken..

int
xfs_agfl_fixup(
	struct xfs_trans	*tp,
	struct xfs_buf		*agbp,
	struct xfs_perag	*pag)
{
	struct xfs_mount	*mp = tp->t_mountp;
	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
	int			agfl_size = XFS_AGFL_SIZE(mp);
	int			ofirst, olast, osize;
	int			nfirst, nlast;
	struct xfs_buf		*agflbp;
	__be32			*agfl_bno;
	int			active;
	xfs_agblock_t		bno;
	bool			wasempty = false;

	if (pag->pagf_flcount == 0)
		wasempty = true;

	ofirst = be32_to_cpu(agf->agf_flfirst);
	olast = be32_to_cpu(agf->agf_fllast);
	if (olast >= ofirst)
		active = olast - ofirst + 1;
	else
		active = agfl_size - ofirst + olast + 1;

	if (active == pag->pagf_flcount + 1)
		osize = agfl_size - 1;
	else if ((active == pag->pagf_flcount - 1) ||
		 ofirst == agfl_size || olast == agfl_size)
		osize = agfl_size + 1;
	else if (active == pag->pagf_flcount)
		osize = agfl_size;
	else
		return -EFSCORRUPTED;

	xfs_alloc_read_agfl(mp, tp, be32_to_cpu(agf->agf_seqno), &agflbp);
	agfl_bno = XFS_BUF_TO_AGFL_BNO(mp, agflbp);

	nlast = do_mod(olast, agfl_size);
	nfirst = nlast + 1;
	nfirst = do_mod(nfirst, agfl_size);
	ASSERT(nfirst != ofirst);

	agf->agf_flfirst = cpu_to_be32(nfirst);
	agf->agf_fllast = cpu_to_be32(nlast);
	agf->agf_flcount = 0;
	xfs_alloc_log_agf(tp, agbp, XFS_AGF_FLFIRST | XFS_AGF_FLLAST |
				    XFS_AGF_FLCOUNT);
	pag->pagf_flcount = 0;

	if (wasempty)
		goto out;

	while (true) {
		ofirst = do_mod(ofirst, osize);
		bno = be32_to_cpu(agfl_bno[ofirst]);
		xfs_alloc_put_freelist(tp, agbp, agflbp, bno, 0);
		if (ofirst == olast)
			break;
		ofirst++;
	}

out:
	xfs_trans_brelse(tp, agflbp);
	return 0;
}

