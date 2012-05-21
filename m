Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LInsm7244410 for <xfs@oss.sgi.com>; Mon, 21 May 2012 13:49:54 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pM73R3JM9pQS0EBT for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 11:49:49 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LInnWA023417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 14:49:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH v2 1/3] xfs: re-enable xfsaild idle mode
Date: Mon, 21 May 2012 14:49:27 -0400
Message-Id: <1337626169-21730-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1337626169-21730-1-git-send-email-bfoster@redhat.com>
References: <1337626169-21730-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Brian Foster <bfoster@redhat.com>

Allow the xfsaild kernel thread to sleep when there is no work
to do.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1dead07..ae620eb 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -508,7 +508,7 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 		ailp->xa_log_flush = 0;
 
-		tout = 50;
+		tout = 0;
 	} else if (XFS_LSN_CMP(lsn, target) >= 0) {
 		/*
 		 * We reached the target so wait a bit longer for I/O to
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
