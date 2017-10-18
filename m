Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38671 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdJRXhk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Oct 2017 19:37:40 -0400
Subject: [PATCH 1/5] quota: clear speculative delalloc when checking quota
 usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Oct 2017 16:37:36 -0700
Message-ID: <150836985643.27213.927427950548904105.stgit@magnolia>
In-Reply-To: <150836985024.27213.3715197937819365388.stgit@magnolia>
References: <150836985024.27213.3715197937819365388.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Occasionally speculative preallocation kicks in when writing files to a
filesystem under test.  These preallocations consume quota and /usually/
aren't around after we drop_caches, but there's nothing to guarantee
that they actually have, so the quota reports will be different before
and after the fs remount, causing sporadic test failures in
generic/{23[123],270}.

We now have xfs_spaceman which can instruct XFS to forcibly remove the
speculative preallocations.  This fixes the sporadic failures, at
least for XFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/config |    1 +
 common/quota  |    6 ++++++
 2 files changed, 7 insertions(+)


diff --git a/common/config b/common/config
index 8844173..96503c6 100644
--- a/common/config
+++ b/common/config
@@ -149,6 +149,7 @@ export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
 export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
 export XFS_DB_PROG="`set_prog_path xfs_db`"
 export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
+export XFS_SPACEMAN_PROG="`set_prog_path xfs_spaceman`"
 export XFS_SCRUB_PROG="`set_prog_path xfs_scrub`"
 export XFS_PARALLEL_REPAIR_PROG="`set_prog_path xfs_prepair`"
 export XFS_PARALLEL_REPAIR64_PROG="`set_prog_path xfs_prepair64`"
diff --git a/common/quota b/common/quota
index d027a8c..2611c48 100644
--- a/common/quota
+++ b/common/quota
@@ -267,6 +267,12 @@ _check_quota_usage()
 		VFS_QUOTA=1
 		quotaon -f -u -g $SCRATCH_MNT 2>/dev/null
 		;;
+	xfs)
+		# Clear out speculative preallocations to eliminate them
+		# as a source of intermittent orig/checked differences.
+		test -x "$XFS_SPACEMAN_PROG" && \
+			"$XFS_SPACEMAN_PROG" -c 'prealloc -s' $SCRATCH_MNT
+		;;
 	*)
 		;;
 	esac

