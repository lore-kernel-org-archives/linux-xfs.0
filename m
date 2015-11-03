Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4005029E72
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 09:22:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABECFAC009
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 07:22:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bdlJmVUbbkJ8HbqP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 Nov 2015 07:22:01 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v13 38/51] nfsd: Add richacl support
Date: Tue,  3 Nov 2015 16:17:14 +0100
Message-Id: <1446563847-14005-39-git-send-email-agruenba@redhat.com>
In-Reply-To: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
References: <1446563847-14005-1-git-send-email-agruenba@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-api@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>

On file systems with richacls enabled, get and set richacls directly
instead of converting from / to posix acls.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/nfsd/acl.h      |   3 +-
 fs/nfsd/nfs4acl.c  | 124 ++++++++++++++++++++++++++++++++++++++---------------
 fs/nfsd/nfs4proc.c |   2 +-
 fs/nfsd/nfs4xdr.c  |  34 +++++++++++----
 4 files changed, 117 insertions(+), 46 deletions(-)

diff --git a/fs/nfsd/acl.h b/fs/nfsd/acl.h
index 1c5deb5..d73c664 100644
--- a/fs/nfsd/acl.h
+++ b/fs/nfsd/acl.h
@@ -53,8 +53,7 @@ __be32 nfsd4_decode_ace_who(struct richace *ace, struct svc_rqst *rqstp,
 __be32 nfsd4_encode_ace_who(struct xdr_stream *xdr, struct svc_rqst *rqstp,
 			    struct richace *ace);
 
-int nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
-		  struct richacl **acl);
+struct richacl *nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry);
 __be32 nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		     struct richacl *acl);
 
diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
index 6d3bb72..f017a76 100644
--- a/fs/nfsd/nfs4acl.c
+++ b/fs/nfsd/nfs4acl.c
@@ -40,6 +40,8 @@
 #include <linux/nfs_fs.h>
 #include <linux/richacl_compat.h>
 #include <linux/nfs4acl.h>
+#include <linux/xattr.h>
+#include <linux/richacl_xattr.h>
 
 #include "nfsfh.h"
 #include "nfsd.h"
@@ -129,32 +131,28 @@ static short ace2type(struct richace *);
 static void _posix_to_richacl_one(struct posix_acl *, struct richacl_alloc *,
 				unsigned int);
 
-int
-nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
-	      struct richacl **acl)
+static struct richacl *
+nfsd4_get_posix_acl(struct svc_rqst *rqstp, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
-	int error = 0;
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	struct richacl_alloc alloc;
 	unsigned int flags = 0;
 	int count;
 
 	pacl = get_acl(inode, ACL_TYPE_ACCESS);
-	if (!pacl)
-		pacl = posix_acl_from_mode(inode->i_mode, GFP_KERNEL);
-
-	if (IS_ERR(pacl))
-		return PTR_ERR(pacl);
+	if (IS_ERR_OR_NULL(pacl))
+		return (void *)pacl;
 
-	/* allocate for worst case: one (deny, allow) pair each: */
+	/* Allocate for worst case: one (deny, allow) pair each.  The resulting
+	   acl will be released shortly and won't be cached. */
 	count = 2 * pacl->a_count;
 
 	if (S_ISDIR(inode->i_mode)) {
 		flags = FLAG_DIRECTORY;
 		dpacl = get_acl(inode, ACL_TYPE_DEFAULT);
 		if (IS_ERR(dpacl)) {
-			error = PTR_ERR(dpacl);
+			alloc.acl = (void *)dpacl;
 			goto rel_pacl;
 		}
 
@@ -163,7 +161,7 @@ nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
 	}
 
 	if (!richacl_prepare(&alloc, count)) {
-		error = -ENOMEM;
+		alloc.acl = ERR_PTR(-ENOMEM);
 		goto out;
 	}
 
@@ -172,13 +170,37 @@ nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry,
 	if (dpacl)
 		_posix_to_richacl_one(dpacl, &alloc, flags | FLAG_DEFAULT_ACL);
 
-	*acl = alloc.acl;
-
 out:
 	posix_acl_release(dpacl);
 rel_pacl:
 	posix_acl_release(pacl);
-	return error;
+	return alloc.acl;
+}
+
+struct richacl *
+nfsd4_get_acl(struct svc_rqst *rqstp, struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+	struct richacl *acl;
+	int error;
+
+	if (IS_RICHACL(inode))
+		acl = get_richacl(inode);
+	else
+		acl = nfsd4_get_posix_acl(rqstp, dentry);
+	if (IS_ERR(acl))
+		return acl;
+	else if (acl == NULL) {
+		acl = richacl_from_mode(inode->i_mode);
+		if (acl == NULL)
+			acl = ERR_PTR(-ENOMEM);
+	}
+	error = richacl_apply_masks(&acl, inode->i_uid);
+	if (error) {
+		richacl_put(acl);
+		acl = ERR_PTR(error);
+	}
+	return acl;
 }
 
 struct posix_acl_summary {
@@ -744,56 +766,88 @@ out_estate:
 	return ret;
 }
 
-__be32
-nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp, struct richacl *acl)
+static int
+nfsd4_set_posix_acl(struct svc_rqst *rqstp, struct dentry *dentry,
+		    struct richacl *acl)
 {
-	__be32 error;
 	int host_error;
-	struct dentry *dentry;
-	struct inode *inode;
+	struct inode *inode = d_inode(dentry);
 	struct posix_acl *pacl = NULL, *dpacl = NULL;
 	unsigned int flags = 0;
 
-	/* Get inode */
-	error = fh_verify(rqstp, fhp, 0, NFSD_MAY_SATTR);
-	if (error)
-		return error;
-
-	dentry = fhp->fh_dentry;
-	inode = d_inode(dentry);
-
 	if (!inode->i_op->set_acl || !IS_POSIXACL(inode))
-		return nfserr_attrnotsupp;
+		return -EOPNOTSUPP;
 
 	if (S_ISDIR(inode->i_mode))
 		flags = FLAG_DIRECTORY;
 
 	host_error = nfs4_richacl_to_posix(acl, &pacl, &dpacl, flags);
 	if (host_error == -EINVAL)
-		return nfserr_attrnotsupp;
+		return -EOPNOTSUPP;
 	if (host_error < 0)
-		goto out_nfserr;
+		return host_error;
 
 	host_error = inode->i_op->set_acl(inode, pacl, ACL_TYPE_ACCESS);
 	if (host_error < 0)
 		goto out_release;
 
-	if (S_ISDIR(inode->i_mode)) {
+	if (S_ISDIR(inode->i_mode))
 		host_error = inode->i_op->set_acl(inode, dpacl,
 						  ACL_TYPE_DEFAULT);
-	}
 
 out_release:
 	posix_acl_release(pacl);
 	posix_acl_release(dpacl);
-out_nfserr:
+	return host_error;
+}
+
+static int
+nfsd4_set_richacl(struct svc_rqst *rqstp, struct dentry *dentry,
+		  struct richacl *acl)
+{
+	int host_error;
+	struct inode *inode = d_inode(dentry);
+	size_t size = richacl_xattr_size(acl);
+	char *buffer;
+
+	if (!inode->i_op->setxattr || !IS_RICHACL(inode))
+		return -EOPNOTSUPP;
+
+	richacl_compute_max_masks(acl);
+
+	buffer = kmalloc(size, GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+	richacl_to_xattr(&init_user_ns, acl, buffer, size);
+	host_error = inode->i_op->setxattr(dentry, XATTR_NAME_RICHACL,
+					   buffer, size, 0);
+	kfree(buffer);
+	return host_error;
+}
+
+__be32
+nfsd4_set_acl(struct svc_rqst *rqstp, struct svc_fh *fhp, struct richacl *acl)
+{
+	struct dentry *dentry;
+	int host_error;
+	__be32 error;
+
+	error = fh_verify(rqstp, fhp, 0, NFSD_MAY_SATTR);
+	if (error)
+		return error;
+	dentry = fhp->fh_dentry;
+
+	if (IS_RICHACL(d_inode(dentry)))
+		host_error = nfsd4_set_richacl(rqstp, dentry, acl);
+	else
+		host_error = nfsd4_set_posix_acl(rqstp, dentry, acl);
+
 	if (host_error == -EOPNOTSUPP)
 		return nfserr_attrnotsupp;
 	else
 		return nfserrno(host_error);
 }
 
-
 static short
 ace2type(struct richace *ace)
 {
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 2430235..1bcfda2 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -110,7 +110,7 @@ check_attr_support(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	 * in current environment or not.
 	 */
 	if (bmval[0] & FATTR4_WORD0_ACL) {
-		if (!IS_POSIXACL(d_inode(dentry)))
+		if (!IS_ACL(d_inode(dentry)))
 			return nfserr_attrnotsupp;
 	}
 
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 8603f40..682a7d8 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -340,11 +340,24 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 
 		richacl_for_each_entry(ace, *acl) {
 			READ_BUF(16); len += 16;
-			ace->e_type = be32_to_cpup(p++);
-			ace->e_flags = be32_to_cpup(p++);
-			ace->e_mask = be32_to_cpup(p++);
-			if (ace->e_flags & RICHACE_SPECIAL_WHO)
+
+			dummy32 = be32_to_cpup(p++);
+			if (dummy32 > RICHACE_ACCESS_DENIED_ACE_TYPE)
+				return nfserr_inval;
+			ace->e_type = dummy32;
+
+			dummy32 = be32_to_cpup(p++);
+			if (dummy32 & (~RICHACE_VALID_FLAGS |
+				       RICHACE_INHERITED_ACE |
+				       RICHACE_SPECIAL_WHO))
 				return nfserr_inval;
+			ace->e_flags = dummy32;
+
+			dummy32 = be32_to_cpup(p++);
+			if (dummy32 & ~NFS4_ACE_MASK_ALL)
+				return nfserr_inval;
+			ace->e_mask = dummy32;
+
 			dummy32 = be32_to_cpup(p++);
 			READ_BUF(dummy32);
 			len += XDR_QUADLEN(dummy32) << 2;
@@ -2330,7 +2343,11 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		fhp = tempfh;
 	}
 	if (bmval0 & FATTR4_WORD0_ACL) {
-		err = nfsd4_get_acl(rqstp, dentry, &acl);
+		acl = nfsd4_get_acl(rqstp, dentry);
+		if (IS_ERR(acl)) {
+			err = PTR_ERR(acl);
+			acl = NULL;
+		}
 		if (err == -EOPNOTSUPP)
 			bmval0 &= ~FATTR4_WORD0_ACL;
 		else if (err == -EINVAL) {
@@ -2370,7 +2387,7 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		u32 word1 = nfsd_suppattrs1(minorversion);
 		u32 word2 = nfsd_suppattrs2(minorversion);
 
-		if (!IS_POSIXACL(dentry->d_inode))
+		if (!IS_ACL(d_inode(dentry)))
 			word0 &= ~FATTR4_WORD0_ACL;
 		if (!contextsupport)
 			word2 &= ~FATTR4_WORD2_SECURITY_LABEL;
@@ -2505,7 +2522,8 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 			if (!p)
 				goto out_resource;
 			*p++ = cpu_to_be32(ace->e_type);
-			*p++ = cpu_to_be32(ace->e_flags & ~RICHACE_SPECIAL_WHO);
+			*p++ = cpu_to_be32(ace->e_flags &
+				~(RICHACE_SPECIAL_WHO | RICHACE_INHERITED_ACE));
 			*p++ = cpu_to_be32(ace->e_mask & NFS4_ACE_MASK_ALL);
 			status = nfsd4_encode_ace_who(xdr, rqstp, ace);
 			if (status)
@@ -2517,7 +2535,7 @@ out_acl:
 		p = xdr_reserve_space(xdr, 4);
 		if (!p)
 			goto out_resource;
-		*p++ = cpu_to_be32(IS_POSIXACL(dentry->d_inode) ?
+		*p++ = cpu_to_be32(IS_ACL(d_inode(dentry)) ?
 			ACL4_SUPPORT_ALLOW_ACL|ACL4_SUPPORT_DENY_ACL : 0);
 	}
 	if (bmval0 & FATTR4_WORD0_CANSETTIME) {
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
