Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 184277F6A
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EE3C38F8033
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:22:56 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gstlzc6Ev3wjzegx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:22:50 -0800 (PST)
Subject: [PATCH 01/21] xfsdocs: fix asciidoc confusion w.r.t. include file
	newline at EOF
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:22:25 -0800
Message-ID: <20151111192225.14235.36980.stgit@birch.djwong.org>
In-Reply-To: <20151111192218.14235.13928.stgit@birch.djwong.org>
References: <20151111192218.14235.13928.stgit@birch.djwong.org>
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
