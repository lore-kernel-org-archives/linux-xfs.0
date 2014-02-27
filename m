Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D229D29DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:15:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4EDCEAC004
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:15:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id e1Kqmyk4I6ZqYqpU for <xfs@oss.sgi.com>;
	Wed, 26 Feb 2014 17:15:53 -0800 (PST)
Message-ID: <530E91C8.1010207@sandeen.net>
Date: Wed, 26 Feb 2014 19:15:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfs_logprint: don't advance op counter in
	xlog_print_trans_icreate
References: <530E8E17.1090901@redhat.com>
In-Reply-To: <530E8E17.1090901@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

xlog_print_trans_icreate is advancing the op counter
"(*i)++" incorrectly; it only contains one region, and
the loop which called it will properly advance the op
once we're done.

Found-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 7070fa3..52f1e85 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -810,7 +810,6 @@ xlog_print_trans_icreate(
 
 	memmove(&icl_buf, *ptr, MIN(sizeof(struct xfs_icreate_log), len));
 	icl = &icl_buf;
-	(*i)++;
 	*ptr += len;
 
 	/* handle complete header only */


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
