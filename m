Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q224DPrP241571 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 22:13:26 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3VqcXWQbxrmox3gL for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 20:13:24 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1S3Jrj-0006G3-70
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:13:11 +1100
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1S3JqT-0000JC-M0
	for xfs@oss.sgi.com; Fri, 02 Mar 2012 15:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 8/8] xfs: add a shrinker for quotacheck
Date: Fri,  2 Mar 2012 15:11:47 +1100
Message-Id: <1330661507-1121-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1330661507-1121-1-git-send-email-david@fromorbit.com>
References: <1330661507-1121-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

From: Dave Chinner <dchinner@redhat.com>

Whenthe filesystem is mounting, the superblock based shrinker cannot run due to
the mount process holding the sb->s_umount lock exclusively. Hence when
quotacheck runs, it cannot shrink the inode cache if it grows too large. We've
had repeated problems with the inode cache shrinker startup and quotacheck
resulting in OOM conditions.

Avoid this problem altogether by installing a quotacheck specific inode cache
shrinker that is registered before the quotacheck starts, and is then
unregistered after the quotacheck finishes. This shrinker uses exactly the same
infrastructure as the superblock based inode cache shrinker, so there is very
little extra code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_qm.h |    2 ++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index c872fea..c1a42f1 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -823,6 +823,7 @@ xfs_qm_init_quotainfo(
 		return error;
 	}
 
+	qinf->qi_mount = mp;
 	INIT_LIST_HEAD(&qinf->qi_dqlist);
 	mutex_init(&qinf->qi_dqlist_lock);
 	lockdep_set_class(&qinf->qi_dqlist_lock, &xfs_quota_mplist_class);
@@ -1398,6 +1399,26 @@ error0:
 }
 
 /*
+ * quotacheck specific shrinker. This is only active while quotacheck is in
+ * progress as the superblock shrinker won't run until the mount completes and
+ * drops the sb->s_umount lock.
+ */
+static int
+xfs_qm_quotacheck_shrink(
+	struct shrinker		*shr,
+	struct shrink_control	*sc)
+{
+	struct xfs_quotainfo	*qi = container_of(shr, struct xfs_quotainfo,
+							qi_shrinker);
+	if (!(sc->gfp_mask & __GFP_FS))
+		return -1;
+	if (sc->nr_to_scan)
+		xfs_reclaim_inodes_nr(qi->qi_mount, sc->nr_to_scan);
+
+	return xfs_reclaim_inodes_count(qi->qi_mount);
+}
+
+/*
  * Walk thru all the filesystem inodes and construct a consistent view
  * of the disk quota world. If the quotacheck fails, disable quotas.
  */
@@ -1410,6 +1431,7 @@ xfs_qm_quotacheck(
 	size_t		structsz;
 	xfs_inode_t	*uip, *gip;
 	uint		flags;
+	struct xfs_quotainfo *qi = mp->m_quotainfo;
 
 	count = INT_MAX;
 	structsz = 1;
@@ -1427,6 +1449,11 @@ xfs_qm_quotacheck(
 
 	xfs_notice(mp, "Quotacheck needed: Please wait.");
 
+	qi->qi_shrinker.seeks = DEFAULT_SEEKS;
+	qi->qi_shrinker.shrink = xfs_qm_quotacheck_shrink;
+	qi->qi_shrinker.batch = 1024;
+	register_shrinker(&qi->qi_shrinker);
+
 	/*
 	 * First we go thru all the dquots on disk, USR and GRP/PRJ, and reset
 	 * their counters to zero. We need a clean slate.
@@ -1500,6 +1527,7 @@ xfs_qm_quotacheck(
 	mp->m_qflags |= flags;
 
  error_return:
+	unregister_shrinker(&qi->qi_shrinker);
 	if (error) {
 		xfs_warn(mp,
 	"Quotacheck: Unsuccessful (Error %d): Disabling quotas.",
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 9a9b997..9ee7990 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -73,6 +73,8 @@ typedef struct xfs_qm {
 typedef struct xfs_quotainfo {
 	xfs_inode_t	*qi_uquotaip;	 /* user quota inode */
 	xfs_inode_t	*qi_gquotaip;	 /* group quota inode */
+	struct xfs_mount *qi_mount;
+	struct shrinker	 qi_shrinker;
 	struct list_head qi_dqlist;	 /* all dquots in filesys */
 	struct mutex	 qi_dqlist_lock;
 	int		 qi_dquots;
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
