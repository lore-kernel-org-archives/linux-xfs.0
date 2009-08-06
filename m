Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n76Mu47s091678 for <xfs@oss.sgi.com>; Thu, 6 Aug 2009 17:56:04 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE6DAB09283
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2009 16:06:30 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id Tc259BMNqJz4A21P for
	<xfs@oss.sgi.com>; Thu, 06 Aug 2009 16:06:30 -0700 (PDT)
Message-ID: <4A7B5FB5.2030706@sandeen.net>
Date: Thu, 06 Aug 2009 17:56:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] add __destroy_inode
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141836.606829000@bombadil.infradead.org>
In-Reply-To: <20090804141836.606829000@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Christoph Hellwig wrote:

> When we want to tear down an inode that lost the add to the cache race
> in XFS we must not call into ->destroy_inode because that would delete
> the inode that won the race from the inode cache radix tree.
>
> This patch provides the __destroy_inode helper needed to fix this,
> the actual fix will be in th next patch.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
Looks fine to me logically, though having __destroy_inode do everything
-but- ->destroy_inode is a little funky semantically ... maybe
__free_inode?  Not a huge deal.

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c	2009-08-04 16:01:18.766801320 +0200
> +++ linux-2.6/fs/inode.c	2009-08-04 16:01:37.281556243 +0200
> @@ -228,7 +228,7 @@ static struct inode *alloc_inode(struct 
>  	return inode;
>  }
>  
> -void destroy_inode(struct inode *inode)
> +void __destroy_inode(struct inode *inode)
>  {
>  	BUG_ON(inode_has_buffers(inode));
>  	ima_inode_free(inode);
> @@ -240,13 +240,17 @@ void destroy_inode(struct inode *inode)
>  	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
>  		posix_acl_release(inode->i_default_acl);
>  #endif
> +}
> +EXPORT_SYMBOL(__destroy_inode);
> +
> +void destroy_inode(struct inode *inode)
> +{
> +	__destroy_inode(inode);
>  	if (inode->i_sb->s_op->destroy_inode)
>  		inode->i_sb->s_op->destroy_inode(inode);
>  	else
>  		kmem_cache_free(inode_cachep, (inode));
>  }
> -EXPORT_SYMBOL(destroy_inode);
> -
>  
>  /*
>   * These are initializations that only need to be done
> Index: linux-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-04 15:59:38.705782128 +0200
> +++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-04 16:01:20.157556334 +0200
> @@ -322,8 +322,11 @@ static inline struct inode *VFS_I(struct
>   */
>  static inline void xfs_destroy_inode(struct xfs_inode *ip)
>  {
> -	make_bad_inode(VFS_I(ip));
> -	return destroy_inode(VFS_I(ip));
> +	struct inode *inode = VFS_I(ip);
> +
> +	make_bad_inode(inode);
> +	__destroy_inode(inode);
> +	inode->i_sb->s_op->destroy_inode(inode);
>  }
>  
>  /*
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2009-08-04 16:01:18.770804693 +0200
> +++ linux-2.6/include/linux/fs.h	2009-08-04 16:01:20.159539128 +0200
> @@ -2163,6 +2163,7 @@ extern void __iget(struct inode * inode)
>  extern void iget_failed(struct inode *);
>  extern void clear_inode(struct inode *);
>  extern void destroy_inode(struct inode *);
> +extern void __destroy_inode(struct inode *);
>  extern struct inode *new_inode(struct super_block *);
>  extern int should_remove_suid(struct dentry *);
>  extern int file_remove_suid(struct file *);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
