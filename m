Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C00E5826D
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 931758F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:49 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XesavdgUgD0Tr07J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:52:47 -0700 (PDT)
Subject: [PATCH 57/71] man: document the reflink inode flag in fsxattr
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:52:43 -0700
Message-ID: <147216916395.4420.14137061415373193422.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

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
