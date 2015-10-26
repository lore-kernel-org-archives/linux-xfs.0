Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1A0AF7F6D
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 09:02:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9F338F8052
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 07:02:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nr470HALneRUvKzn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 26 Oct 2015 07:02:05 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 989F1C0AEE52
	for <xfs@oss.sgi.com>; Mon, 26 Oct 2015 14:02:04 +0000 (UTC)
Date: Mon, 26 Oct 2015 10:02:03 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/4] xfs: SGI ACLs: Fix caching and mode setting
Message-ID: <20151026140202.GB59738@bfoster.bfoster>
References: <1445721369-25679-1-git-send-email-agruenba@redhat.com>
	<1445721369-25679-3-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445721369-25679-3-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Sat, Oct 24, 2015 at 11:16:07PM +0200, Andreas Gruenbacher wrote:
> POSIX ACLs on XFS are exposed as system.posix_acl_* as well as
> trusted.SGI_ACL_*.  Setting the system attributes updates inode->i_mode,
> inode->i_acl, and inode->i_default_acl as it should, but setting the trusted
> attributes does not do that.  Fix that by adding xattr handlers for the two
> trusted.SGI_ACL_* attributes.
> 
> The handlers must be installed before the trusted.* xattr handler in
> xfs_xattr_handlers to take effect.
> 
> Other than before, trusted.SGI_ACL_* attribute values are now verified and
> cannot be set to invalid values anymore.  Access to those attributes is still
> limited to users capable of CAP_SYS_ADMIN, while the system.posix_acl_*
> attributes can be read by anyone and set by the file owner.
> 

We should probably point out that the SGI_ACL_* xattrs are effectively
how ACLs are stored in XFS, thus direct usage expects the value to be in
valid on-disk format. The code mostly looks Ok to me, but this whole
thing still makes me cringe a bit.. :/ A few comments...

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_acl.c   | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_acl.h   |  3 +++
>  fs/xfs/xfs_xattr.c |  4 ++-
>  3 files changed, 82 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 763e365..0eea7ee 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -305,3 +305,79 @@ xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
>   set_acl:
>  	return __xfs_set_acl(inode, type, acl);
>  }
> +
> +static int
> +xfs_xattr_acl_get(struct dentry *dentry, const char *name,
> +		  void *value, size_t size, int type)
> +{

I'm not a huge fan of using the 'type' name here, personally. I'd call
it xflags to be consistent with the other xattr handlers and add a brief
comment for both of these functions that explain we're hooking up into
the ACL interface from a layer below.

> +	struct inode *inode = d_inode(dentry);
> +	struct posix_acl *acl;
> +	int error;
> +
> +	if (S_ISLNK(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	acl = get_acl(inode, type);
> +	if (IS_ERR(acl))
> +		return PTR_ERR(acl);
> +	if (acl == NULL)
> +		return -ENODATA;
> +
> +	error = XFS_ACL_SIZE(acl->a_count);
> +	if (value) {
> +		if (error > size)
> +			error = -ERANGE;
> +		else
> +			xfs_acl_to_disk(value, acl);
> +	}
> +
> +	posix_acl_release(acl);
> +	return error;

With regard to the xattr_acl get function, why do we need to do anything
differently here from xfs_xattr_get()? Here we get the ACL, convert to
in-core format, then convert back to disk format into the buffer. I
don't think we need the extra validation in this scenario. In fact, I'd
expect this to return whatever might be on-disk from an older kernel,
etc. Can we just use xfs_xattr_get() for this case? Note that implies we
probably kill the abuse of xflags as well. If that's a problem for the
set case, just fixing up the flags and calling xfs_xattr_get() from here
might be another option.

> +}
> +
> +static int
> +xfs_xattr_acl_set(struct dentry *dentry, const char *name,
> +		  const void *value, size_t size, int flags, int type)
> +{
> +	struct inode *inode = d_inode(dentry);
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct posix_acl *acl = NULL;
> +	int error;
> +
> +	if (!inode->i_op->set_acl)
> +		return -EOPNOTSUPP;
> +
> +	if (type == ACL_TYPE_DEFAULT && !S_ISDIR(inode->i_mode))
> +		return value ? -EACCES : 0;
> +

FWIW, this appears to be the only use of type here and it's already
handled down in the set_acl() path, so probably not necessary.

> +	if (value) {
> +		acl = xfs_acl_from_disk(value, size, XFS_ACL_MAX_ENTRIES(ip->i_mount));
> +		if (IS_ERR(acl))
> +			return PTR_ERR(acl);
> +

A comment around the validation here wouldn't hurt. E.g.,

/*
 * Data is expected in on-disk format. Therefore we convert to the
 * in-core ACL structures and validate as if this were set_acl().
 */

> +		if (acl) {
> +			error = posix_acl_valid(acl);
> +			if (error)
> +				goto out;
> +		}
> +	}
> +
> +	error = inode->i_op->set_acl(inode, acl, type);
> +out:
> +	posix_acl_release(acl);
> +	return error;
> +}
> +
> +const struct xattr_handler xfs_xattr_sgi_acl_file = {
> +	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_FILE,
> +	.flags	= ACL_TYPE_ACCESS,
> +	.get	= xfs_xattr_acl_get,
> +	.set	= xfs_xattr_acl_set,
> +};
> +
> +const struct xattr_handler xfs_xattr_sgi_acl_default = {
> +	.prefix = XATTR_TRUSTED_PREFIX SGI_ACL_DEFAULT,
> +	.flags	= ACL_TYPE_DEFAULT,
> +	.get	= xfs_xattr_acl_get,
> +	.set	= xfs_xattr_acl_set,
> +};

These should probably be in xfs_xattr.c with all of the other
xattr_handler definitions. We can kill the subsequent xfs_acl.h header
declarations (or replace them with the function declarations, at least)
as well. In fact on further thought, all of this should probably just
end up in xfs_xattr.c since these are technically xattr handlers.

Finally, another random thought... another way to approach this whole
thing might be just to redirect the SGI_FILE_* xattr calls to the
system.posix_acl_* calls. The SGI_FILE_* xattr data changes along with
the required conversions and whatnot, but then at least we expose data
in a more generic format. Isn't it the case that ACLs are generally set
via xattr calls, presumably in some specially defined format? This also
might get around the need for most of the bits in the subsequent
patches..

Brian

> diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
> index 3841b07..461dea6 100644
> --- a/fs/xfs/xfs_acl.h
> +++ b/fs/xfs/xfs_acl.h
> @@ -27,6 +27,9 @@ extern struct posix_acl *xfs_get_acl(struct inode *inode, int type);
>  extern int xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type);
>  extern int posix_acl_access_exists(struct inode *inode);
>  extern int posix_acl_default_exists(struct inode *inode);
> +
> +extern const struct xattr_handler xfs_xattr_sgi_acl_file;
> +extern const struct xattr_handler xfs_xattr_sgi_acl_default;
>  #else
>  static inline struct posix_acl *xfs_get_acl(struct inode *inode, int type)
>  {
> diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
> index c0368151..7534cb5 100644
> --- a/fs/xfs/xfs_xattr.c
> +++ b/fs/xfs/xfs_xattr.c
> @@ -97,12 +97,14 @@ static const struct xattr_handler xfs_xattr_security_handler = {
>  
>  const struct xattr_handler *xfs_xattr_handlers[] = {
>  	&xfs_xattr_user_handler,
> -	&xfs_xattr_trusted_handler,
>  	&xfs_xattr_security_handler,
>  #ifdef CONFIG_XFS_POSIX_ACL
>  	&posix_acl_access_xattr_handler,
>  	&posix_acl_default_xattr_handler,
> +	&xfs_xattr_sgi_acl_file,
> +	&xfs_xattr_sgi_acl_default,
>  #endif
> +	&xfs_xattr_trusted_handler,
>  	NULL
>  };
>  
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
