Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E9C037CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:42:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AA659304039
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:42:38 -0700 (PDT)
Received: from mail-oi0-f67.google.com (mail-oi0-f67.google.com
	[209.85.218.67]) by cuda.sgi.com with ESMTP id 734Y8YRnJAd2AVi4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 May 2016 09:42:35 -0700 (PDT)
Received: by mail-oi0-f67.google.com with SMTP id h125so5471423oib.2
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:42:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464279600-13009-4-git-send-email-jack@suse.cz>
References: <1464279600-13009-1-git-send-email-jack@suse.cz>
	<1464279600-13009-4-git-send-email-jack@suse.cz>
Date: Thu, 26 May 2016 18:42:34 +0200
Message-ID: <CAJfpegtz3y18zaqskyrvZ=JKQ+dFfBn-ktLgocVmvmAf8cWx5w@mail.gmail.com>
Subject: Re: [PATCH 3/5] fuse: Propagate dentry down to inode_change_ok()
From: Miklos Szeredi <miklos@szeredi.hu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

On Thu, May 26, 2016 at 6:19 PM, Jan Kara <jack@suse.cz> wrote:
> To avoid clearing of capabilities or security related extended
> attributes too early, inode_change_ok() will need to take dentry instead
> of inode. Propagate it down to fuse_do_setattr().
>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

> ---
>  fs/fuse/dir.c    | 7 ++++---
>  fs/fuse/file.c   | 2 +-
>  fs/fuse/fuse_i.h | 2 +-
>  3 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index b9419058108f..4a613d1e9e75 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -1586,9 +1586,10 @@ int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
>   * vmtruncate() doesn't allow for this case, so do the rlimit checking
>   * and the actual truncation by hand.
>   */
> -int fuse_do_setattr(struct inode *inode, struct iattr *attr,
> +int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
>                     struct file *file)
>  {
> +       struct inode *inode = d_inode(dentry);
>         struct fuse_conn *fc = get_fuse_conn(inode);
>         struct fuse_inode *fi = get_fuse_inode(inode);
>         FUSE_ARGS(args);
> @@ -1702,9 +1703,9 @@ static int fuse_setattr(struct dentry *entry, struct iattr *attr)
>                 return -EACCES;
>
>         if (attr->ia_valid & ATTR_FILE)
> -               return fuse_do_setattr(inode, attr, attr->ia_file);
> +               return fuse_do_setattr(entry, attr, attr->ia_file);
>         else
> -               return fuse_do_setattr(inode, attr, NULL);
> +               return fuse_do_setattr(entry, attr, NULL);
>  }
>
>  static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 9154f8679024..46d65f1a79d2 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -2828,7 +2828,7 @@ static void fuse_do_truncate(struct file *file)
>         attr.ia_file = file;
>         attr.ia_valid |= ATTR_FILE;
>
> -       fuse_do_setattr(inode, &attr, file);
> +       fuse_do_setattr(file_dentry(file), &attr, file);
>  }
>
>  static inline loff_t fuse_round_up(loff_t off)
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index eddbe02c4028..59a26446762b 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -951,7 +951,7 @@ bool fuse_write_update_size(struct inode *inode, loff_t pos);
>  int fuse_flush_times(struct inode *inode, struct fuse_file *ff);
>  int fuse_write_inode(struct inode *inode, struct writeback_control *wbc);
>
> -int fuse_do_setattr(struct inode *inode, struct iattr *attr,
> +int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
>                     struct file *file);
>
>  void fuse_set_initialized(struct fuse_conn *fc);
> --
> 2.6.6
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
