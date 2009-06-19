Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5JHrB3B074502 for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 12:53:11 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56C99129FDFA
	for <xfs@oss.sgi.com>; Fri, 19 Jun 2009 10:53:37 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id rC45r8dmVj1gH1Fl for <xfs@oss.sgi.com>;
	Fri, 19 Jun 2009 10:53:37 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 2/3] Fix common.config to allow SCRATCH_DEV and SCRATCH_MNT to
	be optional
Date: Fri, 19 Jun 2009 13:53:32 -0400
Message-Id: <1245434013-9433-2-git-send-email-tytso@mit.edu>
In-Reply-To: <1245434013-9433-1-git-send-email-tytso@mit.edu>
References: <1245434013-9433-1-git-send-email-tytso@mit.edu>
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
Cc: tytso@mit.edu

Commit 3ae9f2f8 purports to allow SCRATCH_DEV and SCRATCH_MNT to be
optional, but tests in common.config will cause check to exit with an
error if these environment variables are not defined.  Fix this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 common.config |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/common.config b/common.config
index 64df893..b304247 100644
--- a/common.config
+++ b/common.config
@@ -23,10 +23,10 @@
 #                   mounted XFS file system, needs to be be world
 #                   writeable
 # TEST_DEV -        device for file system containing TEST_DIR
-# SCRATCH_DEV -     device you can make a scratch file system on
-# SCRATCH_MNT -     mount point for scratch file system
 #
 # and optionally:
+# SCRATCH_DEV -     device you can make a scratch file system on
+# SCRATCH_MNT -     mount point for scratch file system
 # SCRATCH_LOGDEV -  scratch log device for external log testing
 # SCRATCH_RTDEV -   scratch rt dev
 # TEST_LOGDEV -     test log device for external log testing
@@ -202,8 +202,8 @@ known_hosts()
   [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
   [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
 
-  [ -z "$SCRATCH_MNT" ]    && MC="$MC SCRATCH_MNT"
-  [ -z "$SCRATCH_DEV" ]    && MC="$MC SCRATCH_DEV"
+#  [ -z "$SCRATCH_MNT" ]    && MC="$MC SCRATCH_MNT"
+#  [ -z "$SCRATCH_DEV" ]    && MC="$MC SCRATCH_DEV"
 
   [ "$MC" ] && (echo "Warning: need to define parameters for host $HOST";\
 	        echo "       or set variables:"; \
-- 
1.6.3.2.1.gb9f7d.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
