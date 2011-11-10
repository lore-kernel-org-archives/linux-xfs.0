Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAALGu84131122 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 15:16:56 -0600
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD115236E36
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 13:16:55 -0800 (PST)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id n1QBNZbqgBawpHLC for
	<xfs@oss.sgi.com>; Thu, 10 Nov 2011 13:16:55 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 10 Nov 2011 14:16:54 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	pAALGfDQ135014 for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:16:42 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id pAALGaHF001929
	for <xfs@oss.sgi.com>; Thu, 10 Nov 2011 14:16:38 -0700
Subject: Debug of xfstest 234 hang
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 10 Nov 2011 15:16:33 -0600
Message-ID: <1320959794.2201.15.camel@chandra-lucid.austin.ibm.com>
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
To: Dave Chinner <david@fromorbit.com>, Alex Elder <aelder@sgi.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hi Dave, Alex,

Debugging using trace, crash and systemtap, I found that the hang
happens when xfs_sync_worker() (thru kworker) gets stuck in xlog_wait()
while reserving a transaction log buffer for the dummy log.

I also found that even though xfsaild_push() keeps getting invoked, it
doesn't do anything to push the log to the disk, since the
ailp->xa_target has not been changed since it has been called from the
process stack a while back.

So, I thought, resetting the target to the max value would help nudge
the flow of ail to the disk. So, I added the following code. 
------------------
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index ed9252b..f59fd9f 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -534,6 +534,10 @@ out_done:
 		ailp->xa_last_pushed_lsn = 0;
 	}
 
+	lsn = xfs_ail_max_lsn(ailp);
+	smp_wmb();
+	xfs_trans_ail_copy_lsn(ailp, &ailp->xa_target, &lsn);
+	smp_wmb();
 	return tout;
 }
--------------------

and it seem to do the magic.

With this change, test 234 runs fine.

Is this a good fix, bad fix, overkill... ?

Please let me know.

regards

chandra
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
