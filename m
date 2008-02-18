Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 22:33:29 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1I6XMZk029622
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:33:26 -0800
Received: from mta3.srv.hcvlny.cv.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45E37E4B995
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:33:47 -0800 (PST)
Received: from mta3.srv.hcvlny.cv.net (mta3.srv.hcvlny.cv.net [167.206.4.198]) by cuda.sgi.com with ESMTP id BzYgrNzTBBQYpWlk for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 22:33:47 -0800 (PST)
Received: from freyr.home (ool-44c218a8.dyn.optonline.net [68.194.24.168])
 by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0JWF00F938WAU1N0@mta3.srv.hcvlny.cv.net> for xfs@oss.sgi.com;
 Mon, 18 Feb 2008 01:33:47 -0500 (EST)
Date: Mon, 18 Feb 2008 01:32:38 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: [PATCH 1/1] Documentation: correct XFS defaults for ikeep/noikeep
 mount options
Message-id: <1203316358-31840-1-git-send-email-jeffpc@josefsipek.net>
Content-transfer-encoding: 7BIT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, hch@infradead.org
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>

Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
---
 Documentation/filesystems/xfs.txt |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 74aeb14..655bdfe 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -59,9 +59,10 @@ When mounting an XFS filesystem, the following options are accepted.
 
   ikeep/noikeep
 	When inode clusters are emptied of inodes, keep them around
-	on the disk (ikeep) - this is the traditional XFS behaviour
-	and is still the default for now.  Using the noikeep option,
-	inode clusters are returned to the free space pool.
+	on the disk (ikeep) - this is the traditional XFS behaviour.
+	Using the noikeep option, inode clusters are returned to the
+	free space pool. noikeep is the default for non-DMAPI mounts,
+	while ikeep is the default when DMAPI is in use.
 
   inode64
 	Indicates that XFS is allowed to create inodes at any location
-- 
1.5.4.rc2.85.g9de45-dirty
