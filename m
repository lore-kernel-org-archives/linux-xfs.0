Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35594 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389331AbfFJUjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Jun 2019 16:39:54 -0400
MIME-Version: 1.0
References: <20190610173657.4655-1-amir73il@gmail.com>
In-Reply-To: <20190610173657.4655-1-amir73il@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Jun 2019 15:39:42 -0500
Message-ID: <CAH2r5mtQObwvdtaNr31fd-wDpjrZi5YLZ+ZcaW0ECVvTR-ByXQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: copy_file_range needs to strip setuid bits and
 update timestamps
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs <linux-xfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>

Looks good in my testing so far - but also want to do a little more
testing with the copy_file_range xfstest cases because your patches
fixed one additional test (not cross mount copy) so we can understand
why it fixed that test case.

On Mon, Jun 10, 2019 at 12:37 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> cifs has both source and destination inodes locked throughout the copy.
> Like ->write_iter(), we update mtime and strip setuid bits of destination
> file before copy and like ->read_iter(), we update atime of source file
> after copy.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Hi Steve,
>
> Please apply this patch to you cifs branch after merging Darrick's
> copy-file-range-fixes branch from:
>         git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git
>
> Thanks,
> Amir.
>
>  fs/cifs/cifsfs.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f11eea6125c1..83956452c108 100644
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


-- 
Thanks,

Steve
