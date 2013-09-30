Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAA307F9C
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CC9878F8049
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:59 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	f1JgGBaSxwiHh5uo for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:58 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxa-0006Pk-Fj
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxa-0002Ha-EO
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 32/32] xfsprogs: kill experimental warnings for v5 filesystems
Date: Mon, 30 Sep 2013 13:15:44 +1000
Message-Id: <1380510944-8571-33-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

With xfsprogs now being close to feature complete on v5 filesystems,
remove the experimental warnings from the superblock verifier. This
means that we don't need to filter such warnings from the output in
xfstests and so we can see exactly what tests are failing due to
code deficiencies rather than from detecting warning noise.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 8b90b88..6febcb3 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -180,10 +180,6 @@ xfs_mount_validate_sb(
 	 * write validation, we don't need to check feature masks.
 	 */
 	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
-		xfs_alert(mp,
-"Version 5 superblock detected. xfsprogs has EXPERIMENTAL support enabled!\n"
-"Use of these features is at your own risk!");
-
 		if (xfs_sb_has_compat_feature(sbp,
 					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
 			xfs_warn(mp,
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
