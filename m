Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 14 Sep 2008 06:30:04 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8EDTwox003040
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:29:59 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24B91126E8AC
	for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:31:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id pkMyMHaQVLNd8wqa for <xfs@oss.sgi.com>; Sun, 14 Sep 2008 06:31:29 -0700 (PDT)
Date: Sun, 14 Sep 2008 09:31:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] XFS: Combine the XFS and Linux inodes V2
Message-ID: <20080914133128.GE14266@infradead.org>
References: <1221315027-29951-1-git-send-email-david@fromorbit.com> <1221315027-29951-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221315027-29951-4-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org

On Sun, Sep 14, 2008 at 12:10:27AM +1000, Dave Chinner wrote:
> + * we need to provide an empty inode free function to prevent
> + * the generic code from trying to free ouuur combined inode.

					    ^^^^ spelling?

> -
> -STATIC void
> -xfs_fs_inode_init_once(
> -	void			*vnode)
> +	struct inode	*inode)
>  {
> -	inode_init_once((struct inode *)vnode);
> +	return;
>  }

No need for a no-argument return at the end of the function.

>  static inline int xfs_icount(struct xfs_inode *ip)
>  {
> -	struct inode *inode = VFS_I(ip);
> -
> -	if (!inode)
> -		return atomic_read(&inode->i_count);
> -	return -1;
> +	return atomic_read(&VFS_I(ip)->i_count);
>  }

At this point we can just kill this helper - there's only one caller
anyway.

> -	if (xfs_iflush(ip, sync_mode) == 0) {
> +	if (!VN_BAD(VFS_I(ip)) && xfs_iflush(ip, sync_mode) == 0) {

Why don't you switch to is_bad_inode directly instead of fixing this
up in a later patch?
