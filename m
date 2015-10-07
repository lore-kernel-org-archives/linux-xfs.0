Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBCA47F37
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:55:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CD6408F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:55:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zbOP3HomYkaBMAnT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:54:59 -0700 (PDT)
Subject: [PATCH 02/58] xfs: fix log ticket type printing
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:54:57 -0700
Message-ID: <20151007045457.30457.96842.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Update the log ticket reservation type printing code to reflect
all the types of log tickets, to avoid incorrect debug output and
avoid running off the end of the array.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_log.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aaadee0..75734af 100644
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
