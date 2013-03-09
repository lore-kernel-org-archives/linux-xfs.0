Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 656217F6B
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:22:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44E778F8035
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 07:21:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2RpkbLhkUe90etLV for <xfs@oss.sgi.com>;
	Sat, 09 Mar 2013 07:21:58 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 288A363C3D47
	for <xfs@oss.sgi.com>; Sat,  9 Mar 2013 09:21:58 -0600 (CST)
Message-ID: <513B5393.4000203@sandeen.net>
Date: Sat, 09 Mar 2013 09:21:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: skip freelist scans of corrupt agf
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
To: xfs-oss <xfs@oss.sgi.com>

If an agf has bad values in the freelist, this can wreak
havoc if, for example, first > last and the loop
never exits; we index agfl->agfl_bno[i] off into the weeds.

If they're off, warn about it and skip the scan.

Thisis done both in xfs_check and xfs_db's freespace cmd.

Also fix uninit'd variable "i" from previous, similar fix
for xfs_repair.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/db/check.c b/db/check.c
index e601e0a..35325b7 100644
--- a/db/check.c
+++ b/db/check.c
@@ -4112,6 +4112,16 @@ scan_freelist(
 		return;
 	}
 	i = be32_to_cpu(agf->agf_flfirst);
+
+	/* verify agf values before proceeding */
+	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp) ||
+	    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp)) {
+		dbprintf(_("agf %d freelist blocks bad, skipping "
+			  "freelist scan\n"), i);
+		pop_cur();
+		return;
+	}
+
 	count = 0;
 	for (;;) {
 		bno = be32_to_cpu(agfl->agfl_bno[i]);
diff --git a/db/freesp.c b/db/freesp.c
index c4dabad..472b1f7 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -239,6 +239,16 @@ scan_freelist(
 				XFS_FSS_TO_BB(mp, 1), DB_RING_IGN, NULL);
 	agfl = iocur_top->data;
 	i = be32_to_cpu(agf->agf_flfirst);
+
+	/* verify agf values before proceeding */
+	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp) ||
+	    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp)) {
+		dbprintf(_("agf %d freelist blocks bad, skipping "
+			  "freelist scan\n"), i);
+		pop_cur();
+		return;
+	}
+
 	for (;;) {
 		bno = be32_to_cpu(agfl->agfl_bno[i]);
 		addtohist(seqno, bno, 1);
diff --git a/repair/scan.c b/repair/scan.c
index 1d39bdc..6a62dff 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1066,6 +1066,7 @@ scan_freelist(
 		return;
 	}
 	agfl = XFS_BUF_TO_AGFL(agflbuf);
+	i = be32_to_cpu(agf->agf_flfirst);
 
 	if (no_modify) {
 		/* agf values not fixed in verify_set_agf, so recheck */
@@ -1078,7 +1079,6 @@ scan_freelist(
 	} else /* should have been fixed in verify_set_agf() */
 		ASSERT(0);
 
-	i = be32_to_cpu(agf->agf_flfirst);
 	count = 0;
 	for (;;) {
 		bno = be32_to_cpu(agfl->agfl_bno[i]);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
