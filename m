Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:46277 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2Tnh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 15:43:37 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-10-amir73il@gmail.com>
In-Reply-To: <20190529174318.22424-10-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 22:43:25 +0300
Message-ID: <CAOQ4uxiGqiFuz+H8YQgU_2JnVWve+NVcY4Gxi_+ym-Gq6G9xAQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] ceph: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>

Hi Zheng and Ilya,

Could we help us get an ACK on this patch.
It is a prerequisite for merging the cross-device copy_file_range work.

It depends on a new helper introduced here:
https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

Luis Henriques has tested (the previous revision of) this work on ceph.

Thanks,
Amir,

On Wed, May 29, 2019 at 8:43 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Because ceph doesn't hold destination inode lock throughout the copy,
> strip setuid bits before and after copy.
>
> The destination inode mtime is updated before and after the copy and the
> source inode atime is updated after the copy, similar to the filesystem
> ->read_iter() implementation.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/ceph/file.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index e87f7b2023af..8a70708e1aca 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1947,6 +1947,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>                 goto out;
>         }
>
> +       /* Should dst_inode lock be held throughout the copy operation? */
> +       inode_lock(dst_inode);
> +       ret = file_modified(dst_file);
> +       inode_unlock(dst_inode);
> +       if (ret < 0) {
> +               dout("failed to modify dst file before copy (%zd)\n", ret);
> +               goto out;
> +       }
> +
>         /*
>          * We need FILE_WR caps for dst_ci and FILE_RD for src_ci as other
>          * clients may have dirty data in their caches.  And OSDs know nothing
> @@ -2097,6 +2106,14 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>  out:
>         ceph_free_cap_flush(prealloc_cf);
>
> +       file_accessed(src_file);
> +       /* To be on the safe side, remove privs also after copy */
> +       inode_lock(dst_inode);
> +       err = file_modified(dst_file);
> +       inode_unlock(dst_inode);
> +       if (err < 0)
> +               dout("failed to modify dst file after copy (%zd)\n", err);
> +
>         return ret;
>  }
>
> --
> 2.17.1
>
