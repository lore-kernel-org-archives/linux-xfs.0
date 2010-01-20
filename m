Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K3bWv3235732 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 21:37:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16574177477
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:38:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	Hf2v6wHxM1uiGJYs for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 19:38:31 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11651455-1927428
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:08:25 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NXROi-00053C-12
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:24 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NXROW-00008G-VN
	for xfs@oss.sgi.com; Wed, 20 Jan 2010 14:38:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/8] xfstests: fix compile warning in doio.c
Date: Wed, 20 Jan 2010 14:38:01 +1100
Message-Id: <1263958688-435-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263958688-435-1-git-send-email-david@fromorbit.com>
References: <1263958688-435-1-git-send-email-david@fromorbit.com>
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

Use of sigblock is deprecated. Use sigprocmask instead.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 ltp/doio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/ltp/doio.c b/ltp/doio.c
index a1c92c9..0fe206d 100644
--- a/ltp/doio.c
+++ b/ltp/doio.c
@@ -350,7 +350,7 @@ char	**argv;
 {
 	int	    	    	i, pid, stat, ex_stat;
 	struct sigaction	sa;
-	int omask;
+	sigset_t		block_mask, old_mask;
 	umask(0);		/* force new file modes to known values */
 #if _CRAYMPP
 	Npes = sysconf(_SC_CRAY_NPES);	/* must do this before parse_cmdline */
@@ -434,7 +434,9 @@ char	**argv;
 		Children[i] = -1;
 	}
 
-	omask = sigblock(sigmask(SIGCLD));
+	sigemptyset(&block_mask);
+	sigaddset(&block_mask, SIGCHLD);
+	sigprocmask(SIG_BLOCK, &block_mask, &old_mask);
 
 	/*
 	 * Fork Nprocs.  This [parent] process is a watchdog, to notify the
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
