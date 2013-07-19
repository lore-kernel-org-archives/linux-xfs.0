Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A79697F3F
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 17:32:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7644E8F8049
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:32:13 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id Pv2KeeDSb4lDSlr4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 15:32:12 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 19 Jul 2013 16:31:41 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 4F47B1FF001C
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:26:18 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6JMVceg380394 for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:31:38 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6JMYGNE005592
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:34:16 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6JMYFo8005585 for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:34:15 -0600
Subject: [PATCH] xfs: Fix a deadlock in xfs_log_commit_cil() code path
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 19 Jul 2013 17:31:38 -0500
Message-ID: <1374273098.8941.2075.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>


While testing and rearranging pquota/gquota code, I stumbled
on a xfs_shutdown() during a mount. But the mount just hung.

Debugged and found that there is a deadlock involving
&log->l_cilp->xc_ctx_lock.

It is in a code path where &log->l_cilp->xc_ctx_lock is first
acquired in read mode and some levels down the same semaphore
is being acquired in write mode causing a deadlock.

This is the stack:
xfs_log_commit_cil -> acquires &log->l_cilp->xc_ctx_lock in read mode
  xlog_print_tic_res
    xfs_force_shutdown
      xfs_log_force_umount
        xlog_cil_force
          xlog_cil_force_lsn
            xlog_cil_push_foreground
              xlog_cil_push - tries to acquire same semaphore in write mode

This patch fixes the deadlock by changing the reason code for
xfs_force_shutdown in xlog_print_tic_res() to SHUTDOWN_LOG_IO_ERROR.

SHUTDOWN_LOG_IO_ERROR is the right reason code to be set since
we are in the log path.

Thanks to Dave for suggesting this solution.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index d852a2b..bf89eb9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1941,7 +1941,7 @@ xlog_print_tic_res(
 
 	xfs_alert_tag(mp, XFS_PTAG_LOGRES,
 		"xlog_write: reservation ran out. Need to up reservation");
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	xfs_force_shutdown(mp, SHUTDOWN_LOG_IO_ERROR);
 }
 
 /*
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
