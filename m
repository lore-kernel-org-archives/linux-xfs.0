Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4MGcVch224720 for <xfs@oss.sgi.com>; Tue, 22 May 2012 11:38:31 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v9EHWUfEXM9y9dcQ for
	<xfs@oss.sgi.com>; Tue, 22 May 2012 09:38:29 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4MGcT78018721
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 22 May 2012 12:38:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH v3 1/2] xfs: re-enable xfsaild idle mode when the ail is
	empty
Date: Tue, 22 May 2012 12:38:33 -0400
Message-Id: <1337704714-50235-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
References: <1337704714-50235-1-git-send-email-bfoster@redhat.com>
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

Running xfstests 273 in a loop on older kernels with xfsaild idle
mode support reproduces a lockup due to xfsaild entering idle mode
indefinitely. The following high-level sequence of events leads to
the hang:

- xfsaild is running, hits the stuck item threshold and reschedules,
  setting xa_last_pushed_lsn appropriately.
- xa_threshold is updated.
- xfsaild restarts from the previous xa_last_pushed_lsn, hits the
  new target and enters idle mode, even though the previously
  stuck items still populate the ail.

Modify the tout logic to only enter idle mode when the ail is empty.
IOW, if we hit the target but did not perform the current scan from
the start of the ail, reschedule at least one more time.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_trans_ail.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 9c51448..8a122d3 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -488,7 +488,10 @@ out_done:
 		 * longer for I/O to complete and remove pushed items from the
 		 * AIL before we start the next scan from the start of the AIL.
 		 */
-		tout = 50;
+		if (!count && !ailp->xa_last_pushed_lsn)
+			tout = 0;
+		else
+			tout = 50;
 		ailp->xa_last_pushed_lsn = 0;
 	} else if (((stuck + flushing) * 100) / count > 90) {
 		/*
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
