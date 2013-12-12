Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A65D7F56
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:22:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B1E28F804C
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:22:38 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QqHHNY7h5JDe82Pk for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:22:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr0bM-0000oI-Mj
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr0bM-0005By-Lo
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 18:22:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] repair: phase 6 is trivially parallelisable
Date: Thu, 12 Dec 2013 18:22:23 +1100
Message-Id: <1386832945-19763-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1386832945-19763-1-git-send-email-david@fromorbit.com>
References: <1386832945-19763-1-git-send-email-david@fromorbit.com>
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

Phase 6 is currently single threaded, but it iterates AGs one at a
time. When there are hundreds of AGs that need scanning, this takes
a long time. Given that all the objects that the AG traversal works
on are per-ag, we can simply parallelise this into a strided AG
processing like phase 3 and 4.

Unpatched:	8m40s
patched:	1m10s (7 threads)

Big win!

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 9 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index d2d4a44..d82f900 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -51,6 +51,7 @@ typedef struct dotdot_update {
 
 static dotdot_update_t		*dotdot_update_list;
 static int			dotdot_update;
+static pthread_mutex_t		dotdot_lock;
 
 static void
 add_dotdot_update(
@@ -64,12 +65,14 @@ add_dotdot_update(
 		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
 			sizeof(dotdot_update_t));
 
+	pthread_mutex_lock(&dotdot_lock);
 	dir->next = dotdot_update_list;
 	dir->irec = irec;
 	dir->agno = agno;
 	dir->ino_offset = ino_offset;
 
 	dotdot_update_list = dir;
+	pthread_mutex_unlock(&dotdot_lock);
 }
 
 /*
@@ -2918,34 +2921,68 @@ update_missing_dotdot_entries(
 	 * these entries parents were updated, rebuild them again
 	 * set dotdot_update flag so processing routines do not count links
 	 */
+	pthread_mutex_lock(&dotdot_lock);
 	dotdot_update = 1;
 	while (dotdot_update_list) {
 		dir = dotdot_update_list;
 		dotdot_update_list = dir->next;
+		dir->next = NULL;
+		pthread_mutex_unlock(&dotdot_lock);
+
 		process_dir_inode(mp, dir->agno, dir->irec, dir->ino_offset);
 		free(dir);
+
+		pthread_mutex_lock(&dotdot_lock);
 	}
+	pthread_mutex_unlock(&dotdot_lock);
 }
 
 static void
 traverse_ags(
-	xfs_mount_t 		*mp)
+	xfs_mount_t		*mp)
 {
-	int			i;
-	work_queue_t		queue;
+	int			i, j;
+	xfs_agnumber_t		agno;
+	work_queue_t		*queues;
 	prefetch_args_t		*pf_args[2];
 
 	/*
 	 * we always do prefetch for phase 6 as it will fill in the gaps
 	 * not read during phase 3 prefetch.
 	 */
-	queue.mp = mp;
-	pf_args[0] = start_inode_prefetch(0, 1, NULL);
-	for (i = 0; i < glob_agcount; i++) {
-		pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
-				pf_args[i & 1]);
-		traverse_function(&queue, i, pf_args[i & 1]);
+	if (!ag_stride) {
+		work_queue_t	queue;
+
+		queue.mp = mp;
+		pf_args[0] = start_inode_prefetch(0, 1, NULL);
+		for (i = 0; i < glob_agcount; i++) {
+			pf_args[(~i) & 1] = start_inode_prefetch(i + 1, 1,
+					pf_args[i & 1]);
+			traverse_function(&queue, i, pf_args[i & 1]);
+		}
+		return;
 	}
+
+	/*
+	 * create one worker thread for each segment of the volume
+	 */
+	queues = malloc(thread_count * sizeof(work_queue_t));
+	for (i = 0, agno = 0; i < thread_count; i++) {
+		create_work_queue(&queues[i], mp, 1);
+		pf_args[0] = NULL;
+		for (j = 0; j < ag_stride && agno < glob_agcount; j++, agno++) {
+			pf_args[0] = start_inode_prefetch(agno, 1, pf_args[0]);
+			queue_work(&queues[i], traverse_function, agno,
+				   pf_args[0]);
+		}
+	}
+
+	/*
+	 * wait for workers to complete
+	 */
+	for (i = 0; i < thread_count; i++)
+		destroy_work_queue(&queues[i]);
+	free(queues);
 }
 
 void
@@ -2957,6 +2994,7 @@ phase6(xfs_mount_t *mp)
 	memset(&zerocr, 0, sizeof(struct cred));
 	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
+	pthread_mutex_init(&dotdot_lock, NULL);
 
 	do_log(_("Phase 6 - check inode connectivity...\n"));
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
