Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 61EC529E1F
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:25:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03038AC001
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:25:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VYFsbmyAOZS5CZ3G (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:25:10 -0800 (PST)
Subject: [PATCH 21/21] xfsdocs: move directory chapter before xattr chapter
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:24:48 -0800
Message-ID: <20151111192448.14235.56366.stgit@birch.djwong.org>
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

Since the chapter on directories introduces data structures that are
referenced in the xattr chapter, the book should discuss directories first.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../xfs_filesystem_structure.asciidoc              |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 4eec464..4ec563c 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -85,10 +85,10 @@ include::ondisk_inode.asciidoc[]
 
 include::data_extents.asciidoc[]
 
-include::extended_attributes.asciidoc[]
-
 include::directories.asciidoc[]
 
+include::extended_attributes.asciidoc[]
+
 include::symbolic_links.asciidoc[]
 
 :leveloffset: 0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
