Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 06:43:50 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PDhgdo006558
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 06:43:43 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PDhhfP031509
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:43:43 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PDhhSv231252
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:43:43 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PDhgx3020366
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:43:43 -0600
Date: Mon, 25 Jun 2007 19:13:52 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/7][TAKE5] fallocate() on ia64
Message-ID: <20070625134352.GD1951@amitarora.in.ibm.com>
References: <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625132810.GA1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

fallocate() on ia64

ia64 fallocate syscall support.

Signed-off-by: Dave Chinner <dgc@sgi.com>

Index: linux-2.6.22-rc4/arch/ia64/kernel/entry.S
===================================================================
--- linux-2.6.22-rc4.orig/arch/ia64/kernel/entry.S	2007-06-11 17:22:15.000000000 -0700
+++ linux-2.6.22-rc4/arch/ia64/kernel/entry.S	2007-06-11 17:30:37.000000000 -0700
@@ -1588,5 +1588,6 @@
 	data8 sys_signalfd
 	data8 sys_timerfd
 	data8 sys_eventfd
+	data8 sys_fallocate			// 1310
 
 	.org sys_call_table + 8*NR_syscalls	// guard against failures to increase NR_syscalls
Index: linux-2.6.22-rc4/include/asm-ia64/unistd.h
===================================================================
--- linux-2.6.22-rc4.orig/include/asm-ia64/unistd.h	2007-06-11 17:22:15.000000000 -0700
+++ linux-2.6.22-rc4/include/asm-ia64/unistd.h	2007-06-11 17:30:37.000000000 -0700
@@ -299,11 +299,12 @@
 #define __NR_signalfd			1307
 #define __NR_timerfd			1308
 #define __NR_eventfd			1309
+#define __NR_fallocate			1310
 
 #ifdef __KERNEL__
 
 
-#define NR_syscalls			286 /* length of syscall table */
+#define NR_syscalls			287 /* length of syscall table */
 
 /*
  * The following defines stop scripts/checksyscalls.sh from complaining about
