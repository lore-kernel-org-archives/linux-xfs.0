Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbfDQTBd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 15:01:33 -0400
Date: Wed, 17 Apr 2019 12:01:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 4/4] xfs: don't allow most setxattr to immutable files
Message-ID: <20190417190124.GA5057@magnolia>
References: <155466882175.633834.15261194784129614735.stgit@magnolia>
 <155466884962.633834.14320700092446721044.stgit@magnolia>
 <20190409031929.GE5147@magnolia>
 <CAOQ4uxgDQHJntoO6EZ1fn-iBVo8gshsSpHd_UB1cnXUJ3CXOTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgDQHJntoO6EZ1fn-iBVo8gshsSpHd_UB1cnXUJ3CXOTg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 <linux-ext4@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>

On Tue, Apr 09, 2019 at 11:24:10AM +0300, Amir Goldstein wrote:
> On Tue, Apr 9, 2019 at 6:19 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> >
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> >
> > The chattr manpage has this to say about immutable files:
> >
> > "A file with the 'i' attribute cannot be modified: it cannot be deleted
> > or renamed, no link can be created to this file, most of the file's
> > metadata can not be modified, and the file can not be opened in write
> > mode."
> >
> > However, we don't actually check the immutable flag in the setattr code,
> > which means that we can update project ids and extent size hints on
> > supposedly immutable files.  Therefore, reject a setattr call on an
> > immutable file except for the case where we're trying to unset
> > IMMUTABLE.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_ioctl.c |   46 ++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 44 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index 5a1b96dad901..67d12027f563 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -1023,6 +1023,40 @@ xfs_ioctl_setattr_flush(
> >         return filemap_write_and_wait(inode->i_mapping);
> >  }
> >
> > +/*
> > + * If immutable is set and we are not clearing it, we're not allowed to change
> > + * anything else in the inode.
> 
> This looks correct, but FYI, neither xfs_io nor chattr clears 'immutable'
> and sets projid/*extsize in one ioctl/xfsctl, so there is no justification to
> making an extra effort to support that use case. You could do with
> checking 'immutable' inside xfs_ioctl_setattr_check_projid/*extsize()
> and leave only the di_flags check here.

However, the API does allow callers to clear immutable and set other
fields in one go, so just because xfs_io won't do it doesn't mean we can
ignore it.

Then again I guess the manpage doesn't explicitly say what the behavior
is supposed to be, so I guess we'll just ... argh, fine I'll go fix the
manpage to document the behavior.

--D

> Some would say that will be cleaner code.
> Its a matter of taste and its your subsystem, so feel free to dismiss
> this comments.
> 
> Thanks,
> Amir.
> 
> > Don't error out if we're only trying to set
> > + * immutable on an immutable file.
> > + */
> > +static int
> > +xfs_ioctl_setattr_immutable(
> > +       struct xfs_inode        *ip,
> > +       struct fsxattr          *fa,
> > +       uint16_t                di_flags,
> > +       uint64_t                di_flags2)
> > +{
> > +       struct xfs_mount        *mp = ip->i_mount;
> > +
> > +       if (!(ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE) ||
> > +           !(fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
> > +               return 0;
> > +
> > +       if ((ip->i_d.di_flags & ~XFS_DIFLAG_IMMUTABLE) !=
> > +           (di_flags & ~XFS_DIFLAG_IMMUTABLE))
> > +               return -EPERM;
> > +       if (ip->i_d.di_version >= 3 && ip->i_d.di_flags2 != di_flags2)
> > +               return -EPERM;
> > +       if (xfs_get_projid(ip) != fa->fsx_projid)
> > +               return -EPERM;
> > +       if (ip->i_d.di_extsize != fa->fsx_extsize >> mp->m_sb.sb_blocklog)
> > +               return -EPERM;
> > +       if (ip->i_d.di_version >= 3 && (di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> > +           ip->i_d.di_cowextsize != fa->fsx_cowextsize >> mp->m_sb.sb_blocklog)
> > +               return -EPERM;
> > +
> > +       return 0;
> > +}
> > +
> >  static int
> >  xfs_ioctl_setattr_xflags(
> >         struct xfs_trans        *tp,
> > @@ -1030,7 +1064,9 @@ xfs_ioctl_setattr_xflags(
> >         struct fsxattr          *fa)
> >  {
> >         struct xfs_mount        *mp = ip->i_mount;
> > +       uint16_t                di_flags;
> >         uint64_t                di_flags2;
> > +       int                     error;
> >
> >         /* Can't change realtime flag if any extents are allocated. */
> >         if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
> > @@ -1061,12 +1097,18 @@ xfs_ioctl_setattr_xflags(
> >             !capable(CAP_LINUX_IMMUTABLE))
> >                 return -EPERM;
> >
> > -       /* diflags2 only valid for v3 inodes. */
> > +       /* Don't allow changes to an immutable inode. */
> > +       di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
> >         di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
> > +       error = xfs_ioctl_setattr_immutable(ip, fa, di_flags, di_flags2);
> > +       if (error)
> > +               return error;
> > +
> > +       /* diflags2 only valid for v3 inodes. */
> >         if (di_flags2 && ip->i_d.di_version < 3)
> >                 return -EINVAL;
> >
> > -       ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
> > +       ip->i_d.di_flags = di_flags;
> >         ip->i_d.di_flags2 = di_flags2;
> >
> >         xfs_diflags_to_linux(ip);
