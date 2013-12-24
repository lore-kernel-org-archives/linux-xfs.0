Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A44337F3F
	for <xfs@oss.sgi.com>; Tue, 24 Dec 2013 00:42:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93A108F8033
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 22:42:27 -0800 (PST)
Received: from alt-proxy11.mail.unifiedlayer.com
	(alt-proxy11.mail.unifiedlayer.com [74.220.211.241]) by
	cuda.sgi.com with SMTP id zqKLoiHjOSGBqTfz for
	<xfs@oss.sgi.com>; Mon, 23 Dec 2013 22:42:23 -0800 (PST)
Message-ID: <1387867304.3974.21.camel@slavad-ubuntu>
Subject: Re: [PATCH 21/21] hfsplus: remove can_set_xattr
From: Vyacheslav Dubeyko <slava@dubeyko.com>
Date: Tue, 24 Dec 2013 10:41:44 +0400
In-Reply-To: <20131223143706.GA8235@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
	<20131220132524.900291394@bombadil.infradead.org>
	<636E01BC-12FD-452B-8B1C-320B6EADAEFD@dubeyko.com>
	<20131222192818.GA32565@infradead.org>
	<1387780809.3991.21.camel@slavad-ubuntu>
	<20131223143706.GA8235@infradead.org>
Mime-Version: 1.0
Reply-To: slava@dubeyko.com
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
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Mon, 2013-12-23 at 06:37 -0800, Christoph Hellwig wrote:
> On Mon, Dec 23, 2013 at 10:40:09AM +0400, Vyacheslav Dubeyko wrote:
> > Maybe I missed something, but I can see that this check is removed only.
> > Could you point out the code in your patch that it checks and forbids
> > such combination as "osx.security.*", "osx.trusted.*" and so on?
> 
> @@ -941,6 +857,9 @@ static int hfsplus_osx_setxattr(struct dentry
> *dentry, const char *name,
>         if (len > HFSPLUS_ATTR_MAX_STRLEN)
> 		return -EOPNOTSUPP;
> 
> +       if (is_known_namespace(name))
> +               return -EOPNOTSUPP;
> +
> 

Yes, now I've realized your approach. You are right. It's my
misunderstanding. So, comments are really necessary for describing the
goal of this check. Thank you for adding it in the last version of
reworked patch.

> 
> > So, if it needs to use xattr handler only for removing then it needs to
> > make some refactoring of using __hfsplus_setxattr() and
> > hfsplus_removexattr() or merging these two functions into one. And I
> > think that merging is better idea.
> 
> I've not done the full merge, but below is an updated patch to make
> sure hfsplus uses the handlers for the remove case, and making sure
> the adding/striping of the prefix for the osv handlers is more
> transparent:
> 

As far as I can judge, changing from hfsplus_removexattr() to
generic_removexattr() is made correctly.

> diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
> index 9ee6298..bdec665 100644
> --- a/fs/hfsplus/dir.c
> +++ b/fs/hfsplus/dir.c
> @@ -529,7 +529,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
>  	.setxattr		= generic_setxattr,
>  	.getxattr		= generic_getxattr,
>  	.listxattr		= hfsplus_listxattr,
> -	.removexattr		= hfsplus_removexattr,
> +	.removexattr		= generic_removexattr,
>  #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
>  	.get_acl		= hfsplus_get_posix_acl,
>  	.set_acl		= hfsplus_set_posix_acl,
> diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
> index 2e10993..83c9166 100644
> --- a/fs/hfsplus/inode.c
> +++ b/fs/hfsplus/inode.c
> @@ -390,7 +390,7 @@ static const struct inode_operations hfsplus_file_inode_operations = {
>  	.setxattr	= generic_setxattr,
>  	.getxattr	= generic_getxattr,
>  	.listxattr	= hfsplus_listxattr,
> -	.removexattr	= hfsplus_removexattr,
> +	.removexattr	= generic_removexattr,
>  #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
>  	.get_acl	= hfsplus_get_posix_acl,
>  	.set_acl	= hfsplus_set_posix_acl,
> diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
> index bf88baa..c838b84 100644
> --- a/fs/hfsplus/xattr.c
> +++ b/fs/hfsplus/xattr.c
> @@ -11,6 +11,8 @@
>  #include "xattr.h"
>  #include "acl.h"
>  
> +static int hfsplus_removexattr(struct inode *inode, const char *name);
> +
>  const struct xattr_handler *hfsplus_xattr_handlers[] = {
>  	&hfsplus_xattr_osx_handler,
>  	&hfsplus_xattr_user_handler,
> @@ -52,82 +54,6 @@ static inline int is_known_namespace(const char *name)
>  	return true;
>  }
>  
> -static int can_set_system_xattr(struct inode *inode, const char *name,
> -				const void *value, size_t size)
> -{
> -#ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
> -	struct posix_acl *acl;
> -	int err;
> -
> -	if (!inode_owner_or_capable(inode))
> -		return -EPERM;
> -
> -	/*
> -	 * POSIX_ACL_XATTR_ACCESS is tied to i_mode
> -	 */
> -	if (strcmp(name, POSIX_ACL_XATTR_ACCESS) == 0) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		if (acl) {
> -			err = posix_acl_equiv_mode(acl, &inode->i_mode);
> -			posix_acl_release(acl);
> -			if (err < 0)
> -				return err;
> -			mark_inode_dirty(inode);
> -		}
> -		/*
> -		 * We're changing the ACL.  Get rid of the cached one
> -		 */
> -		forget_cached_acl(inode, ACL_TYPE_ACCESS);
> -
> -		return 0;
> -	} else if (strcmp(name, POSIX_ACL_XATTR_DEFAULT) == 0) {
> -		acl = posix_acl_from_xattr(&init_user_ns, value, size);
> -		if (IS_ERR(acl))
> -			return PTR_ERR(acl);
> -		posix_acl_release(acl);
> -
> -		/*
> -		 * We're changing the default ACL.  Get rid of the cached one
> -		 */
> -		forget_cached_acl(inode, ACL_TYPE_DEFAULT);
> -
> -		return 0;
> -	}
> -#endif /* CONFIG_HFSPLUS_FS_POSIX_ACL */
> -	return -EOPNOTSUPP;
> -}
> -
> -static int can_set_xattr(struct inode *inode, const char *name,
> -				const void *value, size_t value_len)
> -{
> -	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
> -		return can_set_system_xattr(inode, name, value, value_len);
> -
> -	if (!strncmp(name, XATTR_MAC_OSX_PREFIX, XATTR_MAC_OSX_PREFIX_LEN)) {
> -		/*
> -		 * This makes sure that we aren't trying to set an
> -		 * attribute in a different namespace by prefixing it
> -		 * with "osx."
> -		 */
> -		if (is_known_namespace(name + XATTR_MAC_OSX_PREFIX_LEN))
> -			return -EOPNOTSUPP;
> -
> -		return 0;
> -	}
> -
> -	/*
> -	 * Don't allow setting an attribute in an unknown namespace.
> -	 */
> -	if (strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) &&
> -	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
> -	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
> -		return -EOPNOTSUPP;
> -
> -	return 0;
> -}
> -
>  static void hfsplus_init_header_node(struct inode *attr_file,
>  					u32 clump_size,
>  					char *buf, u16 node_size)
> @@ -350,18 +276,8 @@ int __hfsplus_setxattr(struct inode *inode, const char *name,
>  				HFSPLUS_IS_RSRC(inode))
>  		return -EOPNOTSUPP;
>  
> -	err = can_set_xattr(inode, name, value, size);
> -	if (err)
> -		return err;
> -
> -	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
> -				XATTR_MAC_OSX_PREFIX_LEN) == 0)
> -		name += XATTR_MAC_OSX_PREFIX_LEN;

Removing this skipping of virtual "osx." prefix means that you save it
on volume. But such action means volume corruption really. Because HFS+
volume hasn't such prefixes for xattrs in AttributesFile. Usually,
special xattrs has prefix "com.apple.*" but others haven't any prefix
and can be named as you want. So, I think that it is not correct
modification.

> -
> -	if (value == NULL) {
> -		value = "";
> -		size = 0;
> -	}
> +	if (value == NULL)
> +		return hfsplus_removexattr(inode, name);
>  
>  	err = hfs_find_init(HFSPLUS_SB(inode->i_sb)->cat_tree, &cat_fd);
>  	if (err) {
> @@ -577,18 +493,6 @@ ssize_t __hfsplus_getxattr(struct inode *inode, const char *name,
>  				HFSPLUS_IS_RSRC(inode))
>  		return -EOPNOTSUPP;
>  
> -	if (strncmp(name, XATTR_MAC_OSX_PREFIX,
> -				XATTR_MAC_OSX_PREFIX_LEN) == 0) {
> -		/* skip "osx." prefix */
> -		name += XATTR_MAC_OSX_PREFIX_LEN;

Ditto. This skipping is made because virtual prefix was added by user or
on listxattr phase. But we should use for searching on a volume the name
without "osx." prefix. Otherwise, how do you get
"com.apple.system.Security" xattr from volume, for example? You will
search "osx.com.apple.system.Security" that doesn't exist on HFS+
volume.

Thanks,
Vyacheslav Dubeyko.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
