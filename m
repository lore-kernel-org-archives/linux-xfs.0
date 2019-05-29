Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yb1-f193.google.com ([209.85.219.193]:37792 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfE2Tg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 May 2019 15:36:29 -0400
MIME-Version: 1.0
References: <20190529174318.22424-1-amir73il@gmail.com> <20190529174318.22424-11-amir73il@gmail.com>
In-Reply-To: <20190529174318.22424-11-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 29 May 2019 22:36:16 +0300
Message-ID: <CAOQ4uxiTtZTycTMdvcdJ5nR6YNOjRgQ51pKnXC6M-dO+eNMHRA@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] cifs: copy_file_range needs to strip setuid bits
 and update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Steve French <smfrench@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Olga Kornievskaia <olga.kornievskaia@gmail.com>, Luis Henriques <lhenriques@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

Hi Steve,

Could we get an ACK on this patch.
It is a prerequisite for merging the cross-device copy_file_range work.

It depends on a new helper introduced here:
https://lore.kernel.org/linux-fsdevel/CAOQ4uxjbcSWX1hUcuXbn8hFH3QYB+5bAC9Z1yCwJdR=T-GGtCg@mail.gmail.com/T/#m1569878c41f39fac3aadb3832a30659c323b582a

Thanks,
Amir,

On Wed, May 29, 2019 at 8:43 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> cifs has both source and destination inodes locked throughout the copy.
> Like ->write_iter(), we update mtime and strip setuid bits of destination
> file before copy and like ->read_iter(), we update atime of source file
> after copy.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/cifs/cifsfs.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index c65823270313..ab6c5c24146d 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1096,6 +1096,10 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
>                 goto out;
>         }
>
> +       rc = -EOPNOTSUPP;
> +       if (!target_tcon->ses->server->ops->copychunk_range)
> +               goto out;
> +
>         /*
>          * Note: cifs case is easier than btrfs since server responsible for
>          * checks for proper open modes and file type and if it wants
> @@ -1107,11 +1111,12 @@ ssize_t cifs_file_copychunk_range(unsigned int xid,
>         /* should we flush first and last page first */
>         truncate_inode_pages(&target_inode->i_data, 0);
>
> -       if (target_tcon->ses->server->ops->copychunk_range)
> +       rc = file_modified(dst_file);
> +       if (!rc)
>                 rc = target_tcon->ses->server->ops->copychunk_range(xid,
>                         smb_file_src, smb_file_target, off, len, destoff);
> -       else
> -               rc = -EOPNOTSUPP;
> +
> +       file_accessed(src_file);
>
>         /* force revalidate of size and timestamps of target file now
>          * that target is updated on the server
> --
> 2.17.1
>
