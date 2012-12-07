Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB7BrMLL214100 for <xfs@oss.sgi.com>; Fri, 7 Dec 2012 05:53:22 -0600
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 3wGs74HiXAcpM673
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 07 Dec 2012 03:55:47 -0800 (PST)
Received: by mail-pb0-f53.google.com with SMTP id jt11so314300pbb.26
	for <xfs@oss.sgi.com>; Fri, 07 Dec 2012 03:55:46 -0800 (PST)
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
Subject: [PATCH 4/4] fs: remove obsolete simple_strto<foo>
Date: Fri,  7 Dec 2012 17:25:19 +0530
Message-Id: <1354881319-23585-1-git-send-email-abhi.c.pawar@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, Chris Mason <chris.mason@fusionio.com>, Steve French <sfrench@samba.org>, Christine Caulfield <ccaulfie@redhat.com>, David Teigland <teigland@redhat.com>, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, v9fs-developer@lists.sourceforge.net, linux-btrfs@vger.kernel.org, Abhijit Pawar <abhi.c.pawar@gmail.com>

This patch replace the obsolete simple_strto<foo> with kstrto<foo>

Signed-off-by: Abhijit Pawar <abhi.c.pawar@gmail.com>
---
 fs/9p/v9fs.c         |    6 +++---
 fs/btrfs/ioctl.c     |    6 +++++-
 fs/cifs/cifs_debug.c |    6 ++++--
 fs/dlm/config.c      |   25 ++++++++++++++++++++-----
 fs/dlm/lockspace.c   |   20 ++++++++++++++++----
 fs/xfs/xfs_super.c   |   19 ++++++++++++++-----
 6 files changed, 62 insertions(+), 20 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index d934f04..e5ec1ea 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -112,7 +112,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	substring_t args[MAX_OPT_ARGS];
 	char *p;
 	int option = 0;
-	char *s, *e;
+	char *s;
 	int ret = 0;
 
 	/* setup defaults */
@@ -249,8 +249,8 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				v9ses->flags |= V9FS_ACCESS_CLIENT;
 			} else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				v9ses->uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0') {
+				ret = kstrtouint(s, 10, &v9ses->uid);
+				if (ret) {
 					ret = -EINVAL;
 					pr_info("Unknown access argument %s\n",
 						s);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 5b3429a..95d9e09 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1335,7 +1335,11 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 		sizestr = devstr + 1;
 		*devstr = '\0';
 		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
+		ret = kstrtoull(devstr, 10, &devid);
+		if (ret) {
+			ret = -EINVAL;
+			goto out_free;
+		}
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d9ea6ed..65936f8 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -584,6 +584,7 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	unsigned int flags;
 	char flags_string[12];
 	char c;
+	int rc;
 
 	if ((count < 1) || (count > 11))
 		return -EINVAL;
@@ -609,8 +610,9 @@ static ssize_t cifs_security_flags_proc_write(struct file *file,
 	}
 	/* else we have a number */
 
-	flags = simple_strtoul(flags_string, NULL, 0);
-
+	rc = kstrtouint(flags_string, 0, &flags);
+	if (rc)
+		return -EINVAL;
 	cFYI(1, "sec flags 0x%x", flags);
 
 	if (flags <= 0)  {
diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 7d58d5b..38d164b 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -156,11 +156,14 @@ static ssize_t cluster_set(struct dlm_cluster *cl, unsigned int *cl_field,
 			   const char *buf, size_t len)
 {
 	unsigned int x;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	x = simple_strtoul(buf, NULL, 0);
+	rc = kstrtouint(buf, 0, &x);
+	if (rc)
+		return -EINVAL;
 
 	if (check_zero && !x)
 		return -EINVAL;
@@ -729,7 +732,10 @@ static ssize_t comm_nodeid_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_nodeid_write(struct dlm_comm *cm, const char *buf,
 				 size_t len)
 {
-	cm->nodeid = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &cm->nodeid);
+	if (rc)
+		return -EINVAL;
 	return len;
 }
 
@@ -741,7 +747,10 @@ static ssize_t comm_local_read(struct dlm_comm *cm, char *buf)
 static ssize_t comm_local_write(struct dlm_comm *cm, const char *buf,
 				size_t len)
 {
-	cm->local= simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &cm->local);
+	if (rc)
+		return -EINVAL;
 	if (cm->local && !local_comm)
 		local_comm = cm;
 	return len;
@@ -845,7 +854,10 @@ static ssize_t node_nodeid_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
 	uint32_t seq = 0;
-	nd->nodeid = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &nd->nodeid);
+	if (rc)
+		return -EINVAL;
 	dlm_comm_seq(nd->nodeid, &seq);
 	nd->comm_seq = seq;
 	return len;
@@ -859,7 +871,10 @@ static ssize_t node_weight_read(struct dlm_node *nd, char *buf)
 static ssize_t node_weight_write(struct dlm_node *nd, const char *buf,
 				 size_t len)
 {
-	nd->weight = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &nd->weight);
+	if (rc)
+		return -EINVAL;
 	return len;
 }
 
diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 2e99fb0..e83abfb 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -35,7 +35,10 @@ static struct task_struct *	scand_task;
 static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
 	ssize_t ret = len;
-	int n = simple_strtol(buf, NULL, 0);
+	int n, rc;
+	rc = kstrtoint(buf, 0, &n);
+	if (rc)
+		return -EINVAL;
 
 	ls = dlm_find_lockspace_local(ls->ls_local_handle);
 	if (!ls)
@@ -57,7 +60,10 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 
 static ssize_t dlm_event_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_uevent_result = simple_strtol(buf, NULL, 0);
+	int rc;
+	rc = kstrtoint(buf, 0, &ls->ls_uevent_result);
+	if (rc)
+		return -EINVAL;
 	set_bit(LSFL_UEVENT_WAIT, &ls->ls_flags);
 	wake_up(&ls->ls_uevent_wait);
 	return len;
@@ -70,7 +76,10 @@ static ssize_t dlm_id_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_id_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	ls->ls_global_id = simple_strtoul(buf, NULL, 0);
+	int rc;
+	rc = kstrtouint(buf, 0, &ls->ls_global_id);
+	if (rc)
+		return -EINVAL;
 	return len;
 }
 
@@ -81,7 +90,10 @@ static ssize_t dlm_nodir_show(struct dlm_ls *ls, char *buf)
 
 static ssize_t dlm_nodir_store(struct dlm_ls *ls, const char *buf, size_t len)
 {
-	int val = simple_strtoul(buf, NULL, 0);
+	int val, rc;
+	rc = kstrtoint(buf, 0, &val);
+	if (rc)
+		return -EINVAL;
 	if (val == 1)
 		set_bit(LSFL_NODIR, &ls->ls_flags);
 	return len;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ab8839b..601246f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -174,11 +174,12 @@ xfs_parseargs(
 	char			*options)
 {
 	struct super_block	*sb = mp->m_super;
-	char			*this_char, *value, *eov;
+	char			*this_char, *value;
 	int			dsunit = 0;
 	int			dswidth = 0;
 	int			iosize = 0;
 	__uint8_t		iosizelog = 0;
+	int			rc;
 
 	/*
 	 * set up the mount name first so all the errors will refer to the
@@ -230,7 +231,9 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			mp->m_logbufs = simple_strtoul(value, &eov, 10);
+			rc = kstrtoint(value, 10, &mp->m_logbufs);
+			if (rc)
+				return -EINVAL;
 		} else if (!strcmp(this_char, MNTOPT_LOGBSIZE)) {
 			if (!value || !*value) {
 				xfs_warn(mp, "%s option requires an argument",
@@ -266,7 +269,9 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			iosize = simple_strtoul(value, &eov, 10);
+			rc = kstrtoint(value, 10, &iosize);
+			if (rc)
+				return -EINVAL;
 			iosizelog = ffs(iosize) - 1;
 		} else if (!strcmp(this_char, MNTOPT_ALLOCSIZE)) {
 			if (!value || !*value) {
@@ -296,14 +301,18 @@ xfs_parseargs(
 					this_char);
 				return EINVAL;
 			}
-			dsunit = simple_strtoul(value, &eov, 10);
+			rc = kstrtouint(value, 10, &dsunit);
+			if (rc)
+				return -EINVAL;
 		} else if (!strcmp(this_char, MNTOPT_SWIDTH)) {
 			if (!value || !*value) {
 				xfs_warn(mp, "%s option requires an argument",
 					this_char);
 				return EINVAL;
 			}
-			dswidth = simple_strtoul(value, &eov, 10);
+			rc = kstrtoint(value, 10, &dswidth);
+			if (rc)
+				return -EINVAL;
 		} else if (!strcmp(this_char, MNTOPT_32BITINODE)) {
 			mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
 		} else if (!strcmp(this_char, MNTOPT_64BITINODE)) {
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
