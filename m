Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 03ACE7F82
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:37:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C88A6304039
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:37:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KHbiuVYRaSyhVOw4 for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:37:51 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XWw81-0004yG-LJ
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XWw81-00056t-Ju
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: xfs_kset should be static
Date: Thu, 25 Sep 2014 09:37:42 +1000
Message-Id: <1411601863-19594-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1411601863-19594-1-git-send-email-david@fromorbit.com>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

As it is accessed through the struct xfs_mount and can be set up
entirely from fs/xfs/xfs_super.c

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 3 ---
 fs/xfs/xfs_super.c | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fbf0384..d36bdbc 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -61,8 +61,6 @@ static DEFINE_MUTEX(xfs_uuid_table_mutex);
 static int xfs_uuid_table_size;
 static uuid_t *xfs_uuid_table;
 
-extern struct kset *xfs_kset;
-
 /*
  * See if the UUID is unique among mounted XFS filesystems.
  * Mount fails if UUID is nil or a FS with the same UUID is already mounted.
@@ -729,7 +727,6 @@ xfs_mountfs(
 
 	xfs_set_maxicount(mp);
 
-	mp->m_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
 	if (error)
 		goto out;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dcd4b93..9f622fe 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -63,7 +63,7 @@ static const struct super_operations xfs_super_operations;
 static kmem_zone_t *xfs_ioend_zone;
 mempool_t *xfs_ioend_pool;
 
-struct kset *xfs_kset;			/* top-level xfs sysfs dir */
+static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
 #ifdef DEBUG
 static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
 #endif
@@ -1411,6 +1411,7 @@ xfs_fs_fill_super(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
+	mp->m_kobj.kobject.kset = xfs_kset;
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
