Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2801D7F51
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 02:59:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B9A98F8039
	for <xfs@oss.sgi.com>; Sat, 12 Apr 2014 00:59:54 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id ZD8NI4TPP5aGY16l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 12 Apr 2014 00:59:53 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WYsqu-0006G7-6A
	for xfs@oss.sgi.com; Sat, 12 Apr 2014 07:59:52 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/9] xfs: don't try to use the filestream allocator for
	metadata allocations
Date: Sat, 12 Apr 2014 10:01:55 +0200
Message-Id: <1397289723-26243-2-git-send-email-hch@lst.de>
In-Reply-To: <1397289723-26243-1-git-send-email-hch@lst.de>
References: <1397289723-26243-1-git-send-email-hch@lst.de>
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

xfs_bmap_btalloc_nullfb has two entirely different control flows when
using the filestream allocator vs the regular one, but it get the
conditionals wrong and ends up mixing the two for metadata allocations.
Fix this by adding a missing userdata check and slight refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index f0efc7e..3340f0e 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -3566,33 +3566,31 @@ xfs_bmap_btalloc_nullfb(
 		} else
 			notinit = 1;
 
-		if (xfs_inode_is_filestream(ap->ip)) {
+		if (xfs_inode_is_filestream(ap->ip) && ap->userdata) {
 			if (*blen >= args->maxlen)
 				break;
 
-			if (ap->userdata) {
-				/*
-				 * If startag is an invalid AG, we've
-				 * come here once before and
-				 * xfs_filestream_new_ag picked the
-				 * best currently available.
-				 *
-				 * Don't continue looping, since we
-				 * could loop forever.
-				 */
-				if (startag == NULLAGNUMBER)
-					break;
+			/*
+			 * If startag is an invalid AG, we've
+			 * come here once before and
+			 * xfs_filestream_new_ag picked the
+			 * best currently available.
+			 *
+			 * Don't continue looping, since we
+			 * could loop forever.
+			 */
+			if (startag == NULLAGNUMBER)
+				break;
 
-				error = xfs_filestream_new_ag(ap, &ag);
-				xfs_perag_put(pag);
-				if (error)
-					return error;
+			error = xfs_filestream_new_ag(ap, &ag);
+			xfs_perag_put(pag);
+			if (error)
+				return error;
 
-				/* loop again to set 'blen'*/
-				startag = NULLAGNUMBER;
-				pag = xfs_perag_get(mp, ag);
-				continue;
-			}
+			/* loop again to set 'blen'*/
+			startag = NULLAGNUMBER;
+			pag = xfs_perag_get(mp, ag);
+			continue;
 		}
 		if (++ag == mp->m_sb.sb_agcount)
 			ag = 0;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
