Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D527F8008
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 15:23:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ACCE5304059
	for <xfs@oss.sgi.com>; Sat,  2 Mar 2013 13:23:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wCnu4zhtuWAveton for <xfs@oss.sgi.com>;
	Sat, 02 Mar 2013 13:23:09 -0800 (PST)
Message-ID: <51326DC0.8030403@sandeen.net>
Date: Sat, 02 Mar 2013 15:23:12 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfs_repair: skip freelist scan of corrupt agf in no-modify
	mode
References: <51313DE8.5080104@sandeen.net>
In-Reply-To: <51313DE8.5080104@sandeen.net>
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
Cc: Ole Tange <tange@binf.ku.dk>

In xfs_repair's no-modify mode (-n), verify_set_agf doesn't fix up
bad freelist blocks that it finds.  When we get to scan_freelist,
this can wreak havoc if, for example, first > last and the loop
never exits; we index agfl->agfl_bno[i] off into the weeds.

To fix this, re-check the values in no-modify mode, and if
they're off, warn about it and skip the scan.

Reported-by: Ole Tange <tange@binf.ku.dk>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Remove dumb mistakes :/

diff --git a/repair/scan.c b/repair/scan.c
index 5345094..1d39bdc 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1066,6 +1066,18 @@ scan_freelist(
 		return;
 	}
 	agfl = XFS_BUF_TO_AGFL(agflbuf);
+
+	if (no_modify) {
+		/* agf values not fixed in verify_set_agf, so recheck */
+		if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp) ||
+		    be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp)) {
+			do_warn(_("agf %d freelist blocks bad, skipping "
+				  "freelist scan\n"), i);
+			return;
+		}
+	} else /* should have been fixed in verify_set_agf() */
+		ASSERT(0);
+
 	i = be32_to_cpu(agf->agf_flfirst);
 	count = 0;
 	for (;;) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
