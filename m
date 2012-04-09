Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39LSbtN209328 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 16:28:38 -0500
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id Mbj16xeHKEEkRBJY (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 14:28:36 -0700 (PDT)
Date: Mon, 9 Apr 2012 17:28:33 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: detecting case-insensitivity
Message-ID: <20120409212833.GA10508@fieldses.org>
References: <LBVkglc6jtb7.r3bLKBnl@host202.hostmonster.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <LBVkglc6jtb7.r3bLKBnl@host202.hostmonster.com>
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
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: xfs@oss.sgi.com

> > From: Dave Chinner <david@fromorbit.com>
> > Date: 09.04.2012 03.30
> > 
> > On Sat, Apr 07, 2012 at 10:00:29AM -0400, J. Bruce Fields wrote:
> > > Is there a generic way to detect whether a given filesystem is
> > > case-insensitive?  If not, how should it be done?  (A bit in s_flags?)
> > 
> > I don't think there is a generic flag for it. We could trivially add
> > one, I think, as it is generally a fixed property for the entire
> > filesystem....

So, I assume the following is totally wrong, but the basic idea (create
a new flag, set it based on xfs_sb_version_hasasciici, check it in nfsd)
would work?

On Mon, Apr 09, 2012 at 09:01:11AM +0400, Vyacheslav Dubeyko wrote:
> But why does it need to detect that filesystem case-insensitive or not? In what use-case does it need to make such detection?

To be honest, I have no idea--it's not a mandatory attribute, so I think
I'll instead just ceasing to support the attribute and seeing if anyone
complains....

--b.

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index bcd8904..53f3044 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2233,7 +2233,7 @@ out_acl:
 	if (bmval0 & FATTR4_WORD0_CASE_INSENSITIVE) {
 		if ((buflen -= 4) < 0)
 			goto out_resource;
-		WRITE32(1);
+		WRITE32(__IS_FLG(dentry->d_inode, MS_CASE_INSENSITIVE) ? 1 : 0);
 	}
 	if (bmval0 & FATTR4_WORD0_CASE_PRESERVING) {
 		if ((buflen -= 4) < 0)
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 7423d71..890f439 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1458,7 +1458,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		switch (createmode) {
 		case NFS3_CREATE_UNCHECKED:
 			if (! S_ISREG(dchild->d_inode->i_mode))
-				err = nfserr_exist;
+				goto out;
 			else if (truncp) {
 				/* in nfsv4, we need to treat this case a little
 				 * differently.  we don't want to truncate the
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee5b695..6367817 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1343,6 +1343,8 @@ xfs_fs_fill_super(
 	sb->s_maxbytes = xfs_max_file_offset(sb->s_blocksize_bits);
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
+	if (xfs_sb_version_hasasciici(&mp->m_sb))
+		sb->s_flags |= MS_CASE_INSENSITIVE;
 
 	error = xfs_mountfs(mp);
 	if (error)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8975a56..0ee6614 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -218,6 +218,8 @@ struct inodes_stat_t {
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
+#define MS_CASE_INSENSITIVE (1<<32)
+
 
 /*
  * Superblock flags that can be altered by MS_REMOUNT
@@ -1421,7 +1423,7 @@ struct super_block {
 	const struct dquot_operations	*dq_op;
 	const struct quotactl_ops	*s_qcop;
 	const struct export_operations *s_export_op;
-	unsigned long		s_flags;
+	unsigned long long	s_flags;
 	unsigned long		s_magic;
 	struct dentry		*s_root;
 	struct rw_semaphore	s_umount;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
