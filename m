Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751885AbeFFVNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jun 2018 17:13:40 -0400
Date: Wed, 6 Jun 2018 14:13:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/14] xfs: repair the rmapbt
Message-ID: <20180606211334.GA25007@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia>
 <152770867125.11611.4326291112451031937.stgit@magnolia>
 <CAOQ4uxhz5M_3iYgtdsD-t9PDTy3mGXYfSqy0iYHwujPw-5dbng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhz5M_3iYgtdsD-t9PDTy3mGXYfSqy0iYHwujPw-5dbng@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, May 31, 2018 at 08:42:06AM +0300, Amir Goldstein wrote:
> On Wed, May 30, 2018 at 10:31 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > Rebuild the reverse mapping btree from all primary metadata.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/Makefile            |    1
> >  fs/xfs/scrub/common.c      |    6
> >  fs/xfs/scrub/repair.c      |  119 +++++++
> >  fs/xfs/scrub/repair.h      |   27 +
> >  fs/xfs/scrub/rmap.c        |    6
> >  fs/xfs/scrub/rmap_repair.c |  796 ++++++++++++++++++++++++++++++++++++++++++++
> >  fs/xfs/scrub/scrub.c       |   18 +
> >  fs/xfs/scrub/scrub.h       |    2
> >  fs/xfs/xfs_mount.h         |    1
> >  fs/xfs/xfs_super.c         |   27 +
> >  fs/xfs/xfs_trans.c         |    7
> >  11 files changed, 1004 insertions(+), 6 deletions(-)
> >  create mode 100644 fs/xfs/scrub/rmap_repair.c
> >
> >
> > diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> > index 7c442f83b179..b9bbac3d5075 100644
> > --- a/fs/xfs/Makefile
> > +++ b/fs/xfs/Makefile
> > @@ -178,6 +178,7 @@ xfs-y                               += $(addprefix scrub/, \
> >                                    alloc_repair.o \
> >                                    ialloc_repair.o \
> >                                    repair.o \
> > +                                  rmap_repair.o \
> >                                    )
> >  endif
> >  endif
> > diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> > index 89938b328954..f92994716522 100644
> > --- a/fs/xfs/scrub/common.c
> > +++ b/fs/xfs/scrub/common.c
> > @@ -603,9 +603,13 @@ xfs_scrub_trans_alloc(
> >         struct xfs_scrub_context        *sc,
> >         uint                            resblks)
> >  {
> > +       uint                            flags = 0;
> > +
> > +       if (sc->fs_frozen)
> > +               flags |= XFS_TRANS_NO_WRITECOUNT;
> >         if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
> >                 return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
> > -                               resblks, 0, 0, &sc->tp);
> > +                               resblks, 0, flags, &sc->tp);
> >
> >         return xfs_trans_alloc_empty(sc->mp, &sc->tp);
> >  }
> > diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> > index 45a91841c0ac..4b5d599d53b9 100644
> > --- a/fs/xfs/scrub/repair.c
> > +++ b/fs/xfs/scrub/repair.c
> > @@ -43,6 +43,8 @@
> >  #include "xfs_ag_resv.h"
> >  #include "xfs_trans_space.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_bmap.h"
> > +#include "xfs_bmap_util.h"
> >  #include "scrub/xfs_scrub.h"
> >  #include "scrub/scrub.h"
> >  #include "scrub/common.h"
> > @@ -1146,3 +1148,120 @@ xfs_repair_mod_ino_counts(
> >                                 (int64_t)freecount - old_freecount);
> >         }
> >  }
> > +
> > +/*
> > + * Freeze the FS against all other activity so that we can avoid ABBA
> > + * deadlocks while taking locks in unusual orders so that we can rebuild
> > + * metadata structures such as the rmapbt.
> > + */
> > +int
> > +xfs_repair_fs_freeze(
> > +       struct xfs_scrub_context        *sc)
> > +{
> > +       int                             error;
> > +
> > +       error = freeze_super(sc->mp->m_super);
> > +       if (error)
> > +               return error;
> > +       sc->fs_frozen = true;
> > +       return 0;
> > +}
> > +
> > +/* Unfreeze the FS. */
> > +int
> > +xfs_repair_fs_thaw(
> > +       struct xfs_scrub_context        *sc)
> > +{
> > +       struct inode                    *inode, *o;
> > +       int                             error;
> > +
> > +       sc->fs_frozen = false;
> > +       error = thaw_super(sc->mp->m_super);
> > +
> > +       inode = sc->frozen_inode_list;
> > +       while (inode) {
> > +               o = inode->i_private;
> > +               inode->i_private = NULL;
> > +               iput(inode);
> > +               inode = o;
> > +       }
> > +
> > +       return error;
> > +}
> > +
> 
> 
> I think that new mechanism is worth a mention in the commit message,
> if not a patch of its own with cc to fsdevel.
> In a discussion on said patch I would ask: how does xfs_repair_fs_freeze()
> work in collaboration with user initiated fsfreeze?
> Is there a situation where LVM can be fooled to think that XFS is really
> frozen, but it is actually "repair frozen"? and metadata can change while
> taking a snapshot?

Notice how xfs added a ->freeze_super handler to the superblock
operations that prohibits userspace from initiating a freeze while any
repair operations are running?  If userspace (lvm, etc.) try to initiate
a freeze while repair is running, the freeze attempt is kicked back to
userspace with -EBUSY.  Similarly, a new xfs ->thaw_super handler
prevents userspace from unfreezing while repair is running.

Granted, the current patch doesn't quite work right either; I've
replaced m_scrubbers with a mutex that repair holds for the duration of
the repair freeze; this way regular freeze/thaw requests will block
until the repair is finished.

> This is why I suggested to add a VFS freeze level, e.g.
> SB_FREEZE_FS_MAINTAINANCE so that you don't publish XFS state
> as SB_FREEZE_COMPLETE while you are modifying metadata on disk.
> It might be sufficient to get XFS to state SB_FREEZE_COMPLETE and
> then up only to SB_FREEZE_FS in xfs_repair_fs_freeze() without
> adding any new states.

I tried that, and it didn't work.  We actually /do/ want to be at
SB_FREEZE_COMPLETE so that repair is the /only/ thread that can change
any filesystem state.  Under normal circumstances, XFS transaction
allocation will block until the SB_FREEZE_COMPLETE condition clears.
This stops any background space reclamation from happening, at least if
it requires a transaction.  Online repair of course grants itself the
ability to run transactions even during FREEZE_COMPLETE.

Will the following comment (to be embedded in the repair code) explain
this all sufficiently?

/*
 * Freezing the Filesystem for a Repair
 * ====================================
 *
 * While most repair activity can occur while the filesystem is live,
 * there are certain scenarios where we cannot tolerate concurrent
 * metadata updates.  We therefore must freeze the filesystem against
 * all other changes.
 *
 * The typical scenarios envisioned for repair freezes are (a) to avoid
 * ABBA deadlocks when need to take locks in an unusual order; or (b) to
 * update global filesystem state.  For example, reconstruction of a
 * damaged reverse mapping btree requires us to hold the AG header locks
 * while scanning inodes, which goes against the usual inode -> AG
 * header locking order.
 *
 * A note about inode reclaim: when we freeze the filesystem, users
 * can't modify things and periodic background reclaim of speculative
 * preallocations and copy-on-write staging extents is stopped.
 * However, the repair thread must be careful about evicting an inode
 * from memory -- if the eviction would require a transaction, we must
 * defer the iput until after the repair freeze.  The reasons for this
 * are twofold: first, repair already has a transaction and xfs can't
 * nest transactions; and second, we froze the fs to prevent
 * modifications that repair doesn't control directly.
 *
 * Userspace is prevented from freezing or thawing the filesystem during
 * a repair freeze by the ->freeze_super and ->thaw_super superblock
 * operations, which block any changes to the freeze state while a
 * repair freeze is running through the use of the m_repair_freeze
 * mutex.  It only makes sense to run one repair freeze at a time, so
 * the mutex is fine.
 *
 * Repair freezes cannot be initiated during a regular freeze because
 * freeze_super does not allow nested freeze.  Repair activity that does
 * not require a repair freeze is also prevented from running during a
 * regular freeze because transaction allocation blocks on the regular
 * freeze.  We assume that the only other users of
 * XFS_TRANS_NO_WRITECOUNT transactions either aren't modifying space
 * metadata in a way that would affect repair, or that we can inhibit
 * any of the ones that do.
 */

--D

> 
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
