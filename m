Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EC0C929EB4
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:13:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 996AEAC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:13:08 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id QQWpa14RPfiPAXOU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:13:07 -0800 (PST)
Subject: [PATCH 04/22] xfsdocs: convert html entities to regular characters
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:34 -0800
Message-ID: <20151219091234.15558.35406.stgit@birch.djwong.org>
In-Reply-To: <20151219091208.15558.65013.stgit@birch.djwong.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Convert HTML entities back to regular characters, since this is now ASCII.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../XFS_Filesystem_Structure/directories.asciidoc  |   20 ++++++++++----------
 .../extended_attributes.asciidoc                   |   14 +++++++-------
 2 files changed, 17 insertions(+), 17 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/directories.asciidoc b/design/XFS_Filesystem_Structure/directories.asciidoc
index 98143f7..76d5df7 100644
--- a/design/XFS_Filesystem_Structure/directories.asciidoc
+++ b/design/XFS_Filesystem_Structure/directories.asciidoc
@@ -321,8 +321,8 @@ blocksize = 4096
 ...
 dirblklog = 0
 ...
-xfs_db&gt; inode &lt;inode#&gt;
-xfs_db&gt; p
+xfs_db> inode <inode#>
+xfs_db> p
 core.magic = 0x494e
 core.mode = 040755
 core.version = 1
@@ -694,9 +694,9 @@ And the last data block:
 
 
 ----
-xfs_db&gt; dblock 2
-xfs_db&gt; type dir2
-xfs_db&gt; p
+xfs_db> dblock 2
+xfs_db> type dir2
+xfs_db> p
 dhdr.magic = 0x58443244
 dhdr.bestfree[0].offset = 0x70
 dhdr.bestfree[0].length = 0xf90
@@ -892,8 +892,8 @@ blocksize = 4096
 ...
 dirblklog = 2
 ...
-xfs_db&gt; inode &lt;inode#&gt;
-xfs_db&gt; p
+xfs_db> inode <inode#>
+xfs_db> p
 core.magic = 0x494e
 core.mode = 040755
 core.version = 1
@@ -1101,9 +1101,9 @@ u.bmbt.level = 1
 u.bmbt.numrecs = 1
 u.bmbt.keys[1] = [startoff] 1:[0]
 u.bmbt.ptrs[1] = 1:89
-xfs_db&gt; fsblock 89
-xfs_db&gt; type bmapbtd
-xfs_db&gt; p
+xfs_db> fsblock 89
+xfs_db> type bmapbtd
+xfs_db> p
 magic = 0x424d4150
 level = 0
 numrecs = 234
diff --git a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
index 9887332..8b32bdf 100644
--- a/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
+++ b/design/XFS_Filesystem_Structure/extended_attributes.asciidoc
@@ -355,8 +355,8 @@ core.aformat = 2 (extents)
 ...
 a.bmx[0] = [startoff,startblock,blockcount,extentflag]
           0:[0,37535,9,0]
-xfs_db&gt; ablock 0
-xfs_db&gt; p
+xfs_db> ablock 0
+xfs_db> p
 hdr.info.forw = 0
 hdr.info.back = 0
 hdr.info.magic = 0xfbee
@@ -580,9 +580,9 @@ rightsib = 109968
 recs[1-127] = [startoff,startblock,blockcount,extentflag]
           1:[0,81870,1,0]
           ...
-xfs_db&gt; fsblock 109968
-xfs_db&gt; type bmapbtd
-xfs_db&gt; p
+xfs_db> fsblock 109968
+xfs_db> type bmapbtd
+xfs_db> p
 magic = 0x424d4150
 level = 0
 numrecs = 147
@@ -591,8 +591,8 @@ rightsib = null
 recs[1-147] = [startoff,startblock,blockcount,extentflag]
           ...
                              (which is fsblock 81870)
-xfs_db&gt; ablock 0
-xfs_db&gt; p
+xfs_db> ablock 0
+xfs_db> p
 hdr.info.forw = 0
 hdr.info.back = 0
 hdr.info.magic = 0xfebe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
