Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DF9D7F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CB8C304043
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 05:26:42 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mMUR3SEqnj1sS4g0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 05:26:41 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id r0SDQe39028397
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:40 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r0SDQdbh008040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 13:26:40 GMT
Received: from abhmt103.oracle.com (abhmt103.oracle.com [141.146.116.55])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r0SDQdj3019962 for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 07:26:39 -0600
Message-ID: <51067C8A.10908@oracle.com>
Date: Mon, 28 Jan 2013 21:26:34 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v4 04/13] xfs: calculate xfs_qm_write_sb_changes() space log
	reservation at mount time
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
To: xfs@oss.sgi.com

For the transaction that write the incore superblock changes of quota flags
to disk, it would reserve the same log space to clear/reset quota flags
transaction, hence we can use XFS_TRANS_SBCHANGE_LOG_RES() for it as well.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
CC: Dave Chinner <david@fromorbit.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_qm.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2e86fa0..5745189 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1582,10 +1582,9 @@ xfs_qm_write_sb_changes(
 	int		error;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_QM_SBCHANGE);
-	if ((error = xfs_trans_reserve(tp, 0,
-				      mp->m_sb.sb_sectsize + 128, 0,
-				      0,
-				      XFS_DEFAULT_LOG_COUNT))) {
+	error = xfs_trans_reserve(tp, 0, XFS_QM_SBCHANGE_LOG_RES(mp),
+				  0, 0, XFS_DEFAULT_LOG_COUNT);
+	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
