Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0D17B29DF6
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 15:37:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 90C55AC001
	for <xfs@oss.sgi.com>; Mon, 21 Dec 2015 13:37:31 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RaRkm6sALF2yAxMr for <xfs@oss.sgi.com>;
	Mon, 21 Dec 2015 13:37:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aB88m-0000hr-Ck
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aB88m-0002lE-Bh
	for xfs@oss.sgi.com; Tue, 22 Dec 2015 08:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/9] xfs_mdrestore: correctly account bytes read
Date: Tue, 22 Dec 2015 08:37:03 +1100
Message-Id: <1450733829-9319-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1450733829-9319-1-git-send-email-david@fromorbit.com>
References: <1450733829-9319-1-git-send-email-david@fromorbit.com>
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
index ebc5e54..70a160c 100644
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
