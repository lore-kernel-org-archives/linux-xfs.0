Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52LiNR1131753 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 16:44:23 -0500
From: Robert Herndon <rherndon@sgi.com>
Subject: [PATCH] Add -x mode to include/install-sh;
	add build hints to doc/INSTALL.
Date: Tue,  2 Jun 2009 16:44:40 -0500
Message-Id: <1243979080-5665-1-git-send-email-rherndon@sgi.com>
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
Cc: Robert Herndon <rherndon@sgi.com>


Signed-off-by: Robert Herndon <rherndon@sgi.com>
---
 doc/INSTALL        |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)
 mode change 100644 => 100755 include/install-sh

diff --git a/doc/INSTALL b/doc/INSTALL
index 2ecbf6c..b3a7a3c 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -1,5 +1,5 @@
 This document describes how to configure and build the open source XFS
-commands and utilites ("xfsprogs") from source, and how to install and
+commands and utilities ("xfsprogs") from source, and how to install and
 run them.
 
 See the README file in the top level directory for details about how
@@ -42,8 +42,12 @@ Linux Instructions
 	# make
 	# su root
 	# make install
-	[and optionally, for the development libraries and headers]
+	[and optionally, for the development libraries and basic headers;
+         this is required to build xfsdump and dmapi]
 	# make install-dev
+	[and optionally, for the development libraries and full headers;
+         this is required to build xfstests]
+	# make install-qa
 
    Note that there are so many "install" variants out there that we
    wrote our own script (see "install-sh" in the top level directory).
@@ -98,7 +102,8 @@ Mac OS X Instructions
 	$ make
 	$ su root
 	# make install
-	[and optionally, for the development libraries and headers]
+	[and optionally, for the development libraries and headers;
+         this is required to build xfsdump and dmapi]
 	# make install-dev
 
 
diff --git a/include/install-sh b/include/install-sh
old mode 100644
new mode 100755
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
