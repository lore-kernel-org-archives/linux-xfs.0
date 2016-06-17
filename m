Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 032C37DC3
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:33:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E985AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UurCHjcsIg5q3lNr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:33:37 -0700 (PDT)
Subject: [PATCH 027/145] xfs_io: add free-extent error injection type
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:33:33 -0700
Message-ID: <146612721357.16048.1495184945471967839.stgit@birch.djwong.org>
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

Add XFS_ERRTAG_FREE_EXTENT to the types of errors we can inject.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 90ccda8..12e0fb3 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -74,7 +74,9 @@ error_tag(char *name)
 		{ XFS_ERRTAG_DIOWRITE_IOERR,		"diowrite" },
 #define XFS_ERRTAG_BMAPIFORMAT                          21
 		{ XFS_ERRTAG_BMAPIFORMAT,		"bmapifmt" },
-#define XFS_ERRTAG_MAX                                  22
+#define XFS_ERRTAG_FREE_EXTENT				22
+		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
+#define XFS_ERRTAG_MAX                                  23
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
