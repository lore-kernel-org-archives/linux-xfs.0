Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vs1-f66.google.com ([209.85.217.66]:45409 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbeLCVdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Dec 2018 16:33:44 -0500
MIME-Version: 1.0
References: <20181203083416.28978-1-david@fromorbit.com> <20181203083416.28978-5-david@fromorbit.com>
In-Reply-To: <20181203083416.28978-5-david@fromorbit.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Date: Mon, 3 Dec 2018 16:33:30 -0500
Message-ID: <CAN-5tyH2RX_7SkvipnKkM2EF6_cHJ9qG6g9W+Ufb9+5r-Zb4hg@mail.gmail.com>
Subject: Re: [PATCH 04/11] vfs: add missing checks to copy_file_range
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-nfs <linux-nfs@vger.kernel.org>, linux-unionfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org

On Mon, Dec 3, 2018 at 3:34 AM Dave Chinner <david@fromorbit.com> wrote:
>
> From: Dave Chinner <dchinner@redhat.com>
>
> Like the clone and dedupe interfaces we've recently fixed, the
> copy_file_range() implementation is missing basic sanity, limits and
> boundary condition tests on the parameters that are passed to it
> from userspace. Create a new "generic_copy_file_checks()" function
> modelled on the generic_remap_checks() function to provide this
> missing functionality.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/read_write.c    | 27 ++++++------------
>  include/linux/fs.h |  3 ++
>  mm/filemap.c       | 69 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 81 insertions(+), 18 deletions(-)
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 44339b44accc..69809345977e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1578,7 +1578,7 @@ static ssize_t do_copy_file_range(struct file *file=
_in, loff_t pos_in,
>                 return file_out->f_op->copy_file_range(file_in, pos_in, f=
ile_out,
>                                                       pos_out, len, flags=
);
>
> -       return generic_copy_file_range(file_in, &pos_in, file_out, &pos_o=
ut,
> +       return generic_copy_file_range(file_in, pos_in, file_out, pos_out=
,
>                                         len, flags);
>  }
>
> @@ -1598,10 +1598,14 @@ ssize_t vfs_copy_file_range(struct file *file_in,=
 loff_t pos_in,
>         if (flags !=3D 0)
>                 return -EINVAL;
>
> -       if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> -               return -EISDIR;
> -       if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> -               return -EINVAL;
> +       /* this could be relaxed once a method supports cross-fs copies *=
/
> +       if (inode_in->i_sb !=3D inode_out->i_sb)
> +               return -EXDEV;
> +
> +       ret =3D generic_copy_file_checks(file_in, pos_in, file_out, pos_o=
ut, &len,
> +                                       flags);
> +       if (ret < 0)
> +               return ret;
>
>         ret =3D rw_verify_area(READ, file_in, &pos_in, len);
>         if (unlikely(ret))
> @@ -1611,22 +1615,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, =
loff_t pos_in,
>         if (unlikely(ret))
>                 return ret;
>
> -       if (!(file_in->f_mode & FMODE_READ) ||
> -           !(file_out->f_mode & FMODE_WRITE) ||
> -           (file_out->f_flags & O_APPEND))
> -               return -EBADF;
> -
> -       /* this could be relaxed once a method supports cross-fs copies *=
/
> -       if (inode_in->i_sb !=3D inode_out->i_sb)
> -               return -EXDEV;
> -
>         if (len =3D=3D 0)
>                 return 0;
>
> -       /* If the source range crosses EOF, fail the copy */
> -       if (pos_in >=3D i_size(inode_in) || pos_in + len > i_size(inode_i=
n))
> -               return -EINVAL;
> -
>         file_start_write(file_out);
>
>         /*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a4478764cf63..0d9d2d93d4df 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3022,6 +3022,9 @@ extern ssize_t generic_write_checks(struct kiocb *,=
 struct iov_iter *);
>  extern int generic_remap_checks(struct file *file_in, loff_t pos_in,
>                                 struct file *file_out, loff_t pos_out,
>                                 loff_t *count, unsigned int remap_flags);
> +extern int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +                               struct file *file_out, loff_t pos_out,
> +                               size_t *count, unsigned int flags);
>  extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *)=
;
>  extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter=
 *);
>  extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *=
);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 81adec8ee02c..0a170425935b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2975,6 +2975,75 @@ int generic_remap_checks(struct file *file_in, lof=
f_t pos_in,
>         return 0;
>  }
>
> +
> +/*
> + * Performs necessary checks before doing a file copy
> + *
> + * Can adjust amount of bytes to copy
> + * Returns appropriate error code that caller should return or
> + * zero in case the copy should be allowed.
> + */
> +int generic_copy_file_checks(struct file *file_in, loff_t pos_in,
> +                        struct file *file_out, loff_t pos_out,
> +                        size_t *req_count, unsigned int flags)
> +{
> +       struct inode *inode_in =3D file_inode(file_in);
> +       struct inode *inode_out =3D file_inode(file_out);
> +       uint64_t count =3D *req_count;
> +       uint64_t bcount;
> +       loff_t size_in, size_out;
> +       loff_t bs =3D inode_out->i_sb->s_blocksize;
> +       int ret;

I got compile warnings:

mm/filemap.c: In function =E2=80=98generic_copy_file_checks=E2=80=99:
mm/filemap.c:2995:9: warning: unused variable =E2=80=98bs=E2=80=99 [-Wunuse=
d-variable]
  loff_t bs =3D inode_out->i_sb->s_blocksize;
         ^
mm/filemap.c:2993:11: warning: unused variable =E2=80=98bcount=E2=80=99 [-W=
unused-variable]
  uint64_t bcount;

> +
> +       /* Don't touch certain kinds of inodes */
> +       if (IS_IMMUTABLE(inode_out))
> +               return -EPERM;
> +
> +       if (IS_SWAPFILE(inode_in) || IS_SWAPFILE(inode_out))
> +               return -ETXTBSY;
> +
> +       /* Don't copy dirs, pipes, sockets... */
> +       if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
> +               return -EISDIR;
> +       if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
> +               return -EINVAL;
> +
> +       if (!(file_in->f_mode & FMODE_READ) ||
> +           !(file_out->f_mode & FMODE_WRITE) ||
> +           (file_out->f_flags & O_APPEND))
> +               return -EBADF;
> +
> +       /* Ensure offsets don't wrap. */
> +       if (pos_in + count < pos_in || pos_out + count < pos_out)
> +               return -EOVERFLOW;
> +
> +       size_in =3D i_size_read(inode_in);
> +       size_out =3D i_size_read(inode_out);
> +
> +       /* If the source range crosses EOF, fail the copy */
> +       if (pos_in >=3D size_in)
> +               return -EINVAL;
> +       if (pos_in + count > size_in)
> +               return -EINVAL;
> +
> +       ret =3D generic_access_check_limits(file_in, pos_in, &count);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D generic_write_check_limits(file_out, pos_out, &count);
> +       if (ret)
> +               return ret;
> +
> +       /* Don't allow overlapped copying within the same file. */
> +       if (inode_in =3D=3D inode_out &&
> +           pos_out + count > pos_in &&
> +           pos_out < pos_in + count)
> +               return -EINVAL;
> +
> +       *req_count =3D count;
> +       return 0;
> +}
> +
>  int pagecache_write_begin(struct file *file, struct address_space *mappi=
ng,
>                                 loff_t pos, unsigned len, unsigned flags,
>                                 struct page **pagep, void **fsdata)
> --
> 2.19.1
>
