Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:34526 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbeLCT1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 14:27:52 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-10-david@fromorbit.com>
 <679f1cda1b43fc4cfcd6cdf6dbac223b42db24c2.camel@gmail.com>
In-Reply-To: <679f1cda1b43fc4cfcd6cdf6dbac223b42db24c2.camel@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 3 Dec 2018 14:27:32 -0500
Message-ID: <CAN-5tyFdVs8a_+Qz-9LC+irqE3kNyAQuucD0p33GD6aTFJPVKA@mail.gmail.com>
Subject: Re: [PATCH 09/11] vfs: push copy_file_ranges -EXDEV checks down
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Anna Schumaker <schumaker.anna@gmail.com>
Cc: david@fromorbit.com, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 1:53 PM Anna Schumaker <schumaker.anna@gmail.com> wrote:
>
> On Mon, 2018-12-03 at 19:34 +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> >
> > We want to enable cross-filesystem copy_file_range functionality
> > where possible, so push the "same superblock only" checks down to
> > the individual filesystem callouts so they can make their own
> > decisions about cross-superblock copy offload.
> >
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/ceph/file.c      |  4 +++-
> >  fs/cifs/cifsfs.c    |  8 +++++++-
> >  fs/fuse/file.c      |  5 ++++-
> >  fs/nfs/nfs4file.c   | 16 ++++++++++------
> >  fs/overlayfs/file.c | 10 +++++++++-
> >  fs/read_write.c     | 10 ++++------
> >  6 files changed, 37 insertions(+), 16 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index cf29f0410dcb..eb876e19c1dc 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1905,6 +1905,8 @@ static ssize_t __ceph_copy_file_range(struct file
> > *src_file, loff_t src_off,
> >
> >       if (src_inode == dst_inode)
> >               return -EINVAL;
> > +     if (src_inode->i_sb != dst_inode->i_sb)
> > +             return -EXDEV;
> >       if (ceph_snap(dst_inode) != CEPH_NOSNAP)
> >               return -EROFS;
> >
> > @@ -2105,7 +2107,7 @@ static ssize_t ceph_copy_file_range(struct file
> > *src_file, loff_t src_off,
> >       ret = __ceph_copy_file_range(src_file, src_off, dst_file, dst_off,
> >                                       len, flags);
> >
> > -     if (ret == -EOPNOTSUPP)
> > +     if (ret == -EOPNOTSUPP || ret == -EXDEV)
> >               ret = generic_copy_file_range(src_file, src_off, dst_file,
> >                                       dst_off, len, flags);
> >       return ret;
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 5ef4baec6234..03e4b9eacbd1 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -1072,6 +1072,12 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
> >               goto out;
> >       }
> >
> > +     if (src_inode->i_sb != target_inode->i_sb) {
> > +             rc = -EXDEV;
> > +             goto out;
> > +     }
> > +
> > +
> >       if (!src_file->private_data || !dst_file->private_data) {
> >               rc = -EBADF;
> >               cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
> > @@ -1142,7 +1148,7 @@ static ssize_t cifs_copy_file_range(struct file
> > *src_file, loff_t off,
> >                                       len, flags);
> >       free_xid(xid);
> >
> > -     if (rc == -EOPNOTSUPP)
> > +     if (rc == -EOPNOTSUPP || rc == -EXDEV)
> >               rc = generic_copy_file_range(src_file, off, dst_file,
> >                                       destoff, len, flags);
> >       return rc;
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index b86fb0298739..0758f831a4eb 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -3053,6 +3053,9 @@ static ssize_t __fuse_copy_file_range(struct file
> > *file_in, loff_t pos_in,
> >       if (fc->no_copy_file_range)
> >               return -EOPNOTSUPP;
> >
> > +     if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> > +             return -EXDEV;
> > +
> >       inode_lock(inode_out);
> >
> >       if (fc->writeback_cache) {
> > @@ -3109,7 +3112,7 @@ static ssize_t fuse_copy_file_range(struct file
> > *src_file, loff_t src_off,
> >       ret = __fuse_copy_file_range(src_file, src_off, dst_file, dst_off,
> >                                       len, flags);
> >
> > -     if (ret == -EOPNOTSUPP)
> > +     if (ret == -EOPNOTSUPP || ret == -EXDEV)
> >               ret = generic_copy_file_range(src_file, src_off, dst_file,
> >                                       dst_off, len, flags);
> >       return ret;
> > diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> > index d7766a6eb0f4..4783c0c1c49e 100644
> > --- a/fs/nfs/nfs4file.c
> > +++ b/fs/nfs/nfs4file.c
> > @@ -133,16 +133,20 @@ static ssize_t nfs4_copy_file_range(struct file
> > *file_in, loff_t pos_in,
> >                                   struct file *file_out, loff_t pos_out,
> >                                   size_t count, unsigned int flags)
> >  {
> > -     ssize_t ret;
> > +     ssize_t ret = -EXDEV;
> >
> >       if (file_inode(file_in) == file_inode(file_out))
> >               return -EINVAL;
> > -retry:
> > -     ret = nfs42_proc_copy(file_in, pos_in, file_out, pos_out, count);
> > -     if (ret == -EAGAIN)
> > -             goto retry;
> >
> > -     if (ret == -EOPNOTSUPP)
> > +     /* only offload copy if superblock is the same */
> > +     if (file_inode(file_in)->i_sb == file_inode(file_out)->i_sb) {
> > +             do {
> > +                     ret = nfs42_proc_copy(file_in, pos_in, file_out,
> > +                                     pos_out, count);
> > +             } while (ret == -EAGAIN);
>
> I'm not convinced we can actually return -EAGAIN from nfs42_proc_copy().  The
> nfs_get_lock_context() function doesn't return it, and if _nfs42_proc_copy()
> returns -EAGAIN it's immediately retried by nfs42_proc_copy() instead of
> returning.
>
> Olga, am I missing something here?

I'll update it in the client patches that are coming out.

> Anna
>
> > +     }
> > +
> > +     if (ret == -EOPNOTSUPP || ret == -EXDEV)
> >               ret = generic_copy_file_range(file_in, pos_in, file_out,
> >                                       pos_out, count, flags);
> >       return ret;
> > diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> > index 68736e5d6a56..34fb0398d016 100644
> > --- a/fs/overlayfs/file.c
> > +++ b/fs/overlayfs/file.c
> > @@ -443,6 +443,14 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t
> > pos_in,
> >       const struct cred *old_cred;
> >       loff_t ret;
> >
> > +     /*
> > +      * Temporary. Cross device copy checks should be left to the copy file
> > +      * call on the real inodes, but existing behaviour checks the upper
> > +      * files only.
> > +      */
> > +     if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> > +             return -EXDEV;
> > +
> >       ret = ovl_real_fdget(file_out, &real_out);
> >       if (ret)
> >               return ret;
> > @@ -491,7 +499,7 @@ static ssize_t ovl_copy_file_range(struct file *file_in,
> > loff_t pos_in,
> >       ret =  ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
> >                           OVL_COPY);
> >
> > -     if (ret == -EOPNOTSUPP)
> > +     if (ret == -EOPNOTSUPP || ret == -EXDEV)
> >               ret = generic_copy_file_range(file_in, pos_in, file_out,
> >                                       pos_out, len, flags);
> >       return ret;
> > diff --git a/fs/read_write.c b/fs/read_write.c
> > index 174cf92eea1d..4e0666de0d69 100644
> > --- a/fs/read_write.c
> > +++ b/fs/read_write.c
> > @@ -1565,6 +1565,10 @@ ssize_t generic_copy_file_range(struct file *file_in,
> > loff_t pos_in,
> >                           struct file *file_out, loff_t pos_out,
> >                           size_t len, unsigned int flags)
> >  {
> > +     /* Temporary, do_splice_direct supports cross-sb copies */
> > +     if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> > +             return -EXDEV;
> > +
> >       return do_splice_direct(file_in, &pos_in, file_out, &pos_out,
> >                       len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
> >  }
> > @@ -1611,17 +1615,11 @@ ssize_t vfs_copy_file_range(struct file *file_in,
> > loff_t pos_in,
> >                           struct file *file_out, loff_t pos_out,
> >                           size_t len, unsigned int flags)
> >  {
> > -     struct inode *inode_in = file_inode(file_in);
> > -     struct inode *inode_out = file_inode(file_out);
> >       ssize_t ret;
> >
> >       if (flags != 0)
> >               return -EINVAL;
> >
> > -     /* this could be relaxed once a method supports cross-fs copies */
> > -     if (inode_in->i_sb != inode_out->i_sb)
> > -             return -EXDEV;
> > -
> >       ret = generic_copy_file_checks(file_in, pos_in, file_out, pos_out, &len,
> >                                       flags);
> >       if (ret < 0)
>
