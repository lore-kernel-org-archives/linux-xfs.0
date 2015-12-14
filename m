Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B076B7CBF
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 19:01:37 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92B8F8F8035
	for <xfs@oss.sgi.com>; Sun, 13 Dec 2015 17:01:34 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UXreq01zXLxGC54c for <xfs@oss.sgi.com>;
	Sun, 13 Dec 2015 17:01:32 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1a8HVt-0006oy-O5
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1a8HVt-0000J9-NL
	for xfs@oss.sgi.com; Mon, 14 Dec 2015 12:01:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs_mdrestore: correctly account bytes read
Date: Mon, 14 Dec 2015 12:01:06 +1100
Message-Id: <1450054866-32720-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1450054866-32720-1-git-send-email-david@fromorbit.com>
References: <1450054866-32720-1-git-send-email-david@fromorbit.com>
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

Progess indication comes in the form of a "X MB read" output. This
doesn't match up with the actual number of bytes read from the
metadump file because it only accounts header blocks in the file,
not actual metadata blocks that are restored, Hence the number
reported is usually much lower than the size of the metadump file,
hence it's impossible to use to guage progress of the restore.

While there, fix the progress output so that it overwrites the
previous progress output line correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mdrestore/xfs_mdrestore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 5764616..0c0e08a 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -133,7 +133,7 @@ perform_restore(
 
 	for (;;) {
 		if (show_progress && (bytes_read & ((1 << 20) - 1)) == 0)
-			print_progress("%lld MB read\n", bytes_read >> 20);
+			print_progress("%lld MB read", bytes_read >> 20);
 
 		for (cur_index = 0; cur_index < mb_count; cur_index++) {
 			if (pwrite64(dst_fd, &block_buffer[cur_index <<
@@ -160,7 +160,7 @@ perform_restore(
 								1, src_f) != 1)
 			fatal("error reading from file: %s\n", strerror(errno));
 
-		bytes_read += block_size;
+		bytes_read += block_size + (mb_count << tmb.mb_blocklog);
 	}
 
 	if (progress_since_warning)
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
