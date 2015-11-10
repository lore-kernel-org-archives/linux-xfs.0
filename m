Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BF58A7F47
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 17:22:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F320304062
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 15:22:00 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id nctyzgmBHProZLZA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 15:21:57 -0800 (PST)
Date: Wed, 11 Nov 2015 10:21:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the xfs tree
Message-ID: <20151111102154.507e2a67@canb.auug.org.au>
MIME-Version: 1.0
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
To: Al Viro <viro@ZenIV.linux.org.uk>, Ben Myers <bpm@sgi.com>, David Chinner <david@fromorbit.com>, xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in:

  fs/xfs/xfs_xattr.c

between commit:

  67d8e04e345e ("xfs: invalidate cached acl if set directly via xattr")

from the xfs tree and commit:

  64669c648bc0 ("xattr handlers: Pass handler to operations instead of flags")

from the vfs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/xfs/xfs_xattr.c
index 8294f86441bf,b1850e1489ef..000000000000
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@@ -53,34 -54,12 +54,35 @@@ xfs_xattr_get(const struct xattr_handle
  	return asize;
  }
  
 +void
 +xfs_forget_acl(
 +	struct inode		*inode,
 +	const char		*name,
 +	int			xflags)
 +{
 +	/*
 +	 * Invalidate any cached ACLs if the user has bypassed the ACL
 +	 * interface. We don't validate the content whatsoever so it is caller
 +	 * responsibility to provide data in valid format and ensure i_mode is
 +	 * consistent.
 +	 */
 +	if (xflags & ATTR_ROOT) {
 +#ifdef CONFIG_XFS_POSIX_ACL
 +		if (!strcmp(name, SGI_ACL_FILE))
 +			forget_cached_acl(inode, ACL_TYPE_ACCESS);
 +		else if (!strcmp(name, SGI_ACL_DEFAULT))
 +			forget_cached_acl(inode, ACL_TYPE_DEFAULT);
 +#endif
 +	}
 +}
 +
  static int
- xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
- 		size_t size, int flags, int xflags)
+ xfs_xattr_set(const struct xattr_handler *handler, struct dentry *dentry,
+ 		const char *name, const void *value, size_t size, int flags)
  {
 -	int xflags = handler->flags;
 -	struct xfs_inode *ip = XFS_I(d_inode(dentry));
 +	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
 +	int			error;
++	int			xflags = handler->flags;
  
  	if (strcmp(name, "") == 0)
  		return -EINVAL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
