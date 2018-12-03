Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:58694 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725909AbeLCXi6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 18:38:58 -0500
Date: Tue, 4 Dec 2018 10:34:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Message-ID: <20181203233402.GK6311@dastard>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-9-david@fromorbit.com>
 <CAOQ4uxgwZLsO1yV37_CHaZ-O+-+-OggSP9g6m9YE57kLPc5yDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgwZLsO1yV37_CHaZ-O+-+-OggSP9g6m9YE57kLPc5yDw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 03, 2018 at 01:04:07PM +0200, Amir Goldstein wrote:
> On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > before we can enable cross-device copies into copy_file_range(),
> > we have to ensure that ->remap_file_range() implemenations will
> > correctly reject attempts to do cross filesystem clones. Currently
> 
> But you only fixed remap_file_range() implemenations of xfs and ocfs2...
> 
> > these checks are done above calls to ->remap_file_range(), but
> > we need to drive them inwards so that we get EXDEV protection for all
> > callers of ->remap_file_range().
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/read_write.c | 21 +++++++++++++--------
> >  1 file changed, 13 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 3288db1d5f21..174cf92eea1d 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1909,6 +1909,19 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> >         bool same_inode = (inode_in == inode_out);
> >         int ret;
> >
> > +       /*
> > +        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> > +        * the same mount. Practically, they only need to be on the same file
> > +        * system. We check this here rather than at the ioctl layers because
> > +        * this is effectively a limitation of the fielsystem implementations,
> > +        * not so much the API itself. Further, ->remap_file_range() can be
> > +        * called from syscalls that don't have cross device copy restrictions
> > +        * (such as copy_file_range()) and so we need to catch them before we
> > +        * do any damage.
> > +        */
> > +       if (inode_in->i_sb != inode_out->i_sb)
> > +               return -EXDEV;
> > +
> >         /* Don't touch certain kinds of inodes */
> >         if (IS_IMMUTABLE(inode_out))
> >                 return -EPERM;
> > @@ -2013,14 +2026,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
> >         if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> >                 return -EINVAL;
> >
> > -       /*
> > -        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> > -        * the same mount. Practically, they only need to be on the same file
> > -        * system.
> > -        */
> > -       if (inode_in->i_sb != inode_out->i_sb)
> > -               return -EXDEV;
> > -
> 
> That leaves {nfs42,cifs,btrfs}_remap_file_range() exposed to passing
> files not of their own fs type let alone same sb when do_clone_file_range()
> is called from ovl_copy_up_data().

For some reason I thought everyone called
generic_remap_file_range_prep() so they behaved the same way. My
mistake.

Really, though, I'm of the opinion that those filesystems should be
changed to call the generic checks rather than open code their own
incomplete/incompatible set of checks. This is exactly what I'm
trying to avoid with copy_file_range() - checks are done in one
place, all filesystems have the same checks done - so that future
modification and maintenance is so much easier.

We need to do the same thing to the remap_file_range()
implementations.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
