Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55402 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbeLCX6r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 18:58:47 -0500
Date: Mon, 3 Dec 2018 15:58:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 08/11] vfs: push EXDEV check down into ->remap_file_range
Message-ID: <20181203235837.GF24487@magnolia>
References: <20181203083416.28978-1-david@fromorbit.com>
 <20181203083416.28978-9-david@fromorbit.com>
 <CAOQ4uxgwZLsO1yV37_CHaZ-O+-+-OggSP9g6m9YE57kLPc5yDw@mail.gmail.com>
 <20181203191130.GD24487@magnolia>
 <20181203233714.GL6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203233714.GL6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Tue, Dec 04, 2018 at 10:37:14AM +1100, Dave Chinner wrote:
> On Mon, Dec 03, 2018 at 11:11:30AM -0800, Darrick J. Wong wrote:
> > On Mon, Dec 03, 2018 at 01:04:07PM +0200, Amir Goldstein wrote:
> > > On Mon, Dec 3, 2018 at 10:34 AM Dave Chinner <david@fromorbit.com> wrote:
> > > >
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > >
> > > > before we can enable cross-device copies into copy_file_range(),
> > > > we have to ensure that ->remap_file_range() implemenations will
> > > > correctly reject attempts to do cross filesystem clones. Currently
> > > 
> > > But you only fixed remap_file_range() implemenations of xfs and ocfs2...
> > > 
> > > > these checks are done above calls to ->remap_file_range(), but
> > > > we need to drive them inwards so that we get EXDEV protection for all
> > > > callers of ->remap_file_range().
> > > >
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/read_write.c | 21 +++++++++++++--------
> > > >  1 file changed, 13 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/fs/read_write.c b/fs/read_write.c
> > > > index 3288db1d5f21..174cf92eea1d 100644
> > > > --- a/fs/read_write.c
> > > > +++ b/fs/read_write.c
> > > > @@ -1909,6 +1909,19 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
> > > >         bool same_inode = (inode_in == inode_out);
> > > >         int ret;
> > > >
> > > > +       /*
> > > > +        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> > > > +        * the same mount. Practically, they only need to be on the same file
> > > > +        * system. We check this here rather than at the ioctl layers because
> > > > +        * this is effectively a limitation of the fielsystem implementations,
> > > > +        * not so much the API itself. Further, ->remap_file_range() can be
> > > > +        * called from syscalls that don't have cross device copy restrictions
> > > > +        * (such as copy_file_range()) and so we need to catch them before we
> > > > +        * do any damage.
> > > > +        */
> > > > +       if (inode_in->i_sb != inode_out->i_sb)
> > > > +               return -EXDEV;
> > > > +
> > > >         /* Don't touch certain kinds of inodes */
> > > >         if (IS_IMMUTABLE(inode_out))
> > > >                 return -EPERM;
> > > > @@ -2013,14 +2026,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
> > > >         if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> > > >                 return -EINVAL;
> > > >
> > > > -       /*
> > > > -        * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
> > > > -        * the same mount. Practically, they only need to be on the same file
> > > > -        * system.
> > > > -        */
> > > > -       if (inode_in->i_sb != inode_out->i_sb)
> > > > -               return -EXDEV;
> > > > -
> > > 
> > 
> > I think this is sort of backwards -- the checks should stay in
> > do_clone_file_range, and vfs_copy_file_range should be calling that
> > instead of directly calling ->remap_range():
> > 
> > vfs_copy_file_range()
> > {
> > 	file_start_write(...);
> > 	ret = do_clone_file_range(...);
> > 	if (ret > 0)
> > 		return ret;
> > 	ret = do_copy_file_range(...);
> > 	file_end_write(...);
> > 	return ret;
> > }
> 
> I'm already confused by the way we weave in and out of "vfs_/do_*"
> functions, and this just makes it worse.
> 
> Just what the hell is supposed to be in a "vfs_" prefixed function,
> and why the hell is it considered a "vfs" level function if we then
> export it's internal functions for individual filesystems to use?

I /think/ vfs_ functions are file_start_write()/file_end_write()
wrappers around a similarly named function that lacks the freeze
protection??

(AFAICT Amir made that split so that overlayfs could use these
functions, though I do not know if everything vfs_ was made that way
/specifically/ for overlayfs or if that's the way things have been and
ovlfs simply takes advantage of it...)

Guhhh, none of this is documented......

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
