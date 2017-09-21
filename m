Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29497 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbdIUSOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 14:14:40 -0400
Date: Thu, 21 Sep 2017 11:14:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/27] xfs: test the scrub ioctl
Message-ID: <20170921181436.GM7112@magnolia>
References: <150595305131.18473.16572195821331601191.stgit@magnolia>
 <150595308840.18473.7997837811162843403.stgit@magnolia>
 <20170921060416.GS18948@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921060416.GS18948@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2017 at 04:04:16PM +1000, Dave Chinner wrote:
> On Wed, Sep 20, 2017 at 05:18:08PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create a test scrubber with id 0.  This will be used by xfs_scrub to
> > probe the kernel's abilities to scrub (and repair) the metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile        |    1 +
> >  fs/xfs/libxfs/xfs_fs.h |    3 ++
> >  fs/xfs/scrub/common.c  |   60 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/common.h  |   44 +++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/scrub.c   |   33 ++++++++++++++++++++++++++
> >  fs/xfs/scrub/scrub.h   |    1 +
> >  fs/xfs/scrub/trace.c   |    1 +
> >  7 files changed, 142 insertions(+), 1 deletion(-)
> >  create mode 100644 fs/xfs/scrub/common.c
> >  create mode 100644 fs/xfs/scrub/common.h
> > 
> > 
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index f4312bc..ca14595 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -146,6 +146,7 @@ ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
> >  
> >  xfs-y				+= $(addprefix scrub/, \
> >  				   trace.o \
> > +				   common.o \
> >  				   scrub.o \
> >  				   )
> >  endif
> > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > index a4b4c8c..5105bad 100644
> > --- a/fs/xfs/libxfs/xfs_fs.h
> > +++ b/fs/xfs/libxfs/xfs_fs.h
> > @@ -483,9 +483,10 @@ struct xfs_scrub_metadata {
> >   */
> >  
> >  /* Scrub subcommands. */
> > +#define XFS_SCRUB_TYPE_TEST	0	/* presence test ioctl */
> 
> Shouldn't we call this a "probe" - as in "probe for support" so it
> doesn't get confused with "use this to test whether scrub works"

I'd thought "test" as in "test if it's even there", but "probe" works
just as well and (hopefully) confuses everyone less.

> 
> >  /* Number of scrub subcommands. */
> > -#define XFS_SCRUB_TYPE_NR	0
> > +#define XFS_SCRUB_TYPE_NR	1
> >  
> >  /* i: Repair this metadata. */
> >  #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > new file mode 100644
> > index 0000000..13ccb36
> > --- /dev/null
> > +++ b/fs/xfs/scrub/common.c
> > @@ -0,0 +1,60 @@
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
> > +#include "xfs_alloc.h"
> > +#include "xfs_alloc_btree.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_bmap_btree.h"
> > +#include "xfs_ialloc.h"
> > +#include "xfs_ialloc_btree.h"
> > +#include "xfs_refcount.h"
> > +#include "xfs_refcount_btree.h"
> > +#include "xfs_rmap.h"
> > +#include "xfs_rmap_btree.h"
> > +#include "scrub/xfs_scrub.h"
> > +#include "scrub/scrub.h"
> > +#include "scrub/common.h"
> > +#include "scrub/trace.h"
> > +
> > +/* Common code for the metadata scrubbers. */
> > +
> > +/* Per-scrubber setup functions */
> > +
> > +/* Set us up with a transaction and an empty context. */
> > +int
> > +xfs_scrub_setup_fs(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_inode		*ip)
> > +{
> > +	return xfs_scrub_trans_alloc(sc->sm, sc->mp,
> > +			&M_RES(sc->mp)->tr_itruncate, 0, 0, 0, &sc->tp);
> > +}
> 
> Using the truncate transaction reservation really needs explaining
> here....

/*
 * Reserve a transaction with the largest reservation so that we can
 * handle the worst case log item space requirement if we have to repair
 * something big.
 */

Hm, come to think of it all callres of xfs_scrub_trans_alloc differ only
in the resblks passed in, so I can factor out the rtblks/flags/type
parameters.

> 
> .....
> >  
> > +/*
> > + * Test scrubber -- userspace uses this to probe if we're willing to
> > + * scrub or repair a given mountpoint.
> > + */
> 
> Yup, definitely should be called xfs_scrub_probe()....

Ok.

> > +int
> > +xfs_scrub_tester(
> > +	struct xfs_scrub_context	*sc)
> > +{
> > +	if (sc->sm->sm_ino || sc->sm->sm_agno)
> > +		return -EINVAL;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_CORRUPT)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_PREEN)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_XFAIL)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_XCORRUPT)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_INCOMPLETE)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_INCOMPLETE;
> > +	if (sc->sm->sm_gen & XFS_SCRUB_OFLAG_WARNING)
> > +		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
> > +	if (sc->sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
> > +		return -ENOENT;
> 
> Shouldn't this check should be first? If not, comment to explain?
> 
> Also, I find that really hard to parse because it's so dense and
> so much is repeated over and over again (makes my pattern matching
> brain cells scream). It's copying the exact same flags from
> sc->sm->sm_gen to sc->sm->sm_flags, so why not somethign like:
> 
> 
> 	struct xfs_scrub_m...	*sm = sc->sm;
> 
> 	if (sm->sm_ino || sm->sm_agno)
> 		return -EINVAL;
> 
> 	sm->flags = sm->sm_gen & XFS_SCRUB_FLAGS_OUT;
> 	if (sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
> 		return -ENOENT;

Yes, that could be:

	if (sm->sm_ino || sm->sm_agno)
		return -EINVAL;
	if (sm->sm_gen & ~XFS_SCRUB_FLAGS_OUT)
		return -ENOENT;

	/* Echo parameters back to userspace to prove that we exist. */
	sm->flags = sm->sm_gen & XFS_SCRUB_FLAGS_OUT;

--D

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
