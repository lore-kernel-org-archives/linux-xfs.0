Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C2217F6F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 23:31:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29815AC0A5
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 21:31:37 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rbtVShETyaGid8eH for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 21:31:35 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbNRG-0002z9-3K
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbNRG-0007fn-2n
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 15:31:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 30/30] xfsprogs: kill experimental warnings for v5 filesystems
Date: Wed, 30 Oct 2013 15:31:21 +1100
Message-Id: <1383107481-28937-31-git-send-email-david@fromorbit.com>
In-Reply-To: <1383107481-28937-1-git-send-email-david@fromorbit.com>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
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
index 65ddc2f..48b1a97 100644
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
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
