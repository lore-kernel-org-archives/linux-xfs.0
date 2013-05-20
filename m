Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B1F97F55
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 01:53:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 136D8304043
	for <xfs@oss.sgi.com>; Sun, 19 May 2013 23:53:20 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k0op7rjn2yOBlEPU for <xfs@oss.sgi.com>;
	Sun, 19 May 2013 23:53:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UeJy9-0006r9-Q0
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:17 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UeJy9-0006W7-Mf
	for xfs@oss.sgi.com; Mon, 20 May 2013 16:53:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs_repair: make directory freespace table CRC format
	aware.
Date: Mon, 20 May 2013 16:53:03 +1000
Message-Id: <1369032783-24973-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1369032783-24973-1-git-send-email-david@fromorbit.com>
References: <1368789205-19969-1-git-send-email-david@fromorbit.com>
	<1369032783-24973-1-git-send-email-david@fromorbit.com>
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

We fail to take into account the format of the directory block when
reading the best free space form a directory data block for free
space block verification. This causes occasionaly failures in
xfstests.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 1fdd4c8..2905a1c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1395,6 +1395,7 @@ longform_dir2_entry_check_data(
 	xfs_dir2_db_t		db;
 	xfs_dir2_data_entry_t	*dep;
 	xfs_dir2_data_unused_t	*dup;
+	struct xfs_dir2_data_free *bf;
 	char			*endptr;
 	int			error;
 	xfs_fsblock_t		firstblock;
@@ -1808,7 +1809,10 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 		libxfs_dir2_data_log_header(tp, bp);
 	libxfs_bmap_finish(&tp, &flist, &committed);
 	libxfs_trans_commit(tp, 0);
-	freetab->ents[db].v = be16_to_cpu(d->bestfree[0].length);
+
+	/* record the largest free space in the freetab for later checking */
+	bf = xfs_dir3_data_bestfree_p(d);
+	freetab->ents[db].v = be16_to_cpu(bf[0].length);
 	freetab->ents[db].s = 0;
 }
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
