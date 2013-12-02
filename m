Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E57A77F58
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 14:15:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5FFCCAC008
	for <xfs@oss.sgi.com>; Mon,  2 Dec 2013 12:15:18 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 7ONJbrkHGUiFlh7D for <xfs@oss.sgi.com>;
	Mon, 02 Dec 2013 12:15:16 -0800 (PST)
Date: Mon, 2 Dec 2013 21:15:15 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/18] reiserfs: prefix ACL symbols with reiserfs_
Message-ID: <20131202201515.GC12253@quack.suse.cz>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120653.694912626@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131201120653.694912626@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Sun 01-12-13 03:59:04, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/reiserfs/xattr_acl.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
> index 06c04f7..6f721ea 100644
> --- a/fs/reiserfs/xattr_acl.c
> +++ b/fs/reiserfs/xattr_acl.c
> @@ -16,7 +16,7 @@ static int reiserfs_set_acl(struct reiserfs_transaction_handle *th,
>  			    struct posix_acl *acl);
>  
>  static int
> -posix_acl_set(struct dentry *dentry, const char *name, const void *value,
> +reiserfs_posix_acl_set(struct dentry *dentry, const char *name, const void *value,
>  		size_t size, int flags, int type)
>  {
>  	struct inode *inode = dentry->d_inode;
> @@ -65,7 +65,7 @@ posix_acl_set(struct dentry *dentry, const char *name, const void *value,
>  }
>  
>  static int
> -posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
> +reiserfs_posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
>  		size_t size, int type)
>  {
>  	struct posix_acl *acl;
> @@ -88,7 +88,7 @@ posix_acl_get(struct dentry *dentry, const char *name, void *buffer,
>  /*
>   * Convert from filesystem to in-memory representation.
>   */
> -static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
> +static struct posix_acl *reiserfs_posix_acl_from_disk(const void *value, size_t size)
>  {
>  	const char *end = (char *)value + size;
>  	int n, count;
> @@ -158,7 +158,7 @@ static struct posix_acl *posix_acl_from_disk(const void *value, size_t size)
>  /*
>   * Convert from in-memory to filesystem representation.
>   */
> -static void *posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
> +static void *reiserfs_posix_acl_to_disk(const struct posix_acl *acl, size_t * size)
>  {
>  	reiserfs_acl_header *ext_acl;
>  	char *e;
> @@ -257,7 +257,7 @@ struct posix_acl *reiserfs_get_acl(struct inode *inode, int type)
>  	} else if (retval < 0) {
>  		acl = ERR_PTR(retval);
>  	} else {
> -		acl = posix_acl_from_disk(value, retval);
> +		acl = reiserfs_posix_acl_from_disk(value, retval);
>  	}
>  	if (!IS_ERR(acl))
>  		set_cached_acl(inode, type, acl);
> @@ -307,7 +307,7 @@ reiserfs_set_acl(struct reiserfs_transaction_handle *th, struct inode *inode,
>  	}
>  
>  	if (acl) {
> -		value = posix_acl_to_disk(acl, &size);
> +		value = reiserfs_posix_acl_to_disk(acl, &size);
>  		if (IS_ERR(value))
>  			return (int)PTR_ERR(value);
>  	}
> @@ -499,8 +499,8 @@ static size_t posix_acl_access_list(struct dentry *dentry, char *list,
>  const struct xattr_handler reiserfs_posix_acl_access_handler = {
>  	.prefix = POSIX_ACL_XATTR_ACCESS,
>  	.flags = ACL_TYPE_ACCESS,
> -	.get = posix_acl_get,
> -	.set = posix_acl_set,
> +	.get = reiserfs_posix_acl_get,
> +	.set = reiserfs_posix_acl_set,
>  	.list = posix_acl_access_list,
>  };
>  
> @@ -519,7 +519,7 @@ static size_t posix_acl_default_list(struct dentry *dentry, char *list,
>  const struct xattr_handler reiserfs_posix_acl_default_handler = {
>  	.prefix = POSIX_ACL_XATTR_DEFAULT,
>  	.flags = ACL_TYPE_DEFAULT,
> -	.get = posix_acl_get,
> -	.set = posix_acl_set,
> +	.get = reiserfs_posix_acl_get,
> +	.set = reiserfs_posix_acl_set,
>  	.list = posix_acl_default_list,
>  };
> -- 
> 1.7.10.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
