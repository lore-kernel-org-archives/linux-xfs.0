Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35035 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034290AbcIZSMQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Sep 2016 14:12:16 -0400
MIME-Version: 1.0
In-Reply-To: <20160926163313.GP9314@birch.djwong.org>
References: <1473856994-27463-1-git-send-email-amir73il@gmail.com>
 <1473856994-27463-4-git-send-email-amir73il@gmail.com> <CAOQ4uxiZBE_2qy86b6x19opLcGbMzhtqrWBkFZqHeQnZgHtJfQ@mail.gmail.com>
 <20160923161350.GN9314@birch.djwong.org> <CAOQ4uxidPrUho=BTjzEjKqDXXwX605bDSfpXoVUh=YXU0=EHCg@mail.gmail.com>
 <20160926163313.GP9314@birch.djwong.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 26 Sep 2016 21:12:13 +0300
Message-ID: <CAOQ4uxhJ16BpJUQjNLY_m2Fjr1=jiKGfn3vfR=rPxP-GwmB-dg@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] vfs: allow vfs_copy_file_range() across file systems
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Sep 26, 2016 at 7:33 PM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
> On Fri, Sep 23, 2016 at 09:52:42PM +0300, Amir Goldstein wrote:
>> On Fri, Sep 23, 2016 at 7:13 PM, Darrick J. Wong
>> <darrick.wong@oracle.com> wrote:
>> > On Fri, Sep 23, 2016 at 10:57:56AM +0300, Amir Goldstein wrote:
>> >> On Wed, Sep 14, 2016 at 3:43 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> >> > copy_file_range syscall returns -EXDEV if src and dest
>> >> > file are not on the same file system.
>> >> > The vfs_copy_file_range() helper, however, knows how to copy
>> >> > across file systems with do_splice_direct().
>> >> >
>> >> > Move the enforcement of same file system from the vfs helper
>> >> > to the syscall code.
>> >> >
>> >> > A following patch is going to use the vfs_copy_file_range()
>> >> > helper in overlayfs to copy up between lower and upper
>> >> > not on the same file system.
>> >> >
>> >> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> >> > ---
>> >> >  fs/read_write.c | 16 +++++++++++-----
>> >> >  1 file changed, 11 insertions(+), 5 deletions(-)
>> >> >
>> >> > diff --git a/fs/read_write.c b/fs/read_write.c
>> >> > index 9dc6e52..6975fe8 100644
>> >> > --- a/fs/read_write.c
>> >> > +++ b/fs/read_write.c
>> >> > @@ -1502,10 +1502,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>> >> >             (file_out->f_flags & O_APPEND))
>> >> >                 return -EBADF;
>> >> >
>> >> > -       /* this could be relaxed once a method supports cross-fs copies */
>> >> > -       if (inode_in->i_sb != inode_out->i_sb)
>> >> > -               return -EXDEV;
>> >> > -
>> >> >         if (len == 0)
>> >> >                 return 0;
>> >> >
>> >> > @@ -1514,7 +1510,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>> >> >                 return ret;
>> >> >
>> >> >         ret = -EOPNOTSUPP;
>> >> > -       if (file_out->f_op->copy_file_range)
>> >> > +       /* copy_file_range() method does not support cross-fs copies */
>> >> > +       if (inode_in->i_sb == inode_out->i_sb &&
>> >> > +           file_out->f_op->copy_file_range)
>> >> >                 ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>> >> >                                                       pos_out, len, flags);
>> >> >         if (ret == -EOPNOTSUPP)
>> >> > @@ -1569,6 +1567,14 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
>> >> >                 pos_out = f_out.file->f_pos;
>> >> >         }
>> >> >
>> >> > +       /*
>> >> > +        * vfs_copy_file_range() can do cross-fs copy, but we want to
>> >> > +        * fulfill the guaranty to userland that copy_file_range syscall
>> >> > +        * does not allow cross-fs copy
>> >> > +        */
>> >> > +       if (file_inode(f_in.file)->i_sb != file_inode(f_out.file)->i_sb)
>> >> > +               return -EXDEV;
>> >>
>> >> Oops, that was supposed to be goto out;
>> >> Anyway, I am holding back on the vfs_copy_file_range() patches sub set
>> >> until I have a reliable test on xfs to fall back from clone to copy range
>> >
>> > Ok, attached are two rough patches -- one to add the error injection point
>> > into the kernel, and a second one to add it to the xfs_io 'inject' command.
>> > Note that you'll have to format the XFS filesystem with rmapbt=1 since we
>> > can't otherwise avoid per-AG ENOSPC if rmap is enabled.
>> >
>> > The relevant xfstests commands are:
>> >
>> > _require_xfs_io_error_injection "ag_resv_critical"
>> > _scratch_inject_error "ag_resv_critical"
>> >
>> > See the xfs/325 test for a rough framework.  I'll work on cleaning up the
>> > patches and trying to get them into 4.9.
>> >
>>
>> Thanks, Darrick, but I'm not sure that's enough. does the framework allow
>> to inject an error for a specific AG? otherwise, the code will not
>> fall back from
>> failing full reflink to partial copy partial reflink.
>
> The error injector (as far as I know) cannot inject errors only for a
> specific AG.  However, since your goal is to have the reflink partially
> succeed, I could set up the injector to fail only a fraction of the
> time.  The difficulty here is that what we /probably/ need is to have it
> ENOSPC after N extents, where 0 < N <= nr_file_extents.  Tricky since
> the probabilistic nature means that it could inject during the first
> XFS_TEST_ERROR call.
>
> Or change the function such that the error injector function only gets
> called if the file offset > 0.  Then you can prepare a specially crafted
> file such that you'll always get at least a partial reflink before
> ENOSPC.  Note that the reflink functions won't return where an error
> happened, so you'll end up recopying the entire range regardless.
>

All right. How about the realtime AG. Does it support reflink?
Can a file have extents both in realtime AG and other AGs?
