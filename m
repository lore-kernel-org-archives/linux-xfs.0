Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7DC957CBF
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 23:10:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14936AC006
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 21:10:53 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UaYx6W2ZHN5igrDk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Apr 2013 21:10:51 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r344AnoF010282
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 4 Apr 2013 04:10:50 GMT
Received: from acsmt358.oracle.com (acsmt358.oracle.com [141.146.40.158])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r344AmT0028780
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 4 Apr 2013 04:10:49 GMT
Received: from abhmt107.oracle.com (abhmt107.oracle.com [141.146.116.59])
	by acsmt358.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	r344Am3u010987 for <xfs@oss.sgi.com>; Wed, 3 Apr 2013 23:10:48 -0500
Message-ID: <515CFD42.70109@oracle.com>
Date: Thu, 04 Apr 2013 12:10:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH]xfs: Remove the obsolete XLOG_CIL_HARD_SPACE_LIMIT() macros
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

There is no more users of this Macro, so it's time to kill it dead.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_priv.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 16d8d12..b9ea262 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -468,7 +468,6 @@ struct xfs_cil {
  * threshold, yet give us plenty of space for aggregation on large logs.
  */
 #define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
-#define XLOG_CIL_HARD_SPACE_LIMIT(log)	(3 * (log->l_logsize >> 4))

 /*
  * ticket grant locks, queues and accounting have their own cachlines
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
