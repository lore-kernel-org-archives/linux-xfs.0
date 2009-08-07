Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n77IJZaA147045 for <xfs@oss.sgi.com>; Fri, 7 Aug 2009 13:19:40 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D58018F809C
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2009 11:20:21 -0700 (PDT)
Message-Id: <096BC561-F806-4451-A63B-B296988B4FA5@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090804141836.606829000@bombadil.infradead.org>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 3/4] add __destroy_inode
Date: Fri, 7 Aug 2009 13:20:21 -0500
References: <20090804141554.992235000@bombadil.infradead.org>
	<20090804141836.606829000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com


On Aug 4, 2009, at 9:15 AM, Christoph Hellwig wrote:

> When we want to tear down an inode that lost the add to the cache race
> in XFS we must not call into ->destroy_inode because that would delete
> the inode that won the race from the inode cache radix tree.
>
> This patch provides the __destroy_inode helper needed to fix this,
> the actual fix will be in th next patch.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
>
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c	2009-08-04 16:01:18.766801320 +0200
> +++ linux-2.6/fs/inode.c	2009-08-04 16:01:37.281556243 +0200
> @@ -228,7 +228,7 @@ static struct inode *alloc_inode(struct
> 	return inode;
> }
>
> -void destroy_inode(struct inode *inode)
> +void __destroy_inode(struct inode *inode)
> {
> 	BUG_ON(inode_has_buffers(inode));
> 	ima_inode_free(inode);
> @@ -240,13 +240,17 @@ void destroy_inode(struct inode *inode)
> 	if (inode->i_default_acl && inode->i_default_acl != ACL_NOT_CACHED)
> 		posix_acl_release(inode->i_default_acl);
> #endif
> +}
> +EXPORT_SYMBOL(__destroy_inode);
> +
> +void destroy_inode(struct inode *inode)
> +{
> +	__destroy_inode(inode);
> 	if (inode->i_sb->s_op->destroy_inode)
> 		inode->i_sb->s_op->destroy_inode(inode);
> 	else
> 		kmem_cache_free(inode_cachep, (inode));
> }
> -EXPORT_SYMBOL(destroy_inode);
> -
>
> /*
>  * These are initializations that only need to be done
> Index: linux-2.6/fs/xfs/xfs_inode.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_inode.h	2009-08-04 15:59:38.705782128  
> +0200
> +++ linux-2.6/fs/xfs/xfs_inode.h	2009-08-04 16:01:20.157556334 +0200
> @@ -322,8 +322,11 @@ static inline struct inode *VFS_I(struct
>  */
> static inline void xfs_destroy_inode(struct xfs_inode *ip)
> {
> -	make_bad_inode(VFS_I(ip));
> -	return destroy_inode(VFS_I(ip));
> +	struct inode *inode = VFS_I(ip);
> +
> +	make_bad_inode(inode);
> +	__destroy_inode(inode);
> +	inode->i_sb->s_op->destroy_inode(inode);
> }
>
> /*
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2009-08-04 16:01:18.770804693  
> +0200
> +++ linux-2.6/include/linux/fs.h	2009-08-04 16:01:20.159539128 +0200
> @@ -2163,6 +2163,7 @@ extern void __iget(struct inode * inode)
> extern void iget_failed(struct inode *);
> extern void clear_inode(struct inode *);
> extern void destroy_inode(struct inode *);
> +extern void __destroy_inode(struct inode *);
> extern struct inode *new_inode(struct super_block *);
> extern int should_remove_suid(struct dentry *);
> extern int file_remove_suid(struct file *);
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
