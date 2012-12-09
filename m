Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB9Ne6Tq145742 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 17:40:06 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id PbGp8BTFZtabPDzs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 15:42:34 -0800 (PST)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id B1EE73EE0AE
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:32 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 986D845DE4F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:32 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8101C45DE4D
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:32 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 73F971DB8037
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:32 +0900 (JST)
Received: from g01jpexchkw10.g01.fujitsu.local
	(g01jpexchkw10.g01.fujitsu.local [10.0.194.49])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 331911DB802F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:32 +0900 (JST)
Message-ID: <50C521D7.5060202@jp.fujitsu.com>
Date: Mon, 10 Dec 2012 08:42:15 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 2/2] XFS: Mark no-more-exist xfsbufd related sysctl parameters
	as obsolete.
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
To: xfs ML <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>


xfsbufd is removed since commit 43ff2122e6492bcc88b065c433453dce88223b30.
But there stille be two sysctl parameters about it
(fs.xfs.{xfsbufd_centisecs,age_buffer_centisecs}.)

This patch marks these parameters as obsolete. In adition, prints
a warning message if someone tries to use these parameters.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/filesystems/xfs.txt |    8 ++++----
 fs/xfs/xfs_globals.c              |    2 --
 fs/xfs/xfs_linux.h                |    2 --
 fs/xfs/xfs_sysctl.c               |   36 ++++++++++++++++++++++++------------
 fs/xfs/xfs_sysctl.h               |    2 --
 5 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3fc0c31..31d6ec6 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -183,11 +183,11 @@ The following sysctls are available for the XFS filesystem:
   	out to disk.  This thread will flush log activity out, and
   	do some processing on unlinked inodes.
 
-  fs.xfs.xfsbufd_centisecs	(Min: 50  Default: 100	Max: 3000)
-	The interval at which xfsbufd scans the dirty metadata buffers list.
+  fs.xfs.xfsbufd_centisecs
+	Obsolete. Don't use it.
 
-  fs.xfs.age_buffer_centisecs	(Min: 100  Default: 1500  Max: 720000)
-	The age at which xfsbufd flushes dirty metadata buffers to disk.
+  fs.xfs.age_buffer_centisecs
+	Obsolete. Don't use it.
 
   fs.xfs.error_level		(Min: 0  Default: 3  Max: 11)
 	A volume knob for error reporting when internal errors occur.
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 76e81cf..ea77e2a 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -34,8 +34,6 @@ xfs_param_t xfs_params = {
 	.inherit_sync	= {	0,		1,		1	},
 	.inherit_nodump	= {	0,		1,		1	},
 	.inherit_noatim = {	0,		1,		1	},
-	.xfs_buf_timer	= {	100/2,		1*100,		30*100	},
-	.xfs_buf_age	= {	1*100,		15*100,		7200*100},
 	.inherit_nosym	= {	0,		0,		1	},
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 828662f..f9420f4 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -112,8 +112,6 @@
 #define xfs_inherit_sync	xfs_params.inherit_sync.val
 #define xfs_inherit_nodump	xfs_params.inherit_nodump.val
 #define xfs_inherit_noatime	xfs_params.inherit_noatim.val
-#define xfs_buf_timer_centisecs	xfs_params.xfs_buf_timer.val
-#define xfs_buf_age_centisecs	xfs_params.xfs_buf_age.val
 #define xfs_inherit_nosymlinks	xfs_params.inherit_nosym.val
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index ee2d2ad..a4b7cb2 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -74,6 +74,26 @@ xfs_panic_mask_proc_handler(
 }
 #endif /* CONFIG_PROC_FS */
 
+static int xfs_proc_obsolete(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	char kbuf[] = "0\n";
+
+	if (*ppos) {
+		*lenp = 0;
+		return 0;
+	}
+
+	if (copy_to_user(buffer, kbuf, sizeof(kbuf)))
+		return -EFAULT;
+	pr_warn("XFS: %s sysctl parameter is obsolete.\n",
+	       table->procname);
+
+	*lenp = 2;
+	*ppos += *lenp;
+	return 2;
+}
+
 static ctl_table xfs_table[] = {
 	{
 		.procname	= "irix_sgid_inherit",
@@ -150,21 +170,13 @@ static ctl_table xfs_table[] = {
 	},
 	{
 		.procname	= "xfsbufd_centisecs",
-		.data		= &xfs_params.xfs_buf_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_timer.min,
-		.extra2		= &xfs_params.xfs_buf_timer.max
+		.mode		= 0444,
+		.proc_handler	= xfs_proc_obsolete,
 	},
 	{
 		.procname	= "age_buffer_centisecs",
-		.data		= &xfs_params.xfs_buf_age.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.xfs_buf_age.min,
-		.extra2		= &xfs_params.xfs_buf_age.max
+		.mode		= 0444,
+		.proc_handler	= xfs_proc_obsolete,
 	},
 	{
 		.procname	= "inherit_nosymlinks",
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index af152eb..23b430e 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -41,8 +41,6 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t inherit_sync;	/* Inherit the "sync" inode flag. */
 	xfs_sysctl_val_t inherit_nodump;/* Inherit the "nodump" inode flag. */
 	xfs_sysctl_val_t inherit_noatim;/* Inherit the "noatime" inode flag. */
-	xfs_sysctl_val_t xfs_buf_timer;	/* Interval between xfsbufd wakeups. */
-	xfs_sysctl_val_t xfs_buf_age;	/* Metadata buffer age before flush. */
 	xfs_sysctl_val_t inherit_nosym;	/* Inherit the "nosymlinks" flag. */
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
-- 1.7.10.4 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
