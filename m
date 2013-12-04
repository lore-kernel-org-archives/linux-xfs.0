Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D1C4B7F4E
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 06:14:07 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD8D13040A4
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 04:14:07 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cm0HJhCiABhaOpx4 for
	<xfs@oss.sgi.com>; Wed, 04 Dec 2013 04:14:04 -0800 (PST)
Subject: Re: [Cluster-devel] [PATCH 16/18] gfs2: use generic posix ACL
	infrastructure
From: Steven Whitehouse <swhiteho@redhat.com>
In-Reply-To: <20131201120656.539995924@bombadil.infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.539995924@bombadil.infradead.org>
Date: Wed, 04 Dec 2013 12:12:37 +0000
Message-ID: <1386159157.2711.11.camel@menhir>
Mime-Version: 1.0
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
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Hi,

On Sun, 2013-12-01 at 03:59 -0800, Christoph Hellwig wrote:
> plain text document attachment
> (0016-gfs2-use-generic-posix-ACL-infrastructure.patch)
> This contains some major refactoring for the create path so that
> inodes are created with the right mode to start with instead of
> fixing it up later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/gfs2/acl.c   |  229 +++++++------------------------------------------------
>  fs/gfs2/acl.h   |    4 +-
>  fs/gfs2/inode.c |   33 ++++++--
>  fs/gfs2/xattr.c |    4 +-
>  4 files changed, 61 insertions(+), 209 deletions(-)
> 
Looks very good. I'd really like to be able to do something similar with
the security xattrs, in terms of the refactoring that at inode creation
to give the xattrs ahead of the inode allocation itself. That way it
should be possible to allocate the xattr blocks at the same time as the
inode, rather than as an after thought.

Some more comments below....

> diff --git a/fs/gfs2/acl.c b/fs/gfs2/acl.c
> index e82e4ac..e6c7a2c 100644
> --- a/fs/gfs2/acl.c
> +++ b/fs/gfs2/acl.c
[snip]
> -
> -static int gfs2_xattr_system_set(struct dentry *dentry, const char *name,
> -				 const void *value, size_t size, int flags,
> -				 int xtype)
> -{
> -	struct inode *inode = dentry->d_inode;
> -	struct gfs2_sbd *sdp = GFS2_SB(inode);
> -	struct posix_acl *acl = NULL;
> -	int error = 0, type;
> -
> -	if (!sdp->sd_args.ar_posix_acl)
> -		return -EOPNOTSUPP;
> -
> -	type = gfs2_acl_type(name);
> -	if (type < 0)
> -		return type;
> -	if (flags & XATTR_CREATE)
> -		return -EINVAL;
> -	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
> -		return value ? -EACCES : 0;
> -	if (!uid_eq(current_fsuid(), inode->i_uid) && !capable(CAP_FOWNER))
> -		return -EPERM;
> -	if (S_ISLNK(inode->i_mode))
> -		return -EOPNOTSUPP;
> -
> -	if (!value)
> -		goto set_acl;
>  
> -	acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -	if (!acl) {
> -		/*
> -		 * acl_set_file(3) may request that we set default ACLs with
> -		 * zero length -- defend (gracefully) against that here.
> -		 */
> -		goto out;
> -	}
> -	if (IS_ERR(acl)) {
> -		error = PTR_ERR(acl);
> -		goto out;
> -	}
> -
> -	error = posix_acl_valid(acl);
> -	if (error)
> -		goto out_release;
> -
> -	error = -EINVAL;
>  	if (acl->a_count > GFS2_ACL_MAX_ENTRIES)
> -		goto out_release;
> +		return -EINVAL;
>  
>  	if (type == ACL_TYPE_ACCESS) {
>  		umode_t mode = inode->i_mode;
> +
>  		error = posix_acl_equiv_mode(acl, &mode);
> +		if (error < 0)
>  
Andy Price has pointed out a missing "return error;" here

> -		if (error <= 0) {
> -			posix_acl_release(acl);
> +		if (error == 0)
>  			acl = NULL;
>  
> -			if (error < 0)
> -				return error;
> -		}
> -

Also, there seems to be a white space error in the xfs patch around line
170 in fs/xfs/xfs_iops.c where there is an added "if (default_acl)" with
a space before the tab,

Steve.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
