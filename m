Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57098 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbdAHPaK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jan 2017 10:30:10 -0500
Date: Sun, 8 Jan 2017 07:30:08 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: remove racy hasattr check from attr get
Message-ID: <20170108153008.GA10552@infradead.org>
References: <1483731432-55042-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483731432-55042-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 06, 2017 at 02:37:12PM -0500, Brian Foster wrote:
> xfs_attr_get() has an unlocked attribute fork check to optimize away a
> lock cycle in cases where the fork does not exist or is otherwise empty.
> This check is not safe, however, because an attribute fork short form to
> extent format conversion includes a transient state that causes the
> xfs_inode_hasattr() check to fail. Specifically,
> xfs_attr_shortform_to_leaf() creates an empty extent format attribute
> fork and then adds the existing shortform attributes to it.
> 
> This means that lookup of an existing xattr can spuriously return
> -ENOATTR when racing against a setxattr that causes the associated
> format conversion. This was originally reproduced by an untar on a
> particularly configured glusterfs volume, but can also be reproduced on
> demand with properly crafted xattr requests.
> 
> The format conversion occurs under the exclusive ilock. xfs_attr_get()
> already has the proper locking and checks further down in the function
> to handle this situation correctly. Drop the unlocked check to avoid the
> spurious failure and rely on the existing logic.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> This survives a local xfstests run and the original glusterfs
> reproducer. I also have an xfstests reproducer that I will post shortly.
> 
> Brian
> 
>  fs/xfs/libxfs/xfs_attr.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index af1ecb1..8fcbc52 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -131,9 +131,6 @@ xfs_attr_get(
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return -EIO;
>  
> -	if (!xfs_inode_hasattr(ip))
> -		return -ENOATTR;
> -

What about the similar pre-lock check in xfs_attr_remove?
