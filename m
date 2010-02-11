Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BJP78L172410 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 13:25:07 -0600
Subject: [PATCH 1/2] commit_metadata export operation replacing nfsd_sync_dir
From: Ben Myers <bpm@sgi.com>
Date: Thu, 11 Feb 2010 13:26:17 -0600
Message-ID: <20100211192617.12949.37316.stgit@case>
In-Reply-To: <20100211192611.12949.65493.stgit@case>
References: <20100211192611.12949.65493.stgit@case>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-nfs@vger.kernel.org
Cc: xfs@oss.sgi.com

- Add commit_metadata export_operation to allow the underlying filesystem to
  decide how to sync parent and child inodes most efficiently.

- Usage of nfsd_sync_dir and write_inode_now has been replaced with the
  commit_metadata function that takes a svc_fh and optional dentry for the child.

- The commit_metadata function calls the commit_metadata export_op if it's
  there, or else falls back to sync_inode instead of fsync and write_inode_now
  because only metadata need be synched here.

- nfsd4_sync_rec_dir now uses vfs_fsync so that commit_metadata can be static

- Add a 'delay_commit' arg to nfsd_setattr so that callers of
  nfsd_create_setattr can commit parent and child together avoiding an extra
  sync.

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/nfsd/nfs3proc.c       |    2 -
 fs/nfsd/nfs4proc.c       |    2 -
 fs/nfsd/nfs4recover.c    |    4 --
 fs/nfsd/nfs4state.c      |    2 -
 fs/nfsd/nfsproc.c        |    4 +-
 fs/nfsd/vfs.c            |  116 ++++++++++++++++++++++------------------------
 fs/nfsd/vfs.h            |    3 -
 include/linux/exportfs.h |    6 ++
 8 files changed, 68 insertions(+), 71 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 3d68f45..fe3af23 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -76,7 +76,7 @@ nfsd3_proc_setattr(struct svc_rqst *rqstp, struct nfsd3_sattrargs *argp,
 
 	fh_copy(&resp->fh, &argp->fh);
 	nfserr = nfsd_setattr(rqstp, &resp->fh, &argp->attrs,
-			      argp->check_guard, argp->guardtime);
+			      argp->check_guard, argp->guardtime, 0);
 	RETURN_STATUS(nfserr);
 }
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 37514c4..c6e3c7f 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -803,7 +803,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (status)
 		goto out;
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
-				0, (time_t)0);
+				0, 0, 0);
 out:
 	mnt_drop_write(cstate->current_fh.fh_export->ex_path.mnt);
 	return status;
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 5a754f7..98fb98e 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -119,9 +119,7 @@ out_no_tfm:
 static void
 nfsd4_sync_rec_dir(void)
 {
-	mutex_lock(&rec_dir.dentry->d_inode->i_mutex);
-	nfsd_sync_dir(rec_dir.dentry);
-	mutex_unlock(&rec_dir.dentry->d_inode->i_mutex);
+	vfs_fsync(NULL, rec_dir.dentry, 0);
 }
 
 int
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 3a20c09..f2fc8c8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2290,7 +2290,7 @@ nfsd4_truncate(struct svc_rqst *rqstp, struct svc_fh *fh,
 		return 0;
 	if (!(open->op_share_access & NFS4_SHARE_ACCESS_WRITE))
 		return nfserr_inval;
-	return nfsd_setattr(rqstp, fh, &iattr, 0, (time_t)0);
+	return nfsd_setattr(rqstp, fh, &iattr, 0, 0, 0);
 }
 
 static __be32
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index a047ad6..f5e8280 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -69,7 +69,7 @@ nfsd_proc_setattr(struct svc_rqst *rqstp, struct nfsd_sattrargs *argp,
 		argp->attrs.ia_valid, (long) argp->attrs.ia_size);
 
 	fh_copy(&resp->fh, &argp->fh);
-	nfserr = nfsd_setattr(rqstp, &resp->fh, &argp->attrs,0, (time_t)0);
+	nfserr = nfsd_setattr(rqstp, &resp->fh, &argp->attrs, 0, 0, 0);
 	return nfsd_return_attrs(nfserr, resp);
 }
 
@@ -326,7 +326,7 @@ nfsd_proc_create(struct svc_rqst *rqstp, struct nfsd_createargs *argp,
 		 */
 		attr->ia_valid &= ATTR_SIZE;
 		if (attr->ia_valid)
-			nfserr = nfsd_setattr(rqstp, newfhp, attr, 0, (time_t)0);
+			nfserr = nfsd_setattr(rqstp, newfhp, attr, 0, 0, 0);
 	}
 
 out_unlock:
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7062925..734a088 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -27,6 +27,8 @@
 #include <linux/jhash.h>
 #include <linux/ima.h>
 #include <asm/uaccess.h>
+#include <linux/exportfs.h>
+#include <linux/writeback.h>
 
 #ifdef CONFIG_NFSD_V3
 #include "xdr3.h"
@@ -271,6 +273,38 @@ out:
 	return err;
 }
 
+/*
+ * Commit metadata changes to stable storage.  You pay pass NULL for dchild.
+ */
+static int
+commit_metadata(struct svc_fh *fhp, struct dentry *dchild)
+{
+	struct inode *parent = fhp->fh_dentry->d_inode;
+	struct inode *child = NULL;
+	const struct export_operations *export_ops = parent->i_sb->s_export_op;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0, /* metadata only */
+	};
+	int error = 0, error2 = 0;
+
+	if (!EX_ISSYNC(fhp->fh_export))
+		return 0;
+
+	if (dchild) 
+		child = dchild->d_inode;
+
+	if (export_ops->commit_metadata) {
+		error = export_ops->commit_metadata(parent, child);
+	} else {
+		if (child)
+			error2 = sync_inode(child, &wbc);
+		error = sync_inode(parent, &wbc);
+		if (error2)
+			error = error2;
+	}
+	return error;
+}
 
 /*
  * Set various file attributes.
@@ -278,7 +312,7 @@ out:
  */
 __be32
 nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
-	     int check_guard, time_t guardtime)
+	     int check_guard, time_t guardtime, int delay_commit)
 {
 	struct dentry	*dentry;
 	struct inode	*inode;
@@ -415,9 +449,8 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp, struct iattr *iap,
 	}
 	if (size_change)
 		put_write_access(inode);
-	if (!err)
-		if (EX_ISSYNC(fhp->fh_export))
-			write_inode_now(inode, 1);
+	if (!err && !delay_commit)
+		err = nfserrno(commit_metadata(fhp, NULL));
 out:
 	return err;
 
@@ -770,28 +803,6 @@ nfsd_close(struct file *filp)
 }
 
 /*
- * Sync a directory to disk.
- *
- * We can't just call vfs_fsync because our requirements are slightly odd:
- *
- *  a) we do not have a file struct available
- *  b) we expect to have i_mutex already held by the caller
- */
-int
-nfsd_sync_dir(struct dentry *dentry)
-{
-	struct inode *inode = dentry->d_inode;
-	int error;
-
-	WARN_ON(!mutex_is_locked(&inode->i_mutex));
-
-	error = filemap_write_and_wait(inode->i_mapping);
-	if (!error && inode->i_fop->fsync)
-		error = inode->i_fop->fsync(NULL, dentry, 0);
-	return error;
-}
-
-/*
  * Obtain the readahead parameters for the file
  * specified by (dev, ino).
  */
@@ -1199,8 +1210,10 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	 */
 	if (current_fsuid() != 0)
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
-	if (iap->ia_valid)
-		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
+	if (iap->ia_valid) {
+		return nfsd_setattr(rqstp, resfhp, iap, 0, 0,
+				1 /* delay commit. our caller does it. */);
+	}
 	return 0;
 }
 
@@ -1332,12 +1345,8 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out_nfserr;
 	}
 
-	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
-		write_inode_now(dchild->d_inode, 1);
-	}
-
-	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
+	err = nfsd_create_setattr(rqstp, resfhp, iap);
+	err2 = nfserrno(commit_metadata(fhp, dchild));
 	if (err2)
 		err = err2;
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
@@ -1369,7 +1378,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
-	__be32		err2;
 	int		host_err;
 	__u32		v_mtime=0, v_atime=0;
 
@@ -1464,11 +1472,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (created)
 		*created = 1;
 
-	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
-		/* setattr will sync the child (or not) */
-	}
-
 	nfsd_check_ignore_resizing(iap);
 
 	if (createmode == NFS3_CREATE_EXCLUSIVE) {
@@ -1483,9 +1486,9 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
  set_attr:
-	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
-	if (err2)
-		err = err2;
+	err = nfsd_create_setattr(rqstp, resfhp, iap);
+	if (!err) 
+		err = nfserrno(commit_metadata(fhp, dchild));
 
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 	/*
@@ -1600,12 +1603,10 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		}
 	} else
 		host_err = vfs_symlink(dentry->d_inode, dnew, path);
-
-	if (!host_err) {
-		if (EX_ISSYNC(fhp->fh_export))
-			host_err = nfsd_sync_dir(dentry);
-	}
 	err = nfserrno(host_err);
+	if (!err)
+		err = nfserrno(commit_metadata(fhp, NULL));
+
 	fh_unlock(fhp);
 
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
@@ -1667,11 +1668,7 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	}
 	host_err = vfs_link(dold, dirp, dnew);
 	if (!host_err) {
-		if (EX_ISSYNC(ffhp->fh_export)) {
-			err = nfserrno(nfsd_sync_dir(ddir));
-			write_inode_now(dest, 1);
-		}
-		err = 0;
+		err = nfserrno(commit_metadata(ffhp, dold));
 	} else {
 		if (host_err == -EXDEV && rqstp->rq_vers == 2)
 			err = nfserr_acces;
@@ -1767,10 +1764,10 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 		goto out_dput_new;
 
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
-	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
-		host_err = nfsd_sync_dir(tdentry);
+	if (!host_err) {
+		host_err = commit_metadata(tfhp, NULL);
 		if (!host_err)
-			host_err = nfsd_sync_dir(fdentry);
+			host_err = commit_metadata(ffhp, NULL);
 	}
 
 	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
@@ -1851,12 +1848,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 
 	dput(rdentry);
 
-	if (host_err)
-		goto out_drop;
-	if (EX_ISSYNC(fhp->fh_export))
-		host_err = nfsd_sync_dir(dentry);
+	if (!host_err)
+		host_err = commit_metadata(fhp, NULL);
 
-out_drop:
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 out_nfserr:
 	err = nfserrno(host_err);
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index 4b1de0a..5062afd 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -41,7 +41,7 @@ __be32		 nfsd_lookup_dentry(struct svc_rqst *, struct svc_fh *,
 				const char *, unsigned int,
 				struct svc_export **, struct dentry **);
 __be32		nfsd_setattr(struct svc_rqst *, struct svc_fh *,
-				struct iattr *, int, time_t);
+				struct iattr *, int, time_t, int);
 int nfsd_mountpoint(struct dentry *, struct svc_export *);
 #ifdef CONFIG_NFSD_V4
 __be32          nfsd4_set_nfs4_acl(struct svc_rqst *, struct svc_fh *,
@@ -91,7 +91,6 @@ __be32		nfsd_statfs(struct svc_rqst *, struct svc_fh *,
 int		nfsd_notify_change(struct inode *, struct iattr *);
 __be32		nfsd_permission(struct svc_rqst *, struct svc_export *,
 				struct dentry *, int);
-int		nfsd_sync_dir(struct dentry *dp);
 
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 struct posix_acl *nfsd_get_posix_acl(struct svc_fh *, int);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index dc12f41..9102ecf 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -96,6 +96,7 @@ struct fid {
  * @fh_to_parent:   find the implied object's parent and get a dentry for it
  * @get_name:       find the name for a given inode in a given directory
  * @get_parent:     find the parent of a given directory
+ * @commit_metadata: commit metadata changes to stable storage
  *
  * See Documentation/filesystems/nfs/Exporting for details on how to use
  * this interface correctly.
@@ -137,6 +138,10 @@ struct fid {
  *    is also a directory.  In the event that it cannot be found, or storage
  *    space cannot be allocated, a %ERR_PTR should be returned.
  *
+ * commit_metadata:
+ *    @commit_metadata should commit metadata changes to stable storage.
+ *    Parent or child can be NULL.
+ *
  * Locking rules:
  *    get_parent is called with child->d_inode->i_mutex down
  *    get_name is not (which is possibly inconsistent)
@@ -152,6 +157,7 @@ struct export_operations {
 	int (*get_name)(struct dentry *parent, char *name,
 			struct dentry *child);
 	struct dentry * (*get_parent)(struct dentry *child);
+	int (*commit_metadata)(struct inode *parent, struct inode *child);
 };
 
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
