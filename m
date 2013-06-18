Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0103F29E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 17:57:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E63F1304032
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 15:57:06 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 1t53PY9B497ltEQf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 15:57:02 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5IMv1hc031794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:57:02 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5IMv1sC007191
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:57:01 GMT
Received: from abhmt106.oracle.com (abhmt106.oracle.com [141.146.116.58])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5IMv0fw007184 for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:57:00 GMT
Message-ID: <51C0E5BC.6060809@oracle.com>
Date: Tue, 18 Jun 2013 17:57:00 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: aio-stress is calling pthread_join incorrectly
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
To: xfs@oss.sgi.com

The retval parameter to pthread_join() is a pointer to a pointer.
aio-stress is passing in a pointer to an int. This can result in a bus
error on sparc64 when the pointer is not aligned on a 64-bit boundary.
Since the return value is not used, it is simplest to pass a NULL
pointer instead.

This has been fixed in the LTP source:
https://github.com/linux-test-project/ltp/commit/981d33aad3b33c4625b88990fbf2fad5470d47e0

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
---

diff -up xfstests/ltp/aio-stress.c.orig xfstests/ltp/aio-stress.c
--- xfstests/ltp/aio-stress.c.orig	2013-06-03 11:53:49.000000000 -0700
+++ xfstests/ltp/aio-stress.c	2013-06-18 15:04:35.593859720 -0700
@@ -1210,7 +1210,6 @@ typedef void * (*start_routine)(void *);
 int run_workers(struct thread_info *t, int num_threads)
 {
     int ret;
-    int thread_ret;
     int i;
 
     for(i = 0 ; i < num_threads ; i++) {
@@ -1221,7 +1220,7 @@ int run_workers(struct thread_info *t, i
 	}
     }
     for(i = 0 ; i < num_threads ; i++) {
-        ret = pthread_join(t[i].tid, (void *)&thread_ret);
+        ret = pthread_join(t[i].tid, NULL);
         if (ret) {
 	    perror("pthread_join");
 	    exit(1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
