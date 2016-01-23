Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 290517F51
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:36:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1C3348F8040
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:24 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id DSi00FYHPvT9w9Wj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:36:22 -0800 (PST)
Subject: [PATCH 2/2] xfsdocs: update the on-disk format with changes for
	Linux 4.5
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:36:19 -0800
Message-ID: <20160123003619.2605.76125.stgit@birch.djwong.org>
In-Reply-To: <20160123003613.2605.14510.stgit@birch.djwong.org>
References: <20160123003613.2605.14510.stgit@birch.djwong.org>
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
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
index 4aabc55..f1b0421 100644
--- a/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
+++ b/design/XFS_Filesystem_Structure/ondisk_inode.asciidoc
@@ -66,7 +66,7 @@ of the literal area and +di_forkoff+. The attribute fork is located between
 [[Inode_Core]]
 == Inode Core
 
-The inode's core is 96 bytes in size and contains information about the file
+The inode's core is 176 bytes in size and contains information about the file
 itself including most stat data information about data and attribute forks after
 the core within the inode. It uses the following structure:
 
@@ -313,8 +313,16 @@ Counts the number of changes made to the attributes in this inode.
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
