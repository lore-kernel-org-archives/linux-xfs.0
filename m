Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00FF229E4E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5F8BAC006
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:48 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PfV80MAMd4SHPKP3 for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:47 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003Oo-II
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-0008WP-Hh
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 31/37] db: Unwind the IO stack on exit
Date: Wed,  6 Nov 2013 12:07:17 +1100
Message-Id: <1383700043-32305-32-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

xfs_db can build up a large IO stack by the time it has run to
completion. If we don't unwind this IO stack before we shut down the
libxfs caches, metadump and other db programs will exit with
unreleased buffers and emit warnings like:

cache_purge: shake on cache 0x69e4f0 left 7 nodes!?

Hence we need to unwind the iostack as we shut down.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/db/init.c b/db/init.c
index 4bc048a..8ad21da 100644
--- a/db/init.c
+++ b/db/init.c
@@ -183,9 +183,11 @@ main(
 	int	c, i, done = 0;
 	char	*input;
 	char	**v;
+	int	start_iocur_sp;
 
 	pushfile(stdin);
 	init(argc, argv);
+	start_iocur_sp = iocur_sp;
 
 	for (i = 0; !done && i < ncmdline; i++) {
 		v = breakline(cmdline[i], &c);
@@ -209,10 +211,11 @@ main(
 
 close_devices:
 	/*
-	 * make sure that we pop the last buffer context we held so that the
-	 * buffer is released before purge the caches during unmount.
+	 * Make sure that we pop the all the buffer contexts we hold so that
+	 * they are released before we purge the caches during unmount.
 	 */
-	pop_cur();
+	while (iocur_sp > start_iocur_sp)
+		pop_cur();
 	libxfs_umount(mp);
 	if (x.ddev)
 		libxfs_device_close(x.ddev);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
