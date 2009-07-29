Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TH8hP0003080 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 12:08:43 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A2B6141F4E9
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 10:09:30 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 4s7hDgQ1TxK5UiFK for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2009 10:09:30 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n6TH9TgU020682
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 13:09:29 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6TH9Sil012809
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 13:09:28 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n6TH9RAe010088
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 13:09:28 -0400
Message-ID: <4A708247.7040509@sandeen.net>
Date: Wed, 29 Jul 2009 12:09:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: do bounds checking in frag's scanfunc_bmap
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
To: xfs mailing list <xfs@oss.sgi.com>

This is for http://oss.sgi.com/bugzilla/show_bug.cgi?id=842
Bug 842 -  xfs_db crashes on 'frag'

The nrecs in scanfunc_bmap was corrupted & out of bounds, causing
the loop in process_bmbt_reclist to walk well past allocated memory
and eventually segfault.

Add checking to this scanfunc_bmap() similar to that in similar
functions for check, metadump, and repair.

I'm not sure if we can/should print out any more information here...

# db/xfs_db -r -c frag xfs.img 
invalid numrecs (46311) in bmapbtd block
actual 38085, ideal 37731, fragmentation factor 0.93%

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/db/frag.c b/db/frag.c
index 925863d..bba91ed 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -437,15 +437,29 @@ scanfunc_bmap(
 	int			i;
 	xfs_bmbt_ptr_t		*pp;
 	xfs_bmbt_rec_t		*rp;
+	int			nrecs;
+
+	nrecs = be16_to_cpu(block->bb_numrecs);
 
 	if (level == 0) {
+		if (nrecs > mp->m_bmap_dmxr[0]) {
+			dbprintf(_("invalid numrecs (%u) in %s block\n"),
+				   nrecs, typtab[btype].name);
+			return;
+		}
 		rp = XFS_BMBT_REC_ADDR(mp, block, 1);
 		process_bmbt_reclist((xfs_bmbt_rec_32_t *)rp, 
-				be16_to_cpu(block->bb_numrecs), extmapp);
+				nrecs, extmapp);
+		return;
+	}
+
+	if (nrecs > mp->m_bmap_dmxr[1]) {
+		dbprintf(_("invalid numrecs (%u) in %s block\n"),
+			   nrecs, typtab[btype].name);
 		return;
 	}
 	pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[0]);
-	for (i = 0; i < be16_to_cpu(block->bb_numrecs); i++)
+	for (i = 0; i < nrecs; i++)
 		scan_lbtree(be64_to_cpu(pp[i]), level, scanfunc_bmap, extmapp, 
 									btype);
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
