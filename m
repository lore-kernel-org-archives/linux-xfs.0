Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B74727DDA
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:38:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7D367304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id s18c7qE51mfuDWGc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:38:24 -0700 (PDT)
Subject: [PATCH 59/71] xfs: provide switch to force filesystem to
	copy-on-write all the time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:38:20 -0700
Message-ID: <147216830032.867.12177632219145817933.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Make it possible to force XFS to use copy on write all the time, at
least if reflink is turned on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_globals.c |    1 +
 fs/xfs/xfs_linux.h   |    1 +
 fs/xfs/xfs_reflink.c |    6 ++++++
 fs/xfs/xfs_sysctl.c  |   11 +++++++++++
 fs/xfs/xfs_sysctl.h  |    1 +
 5 files changed, 20 insertions(+)


diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index f3f6aa9..9a55966 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -43,6 +43,7 @@ xfs_param_t xfs_params = {
 	.fstrm_timer	= {	1,		30*100,		3600*100},
 	.eofb_timer	= {	1,		300,		3600*24},
 	.cowb_timer	= {	1,		300,		3600*24},
+	.always_cow	= {	0,		0,		1	},
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 68640fb..a9c1765 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -117,6 +117,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
 #define xfs_eofb_secs		xfs_params.eofb_timer.val
 #define xfs_cowb_secs		xfs_params.cowb_timer.val
+#define xfs_always_cow		xfs_params.always_cow.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_pid()		(current->pid)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0db3a34..1299a42 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -166,6 +166,12 @@ xfs_reflink_find_shared(
 	struct xfs_btree_cur	*cur;
 	int			error;
 
+	if (xfs_always_cow) {
+		*fbno = agbno;
+		*flen = aglen;
+		return 0;
+	}
+
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index afe1f66..650b8d5 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -193,6 +193,17 @@ static struct ctl_table xfs_table[] = {
 		.extra1		= &xfs_params.cowb_timer.min,
 		.extra2		= &xfs_params.cowb_timer.max,
 	},
+#ifdef DEBUG
+	{
+		.procname	= "always_cow",
+		.data		= &xfs_params.always_cow.val,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &xfs_params.always_cow.min,
+		.extra2		= &xfs_params.always_cow.max,
+	},
+#endif
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
 	{
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 984a349..16099dc 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -49,6 +49,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
 	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
+	xfs_sysctl_val_t always_cow;	/* Always copy on write? */
 } xfs_param_t;
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
