Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58388 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751853AbeEPBB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 May 2018 21:01:29 -0400
Date: Tue, 15 May 2018 18:01:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix refactor quota limits initialization
Message-ID: <20180516010108.GA23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Cc: bfoster@redhat.com

dquot warning fields are be16, not be32.  Fix this mistake.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_qm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 913d46d01bfc..c3e014bfc848 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -636,11 +636,11 @@ xfs_qm_init_timelimits(
 	if (ddqp->d_rtbtimer)
 		qinf->qi_rtbtimelimit = be32_to_cpu(ddqp->d_rtbtimer);
 	if (ddqp->d_bwarns)
-		qinf->qi_bwarnlimit = be32_to_cpu(ddqp->d_bwarns);
+		qinf->qi_bwarnlimit = be16_to_cpu(ddqp->d_bwarns);
 	if (ddqp->d_iwarns)
-		qinf->qi_iwarnlimit = be32_to_cpu(ddqp->d_iwarns);
+		qinf->qi_iwarnlimit = be16_to_cpu(ddqp->d_iwarns);
 	if (ddqp->d_rtbwarns)
-		qinf->qi_rtbwarnlimit = be32_to_cpu(ddqp->d_rtbwarns);
+		qinf->qi_rtbwarnlimit = be16_to_cpu(ddqp->d_rtbwarns);
 
 	xfs_qm_dqdestroy(dqp);
 }
