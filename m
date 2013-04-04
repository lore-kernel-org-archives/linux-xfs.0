Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9F0827F37
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 03:07:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6C2F0304064
	for <xfs@oss.sgi.com>; Thu,  4 Apr 2013 01:07:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 5iEylzY1OauM0a3f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Apr 2013 01:07:21 -0700 (PDT)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r3487KeX014492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 4 Apr 2013 08:07:20 GMT
Received: from acsmt357.oracle.com (acsmt357.oracle.com [141.146.40.157])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r3487Jbt014401
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 4 Apr 2013 08:07:20 GMT
Received: from abhmt104.oracle.com (abhmt104.oracle.com [141.146.116.56])
	by acsmt357.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r3487JpF013659 for <xfs@oss.sgi.com>; Thu, 4 Apr 2013 03:07:19 -0500
Message-ID: <515D34B2.9050807@oracle.com>
Date: Thu, 04 Apr 2013 16:07:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Update xfs_log_commit_cil() comments
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

xfs_log_commit_iclog() function has been removed by commits 93b8a585:
	xfs: remove the deprecated nodelaylog option

Beginning from Linux 3.3, only delayed logging is supported so that
we call xfs_log_commit_cil() at xfs_trans_commit() only, remove the
useless comments so.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_cil.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index ddc4529..e3d0b85 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -668,10 +668,6 @@ xlog_cil_push_foreground(
  * transaction to the checkpoint context so we carry the busy extents through
  * to checkpoint completion, and then unlock all the items in the transaction.
  *
- * For more specific information about the order of operations in
- * xfs_log_commit_cil() please refer to the comments in
- * xfs_trans_commit_iclog().
- *
  * Called with the context lock already held in read mode to lock out
  * background commit, returns without it held once background commits are
  * allowed again.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
