Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6BHJPG212197 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 05:17:19 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A28F41A2FCCF
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 03:17:17 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	I0lE7Sno711hLngw for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 03:17:17 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RXt1D-0001lw-At
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 22:17:03 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RXt1C-0004CK-Ks
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 22:17:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfstests: ln failure output has changed again
Date: Tue,  6 Dec 2011 22:16:59 +1100
Message-Id: <1323170219-16080-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1323170219-16080-1-git-send-email-david@fromorbit.com>
References: <1323170219-16080-1-git-send-email-david@fromorbit.com>
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

Recent coreutils packages have changed the failure output of ln(1)
(again!) to be more verbose, breaking the filter in test 103:

-ln: creating symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted
+ln: failed to create symbolic link `SCRATCH_MNT/nosymlink/target' to `SCRATCH_MNT/nosymlink/source': Operation not permitted

Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 103 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/103 b/103
index 1c9994e..e383991 100755
--- a/103
+++ b/103
@@ -57,7 +57,8 @@ _create_scratch()
 _filter_ln()
 {
     sed -e "s,SCRATCH_MNT/nosymlink/target - Operation not permitted,ln: creating symbolic link \`SCRATCH_MNT/nosymlink/target\' to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g" \
-        -e "/SCRATCH_MNT.*to.*SCRATCH_MNT/! s,: Operation not permitted, to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g"
+        -e "/SCRATCH_MNT.*to.*SCRATCH_MNT/! s,: Operation not permitted, to \`SCRATCH_MNT/nosymlink/source\': Operation not permitted,g" \
+	-e "s,failed to create,creating,"
 }
 
 _filter_noymlinks_flag()
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
