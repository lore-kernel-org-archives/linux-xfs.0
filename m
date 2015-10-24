Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 966417F50
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 07:57:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 66EDF8F8049
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 05:57:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NJZhGbegJwi3IO7l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 24 Oct 2015 05:57:02 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id B50F18EA45
	for <xfs@oss.sgi.com>; Sat, 24 Oct 2015 12:57:01 +0000 (UTC)
Date: Sat, 24 Oct 2015 08:57:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Inconsistencies with trusted.SGI_ACL_{FILE,DEFAULT}
Message-ID: <20151024125659.GA8095@bfoster.bfoster>
References: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5gS4BA+iTRHo1oHJMVHkLs4aa0eYd5T1ftLC9biRaxrg@mail.gmail.com>
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

On Fri, Oct 23, 2015 at 03:52:54PM +0200, Andreas Gruenbacher wrote:
> Hello,
> 
> The usual way of manipulating a file's POSIX ACL is through the
> system.posix_acl_{access,default} xattrs. Setting
> system.posix_acl_access also sets the permission bits in the file
> mode. The acls are cached in inode->i_acl and inode->i_default_acl.
> 
> On XFS, POSIX ACLs are also exposed as trusted.SGI_ACL_{FILE,DEFAULT}
> xattrs in a different value format. However, setting these xattrs does
> not update inode->i_{,default_}acl, and setting trusted.SGI_ACL_FILE
> does not update the file mode; things can get out of sync:
> 

It looks like the posix_acl_* values are virtual xattrs on XFS. They get
translated to the SGI_ACL_* names before the acl code calls down into
the xattr code. The result is cached into the inode via set_cached_acl()
before the call returns.

The xattr code doesn't know anything about this so I suspect this is the
reason for the inconsistency. A direct xattr update just updates the
data on-disk and has no knowledge of the ACLs cached to the inode, the
latter of which is probably what is returned after the setxattr.

>   $ touch f
>   $ setfacl -m u:agruenba:rw f
>   $ ls -l f
>   -rw-rw-r--+ 1 root root 0 Oct 23 15:04 f
>   $ getfattr -m- -d f
>   # file: f
>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
>   system.posix_acl_access=0sAgAAAAEABgD/////AgAGAOgDAAAEAAQA/////xAABgD/////IAAEAP////8=
>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> 
>   $ chmod 0 f
>   $ setfattr -n trusted.SGI_ACL_FILE -v
> 0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> f
>   $ ls -l f
>   ----------+ 1 root root 0 Oct 23 15:04 /var/tmp/f
>   $ getfacl f
>   # file: f
>   # owner: root
>   # group: root
>   user::---
>   user:agruenba:rw-        #effective:---
>   group::r--            #effective:---
>   mask::---
>   other::---
>   $ getfattr -m- -d f
>   # file: f
>   security.selinux="unconfined_u:object_r:user_tmp_t:s0"
>   system.posix_acl_access=0sAgAAAAEAAAD/////AgAGAOgDAAAEAAQA/////xAAAAD/////IAAAAP////8=
>   trusted.SGI_ACL_FILE=0sAAAABQAAAAH/////AAYAAAAAAAIAAAPoAAYAAAAAAAT/////AAQAAAAAABD/////AAYAAAAAACD/////AAQAAA==
> 
> Here, the file mode and the reported value of system.posix_acl_access
> are both wrong; trusted.SGI_ACL_FILE corresponds to what's stored on
> disk.
> 
> Access to trusted.* attributes is limited to users capable of
> CAP_SYS_ADMIN so ordinary users cannot cause this kind of damage, but
> this still deserves fixing.
> 

Not sure there's a real use case for this, but it looks like we could
invalidate the cached ACLs if those xattrs are modified directly via the
xattr interface. Care to test the (compile tested only) hunk below? An
alternative could be to just disallow setting these xattrs directly.

Brian

> Thanks,
> Andreas
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c0368151..651c2a3 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -57,7 +57,8 @@ static int
 xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		size_t size, int flags, int xflags)
 {
-	struct xfs_inode *ip = XFS_I(d_inode(dentry));
+	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
+	int			error;
 
 	if (strcmp(name, "") == 0)
 		return -EINVAL;
@@ -70,8 +71,20 @@ xfs_xattr_set(struct dentry *dentry, const char *name, const void *value,
 
 	if (!value)
 		return xfs_attr_remove(ip, (unsigned char *)name, xflags);
-	return xfs_attr_set(ip, (unsigned char *)name,
+	error = xfs_attr_set(ip, (unsigned char *)name,
 				(void *)value, size, xflags);
+	/*
+	 * Invalidate any cached ACLs if the user has bypassed the ACL
+	 * interface.
+	 */
+	if (!error && (xflags & ATTR_ROOT)) {
+		if (!strncmp(name, SGI_ACL_FILE, strlen(name)))
+			forget_cached_acl(VFS_I(ip), ACL_TYPE_ACCESS);
+		else if (!strncmp(name, SGI_ACL_DEFAULT, strlen(name)))
+			forget_cached_acl(VFS_I(ip), ACL_TYPE_DEFAULT);
+	}
+
+	return error;
 }
 
 static const struct xattr_handler xfs_xattr_user_handler = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
