Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GL2wo7181011 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 15:02:59 -0600
Subject: [PATCH 1/2] commit_metadata export operation replacing nfsd_sync_dir
From: Ben Myers <bpm@sgi.com>
Date: Tue, 16 Feb 2010 15:04:13 -0600
Message-ID: <20100216210413.5694.88826.stgit@case>
In-Reply-To: <20100216210026.5694.14423.stgit@case>
References: <20100216210026.5694.14423.stgit@case>
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
To: bfields@fieldses.org
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

- Add commit_metadata export_operation to allow the underlying filesystem to
decide how to commit an inode most efficiently.

- Usage of nfsd_sync_dir and write_inode_now has been replaced with the
commit_metadata function that takes a svc_fh.

- The commit_metadata function calls the commit_metadata export_op if it's
there, or else falls back to sync_inode instead of fsync and write_inode_now
because only metadata need be synced here.

- nfsd4_sync_rec_dir now uses vfs_fsync so that commit_metadata can be static

Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/nfsd/nfs4recover.c    |    4 --
 fs/nfsd/vfs.c            |  109 ++++++++++++++++++++++------------------------
 include/linux/exportfs.h |    5 ++
 3 files changed, 59 insertions(+), 59 deletions(-)

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
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ed024d3..cde275b 100644
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
@@ -271,6 +273,31 @@ out:
 	return err;
 }
 
+/*
+ * Commit metadata changes to stable storage.  You pay pass NULL for dchild.
+ */
+static int
+commit_metadata(struct svc_fh *fhp)
+{
+	struct inode *inode = fhp->fh_dentry->d_inode;
+	const struct export_operations *export_ops = inode->i_sb->s_export_op;
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0, /* metadata only */
+	};
+	int error = 0;
+
+	if (!EX_ISSYNC(fhp->fh_export))
+		return 0;
+
+	if (export_ops->commit_metadata) {
+		error = export_ops->commit_metadata(inode);
+	} else {
+		error = sync_inode(inode, &wbc);
+	}
+
+	return error;
+}
 
 /*
  * Set various file attributes.
@@ -769,28 +796,6 @@ nfsd_close(struct file *filp)
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
@@ -1199,7 +1204,7 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
 	if (current_fsuid() != 0)
 		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
 	if (iap->ia_valid)
-		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
+		return nfsd_setattr(rqstp, resfhp, iap, 0, 0);
 	return 0;
 }
 
@@ -1331,13 +1336,15 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out_nfserr;
 	}
 
-	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
-		write_inode_now(dchild->d_inode, 1);
-	}
+	err = nfsd_create_setattr(rqstp, resfhp, iap);
 
-	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
-	if (err2)
+	/*
+	 * nfsd_setattr already committed the child.  Transactional filesystems
+	 * had a chance to commit changes for both parent and child
+	 * simultaneously making the following commit_metadata a noop.
+	 */
+	err2 = nfserrno(commit_metadata(fhp));
+       	if (err2)
 		err = err2;
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 	/*
@@ -1368,7 +1375,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	struct dentry	*dentry, *dchild = NULL;
 	struct inode	*dirp;
 	__be32		err;
-	__be32		err2;
 	int		host_err;
 	__u32		v_mtime=0, v_atime=0;
 
@@ -1463,11 +1469,6 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (created)
 		*created = 1;
 
-	if (EX_ISSYNC(fhp->fh_export)) {
-		err = nfserrno(nfsd_sync_dir(dentry));
-		/* setattr will sync the child (or not) */
-	}
-
 	nfsd_check_ignore_resizing(iap);
 
 	if (createmode == NFS3_CREATE_EXCLUSIVE) {
@@ -1482,9 +1483,13 @@ nfsd_create_v3(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	}
 
  set_attr:
-	err2 = nfsd_create_setattr(rqstp, resfhp, iap);
-	if (err2)
-		err = err2;
+	err = nfsd_create_setattr(rqstp, resfhp, iap);
+
+	/*
+	 * nfsd_setattr already committed the child (and possibly also the parent).
+	 */
+	if (!err)
+		err = nfserrno(commit_metadata(fhp));
 
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 	/*
@@ -1599,12 +1604,9 @@ nfsd_symlink(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
+		err = nfserrno(commit_metadata(fhp));
 	fh_unlock(fhp);
 
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
@@ -1666,11 +1668,9 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	}
 	host_err = vfs_link(dold, dirp, dnew);
 	if (!host_err) {
-		if (EX_ISSYNC(ffhp->fh_export)) {
-			err = nfserrno(nfsd_sync_dir(ddir));
-			write_inode_now(dest, 1);
-		}
-		err = 0;
+		err = nfserrno(commit_metadata(ffhp));
+		if (!err)
+			err = nfserrno(commit_metadata(tfhp));
 	} else {
 		if (host_err == -EXDEV && rqstp->rq_vers == 2)
 			err = nfserr_acces;
@@ -1766,10 +1766,10 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 		goto out_dput_new;
 
 	host_err = vfs_rename(fdir, odentry, tdir, ndentry);
-	if (!host_err && EX_ISSYNC(tfhp->fh_export)) {
-		host_err = nfsd_sync_dir(tdentry);
+	if (!host_err) {
+		host_err = commit_metadata(tfhp);
 		if (!host_err)
-			host_err = nfsd_sync_dir(fdentry);
+			host_err = commit_metadata(ffhp);
 	}
 
 	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
@@ -1850,12 +1850,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 
 	dput(rdentry);
 
-	if (host_err)
-		goto out_drop;
-	if (EX_ISSYNC(fhp->fh_export))
-		host_err = nfsd_sync_dir(dentry);
+	if (!host_err)
+		host_err = commit_metadata(fhp);
 
-out_drop:
 	mnt_drop_write(fhp->fh_export->ex_path.mnt);
 out_nfserr:
 	err = nfserrno(host_err);
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index dc12f41..a9cd507 100644
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
@@ -137,6 +138,9 @@ struct fid {
  *    is also a directory.  In the event that it cannot be found, or storage
  *    space cannot be allocated, a %ERR_PTR should be returned.
  *
+ * commit_metadata:
+ *    @commit_metadata should commit metadata changes to stable storage.
+ *
  * Locking rules:
  *    get_parent is called with child->d_inode->i_mutex down
  *    get_name is not (which is possibly inconsistent)
@@ -152,6 +156,7 @@ struct export_operations {
 	int (*get_name)(struct dentry *parent, char *name,
 			struct dentry *child);
 	struct dentry * (*get_parent)(struct dentry *child);
+	int (*commit_metadata)(struct inode *inode);
 };
 
 extern int exportfs_encode_fh(struct dentry *dentry, struct fid *fid,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
