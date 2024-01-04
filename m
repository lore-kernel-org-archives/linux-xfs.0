Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE3F1847
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jan 2024 01:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WEoX7h51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C909C433C8;
	Thu,  4 Jan 2024 01:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704332779;
	bh=HiHvjpivMQEtThSz4KrslUSXDpcj4YijsZ5dJbqohC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WEoX7h51uAXrN5cKt0yaLoI+xwQ86SYOKZpLFJ2cH7eW1ZSniso4BUeDsTIt4kCgW
	 ng1Pf5UnaxpteEY8sJZdaGJqNoQfxA2Qg/ByLVt5CM8UIeSW9+3T+1/QYX6WmXOEPN
	 3AftZ9GMGLOtb1Iszv+CJUKB3tMLoiaR/4OXuWLVSsnFYHs92vlnki3hVKShz5UlTG
	 YBjhhRxsUAzOL1zyL+o6T85x+qlpdJhEH4h78Q6G4XE6IImKt81M8QJQ0UEOR3Vjm/
	 pdPqDcZhsQct5+WYoAmJxk+itqtjYXbtqZJUsKLfPEm4jZRytr+WJDxWZakHUtmHhE
	 ehyGXK2Y6xXxw==
Date: Wed, 3 Jan 2024 17:46:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com,
	Dave Chinner <david@fromorbit.com>, Jian Wen <wenjian1@xiaomi.com>
Subject: Re: [PATCH v3] xfs: improve handling of prjquot ENOSPC
Message-ID: <20240104014618.GR361584@frogsfrogsfrogs>
References: <20231214150708.77586-1-wenjianhn@gmail.com>
 <20231223105632.85286-1-wenjianhn@gmail.com>
 <20240103014209.GH361584@frogsfrogsfrogs>
 <CAMXzGWJZHpatRBBJsH04B9GWNEVntGjU3WHQS-nDiC4wN2_HjQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXzGWJZHpatRBBJsH04B9GWNEVntGjU3WHQS-nDiC4wN2_HjQ@mail.gmail.com>

On Wed, Jan 03, 2024 at 11:45:30AM +0800, Jian Wen wrote:
> > Dave commented earlier:
> >
> > "Hence my suggestion that we should be returning -EDQUOT from project
> > quotas and only converting it to -ENOSPC once the project quota has been
> > flushed and failed with EDQUOT a second time."
> >
> > I think what he meant was changing xfs_trans_dqresv to return EDQUOT in
> > all circumstances.  I don't see that anywhere in this patch?
> 
> The related code that makes xfs_trans_dqresv() return -EDQUOT if the
> project quota limit is reached is as below.
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -700,8 +700,6 @@ xfs_trans_dqresv(
> 
>  error_return:
>         xfs_dqunlock(dqp);
> -       if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
> -               return -ENOSPC;
>         return -EDQUOT;
>  error_corrupt:
>         xfs_dqunlock(dqp);

Oh, silly me, I missed that change, sorry about that.

> On Wed, Jan 3, 2024 at 9:42 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Sat, Dec 23, 2023 at 06:56:32PM +0800, Jian Wen wrote:
> > > Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
> > > limit is reached. As a result, xfs_file_buffered_write() will flush
> > > the whole filesystem instead of the project quota.
> > >
> > > Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
> > > -ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
> > > for both EDQUOT and ENOSPC consistent.
> > >
> > > Changes since v2:
> > >   - completely rewrote based on the suggestions from Dave
> > >
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > > ---
> > >  fs/xfs/xfs_dquot.h       | 13 +++++++++++
> > >  fs/xfs/xfs_file.c        | 40 +++++++++++---------------------
> > >  fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
> > >  fs/xfs/xfs_icache.h      |  7 +++---
> > >  fs/xfs/xfs_inode.c       | 19 ++++++++-------
> > >  fs/xfs/xfs_reflink.c     |  2 ++
> > >  fs/xfs/xfs_trans.c       | 39 +++++++++++++++++++++++--------
> > >  fs/xfs/xfs_trans_dquot.c |  3 ---
> > >  8 files changed, 109 insertions(+), 64 deletions(-)
> > >
> > > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > > index 80c8f851a2f3..c5f4a170eef1 100644
> > > --- a/fs/xfs/xfs_dquot.h
> > > +++ b/fs/xfs/xfs_dquot.h
> > > @@ -183,6 +183,19 @@ xfs_dquot_is_enforced(
> > >       return false;
> > >  }
> > >
> > > +static inline bool
> > > +xfs_dquot_is_enospc(
> >
> > I don't like encoding error codes in a function name, especially since
> > EDQUOT is used for more dquot types than ENOSPC.
> >
> > "xfs_dquot_hardlimit_exceeded" ?
> >
> > > +     struct xfs_dquot        *dqp)
> > > +{
> > > +     if (!dqp)
> > > +             return false;
> > > +     if (!xfs_dquot_is_enforced(dqp))
> > > +             return false;
> > > +     if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
> > > +             return false;
> >
> >         return q_blk.reserved > dqp->q_blk.hardlimit; ?
> >
> > hardlimit == reserved shouldn't be considered an edquot condition.
> >
> > Also, locking is needed here.

Any response to this?

> > > +     return true;
> > > +}
> > > +
> > >  /*
> > >   * Check whether a dquot is under low free space conditions. We assume the quota
> > >   * is enabled and enforced.
> > > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > > index e33e5e13b95f..4b6e90bb1c59 100644
> > > --- a/fs/xfs/xfs_file.c
> > > +++ b/fs/xfs/xfs_file.c
> > > @@ -24,6 +24,9 @@
> > >  #include "xfs_pnfs.h"
> > >  #include "xfs_iomap.h"
> > >  #include "xfs_reflink.h"
> > > +#include "xfs_quota.h"
> > > +#include "xfs_dquot_item.h"
> > > +#include "xfs_dquot.h"
> > >
> > >  #include <linux/dax.h>
> > >  #include <linux/falloc.h>
> > > @@ -785,32 +788,17 @@ xfs_file_buffered_write(
> > >       trace_xfs_file_buffered_write(iocb, from);
> > >       ret = iomap_file_buffered_write(iocb, from,
> > >                       &xfs_buffered_write_iomap_ops);
> > > -
> > > -     /*
> > > -      * If we hit a space limit, try to free up some lingering preallocated
> > > -      * space before returning an error. In the case of ENOSPC, first try to
> > > -      * write back all dirty inodes to free up some of the excess reserved
> > > -      * metadata space. This reduces the chances that the eofblocks scan
> > > -      * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
> > > -      * also behaves as a filter to prevent too many eofblocks scans from
> > > -      * running at the same time.  Use a synchronous scan to increase the
> > > -      * effectiveness of the scan.
> > > -      */
> > > -     if (ret == -EDQUOT && !cleared_space) {
> > > -             xfs_iunlock(ip, iolock);
> > > -             xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
> > > -             cleared_space = true;
> > > -             goto write_retry;
> > > -     } else if (ret == -ENOSPC && !cleared_space) {
> > > -             struct xfs_icwalk       icw = {0};
> > > -
> > > -             cleared_space = true;
> > > -             xfs_flush_inodes(ip->i_mount);
> > > -
> > > -             xfs_iunlock(ip, iolock);
> > > -             icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > -             xfs_blockgc_free_space(ip->i_mount, &icw);
> > > -             goto write_retry;
> > > +     if (ret == -EDQUOT || ret == -ENOSPC) {
> >
> > Huh?
> >
> > Dave commented earlier:
> >
> > "Hence my suggestion that we should be returning -EDQUOT from project
> > quotas and only converting it to -ENOSPC once the project quota has been
> > flushed and failed with EDQUOT a second time."
> >
> > I think what he meant was changing xfs_trans_dqresv to return EDQUOT in
> > all circumstances.  I don't see that anywhere in this patch?
> >
> > Granted I think it's messy to set the /wrong/ errno in low level code
> > and require higher level code to detect and change it.  But I don't see
> > a better way to do that.
> >
> > Also, a question for Dave: What happens if xfs_trans_dqresv detects a
> > fatal overage in the project dquot, but the overage condition clears by
> > the time this caller rechecks the dquot?  Is it ok that we then return
> > EDQUOT whereas the current code would return ENOSPC?

I think this question is still relevant, though.  Or perhaps we should
define our own code for project quota exceeded, and translate that to
ENOSPC in the callers?

> >
> > --D
> >
> > > +             if (!cleared_space) {
> > > +                     xfs_iunlock(ip, iolock);
> > > +                     xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
> > > +                                             ip->i_gdquot, ip->i_pdquot,
> > > +                                             XFS_ICWALK_FLAG_SYNC, ret);
> > > +                     cleared_space = true;
> > > +                     goto write_retry;
> > > +             }
> > > +             if (ret == -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
> > > +                     ret = -ENOSPC;
> > >       }
> > >
> > >  out:
> > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > index dba514a2c84d..d2dcb653befc 100644
> > > --- a/fs/xfs/xfs_icache.c
> > > +++ b/fs/xfs/xfs_icache.c
> > > @@ -64,6 +64,10 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
> > >                                        XFS_ICWALK_FLAG_RECLAIM_SICK | \
> > >                                        XFS_ICWALK_FLAG_UNION)
> > >
> > > +static int xfs_blockgc_free_dquots(struct xfs_mount *mp,
> > > +             struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> > > +             struct xfs_dquot *pdqp, unsigned int iwalk_flags);
> > > +
> > >  /*
> > >   * Allocate and initialise an xfs_inode.
> > >   */
> > > @@ -1477,6 +1481,38 @@ xfs_blockgc_free_space(
> > >       return xfs_inodegc_flush(mp);
> > >  }
> > >
> > > +/*
> > > + * If we hit a space limit, try to free up some lingering preallocated
> > > + * space before returning an error. In the case of ENOSPC, first try to
> > > + * write back all dirty inodes to free up some of the excess reserved
> > > + * metadata space. This reduces the chances that the eofblocks scan
> > > + * waits on dirty mappings. Since xfs_flush_inodes() is serialized, this
> > > + * also behaves as a filter to prevent too many eofblocks scans from
> > > + * running at the same time.  Use a synchronous scan to increase the
> > > + * effectiveness of the scan.
> > > + */
> > > +void
> > > +xfs_blockgc_nospace_flush(
> > > +     struct xfs_mount        *mp,
> > > +     struct xfs_dquot        *udqp,
> > > +     struct xfs_dquot        *gdqp,
> > > +     struct xfs_dquot        *pdqp,
> > > +     unsigned int            iwalk_flags,
> > > +     int                     what)
> > > +{
> > > +     ASSERT(what == -EDQUOT || what == -ENOSPC);
> > > +
> > > +     if (what == -EDQUOT) {
> > > +             xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, iwalk_flags);
> > > +     } else if (what == -ENOSPC) {
> > > +             struct xfs_icwalk       icw = {0};
> > > +
> > > +             xfs_flush_inodes(mp);
> > > +             icw.icw_flags = iwalk_flags;
> > > +             xfs_blockgc_free_space(mp, &icw);
> > > +     }
> > > +}
> > > +
> > >  /*
> > >   * Reclaim all the free space that we can by scheduling the background blockgc
> > >   * and inodegc workers immediately and waiting for them all to clear.
> > > @@ -1515,7 +1551,7 @@ xfs_blockgc_flush_all(
> > >   * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's IOLOCK or
> > >   * MMAPLOCK.
> > >   */
> > > -int
> > > +static int
> > >  xfs_blockgc_free_dquots(
> > >       struct xfs_mount        *mp,
> > >       struct xfs_dquot        *udqp,
> > > @@ -1559,18 +1595,6 @@ xfs_blockgc_free_dquots(
> > >       return xfs_blockgc_free_space(mp, &icw);
> > >  }
> > >
> > > -/* Run cow/eofblocks scans on the quotas attached to the inode. */
> > > -int
> > > -xfs_blockgc_free_quota(
> > > -     struct xfs_inode        *ip,
> > > -     unsigned int            iwalk_flags)
> > > -{
> > > -     return xfs_blockgc_free_dquots(ip->i_mount,
> > > -                     xfs_inode_dquot(ip, XFS_DQTYPE_USER),
> > > -                     xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
> > > -                     xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
> > > -}
> > > -
> > >  /* XFS Inode Cache Walking Code */
> > >
> > >  /*
> > > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > > index 905944dafbe5..c0833450969d 100644
> > > --- a/fs/xfs/xfs_icache.h
> > > +++ b/fs/xfs/xfs_icache.h
> > > @@ -57,11 +57,10 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, unsigned long nr_to_scan);
> > >
> > >  void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
> > >
> > > -int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
> > > -             struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > > -             unsigned int iwalk_flags);
> > > -int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
> > >  int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
> > > +void xfs_blockgc_nospace_flush(struct xfs_mount *mp, struct xfs_dquot *udqp,
> > > +                     struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > > +                     unsigned int iwalk_flags, int what);
> > >  int xfs_blockgc_flush_all(struct xfs_mount *mp);
> > >
> > >  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index c0f1c89786c2..e99ffa17d3d0 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -27,6 +27,8 @@
> > >  #include "xfs_errortag.h"
> > >  #include "xfs_error.h"
> > >  #include "xfs_quota.h"
> > > +#include "xfs_dquot_item.h"
> > > +#include "xfs_dquot.h"
> > >  #include "xfs_filestream.h"
> > >  #include "xfs_trace.h"
> > >  #include "xfs_icache.h"
> > > @@ -1007,12 +1009,6 @@ xfs_create(
> > >        */
> > >       error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
> > >                       &tp);
> > > -     if (error == -ENOSPC) {
> > > -             /* flush outstanding delalloc blocks and retry */
> > > -             xfs_flush_inodes(mp);
> > > -             error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
> > > -                             resblks, &tp);
> > > -     }
> > >       if (error)
> > >               goto out_release_dquots;
> > >
> > > @@ -2951,14 +2947,21 @@ xfs_rename(
> > >       if (spaceres != 0) {
> > >               error = xfs_trans_reserve_quota_nblks(tp, target_dp, spaceres,
> > >                               0, false);
> > > -             if (error == -EDQUOT || error == -ENOSPC) {
> > > +             if (error == -EDQUOT) {
> > >                       if (!retried) {
> > >                               xfs_trans_cancel(tp);
> > > -                             xfs_blockgc_free_quota(target_dp, 0);
> > > +                             xfs_blockgc_nospace_flush(target_dp->i_mount,
> > > +                                                     target_dp->i_udquot,
> > > +                                                     target_dp->i_gdquot,
> > > +                                                     target_dp->i_pdquot,
> > > +                                                     0, error);
> > >                               retried = true;
> > >                               goto retry;
> > >                       }
> > >
> > > +                     if (xfs_dquot_is_enospc(target_dp->i_pdquot))
> > > +                             error = -ENOSPC;
> > > +
> > >                       nospace_error = error;
> > >                       spaceres = 0;
> > >                       error = 0;
> > > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > > index e5b62dc28466..cb036e1173ae 100644
> > > --- a/fs/xfs/xfs_reflink.c
> > > +++ b/fs/xfs/xfs_reflink.c
> > > @@ -25,6 +25,8 @@
> > >  #include "xfs_bit.h"
> > >  #include "xfs_alloc.h"
> > >  #include "xfs_quota.h"
> > > +#include "xfs_dquot_item.h"
> > > +#include "xfs_dquot.h"
> > >  #include "xfs_reflink.h"
> > >  #include "xfs_iomap.h"
> > >  #include "xfs_ag.h"

I wonder, what about the xfs_trans_reserve_quota_nblks in
xfs_reflink_remap_extent?  Does it need to filter EDQUOT?

Just looking through the list, I think xfs_ioctl_setattr_get_trans and
xfs_setattr_nonsize also need to check for EDQUOT and project dquots
being over, don't they?

> > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > index 305c9d07bf1b..1574d7aa49c4 100644
> > > --- a/fs/xfs/xfs_trans.c
> > > +++ b/fs/xfs/xfs_trans.c
> > > @@ -1217,15 +1217,21 @@ xfs_trans_alloc_inode(
> > >       }
> > >
> > >       error = xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks, force);
> > > -     if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > > +     if (error == -EDQUOT && !retried) {
> > >               xfs_trans_cancel(tp);
> > >               xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > -             xfs_blockgc_free_quota(ip, 0);
> > > +             xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
> > > +                                     ip->i_gdquot, ip->i_pdquot,
> > > +                                     0, error);
> > >               retried = true;
> > >               goto retry;
> > >       }
> > > -     if (error)
> > > +     if (error) {
> > > +             if (error == -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquot))
> > > +                     error = -ENOSPC;
> > > +
> > >               goto out_cancel;
> > > +     }
> > >
> > >       *tpp = tp;
> > >       return 0;
> > > @@ -1260,13 +1266,16 @@ xfs_trans_alloc_icreate(
> > >               return error;
> > >
> > >       error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
> > > -     if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > > +     if (error == -EDQUOT && !retried) {
> > >               xfs_trans_cancel(tp);
> > > -             xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > > +             xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0, error);
> > >               retried = true;
> > >               goto retry;
> > >       }
> > >       if (error) {
> > > +             if (error == -EDQUOT && xfs_dquot_is_enospc(pdqp))
> > > +                     error = -ENOSPC;
> > > +
> > >               xfs_trans_cancel(tp);
> > >               return error;
> > >       }
> > > @@ -1340,14 +1349,19 @@ xfs_trans_alloc_ichange(
> > >               error = xfs_trans_reserve_quota_bydquots(tp, mp, udqp, gdqp,
> > >                               pdqp, ip->i_nblocks + ip->i_delayed_blks,
> > >                               1, qflags);
> > > -             if ((error == -EDQUOT || error == -ENOSPC) && !retried) {
> > > +             if (error == -EDQUOT && !retried) {
> > >                       xfs_trans_cancel(tp);
> > > -                     xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > > +                     xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0,
> > > +                                             error);
> > >                       retried = true;
> > >                       goto retry;
> > >               }
> > > -             if (error)
> > > +             if (error) {
> > > +                     if (error == -EDQUOT && xfs_dquot_is_enospc(pdqp))
> > > +                             error = -ENOSPC;
> > > +
> > >                       goto out_cancel;
> > > +             }
> > >       }
> > >
> > >       *tpp = tp;
> > > @@ -1419,14 +1433,19 @@ xfs_trans_alloc_dir(
> > >               goto done;
> > >
> > >       error = xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false);
> > > -     if (error == -EDQUOT || error == -ENOSPC) {
> > > +     if (error == -EDQUOT) {
> > >               if (!retried) {
> > >                       xfs_trans_cancel(tp);
> > > -                     xfs_blockgc_free_quota(dp, 0);
> > > +                     xfs_blockgc_nospace_flush(dp->i_mount, ip->i_udquot,
> > > +                                             ip->i_gdquot, ip->i_pdquot,
> > > +                                             0, error);
> > >                       retried = true;
> > >                       goto retry;
> > >               }
> > >
> > > +             if (xfs_dquot_is_enospc(dp->i_pdquot))
> > > +                     error = -ENOSPC;
> > > +
> > >               *nospace_error = error;
> > >               resblks = 0;
> > >               error = 0;
> > > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > > index aa00cf67ad72..7201b86ef2c2 100644
> > > --- a/fs/xfs/xfs_trans_dquot.c
> > > +++ b/fs/xfs/xfs_trans_dquot.c
> > > @@ -700,8 +700,6 @@ xfs_trans_dqresv(
> > >
> > >  error_return:
> > >       xfs_dqunlock(dqp);
> > > -     if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
> > > -             return -ENOSPC;
> > >       return -EDQUOT;
> > >  error_corrupt:
> > >       xfs_dqunlock(dqp);
> > > @@ -717,7 +715,6 @@ xfs_trans_dqresv(
> > >   * approach.
> > >   *
> > >   * flags = XFS_QMOPT_FORCE_RES evades limit enforcement. Used by chown.
> > > - *      XFS_QMOPT_ENOSPC returns ENOSPC not EDQUOT.  Used by pquota.
> > >   *      XFS_TRANS_DQ_RES_BLKS reserves regular disk blocks
> > >   *      XFS_TRANS_DQ_RES_RTBLKS reserves realtime disk blocks
> > >   * dquots are unlocked on return, if they were not locked by caller.
> > > --
> > > 2.34.1
> > >
> > >
> 
> 
> 
> --
> Best,
> 
> Jian
> 
