Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52JN6Yi124416 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 14:23:06 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 517573040C0
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 12:23:24 -0700 (PDT)
From: robert herndon <rherndon@sgi.com>
Subject: [PATCH] Update xfstests' README to document method/necessity
Date: Tue,  2 Jun 2009 14:23:24 -0500
Message-Id: <1243970604-13732-1-git-send-email-rherndon@attica.americas.sgi.com>
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
Cc: robert herndon <rherndon@elm.eagan>

From: robert herndon <rherndon@elm.eagan>

---
 README |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/README b/README
index 375e07c..f9725b4 100644
--- a/README
+++ b/README
@@ -18,6 +18,17 @@ Preparing system for tests (IRIX and Linux):
 
     - compile XFS into your kernel or load XFS modules
     - install user tools including mkfs.xfs, xfs_db & xfs_bmap
+    - install header files required to build xfstests' programs:
+
+           # cd <...>/xfsprogs
+           # make install-qa
+
+           % cd <...>/xfstests
+           % make xfstests
+
+      This creates the directory /usr/include/xfs and installs
+      files there that are required to compile the programs in
+      this directory.
     - If you wish to run the udf components of the suite install 
       mkfs_udf and udf_db for IRIX and mkudffs for Linux. Also download and 
       build the Philips UDF Verification Software from 
-- 
1.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
