Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E9457F5F
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:23:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3FF358F8035
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:06 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mhixg7N0q02FQSsR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:23:00 -0800 (PST)
Subject: [PATCH 02/21] xfsdocs: update book subtitles and headings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:22:31 -0800
Message-ID: <20151111192231.14235.80898.stgit@birch.djwong.org>
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
