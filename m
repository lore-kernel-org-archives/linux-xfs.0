Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 087987CBF
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:43:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B484C304039
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:43:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id d2qQGV5FqbyXBvJG for
	<linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:43:00 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r711h0AI023803
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:43:00 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r711gwG4003344
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:43:00 -0400
Message-ID: <51F9BD22.8060102@redhat.com>
Date: Wed, 31 Jul 2013 20:42:58 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix buffer leak in xlog_print_find_oldest
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

The error path in this function did not free the buffer
before returning.

Coverity found this one.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index dfd76b7..d0c2959 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -29,7 +29,7 @@ xlog_print_find_oldest(
 	xfs_buf_t	*bp;
 	xfs_daddr_t	first_blk;
 	uint		first_half_cycle, last_half_cycle;
-	int		error;
+	int		error = 0;
 
 	if (xlog_find_zeroed(log, &first_blk))
 		return 0;
@@ -43,17 +43,14 @@ xlog_print_find_oldest(
 	last_half_cycle = xlog_get_cycle(XFS_BUF_PTR(bp));
 	ASSERT(last_half_cycle != 0);
 
-	if (first_half_cycle == last_half_cycle) { /* all cycle nos are same */
+	if (first_half_cycle == last_half_cycle) /* all cycle nos are same */
 		*last_blk = 0;
-	} else {		/* have 1st and last; look for middle cycle */
+	else		/* have 1st and last; look for middle cycle */
 		error = xlog_find_cycle_start(log, bp, first_blk,
 					      last_blk, last_half_cycle);
-		if (error)
-			return error;
-	}
 
 	xlog_put_bp(bp);
-	return 0;
+	return error;
 }
 
 void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
