Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8267529EA8
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 30C61AC003
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id r0B5CgIpg8e6HTXv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:45 -0800 (PST)
Subject: [PATCH 01/22] xfsdocs: fix asciidoc confusion w.r.t. include file
	newline at EOF
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:15 -0800
Message-ID: <20151219091215.15558.79820.stgit@birch.djwong.org>
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

Space each include one line apart so that asciidoc knows that each
section has ended at included file's EOF.  This prevents it from
spewing horribly confused XML that blows up xmllint if each included
file doesn't itself end with a blank line.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../xfs_filesystem_structure.asciidoc              |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 226bb25..560e549 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -36,18 +36,28 @@ Global Structures
 =================
 
 :leveloffset: 1
+
 include::allocation_groups.asciidoc[]
+
 include::journaling_log.asciidoc[]
+
 include::internal_inodes.asciidoc[]
+
 :leveloffset: 0
 
 Dynamically Allocated Structures
 ================================
 
 :leveloffset: 1
+
 include::ondisk_inode.asciidoc[]
+
 include::data_extents.asciidoc[]
+
 include::extended_attributes.asciidoc[]
+
 include::directories.asciidoc[]
+
 include::symbolic_links.asciidoc[]
+
 :leveloffset: 0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
