Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52LrmKR132228 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 16:53:48 -0500
From: Robert Herndon <rherndon@sgi.com>
Subject: [PATCH] Add hint to see xfsprogs' doc/INSTALL in doc/INSTALL.
Date: Tue,  2 Jun 2009 16:54:02 -0500
Message-Id: <1243979642-10017-1-git-send-email-rherndon@sgi.com>
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
 doc/INSTALL |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/doc/INSTALL b/doc/INSTALL
index 6c32f28..7cd71b4 100644
--- a/doc/INSTALL
+++ b/doc/INSTALL
@@ -1,5 +1,5 @@
 This document describes how to configure and build the open source XFS
-commands and utilites ("xfsdump") from source, and how to install and
+commands and utilities ("xfsdump") from source, and how to install and
 run them.
 
 0. If you have the binary rpm, simply install it and skip to step 2 (below).
@@ -13,6 +13,9 @@ run them.
 
 1. Configure, build and install the package
 
+   Ensure that you have installed the required libraries and
+   header files.  See doc/INSTALL in the xfsprogs repository.
+
    The xfsdump package uses autoconf/configure and expects a GNU build
    environment (your platform must at least have both autoconf and gmake). 
    You will also need to have installed either the e2fsprogs-devel package
-- 
1.5.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
