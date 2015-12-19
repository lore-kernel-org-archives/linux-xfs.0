Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8936A29EB4
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C463304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:48 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SOcnLJYm2BCutzkA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:47 -0800 (PST)
Subject: [PATCH 02/22] xfsdocs: update book subtitles and headings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:21 -0800
Message-ID: <20151219091221.15558.28333.stgit@birch.djwong.org>
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

The current subtitle is redundant and since this is the third edition
(the second ed. came out in 2006) we might as well note that.  Update
some of the headings to make it clear that we're talking about disk
format and not much else.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 design/XFS_Filesystem_Structure/docinfo.xml        |    2 +-
 .../xfs_filesystem_structure.asciidoc              |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/docinfo.xml b/design/XFS_Filesystem_Structure/docinfo.xml
index d56aaed..cb5ffe7 100644
--- a/design/XFS_Filesystem_Structure/docinfo.xml
+++ b/design/XFS_Filesystem_Structure/docinfo.xml
@@ -1,4 +1,4 @@
-<subtitle>Documentation of the XFS filesystem on-disk structures</subtitle>
+<subtitle>3rd Edition</subtitle>
 <abstract>
 	<para>This book documents the XFS Filesystem Structure</para>
 </abstract>
diff --git a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
index 560e549..a78f3b9 100644
--- a/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
+++ b/design/XFS_Filesystem_Structure/xfs_filesystem_structure.asciidoc
@@ -6,13 +6,13 @@
 // and we really need an area to set up various docbook sections like copyright
 // and legal notice sections.
 //
-XFS Filesystem Structure
-========================
+XFS Filesystem Disk Structures
+==============================
 :doctype: book
 :docinfo1:
 
-Introduction
-============
+High Level Design
+=================
 
 [partintro]
 --

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
