Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53878 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbeKBIYP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Nov 2018 04:24:15 -0400
Subject: [PATCH 1/8] quota: clean out speculative preallocations when
 checking quota usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 01 Nov 2018 16:19:09 -0700
Message-ID: <154111434915.6577.14047300095921080052.stgit@magnolia>
In-Reply-To: <154111434286.6577.15010861884505931015.stgit@magnolia>
References: <154111434286.6577.15010861884505931015.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On XFS, the only reliable way to clean out speculative post-eof
preallocations, delayed allocations, and speculative cow preallocations
is to cycle the filesystem mount.  Since we're comparing the post-test
quota counts against a freshly quotacheck to look for leaks, it's fine
to cycle the mount.  This eliminates sporadic quota count failures when
running xfstests with quotas enabled.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/quota |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/common/quota b/common/quota
index 993ff5de..9309e786 100644
--- a/common/quota
+++ b/common/quota
@@ -260,10 +260,10 @@ _check_quota_usage()
 		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
 		;;
 	xfs)
-		# Clear out speculative preallocations to eliminate them
-		# as a source of intermittent orig/checked differences.
-		test -x "$XFS_SPACEMAN_PROG" && \
-			"$XFS_SPACEMAN_PROG" -c 'prealloc -s' $SCRATCH_MNT
+		# Only way to make this reliable with cow/delalloc/speculative
+		# preallocations is to unmount and remount the whole mess...
+		_scratch_unmount
+		_scratch_mount "-o usrquota,grpquota"
 		;;
 	*)
 		;;
