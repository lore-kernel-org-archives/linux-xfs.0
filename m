Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B635C7F61
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:56:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 98A838F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:44 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 5KAldpu3UhxnFFrL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:56:43 -0800 (PST)
Subject: [PATCH 02/76] xfs: fix log ticket type printing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:56:36 -0800
Message-ID: <20151219085636.12713.59155.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

Update the log ticket reservation type printing code to reflect
all the types of log tickets, to avoid incorrect debug output and
avoid running off the end of the array.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f52c72a..2aa187e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2045,12 +2045,14 @@ xlog_print_tic_res(
 	    "QM_DQCLUSTER",
 	    "QM_QINOCREATE",
 	    "QM_QUOTAOFF_END",
-	    "SB_UNIT",
 	    "FSYNC_TS",
 	    "GROWFSRT_ALLOC",
 	    "GROWFSRT_ZERO",
 	    "GROWFSRT_FREE",
-	    "SWAPEXT"
+	    "SWAPEXT",
+	    "CHECKPOINT",
+	    "ICREATE",
+	    "CREATE_TMPFILE"
 	};
 
 	xfs_warn(mp, "xlog_write: reservation summary:");

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
