Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0BF88363
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:43:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A47B58F8050
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id zxMMka6hadXNKXbw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:33 -0700 (PDT)
Subject: [PATCH 121/145] man: document the reflink inode flag in fsxattr
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:43:27 -0700
Message-ID: <146612780777.16048.2394921482033235268.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

Document the new inode flag in struct fsxattr for reflink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 9e7f138..ef6c992 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -230,6 +230,16 @@ If the filesystem lives on directly accessible persistent memory, reads and
 writes to this file will go straight to the persistent memory, bypassing the
 page cache.
 .TP
+.SM "Bit 16 (0x10000) \- XFS_XFLAG_REFLINK"
+This file is sharing or has shared blocks with another file.
+This flag can be set by reflinking or deduping blocks with another file
+and cleared by fallocating the entire file to pre-copy all shared extents.
+A file cannot have
+.BR XFS_XFLAG_REFLINK
+and
+.BR XFS_XFLAG_DAX
+set at the same time, that is to say that DAX files cannot share blocks.
+.TP
 .SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
 The file has extended attributes associated with it.
 .RE

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
