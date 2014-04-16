Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E8C437F50
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 23:18:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF74F30407F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 21:18:41 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Iqpb414RH3g9ylok (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 21:18:40 -0700 (PDT)
From: NeilBrown <neilb@suse.de>
Date: Wed, 16 Apr 2014 14:03:36 +1000
Subject: [PATCH 07/19] nfsd and VM: use PF_LESS_THROTTLE to avoid throttle
	in shrink_inactive_list.
Message-ID: <20140416040336.10604.55772.stgit@notabene.brown>
In-Reply-To: <20140416033623.10604.69237.stgit@notabene.brown>
References: <20140416033623.10604.69237.stgit@notabene.brown>
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
To: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

nfsd already uses PF_LESS_THROTTLE (and is the only user) to avoid
throttling while dirtying pages.  Use it also to avoid throttling while
doing direct reclaim as this can stall nfsd in the same way.

Also only set PF_LESS_THROTTLE when handling a 'write' request for a
local connection.  This is the only time when the throttling can cause
a problem.  In other cases we should throttle if the system is busy.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/nfsd/nfssvc.c |    6 ------
 fs/nfsd/vfs.c    |    6 ++++++
 mm/vmscan.c      |    7 +++++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 6af8bc2daf7d..cd24aa76e58d 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -593,12 +593,6 @@ nfsd(void *vrqstp)
 	nfsdstats.th_cnt++;
 	mutex_unlock(&nfsd_mutex);
 
-	/*
-	 * We want less throttling in balance_dirty_pages() so that nfs to
-	 * localhost doesn't cause nfsd to lock up due to all the client's
-	 * dirty pages.
-	 */
-	current->flags |= PF_LESS_THROTTLE;
 	set_freezable();
 
 	/*
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6d7be3f80356..be2d7af3beee 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -913,6 +913,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 	int			stable = *stablep;
 	int			use_wgather;
 	loff_t			pos = offset;
+	unsigned int		pflags;
+
+	if (rqstp->rq_local)
+		current_set_flags_nested(&pflags, PF_LESS_THROTTLE);
 
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
@@ -950,6 +954,8 @@ out_nfserr:
 		err = 0;
 	else
 		err = nfserrno(host_err);
+	if (rqstp->rq_local)
+		current_restore_flags_nested(&pflags, PF_LESS_THROTTLE);
 	return err;
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 05de3289d031..1b7c4e44f0a1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1552,7 +1552,8 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * implies that pages are cycling through the LRU faster than
 		 * they are written so also forcibly stall.
 		 */
-		if (nr_unqueued_dirty == nr_taken || nr_immediate)
+		if ((nr_unqueued_dirty == nr_taken || nr_immediate)
+		    && !current_test_flags(PF_LESS_THROTTLE))
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
@@ -1561,7 +1562,9 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	 * is congested. Allow kswapd to continue until it starts encountering
 	 * unqueued dirty pages or cycling through the LRU too quickly.
 	 */
-	if (!sc->hibernation_mode && !current_is_kswapd())
+	if (!sc->hibernation_mode &&
+	    !current_is_kswapd() &&
+	    !current_test_flags(PF_LESS_THROTTLE))
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
