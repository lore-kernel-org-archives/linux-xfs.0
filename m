Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NBxUW130650 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:12:00 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9056E1C79D31
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:11:57 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kQj6inU4gXTzpIFA for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:11:57 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1RD2XB-0003aw-UQ
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1RD2XB-0002vZ-Kb
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 10:11:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] repair: fix some valgrind reported errors on i686
Date: Mon, 10 Oct 2011 10:11:47 +1100
Message-Id: <1318201910-11144-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1318201910-11144-1-git-send-email-david@fromorbit.com>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Fix a potential prefetch read problem due to the first loop
execution of pf_batch_read potentially not initialising the fsbno
varaible:

==10177== Thread 6:
==10177== Conditional jump or move depends on uninitialised value(s)
==10177==    at 0x8079CAB: pf_batch_read (prefetch.c:408)
==10177==    by 0x6A2996D: clone (clone.S:130)
==10177==

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/prefetch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/repair/prefetch.c b/repair/prefetch.c
index d2fdf90..da074a8 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -397,7 +397,7 @@ pf_batch_read(
 	int			len, size;
 	int			i;
 	int			inode_bufs;
-	unsigned long		fsbno;
+	unsigned long		fsbno = 0;
 	unsigned long		max_fsbno;
 	char			*pbuf;
 
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
