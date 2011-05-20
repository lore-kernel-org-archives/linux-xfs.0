Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4K0tiL7062012 for <xfs@oss.sgi.com>; Thu, 19 May 2011 19:55:44 -0500
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B22541618972
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 17:55:43 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id DBqlmAbLn9gKUxWx for
	<xfs@oss.sgi.com>; Thu, 19 May 2011 17:55:43 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4K0h81p011933
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:43:08 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p4K0tc8s151920 for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:55:38 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4K0tcKR002084
	for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:55:38 -0600
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p4K0tcdH002037 for <xfs@oss.sgi.com>; Thu, 19 May 2011 18:55:38 -0600
Subject: Failure of xfstest 229
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 19 May 2011 17:55:37 -0700
Message-ID: <1305852937.7661.369.camel@chandra-lucid.beaverton.ibm.com>
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

Hi all,

I remember running this test successfully sometime back. 

But, now it is failing on different versions of kernel that I try it on,
like 2.6.34,35,36,37,38 and 39. with the following errors (at the end).

I tried it in 2 filesystem sizes (1TB and 20GB), both of which fail.

I tried to do what the test does externally and found that running
xfs_io -c "extsize ${EXTSIZE}" ${TDIR}

before running 
$here/src/t_holes ${TDIR}/${i}

creates the failures.

Is there any special setup needed for it to run successfully ?

Thanks & Regards,

chandra
---------------------------------------------

229 118s ... [failed, exit status 45] - output mismatch (see 229.out.bad)
--- 229.out	2011-04-20 08:34:36.000000000 -0700
+++ 229.out.bad	2011-05-19 14:51:48.000000000 -0700
@@ -1,4 +1,49 @@
 QA output created by 229
 generating 10 files
 comparing files
-got 0 errors
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/1 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/2 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/3 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/4 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/5 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/6 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/7 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/8 differ: char 282193, line 1
+/mnt/xfsMntPt//t_holes/0 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/2 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/3 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/4 differ: char 415617, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/5 differ: char 304801, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/6 differ: char 415617, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/7 differ: char 415617, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/8 differ: char 402977, line 1
+/mnt/xfsMntPt//t_holes/1 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/3 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/4 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/5 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/6 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/7 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/8 differ: char 277873, line 1
+/mnt/xfsMntPt//t_holes/2 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/4 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/5 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/6 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/7 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/8 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/3 /mnt/xfsMntPt//t_holes/9 differ: char 264289, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/5 differ: char 304801, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/6 differ: char 416689, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/7 differ: char 474353, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/8 differ: char 402977, line 1
+/mnt/xfsMntPt//t_holes/4 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/6 differ: char 304801, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/7 differ: char 304801, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/8 differ: char 304801, line 1
+/mnt/xfsMntPt//t_holes/5 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/7 differ: char 416689, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/8 differ: char 402977, line 1
+/mnt/xfsMntPt//t_holes/6 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/7 /mnt/xfsMntPt//t_holes/8 differ: char 402977, line 1
+/mnt/xfsMntPt//t_holes/7 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+/mnt/xfsMntPt//t_holes/8 /mnt/xfsMntPt//t_holes/9 differ: char 265361, line 1
+got 45 errors
Ran: 229
Failures: 229
Failed 1 of 1 tests
---------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
