Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46056 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2TiE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 15:38:04 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-12-amir73il@gmail.com>
In-Reply-To: <20190529174318.22424-12-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 22:37:52 +0300
Message-ID: <CAOQ4uxiAa5jCCqkRbq7cn8Mmnb0rX7piMOfy9W4qk7g=7ziJnA@mail.gmail.com>
Subject: Re: [PATCH v3 11/13] fuse: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>

Hi Miklos,

Could we get an ACK on this patch.
It is a prerequisite for merging the cross-device copy_file_range work.

It depends on a new helper introduced here:
https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

Thanks,
Amir,

On Wed, May 29, 2019 at 8:43 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Like ->write_iter(), we update mtime and strip setuid of dst file before
> copy and like ->read_iter(), we update atime of src file after copy.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/fuse/file.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index e03901ae729b..7f33d68f66d9 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3128,6 +3128,10 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
>
>         inode_lock(inode_out);
>
> +       err = file_modified(file_out);
> +       if (err)
> +               goto out;
> +
>         if (fc->writeback_cache) {
>                 err = filemap_write_and_wait_range(inode_out->i_mapping,
>                                                    pos_out, pos_out + len);
> @@ -3169,6 +3173,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
>                 clear_bit(FUSE_I_SIZE_UNSTABLE, &fi_out->state);
>
>         inode_unlock(inode_out);
> +       file_accessed(file_in);
>
>         return err;
>  }
> --
> 2.17.1
>
