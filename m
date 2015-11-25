Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ED2D97F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 02:52:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E111AC002
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 00:52:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XxTOTdVt5rGwGl2m (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 00:52:48 -0800 (PST)
From: Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH] xfs: send warning of project quota to userspace via netlink
Date: Wed, 25 Nov 2015 17:52:41 +0900
Message-Id: <1448441561-31849-1-git-send-email-yamato@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: yamato@redhat.com

Linux's quota subsystem has an ability to handle
project quota. This commit just utilizes the ability
from xfs side.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 fs/xfs/xfs_trans_dquot.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index ce78534..1a46544 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -572,12 +572,17 @@ xfs_quota_warn(
 	struct xfs_dquot	*dqp,
 	int			type)
 {
-	/* no warnings for project quotas - we just return ENOSPC later */
+	enum quota_type t;
+
 	if (dqp->dq_flags & XFS_DQ_PROJ)
-		return;
+		t = PRJQUOTA;
+	else if (dqp->dq_flags & XFS_DQ_USER)
+		t = USRQUOTA;
+	else
+		t = GRPQUOTA;
+
 	quota_send_warning(make_kqid(&init_user_ns,
-				     (dqp->dq_flags & XFS_DQ_USER) ?
-				     USRQUOTA : GRPQUOTA,
+				     t,
 				     be32_to_cpu(dqp->q_core.d_id)),
 			   mp->m_super->s_dev, type);
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
