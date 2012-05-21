Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4LInpL0244376 for <xfs@oss.sgi.com>; Mon, 21 May 2012 13:49:51 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1hOqkfNTc7Il0BST for
	<xfs@oss.sgi.com>; Mon, 21 May 2012 11:49:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4LInn7C027307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 May 2012 14:49:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC PATCH v2 2/3] xfs: fix xfsaild hang due to premature idle
Date: Mon, 21 May 2012 14:49:28 -0400
Message-Id: <1337626169-21730-3-git-send-email-bfoster@redhat.com>
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

Running xfstests 273 in a loop reproduces an XFS lockup due to
xfsaild entering idle mode indefinitely. The following
high-level sequence of events lead to the hang:

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
 fs/xfs/xfs_trans_ail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ae620eb..8bc8aa2 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -503,7 +503,7 @@ xfsaild_push(
 
 	/* assume we have more work to do in a short while */
 out_done:
-	if (!count) {
+	if (!count && !ailp->xa_last_pushed_lsn) {
 		/* We're past our target or empty, so idle */
 		ailp->xa_last_pushed_lsn = 0;
 		ailp->xa_log_flush = 0;
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
