Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5EIpPej117828 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 13:51:25 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B9423ECD
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:51:24 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id AQIzg7xAAVMOs2Wp for
	<xfs@oss.sgi.com>; Tue, 14 Jun 2011 11:51:24 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5EIhwuD019750
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 12:43:58 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5EIp9o4129776 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 12:51:11 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5ECocRp026461
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 06:50:38 -0600
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p5ECoc6E026406 for <xfs@oss.sgi.com>; Tue, 14 Jun 2011 06:50:38 -0600
Subject: xfstests test case 180 fails often
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 14 Jun 2011 11:51:04 -0700
Message-ID: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
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

test case 180 fails often (4 out of 5) in my x86_64 system.
Any suggestions on how to proceed to debug ?

regards,

chandra

80 176s ... - output mismatch (see 180.out.bad)^M
--- 180.out     2011-04-20 08:34:36.000000000 -0700^M
+++ 180.out.bad 2011-06-03 14:10:45.000000000 -0700^M
@@ -1 +1,4 @@^M
 QA output created by 180^M
+file /mnt/xfsScratchMntPt/656 has incorrect size - sync failed^M
+file /mnt/xfsScratchMntPt/818 has incorrect size - sync failed^M
+file /mnt/xfsScratchMntPt/899 has incorrect size - sync failed^M
Ran: 180^M
Failures: 180^M
Failed 1 of 1 tests^M


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
