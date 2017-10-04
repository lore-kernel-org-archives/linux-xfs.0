Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32563 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdJDEGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2017 00:06:50 -0400
Date: Tue, 3 Oct 2017 21:06:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 09/25] xfs: scrub the backup superblocks
Message-ID: <20171004040646.GM6503@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
 <150706330624.19351.11752175372525617518.stgit@magnolia>
 <20171004005709.GV3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171004005709.GV3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 11:57:09AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 01:41:46PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Ensure that the geometry presented in the backup superblocks matches
> > the primary superblock so that repair can recover the filesystem if
> > that primary gets corrupted.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile         |    1 
> >  fs/xfs/libxfs/xfs_fs.h  |    3 
> >  fs/xfs/scrub/agheader.c |  317 +++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/common.h   |    2 
> >  fs/xfs/scrub/scrub.c    |    4 +
> >  fs/xfs/scrub/scrub.h    |    1 
> >  6 files changed, 327 insertions(+), 1 deletion(-)
> >  create mode 100644 fs/xfs/scrub/agheader.c
> > 
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 5888b9f..e92d04d 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -146,6 +146,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> >  
> >  xfs-y				+= $(addprefix scrub/, \
> >  				   trace.o \
> > +				   agheader.o \
> >  				   btree.o \
> >  				   common.o \
> >  				   scrub.o \
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index 765f91e..8543cbb 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -484,9 +484,10 @@ struct xfs_scrub_metadata {
> >  
> >  /* Scrub subcommands. */
> >  #define XFS_SCRUB_TYPE_PROBE	0	/* presence test ioctl */
> > +#define XFS_SCRUB_TYPE_SB	1	/* superblock */
> >  
> >  /* Number of scrub subcommands. */
> > -#define XFS_SCRUB_TYPE_NR	1
> > +#define XFS_SCRUB_TYPE_NR	2
> >  
> >  /* i: Repair this metadata. */
> >  #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> > diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> > new file mode 100644
> > index 0000000..487c4f4
> > --- /dev/null
> > +++ b/fs/xfs/scrub/agheader.c
> > @@ -0,0 +1,317 @@
> > +/*
> > + * Copyright (C) 2017 Oracle.  All Rights Reserved.
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
> > +#include "xfs_trans_resv.h"
> > +#include "xfs_mount.h"
> > +#include "xfs_defer.h"
> > +#include "xfs_btree.h"
> > +#include "xfs_bit.h"
> > +#include "xfs_log_format.h"
> > +#include "xfs_trans.h"
> > +#include "xfs_sb.h"
> > +#include "xfs_inode.h"
> > +#include "scrub/xfs_scrub.h"
> > +#include "scrub/scrub.h"
> > +#include "scrub/common.h"
> > +#include "scrub/trace.h"
> > +
> > +/* Set us up to check an AG header. */
> > +int
> > +xfs_scrub_setup_ag_header(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> 
> Not immediately clear what "AG header" is being set up here?

AGF/AGFL/AGI.  All three of them.  Maybe I ought to split them into
three separate files...?

> 
> > +	struct xfs_mount		*mp = sc->mp;
> > +
> > +	if (sc->sm->sm_agno >= mp->m_sb.sb_agcount ||
> > +	    sc->sm->sm_ino || sc->sm->sm_gen)
> > +		return -EINVAL;
> > +	return xfs_scrub_setup_fs(sc, ip);
> > +}
> > +
> > +/* Superblock */
> > +
> > +/* Scrub the filesystem superblock. */
> > +int
> > +xfs_scrub_superblock(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	struct xfs_mount		*mp = sc->mp;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_dsb			*sb;
> > +	xfs_agnumber_t			agno;
> > +	uint32_t			v2_ok;
> > +	__be32				features_mask;
> > +	int				error;
> > +	__be16				vernum_mask;
> > +
> > +	agno = sc->sm->sm_agno;
> > +	if (agno == 0)
> > +		return 0;
> > +
> > +	error = xfs_trans_read_buf(mp, sc->tp, mp->m_ddev_targp,
> > +		  XFS_AGB_TO_DADDR(mp, agno, XFS_SB_BLOCK(mp)),
> > +		  XFS_FSS_TO_BB(mp, 1), 0, &bp, &xfs_sb_buf_ops);
> > +	if (!xfs_scrub_op_ok(sc, agno, XFS_SB_BLOCK(mp), &error))
> > +		return error;
> 
> Might be worth a comment to say the verifier is doing validity/range
> checks of the on-disk fields so they aren't duplicated here. I took
> a little while to work out why range checks weren't being done
> here...

Ok.

> > +
> > +	sb = XFS_BUF_TO_SBP(bp);
> > +
> > +	/*
> > +	 * Verify the geometries match.  Fields that are permanently
> > +	 * set by mkfs are checked; fields that can be updated later
> > +	 * (and are not propagated to backup superblocks) are preen
> > +	 * checked.
> > +	 */
> > +	if (sb->sb_blocksize != cpu_to_be32(mp->m_sb.sb_blocksize))
> > +		xfs_scrub_block_set_corrupt(sc, bp);
> > +
> > +	if (sb->sb_dblocks != cpu_to_be64(mp->m_sb.sb_dblocks))
> > +		xfs_scrub_block_set_corrupt(sc, bp);
> 
> Just wondering - once we've set the corrupt flag, do we need to
> bother checking any of the other fields? It makes no difference to
> what is reported to userspace or the action it is going to take,
> so couldn't we just do something like:

This is something I've also struggled with for quite a while.  The most
pragmatic reaction is to set the corrupt flag and jump out immediately
on any failure since we really only care about whether or not we have to
react to bad metadata either by fixing it or shutting down.

On the other hand, continuing with the checks gives us the ability to
report /everything/ that's broken in the data structure, which could be
useful for online forensics (cough) to correlate scrub's report against
anything else that has popped up in dmesg.

A downside of having everything jump to a single call to
xfs_scrub_block_set_corrupt at the end of the function is that the
return address that we record in the tracepoint will be the end of the
function instead of right after the failing check.

(Turning on the ludicrous speed optimizer might do that anyway...)

--D

> 	if (sb->sb_dblocks != cpu_to_be64(mp->m_sb.sb_dblocks))
> 		goto out_corrupt;
> 
> .....
> out_corrupt:
> 	xfs_scrub_block_set_corrupt(sc, bp);
> 	return 0;
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
