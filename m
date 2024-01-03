Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E210F13AF4
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 03:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jQrtOiKn"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-595564b5764so181907eaf.1
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jan 2024 19:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704253567; x=1704858367; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B/ioFlb4nKFeF64KRgudRM9CiJ9WZXmDWv65c5kXFo8=;
        b=jQrtOiKnbyQa+hjTxRwtQaZkVpeL67JPPOpbSbkEL+eQN4T3iEGDHwdx4U1x7Ekd9o
         wcnsQBfUe2qvgtf4uVRGUWNSeBhDlhY1KrvM8RsxCHWMzmlQBVvtrunW54JYsHMMKxOi
         3E5HiTU6HZA4Z3TwBCuOHOe88ine5ySiMuHyg3fJgPRDXemU5lTFuv6EpJZtCXQ21slm
         FpBu0xSfIv6MnvPo1E/EmvUfabuVq51MOOTy+42S6OCsVhNW9iwlmxHNmLWQv881VrBD
         eoyxghaPMCUpsnn4/4vldjs9/ykTEtVqGLxFMyODQmTr7vaooVT0h/kKy1+DyzU6MN0x
         BCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704253567; x=1704858367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/ioFlb4nKFeF64KRgudRM9CiJ9WZXmDWv65c5kXFo8=;
        b=GG7cpFPWj61HzonmeLG9PhbHOfRYX5iCUJwrSvdNrOoFV8nxbZ8GsPUvJo+8i2fH86
         ZzBMQHldfo0BqZWmhiR32d/Us4bsw3FTFRcB+vuRV/BoqJr78YAx0nyso/GZSfIlfcS2
         kH0VodB3O6WDhZsDQshapQA4fbmXSXWkRJXs3DHKwnLDSxVC3u3Za9B8KodeOimushza
         GJHN/4RqluSe2rfSiroCC3h8ViJNijyOIRsNARBlxP9Nu8cS8EBL2xUVnoEKPVnOqjID
         f3jZTGwFCKgQ7nPHRc4CC0crr2u+VXGe98EiD3dKIl6ZsAt16OvH3dckAwn46sIwbUCq
         lSvw==
X-Gm-Message-State: AOJu0YzGwOSobrIjGwwywy8oTf9Rkp10YYplZHNd7PzCMpUYNHQYNc2n
	JuZRcG6QJ9tjzEpDNbk8s1cprMElsKrgkTyaH5o=
X-Google-Smtp-Source: AGHT+IEZGDDNGMUzVJPPrPMRGm3iX3opmc6SI6hAmzwszH31rFOqYt3xHQfpxadeibwH3CLgYG4pvj3+YT6SMYcy+EE=
X-Received: by 2002:a4a:b38c:0:b0:595:6024:c4f8 with SMTP id
 p12-20020a4ab38c000000b005956024c4f8mr6991575ooo.1.1704253566715; Tue, 02 Jan
 2024 19:46:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231214150708.77586-1-wenjianhn@gmail.com> <20231223105632.85286-1-wenjianhn@gmail.com>
 <20240103014209.GH361584@frogsfrogsfrogs>
In-Reply-To: <20240103014209.GH361584@frogsfrogsfrogs>
From: Jian Wen <wenjianhn@gmail.com>
Date: Wed, 3 Jan 2024 11:45:30 +0800
Message-ID: <CAMXzGWJZHpatRBBJsH04B9GWNEVntGjU3WHQS-nDiC4wN2_HjQ@mail.gmail.com>
Subject: Re: [PATCH v3] xfs: improve handling of prjquot ENOSPC
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dchinner@redhat.com, 
	Dave Chinner <david@fromorbit.com>, Jian Wen <wenjian1@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Dave commented earlier:
>
> "Hence my suggestion that we should be returning -EDQUOT from project
> quotas and only converting it to -ENOSPC once the project quota has been
> flushed and failed with EDQUOT a second time."
>
> I think what he meant was changing xfs_trans_dqresv to return EDQUOT in
> all circumstances.  I don't see that anywhere in this patch?

The related code that makes xfs_trans_dqresv() return -EDQUOT if the
project quota limit is reached is as below.
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -700,8 +700,6 @@ xfs_trans_dqresv(

 error_return:
        xfs_dqunlock(dqp);
-       if (xfs_dquot_type(dqp) =3D=3D XFS_DQTYPE_PROJ)
-               return -ENOSPC;
        return -EDQUOT;
 error_corrupt:
        xfs_dqunlock(dqp);
On Wed, Jan 3, 2024 at 9:42=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> On Sat, Dec 23, 2023 at 06:56:32PM +0800, Jian Wen wrote:
> > Currently, xfs_trans_dqresv() return -ENOSPC when the project quota
> > limit is reached. As a result, xfs_file_buffered_write() will flush
> > the whole filesystem instead of the project quota.
> >
> > Fix the issue by make xfs_trans_dqresv() return -EDQUOT rather than
> > -ENOSPC. Add a helper, xfs_blockgc_nospace_flush(), to make flushing
> > for both EDQUOT and ENOSPC consistent.
> >
> > Changes since v2:
> >   - completely rewrote based on the suggestions from Dave
> >
> > Suggested-by: Dave Chinner <david@fromorbit.com>
> > Signed-off-by: Jian Wen <wenjian1@xiaomi.com>
> > ---
> >  fs/xfs/xfs_dquot.h       | 13 +++++++++++
> >  fs/xfs/xfs_file.c        | 40 +++++++++++---------------------
> >  fs/xfs/xfs_icache.c      | 50 +++++++++++++++++++++++++++++-----------
> >  fs/xfs/xfs_icache.h      |  7 +++---
> >  fs/xfs/xfs_inode.c       | 19 ++++++++-------
> >  fs/xfs/xfs_reflink.c     |  2 ++
> >  fs/xfs/xfs_trans.c       | 39 +++++++++++++++++++++++--------
> >  fs/xfs/xfs_trans_dquot.c |  3 ---
> >  8 files changed, 109 insertions(+), 64 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> > index 80c8f851a2f3..c5f4a170eef1 100644
> > --- a/fs/xfs/xfs_dquot.h
> > +++ b/fs/xfs/xfs_dquot.h
> > @@ -183,6 +183,19 @@ xfs_dquot_is_enforced(
> >       return false;
> >  }
> >
> > +static inline bool
> > +xfs_dquot_is_enospc(
>
> I don't like encoding error codes in a function name, especially since
> EDQUOT is used for more dquot types than ENOSPC.
>
> "xfs_dquot_hardlimit_exceeded" ?
>
> > +     struct xfs_dquot        *dqp)
> > +{
> > +     if (!dqp)
> > +             return false;
> > +     if (!xfs_dquot_is_enforced(dqp))
> > +             return false;
> > +     if (dqp->q_blk.hardlimit - dqp->q_blk.reserved > 0)
> > +             return false;
>
>         return q_blk.reserved > dqp->q_blk.hardlimit; ?
>
> hardlimit =3D=3D reserved shouldn't be considered an edquot condition.
>
> Also, locking is needed here.
>
> > +     return true;
> > +}
> > +
> >  /*
> >   * Check whether a dquot is under low free space conditions. We assume=
 the quota
> >   * is enabled and enforced.
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index e33e5e13b95f..4b6e90bb1c59 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -24,6 +24,9 @@
> >  #include "xfs_pnfs.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_reflink.h"
> > +#include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >
> >  #include <linux/dax.h>
> >  #include <linux/falloc.h>
> > @@ -785,32 +788,17 @@ xfs_file_buffered_write(
> >       trace_xfs_file_buffered_write(iocb, from);
> >       ret =3D iomap_file_buffered_write(iocb, from,
> >                       &xfs_buffered_write_iomap_ops);
> > -
> > -     /*
> > -      * If we hit a space limit, try to free up some lingering preallo=
cated
> > -      * space before returning an error. In the case of ENOSPC, first =
try to
> > -      * write back all dirty inodes to free up some of the excess rese=
rved
> > -      * metadata space. This reduces the chances that the eofblocks sc=
an
> > -      * waits on dirty mappings. Since xfs_flush_inodes() is serialize=
d, this
> > -      * also behaves as a filter to prevent too many eofblocks scans f=
rom
> > -      * running at the same time.  Use a synchronous scan to increase =
the
> > -      * effectiveness of the scan.
> > -      */
> > -     if (ret =3D=3D -EDQUOT && !cleared_space) {
> > -             xfs_iunlock(ip, iolock);
> > -             xfs_blockgc_free_quota(ip, XFS_ICWALK_FLAG_SYNC);
> > -             cleared_space =3D true;
> > -             goto write_retry;
> > -     } else if (ret =3D=3D -ENOSPC && !cleared_space) {
> > -             struct xfs_icwalk       icw =3D {0};
> > -
> > -             cleared_space =3D true;
> > -             xfs_flush_inodes(ip->i_mount);
> > -
> > -             xfs_iunlock(ip, iolock);
> > -             icw.icw_flags =3D XFS_ICWALK_FLAG_SYNC;
> > -             xfs_blockgc_free_space(ip->i_mount, &icw);
> > -             goto write_retry;
> > +     if (ret =3D=3D -EDQUOT || ret =3D=3D -ENOSPC) {
>
> Huh?
>
> Dave commented earlier:
>
> "Hence my suggestion that we should be returning -EDQUOT from project
> quotas and only converting it to -ENOSPC once the project quota has been
> flushed and failed with EDQUOT a second time."
>
> I think what he meant was changing xfs_trans_dqresv to return EDQUOT in
> all circumstances.  I don't see that anywhere in this patch?
>
> Granted I think it's messy to set the /wrong/ errno in low level code
> and require higher level code to detect and change it.  But I don't see
> a better way to do that.
>
> Also, a question for Dave: What happens if xfs_trans_dqresv detects a
> fatal overage in the project dquot, but the overage condition clears by
> the time this caller rechecks the dquot?  Is it ok that we then return
> EDQUOT whereas the current code would return ENOSPC?
>
> --D
>
> > +             if (!cleared_space) {
> > +                     xfs_iunlock(ip, iolock);
> > +                     xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udqu=
ot,
> > +                                             ip->i_gdquot, ip->i_pdquo=
t,
> > +                                             XFS_ICWALK_FLAG_SYNC, ret=
);
> > +                     cleared_space =3D true;
> > +                     goto write_retry;
> > +             }
> > +             if (ret =3D=3D -EDQUOT && xfs_dquot_is_enospc(ip->i_pdquo=
t))
> > +                     ret =3D -ENOSPC;
> >       }
> >
> >  out:
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index dba514a2c84d..d2dcb653befc 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> > @@ -64,6 +64,10 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
> >                                        XFS_ICWALK_FLAG_RECLAIM_SICK | \
> >                                        XFS_ICWALK_FLAG_UNION)
> >
> > +static int xfs_blockgc_free_dquots(struct xfs_mount *mp,
> > +             struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
> > +             struct xfs_dquot *pdqp, unsigned int iwalk_flags);
> > +
> >  /*
> >   * Allocate and initialise an xfs_inode.
> >   */
> > @@ -1477,6 +1481,38 @@ xfs_blockgc_free_space(
> >       return xfs_inodegc_flush(mp);
> >  }
> >
> > +/*
> > + * If we hit a space limit, try to free up some lingering preallocated
> > + * space before returning an error. In the case of ENOSPC, first try t=
o
> > + * write back all dirty inodes to free up some of the excess reserved
> > + * metadata space. This reduces the chances that the eofblocks scan
> > + * waits on dirty mappings. Since xfs_flush_inodes() is serialized, th=
is
> > + * also behaves as a filter to prevent too many eofblocks scans from
> > + * running at the same time.  Use a synchronous scan to increase the
> > + * effectiveness of the scan.
> > + */
> > +void
> > +xfs_blockgc_nospace_flush(
> > +     struct xfs_mount        *mp,
> > +     struct xfs_dquot        *udqp,
> > +     struct xfs_dquot        *gdqp,
> > +     struct xfs_dquot        *pdqp,
> > +     unsigned int            iwalk_flags,
> > +     int                     what)
> > +{
> > +     ASSERT(what =3D=3D -EDQUOT || what =3D=3D -ENOSPC);
> > +
> > +     if (what =3D=3D -EDQUOT) {
> > +             xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, iwalk_flags=
);
> > +     } else if (what =3D=3D -ENOSPC) {
> > +             struct xfs_icwalk       icw =3D {0};
> > +
> > +             xfs_flush_inodes(mp);
> > +             icw.icw_flags =3D iwalk_flags;
> > +             xfs_blockgc_free_space(mp, &icw);
> > +     }
> > +}
> > +
> >  /*
> >   * Reclaim all the free space that we can by scheduling the background=
 blockgc
> >   * and inodegc workers immediately and waiting for them all to clear.
> > @@ -1515,7 +1551,7 @@ xfs_blockgc_flush_all(
> >   * (XFS_ICWALK_FLAG_SYNC), the caller also must not hold any inode's I=
OLOCK or
> >   * MMAPLOCK.
> >   */
> > -int
> > +static int
> >  xfs_blockgc_free_dquots(
> >       struct xfs_mount        *mp,
> >       struct xfs_dquot        *udqp,
> > @@ -1559,18 +1595,6 @@ xfs_blockgc_free_dquots(
> >       return xfs_blockgc_free_space(mp, &icw);
> >  }
> >
> > -/* Run cow/eofblocks scans on the quotas attached to the inode. */
> > -int
> > -xfs_blockgc_free_quota(
> > -     struct xfs_inode        *ip,
> > -     unsigned int            iwalk_flags)
> > -{
> > -     return xfs_blockgc_free_dquots(ip->i_mount,
> > -                     xfs_inode_dquot(ip, XFS_DQTYPE_USER),
> > -                     xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
> > -                     xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags=
);
> > -}
> > -
> >  /* XFS Inode Cache Walking Code */
> >
> >  /*
> > diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> > index 905944dafbe5..c0833450969d 100644
> > --- a/fs/xfs/xfs_icache.h
> > +++ b/fs/xfs/xfs_icache.h
> > @@ -57,11 +57,10 @@ long xfs_reclaim_inodes_nr(struct xfs_mount *mp, un=
signed long nr_to_scan);
> >
> >  void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
> >
> > -int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *ud=
qp,
> > -             struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > -             unsigned int iwalk_flags);
> > -int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_fl=
ags);
> >  int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *ic=
m);
> > +void xfs_blockgc_nospace_flush(struct xfs_mount *mp, struct xfs_dquot =
*udqp,
> > +                     struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
> > +                     unsigned int iwalk_flags, int what);
> >  int xfs_blockgc_flush_all(struct xfs_mount *mp);
> >
> >  void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index c0f1c89786c2..e99ffa17d3d0 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -27,6 +27,8 @@
> >  #include "xfs_errortag.h"
> >  #include "xfs_error.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >  #include "xfs_filestream.h"
> >  #include "xfs_trace.h"
> >  #include "xfs_icache.h"
> > @@ -1007,12 +1009,6 @@ xfs_create(
> >        */
> >       error =3D xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, res=
blks,
> >                       &tp);
> > -     if (error =3D=3D -ENOSPC) {
> > -             /* flush outstanding delalloc blocks and retry */
> > -             xfs_flush_inodes(mp);
> > -             error =3D xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, p=
dqp,
> > -                             resblks, &tp);
> > -     }
> >       if (error)
> >               goto out_release_dquots;
> >
> > @@ -2951,14 +2947,21 @@ xfs_rename(
> >       if (spaceres !=3D 0) {
> >               error =3D xfs_trans_reserve_quota_nblks(tp, target_dp, sp=
aceres,
> >                               0, false);
> > -             if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) {
> > +             if (error =3D=3D -EDQUOT) {
> >                       if (!retried) {
> >                               xfs_trans_cancel(tp);
> > -                             xfs_blockgc_free_quota(target_dp, 0);
> > +                             xfs_blockgc_nospace_flush(target_dp->i_mo=
unt,
> > +                                                     target_dp->i_udqu=
ot,
> > +                                                     target_dp->i_gdqu=
ot,
> > +                                                     target_dp->i_pdqu=
ot,
> > +                                                     0, error);
> >                               retried =3D true;
> >                               goto retry;
> >                       }
> >
> > +                     if (xfs_dquot_is_enospc(target_dp->i_pdquot))
> > +                             error =3D -ENOSPC;
> > +
> >                       nospace_error =3D error;
> >                       spaceres =3D 0;
> >                       error =3D 0;
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index e5b62dc28466..cb036e1173ae 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -25,6 +25,8 @@
> >  #include "xfs_bit.h"
> >  #include "xfs_alloc.h"
> >  #include "xfs_quota.h"
> > +#include "xfs_dquot_item.h"
> > +#include "xfs_dquot.h"
> >  #include "xfs_reflink.h"
> >  #include "xfs_iomap.h"
> >  #include "xfs_ag.h"
> > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > index 305c9d07bf1b..1574d7aa49c4 100644
> > --- a/fs/xfs/xfs_trans.c
> > +++ b/fs/xfs/xfs_trans.c
> > @@ -1217,15 +1217,21 @@ xfs_trans_alloc_inode(
> >       }
> >
> >       error =3D xfs_trans_reserve_quota_nblks(tp, ip, dblocks, rblocks,=
 force);
> > -     if ((error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) && !retried) {
> > +     if (error =3D=3D -EDQUOT && !retried) {
> >               xfs_trans_cancel(tp);
> >               xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > -             xfs_blockgc_free_quota(ip, 0);
> > +             xfs_blockgc_nospace_flush(ip->i_mount, ip->i_udquot,
> > +                                     ip->i_gdquot, ip->i_pdquot,
> > +                                     0, error);
> >               retried =3D true;
> >               goto retry;
> >       }
> > -     if (error)
> > +     if (error) {
> > +             if (error =3D=3D -EDQUOT && xfs_dquot_is_enospc(ip->i_pdq=
uot))
> > +                     error =3D -ENOSPC;
> > +
> >               goto out_cancel;
> > +     }
> >
> >       *tpp =3D tp;
> >       return 0;
> > @@ -1260,13 +1266,16 @@ xfs_trans_alloc_icreate(
> >               return error;
> >
> >       error =3D xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, d=
blocks);
> > -     if ((error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) && !retried) {
> > +     if (error =3D=3D -EDQUOT && !retried) {
> >               xfs_trans_cancel(tp);
> > -             xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > +             xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0, error)=
;
> >               retried =3D true;
> >               goto retry;
> >       }
> >       if (error) {
> > +             if (error =3D=3D -EDQUOT && xfs_dquot_is_enospc(pdqp))
> > +                     error =3D -ENOSPC;
> > +
> >               xfs_trans_cancel(tp);
> >               return error;
> >       }
> > @@ -1340,14 +1349,19 @@ xfs_trans_alloc_ichange(
> >               error =3D xfs_trans_reserve_quota_bydquots(tp, mp, udqp, =
gdqp,
> >                               pdqp, ip->i_nblocks + ip->i_delayed_blks,
> >                               1, qflags);
> > -             if ((error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) && !re=
tried) {
> > +             if (error =3D=3D -EDQUOT && !retried) {
> >                       xfs_trans_cancel(tp);
> > -                     xfs_blockgc_free_dquots(mp, udqp, gdqp, pdqp, 0);
> > +                     xfs_blockgc_nospace_flush(mp, udqp, gdqp, pdqp, 0=
,
> > +                                             error);
> >                       retried =3D true;
> >                       goto retry;
> >               }
> > -             if (error)
> > +             if (error) {
> > +                     if (error =3D=3D -EDQUOT && xfs_dquot_is_enospc(p=
dqp))
> > +                             error =3D -ENOSPC;
> > +
> >                       goto out_cancel;
> > +             }
> >       }
> >
> >       *tpp =3D tp;
> > @@ -1419,14 +1433,19 @@ xfs_trans_alloc_dir(
> >               goto done;
> >
> >       error =3D xfs_trans_reserve_quota_nblks(tp, dp, resblks, 0, false=
);
> > -     if (error =3D=3D -EDQUOT || error =3D=3D -ENOSPC) {
> > +     if (error =3D=3D -EDQUOT) {
> >               if (!retried) {
> >                       xfs_trans_cancel(tp);
> > -                     xfs_blockgc_free_quota(dp, 0);
> > +                     xfs_blockgc_nospace_flush(dp->i_mount, ip->i_udqu=
ot,
> > +                                             ip->i_gdquot, ip->i_pdquo=
t,
> > +                                             0, error);
> >                       retried =3D true;
> >                       goto retry;
> >               }
> >
> > +             if (xfs_dquot_is_enospc(dp->i_pdquot))
> > +                     error =3D -ENOSPC;
> > +
> >               *nospace_error =3D error;
> >               resblks =3D 0;
> >               error =3D 0;
> > diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> > index aa00cf67ad72..7201b86ef2c2 100644
> > --- a/fs/xfs/xfs_trans_dquot.c
> > +++ b/fs/xfs/xfs_trans_dquot.c
> > @@ -700,8 +700,6 @@ xfs_trans_dqresv(
> >
> >  error_return:
> >       xfs_dqunlock(dqp);
> > -     if (xfs_dquot_type(dqp) =3D=3D XFS_DQTYPE_PROJ)
> > -             return -ENOSPC;
> >       return -EDQUOT;
> >  error_corrupt:
> >       xfs_dqunlock(dqp);
> > @@ -717,7 +715,6 @@ xfs_trans_dqresv(
> >   * approach.
> >   *
> >   * flags =3D XFS_QMOPT_FORCE_RES evades limit enforcement. Used by cho=
wn.
> > - *      XFS_QMOPT_ENOSPC returns ENOSPC not EDQUOT.  Used by pquota.
> >   *      XFS_TRANS_DQ_RES_BLKS reserves regular disk blocks
> >   *      XFS_TRANS_DQ_RES_RTBLKS reserves realtime disk blocks
> >   * dquots are unlocked on return, if they were not locked by caller.
> > --
> > 2.34.1
> >
> >



--
Best,

Jian
