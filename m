Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37754 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2TfK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 15:35:10 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-13-amir73il@gmail.com>
In-Reply-To: <20190529174318.22424-13-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 22:34:58 +0300
Message-ID: <CAOQ4uxgYM_eM==uqGQuKiGb+f08qs53=E+DONMMzW=N-Ab5YZA@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] nfs: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, "Darrick J . Wong" <darrick.wong@oracle.com>

Hi Olga,Anna,Trond

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
>  fs/nfs/nfs42proc.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
> index 5196bfa7894d..c37a8e5116c6 100644
> --- a/fs/nfs/nfs42proc.c
> +++ b/fs/nfs/nfs42proc.c
> @@ -345,10 +345,13 @@ ssize_t nfs42_proc_copy(struct file *src, loff_t pos_src,
>
>         do {
>                 inode_lock(file_inode(dst));
> -               err = _nfs42_proc_copy(src, src_lock,
> -                               dst, dst_lock,
> -                               &args, &res);
> +               err = file_modified(dst);
> +               if (!err)
> +                       err = _nfs42_proc_copy(src, src_lock,
> +                                              dst, dst_lock,
> +                                              &args, &res);
>                 inode_unlock(file_inode(dst));
> +               file_accessed(src);
>
>                 if (err >= 0)
>                         break;
> --
> 2.17.1
>
