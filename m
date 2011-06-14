Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EIs2EJ118256 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:54:02 -0500
Received: from e4.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B11511DC1DD
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:54:01 -0700 (PDT)
Received: from e4.ny.us.ibm.com (e4.ny.us.ibm.com [32.97.182.144]) by
	cuda.sgi.com with ESMTP id FxGcknnkyoZzMvB1 for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:54:01 -0700 (PDT)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EIWTLa024785
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:32:29 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5EIrxdV117824 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:53:59 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5EIrw7X027519 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:53:58 -0400
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p5EIrvl6027458 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 14:53:57 -0400
Subject: xfstests test case 229 fails consistently
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 14 Jun 2011 11:53:56 -0700
Message-ID: <1308077636.7661.476.camel@chandra-lucid.beaverton.ibm.com>
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
To: XFS Mailing List <xfs@oss.sgi.com>

Hello All,

xfstests test case 229 fails consistently in my x84_64 system.
Only thing that is different between runs is the number of errors. 
Any suggestions on how to proceed with the debug. 

regards,

chandra

229 118s ... [failed, exit status 45] - output mismatch (see 229.out.bad)
--- 229.out     2011-04-20 08:34:36.000000000 -0700
+++ 229.out.bad 2011-06-03 14:53:22.000000000 -0700
@@ -1,4 +1,49 @@
 QA output created by 229
 generating 10 files
 comparing files
-got 0 errors
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/1 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/2 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/3 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/4 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/5 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/6 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/7 differ: char 274433, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/8 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/9 differ: char 274433, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/2 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/3 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/4 differ: char 274433, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/5 differ: char 274433, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/6 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/7 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/8 differ: char 270337, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/9 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/3 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/4 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/5 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/6 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/7 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/8 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/9 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/4 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/5 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/6 differ: char 278529, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/7 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/8 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/9 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/5 differ: char 282625, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/6 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/7 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/8 differ: char 270337, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/9 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/6 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/7 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/8 differ: char 270337, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/9 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/7 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/8 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/9 differ: char 262145, line 1
+/mnt/xfsMntPt//t_holes/7 /mnt/xfsMntPt//t_holes/8 differ: char 266241, line 1
+/mnt/xfsMntPt//t_holes/7 /mnt/xfsMntPt//t_holes/9 differ: char 70037361, line 8097
+/mnt/xfsMntPt//t_holes/8 /mnt/xfsMntPt//t_holes/9 differ: char 266241, line 1
+got 45 errors
Ran: 229
Failures: 229
Failed 1 of 1 tests


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
