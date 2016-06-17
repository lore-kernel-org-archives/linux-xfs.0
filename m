Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 211E181DF
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:36:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8C11DAC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:36 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PfWlaSZGJhFBZADD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:36:34 -0700 (PDT)
Subject: [PATCH 054/145] xfs_io: add rmap-finish error injection type
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:36:25 -0700
Message-ID: <146612738585.16048.10795156252841536265.stgit@birch.djwong.org>
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

Add XFS_ERRTAG_RMAP_FINISH_ONE to the types of errors we can inject.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 12e0fb3..16ac925 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -76,7 +76,9 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BMAPIFORMAT,		"bmapifmt" },
 #define XFS_ERRTAG_FREE_EXTENT				22
 		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
-#define XFS_ERRTAG_MAX                                  23
+#define XFS_ERRTAG_RMAP_FINISH_ONE			23
+		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
+#define XFS_ERRTAG_MAX                                  24
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
