Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3LiruA054867 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 16:44:54 -0500
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7623821CFA1
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 14:44:52 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id k43q4M2vJGmK0SKp for
	<xfs@oss.sgi.com>; Thu, 03 Nov 2011 14:44:52 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 3 Nov 2011 15:44:51 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pA3LhlTg109326 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 15:43:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pA3Lhl0p013535
	for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 15:43:47 -0600
Subject: Hang seen in xfstests 234
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 03 Nov 2011 16:43:46 -0500
Message-ID: <1320356626.17713.32.camel@chandra-lucid.austin.ibm.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hi Alex,

I ran the xfstests 234 with procs set to 20 and I can consistently make
it hang.

Looks like, the log buffer is full and all the processes are sleeping at
xlog_wait() or blocked on a mutex which was held by a process that is
sleeping on xlog_wait().

wake up happens when sync is invoked and all processes run free to
completion.

In order to verify the hypothesis, I added the following code
-------------------------
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 5cc3dde..b2c0d49 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -621,6 +621,7 @@ xfs_qm_scall_setqlim(
        dqp->dq_flags |= XFS_DQ_DIRTY;
        xfs_trans_log_dquot(tp, dqp);
 
+       xfs_trans_set_sync(tp);
        error = xfs_trans_commit(tp, 0);
        xfs_qm_dqrele(dqp);
 
--------------------------

and it seems to work well.

Not sure if this can be a fix or the nudge has to happen somewhere else.

Please comment.

Regards,

Chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
