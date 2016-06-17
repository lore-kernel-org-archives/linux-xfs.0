Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BA29858E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46289304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:33 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gVZsOTndCsCFVtrB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:32 -0700 (PDT)
Subject: [PATCH 3/6] xfsdocs: update the on-disk format with changes for
	Linux 4.5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:48:27 -0700
Message-ID: <146612810746.25586.15997328091238540438.stgit@birch.djwong.org>
In-Reply-To: <146612808918.25586.1147874927753492795.stgit@birch.djwong.org>
References: <146612808918.25586.1147874927753492795.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 4aabc55..dc1fad2 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -66,9 +66,10 @@ of the literal area and +di_forkoff+. The attribute fork is located between
 [[Inode_Core]]
 == Inode Core
 
-The inode's core is 96 bytes in size and contains information about the file
-itself including most stat data information about data and attribute forks after
-the core within the inode. It uses the following structure:
+The inode's core is 96 bytes on a V4 filesystem and 176 bytes on a V5
+filesystem.  It contains information about the file itself including most stat
+data information about data and attribute forks after the core within the
+inode. It uses the following structure:
 
 [source, c]
 ----
@@ -313,8 +314,16 @@ Counts the number of changes made to the attributes in this inode.
 Log sequence number of the last inode write.
 
 *di_flags2*::
-Specifies extended flags associated with a v3 inode.  There are no flags defined
-currently.
+Specifies extended flags associated with a v3 inode.
+
+.Version 3 Inode flags
+[options="header"]
+|=====
+| Flag				| Description
+| +XFS_DIFLAG2_DAX+		|
+For a file, enable DAX to increase performance on persistent-memory storage.
+If set on a directory, files created in the directory will inherit this flag.
+|=====
 
 *di_pad2*::
 Padding for future expansion of the inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
