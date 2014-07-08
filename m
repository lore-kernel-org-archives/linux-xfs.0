Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 926F47F54
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 18:41:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B056AC005
	for <xfs@oss.sgi.com>; Tue,  8 Jul 2014 16:41:48 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3ZLnBPuN5nAdFeY3 for <xfs@oss.sgi.com>;
	Tue, 08 Jul 2014 16:41:46 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X4f14-0006T3-LQ
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X4f14-0000tA-KY
	for xfs@oss.sgi.com; Wed, 09 Jul 2014 09:41:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] repair: handle uncorrected corruptions in phase 2
Date: Wed,  9 Jul 2014 09:41:40 +1000
Message-Id: <1404862900-3369-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1404862900-3369-1-git-send-email-david@fromorbit.com>
References: <1404862900-3369-1-git-send-email-david@fromorbit.com>
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

Some of the AG header corruptions detected by the IO verifiers
cannot be corrected in phase 2 when we do the initial scan of the
AGs. Correcting some errors cannot be done until a full rebuild of
the trees is done in phase 5.

Hence we can end up with a "clean" AGF/AGI buffer but have a
EFSCORRUPTED error on the buffer. This results in an assert failing:

	ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);

and repair not beign able to fix the problems it has tripped over.
Hence the assert that we corrected all corruptions in the buffers
is not valid and should be removed.

Reported-by: Hans Kraus <hans.w.kraus@gmx.at>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/scan.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index f29ff8d..142d8d7 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -1572,14 +1572,13 @@ scan_ag(
 
 	/*
 	 * Only pay attention to CRC/verifier errors if we can correct them.
-	 * While there, ensure that we corrected a corruption error if the
-	 * verifier detected one.
+	 * Note that we can get uncorrected EFSCORRUPTED errors here because
+	 * the verifier will flag on out of range values that we can't correct
+	 * until phase 5 when we have all the information necessary to rebuild
+	 * the freespace/inode btrees. We can correct bad CRC errors
+	 * immediately, though.
 	 */
 	if (!no_modify) {
-		ASSERT(agi_dirty || agibuf->b_error != EFSCORRUPTED);
-		ASSERT(agf_dirty || agfbuf->b_error != EFSCORRUPTED);
-		ASSERT(sb_dirty || sbbuf->b_error != EFSCORRUPTED);
-
 		agi_dirty += (agibuf->b_error == EFSBADCRC);
 		agf_dirty += (agfbuf->b_error == EFSBADCRC);
 		sb_dirty += (sbbuf->b_error == EFSBADCRC);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
