Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EE6F8078
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:32:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2C0E8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:04 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 94ck3CRAGOnIeqTC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:32:02 -0700 (PDT)
Subject: [PATCH 011/145] man: document the DAX fsxattr inode flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:31:54 -0700
Message-ID: <146612711418.16048.15527594819477737762.stgit@birch.djwong.org>
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

Document the new inode flag in struct fsxattr for DAX.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man/man3/xfsctl.3 |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index e84b829..9e7f138 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -225,6 +225,11 @@ group and so files within different directories will not interleave
 extents on disk. The reservation is only active while files are being
 created and written into the directory.
 .TP
+.SM "Bit 15 (0x8000) \- XFS_XFLAG_DAX"
+If the filesystem lives on directly accessible persistent memory, reads and
+writes to this file will go straight to the persistent memory, bypassing the
+page cache.
+.TP
 .SM "Bit 31 (0x80000000) \- XFS_XFLAG_HASATTR"
 The file has extended attributes associated with it.
 .RE

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
