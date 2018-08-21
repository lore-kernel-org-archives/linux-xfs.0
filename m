Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:24328 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726916AbeHVDF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Aug 2018 23:05:28 -0400
Date: Wed, 22 Aug 2018 09:43:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: open code sb verifier feature checks
Message-ID: <20180821234309.GN31495@dastard>
References: <20180820044851.414-1-david@fromorbit.com>
 <20180820044851.414-9-david@fromorbit.com>
 <CACj3i71PtPLve-zSUAdkzwQMXpf-pbXwpc+YGYmM6+9GQxBKjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71PtPLve-zSUAdkzwQMXpf-pbXwpc+YGYmM6+9GQxBKjA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Aug 21, 2018 at 03:01:21PM +0200, Jan Tulak wrote:
> On Mon, Aug 20, 2018 at 6:49 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > The superblock verifiers are one of the last places that use the sb
> > version functions to do feature checks. This are all quite simple
> > uses, and there aren't many of them so open code them all.
> >
> > Also, move the good version number check into xfs_sb.c instead of it
> > being an inline function in xfs_format.h
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |  26 ---------
> >  fs/xfs/libxfs/xfs_sb.c     | 116 +++++++++++++++++++++++++------------
> >  fs/xfs/libxfs/xfs_sb.h     |   1 +
> >  3 files changed, 81 insertions(+), 62 deletions(-)
> >
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index e21c39b13890..1f1107892dcd 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -280,32 +280,6 @@ typedef struct xfs_dsb {
> >
> >  #define        XFS_SB_VERSION_NUM(sbp) ((sbp)->sb_versionnum & XFS_SB_VERSION_NUMBITS)
> >
> > -/*
> > - * The first XFS version we support is a v4 superblock with V2 directories.
> > - */
> > -static inline bool xfs_sb_good_v4_features(struct xfs_sb *sbp)
> > -{
> > -       if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
> > -               return false;
> > -
> > -       /* check for unknown features in the fs */
> > -       if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> > -           ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> > -            (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
> > -               return false;
> > -
> > -       return true;
> > -}
> > -
> > -static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
> > -{
> > -       if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> > -               return true;
> > -       if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_4)
> > -               return xfs_sb_good_v4_features(sbp);
> > -       return false;
> > -}
> > -
> 
> As I understand this removed code, if, in the future, we would have
> e.g. superblock v6, then xfs_sb_good_version would return false,
> right?

Yes, which is correct because this kernel does not support v6
superblock filesystems.

> Which I think is not correctly replicated in the new function
> below.
> 
> >  static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
> >  {
> >         return sbp->sb_rblocks > 0;
> > diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> > index bedf6c6bf990..b83cf8adca1a 100644
> > --- a/fs/xfs/libxfs/xfs_sb.c
> > +++ b/fs/xfs/libxfs/xfs_sb.c
> > @@ -96,6 +96,35 @@ xfs_perag_put(
> >         trace_xfs_perag_put(pag->pag_mount, pag->pag_agno, ref, _RET_IP_);
> >  }
> >
> > +/*
> > + * We support all XFS versions newer than a v4 superblock with V2 directories.
> > + */
> > +bool
> > +xfs_sb_good_version(
> > +       struct xfs_sb   *sbp)
> > +{
> > +       /* all v5 filesystems are supported */
> > +       if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5)
> > +               return true;
> > +
> > +       /* versions prior to v4 are not supported */
> > +       if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
> > +               return false;
> > +
> > +       /* V4 filesystems need v2 directories */
> > +       if (!(sbp->sb_versionnum & XFS_SB_VERSION_DIRV2BIT))
> > +               return false;
> > +
> > +       /* And must not have any unknown v4 feature bits set */
> > +       if ((sbp->sb_versionnum & ~XFS_SB_VERSION_OKBITS) ||
> > +           ((sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) &&
> > +            (sbp->sb_features2 & ~XFS_SB_VERSION2_OKBITS)))
> > +               return false;
> > +
> > +       /* It's a supported v4 filesystem */
> > +       return true;
> > +}
> > +
> 
> If we call this xfs_sb_good_version() with superblock v6 or higher, it
> returns true too, not only for a supported v4. Unless the V4 specific
> checks (v2 directories and feature bits) somehow implicitly prevents
> that from happening, which is something I can't tell. :-)

Well, the unsupported v4 feature bits would catch it (like the
unsupported CRC V4 feature bit we set on v5 filesystems to ensure
pre-v5 sb kernels will reject it based on unsupported v4
functionality).

Regardless, I'll change it to explicitly check for supported
versions so (i.e. the num < v4 check becomes != v4).

Cheers,

Dave.

> 
> Cheers,
> Jan
> 
> -- 
> Jan Tulak
> jtulak@redhat.com / jan@tulak.me
> 

-- 
Dave Chinner
david@fromorbit.com
