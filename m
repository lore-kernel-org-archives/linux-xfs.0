Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA1JrXNI129316 for <xfs@oss.sgi.com>; Tue, 1 Nov 2011 14:53:33 -0500
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH 2/4] xfstests: refactor xfsdump quota checking
Date: Tue,  1 Nov 2011 14:53:05 -0500
Message-Id: <1320177187-18871-3-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320177187-18871-1-git-send-email-wkendall@sgi.com>
References: <1320177187-18871-1-git-send-email-wkendall@sgi.com>
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

Tests can enable/disable quota checking by passing -q or -Q to the
various dump and restore helper routines. But -q and -Q are valid
xfsdump/xfsrestore options, so in addition to being confusing, tests
cannot use these options. Use --check-quota and --no-check-quota
instead.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 061         |    3 ++-
 common.dump |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/061 b/061
index 414675f..2b08e11 100755
--- a/061
+++ b/061
@@ -48,7 +48,8 @@ dump_file=src/dumpfile # override dump_file to checked-in dumpfile
 session_label="stress_056"
 # we have no quotas to restore
 # if we happen to run this on crackle then put the hostname back
-_do_restore_file -Q  | sed -e 's/HOSTNAME/crackle/g' -e 's#SCRATCH_DEV#/dev/dsk/dks0d2s1#'
+_do_restore_file --no-check-quota |
+sed -e 's/HOSTNAME/crackle/g' -e 's#SCRATCH_DEV#/dev/dsk/dks0d2s1#'
 _diff_compare_sub
 _ls_nodate_compare_sub
 
diff --git a/common.dump b/common.dump
index 56b348a..09f1a91 100644
--- a/common.dump
+++ b/common.dump
@@ -903,10 +903,10 @@ _parse_args()
 	    multi=$2
 	    shift
 	    ;;
-        -q)
+        --check-quota)
             do_quota_check=true
             ;;
-        -Q)
+        --no-check-quota)
             do_quota_check=false
             ;;
         -l|-d)
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
