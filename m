Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 396A383A9
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:43:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F05658F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id K3A4OZHZPTJIwWYU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:43:07 -0700 (PDT)
Subject: [PATCH 117/145] xfs_io: add refcount+bmap error injection types
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:43:03 -0700
Message-ID: <146612778322.16048.5833598458395784088.stgit@birch.djwong.org>
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

Add refcount and bmap deferred finish to the types of errors we can
inject.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/inject.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/io/inject.c b/io/inject.c
index 16ac925..56642b8 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -78,7 +78,13 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FREE_EXTENT,		"free_extent" },
 #define XFS_ERRTAG_RMAP_FINISH_ONE			23
 		{ XFS_ERRTAG_RMAP_FINISH_ONE,		"rmap_finish_one" },
-#define XFS_ERRTAG_MAX                                  24
+#define XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE		24
+		{ XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE,	"refcount_continue_update" },
+#define XFS_ERRTAG_REFCOUNT_FINISH_ONE			25
+		{ XFS_ERRTAG_REFCOUNT_FINISH_ONE,	"refcount_finish_one" },
+#define XFS_ERRTAG_BMAP_FINISH_ONE			26
+		{ XFS_ERRTAG_BMAP_FINISH_ONE,		"bmap_finish_one" },
+#define XFS_ERRTAG_MAX                                  27
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
