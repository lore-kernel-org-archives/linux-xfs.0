Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:33346 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751660AbeEaFmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 01:42:07 -0400
Received: by mail-yb0-f195.google.com with SMTP id x36-v6so7184585ybi.0
        for <linux-xfs@vger.kernel.org>; Wed, 30 May 2018 22:42:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <152770867125.11611.4326291112451031937.stgit@magnolia>
References: <152770863951.11611.5866814627357136911.stgit@magnolia> <152770867125.11611.4326291112451031937.stgit@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 31 May 2018 08:42:06 +0300
Message-ID: <CAOQ4uxhz5M_3iYgtdsD-t9PDTy3mGXYfSqy0iYHwujPw-5dbng@mail.gmail.com>
Subject: Re: [PATCH 05/14] xfs: repair the rmapbt
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, May 30, 2018 at 10:31 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Rebuild the reverse mapping btree from all primary metadata.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/Makefile            |    1
>  fs/xfs/scrub/common.c      |    6
>  fs/xfs/scrub/repair.c      |  119 +++++++
>  fs/xfs/scrub/repair.h      |   27 +
>  fs/xfs/scrub/rmap.c        |    6
>  fs/xfs/scrub/rmap_repair.c |  796 ++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/scrub.c       |   18 +
>  fs/xfs/scrub/scrub.h       |    2
>  fs/xfs/xfs_mount.h         |    1
>  fs/xfs/xfs_super.c         |   27 +
>  fs/xfs/xfs_trans.c         |    7
>  11 files changed, 1004 insertions(+), 6 deletions(-)
>  create mode 100644 fs/xfs/scrub/rmap_repair.c
>
>
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 7c442f83b179..b9bbac3d5075 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -178,6 +178,7 @@ xfs-y                               += $(addprefix scrub/, \
>                                    alloc_repair.o \
>                                    ialloc_repair.o \
>                                    repair.o \
> +                                  rmap_repair.o \
>                                    )
>  endif
>  endif
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 89938b328954..f92994716522 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -603,9 +603,13 @@ xfs_scrub_trans_alloc(
>         struct xfs_scrub_context        *sc,
>         uint                            resblks)
>  {
> +       uint                            flags = 0;
> +
> +       if (sc->fs_frozen)
> +               flags |= XFS_TRANS_NO_WRITECOUNT;
>         if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
>                 return xfs_trans_alloc(sc->mp, &M_RES(sc->mp)->tr_itruncate,
> -                               resblks, 0, 0, &sc->tp);
> +                               resblks, 0, flags, &sc->tp);
>
>         return xfs_trans_alloc_empty(sc->mp, &sc->tp);
>  }
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 45a91841c0ac..4b5d599d53b9 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -43,6 +43,8 @@
>  #include "xfs_ag_resv.h"
>  #include "xfs_trans_space.h"
>  #include "xfs_quota.h"
> +#include "xfs_bmap.h"
> +#include "xfs_bmap_util.h"
>  #include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> @@ -1146,3 +1148,120 @@ xfs_repair_mod_ino_counts(
>                                 (int64_t)freecount - old_freecount);
>         }
>  }
> +
> +/*
> + * Freeze the FS against all other activity so that we can avoid ABBA
> + * deadlocks while taking locks in unusual orders so that we can rebuild
> + * metadata structures such as the rmapbt.
> + */
> +int
> +xfs_repair_fs_freeze(
> +       struct xfs_scrub_context        *sc)
> +{
> +       int                             error;
> +
> +       error = freeze_super(sc->mp->m_super);
> +       if (error)
> +               return error;
> +       sc->fs_frozen = true;
> +       return 0;
> +}
> +
> +/* Unfreeze the FS. */
> +int
> +xfs_repair_fs_thaw(
> +       struct xfs_scrub_context        *sc)
> +{
> +       struct inode                    *inode, *o;
> +       int                             error;
> +
> +       sc->fs_frozen = false;
> +       error = thaw_super(sc->mp->m_super);
> +
> +       inode = sc->frozen_inode_list;
> +       while (inode) {
> +               o = inode->i_private;
> +               inode->i_private = NULL;
> +               iput(inode);
> +               inode = o;
> +       }
> +
> +       return error;
> +}
> +


I think that new mechanism is worth a mention in the commit message,
if not a patch of its own with cc to fsdevel.
In a discussion on said patch I would ask: how does xfs_repair_fs_freeze()
work in collaboration with user initiated fsfreeze?
Is there a situation where LVM can be fooled to think that XFS is really
frozen, but it is actually "repair frozen"? and metadata can change while
taking a snapshot?
This is why I suggested to add a VFS freeze level, e.g.
SB_FREEZE_FS_MAINTAINANCE so that you don't publish XFS state
as SB_FREEZE_COMPLETE while you are modifying metadata on disk.
It might be sufficient to get XFS to state SB_FREEZE_COMPLETE and
then up only to SB_FREEZE_FS in xfs_repair_fs_freeze() without
adding any new states.

Thanks,
Amir.
