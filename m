Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB9NdZ5r145717 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 17:39:35 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id XYUggJUs0k3UNMyh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 15:42:02 -0800 (PST)
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 9D4E63EE0B6
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:01 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 87FD545DE56
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:01 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 712B545DE55
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:01 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 657211DB804B
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:01 +0900 (JST)
Received: from g01jpexchkw03.g01.fujitsu.local
	(g01jpexchkw03.g01.fujitsu.local [10.0.194.42])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 2069C1DB8042
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:42:01 +0900 (JST)
Message-ID: <50C521B2.1030001@jp.fujitsu.com>
Date: Mon, 10 Dec 2012 08:41:38 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] XFS: remove a unused sysctl related enum definition.
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
To: xfs ML <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

There is a unused sysctl related enum definition
in fs/xfs/xfs_sysctl.h. This patch removes it.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 fs/xfs/xfs_sysctl.h |   25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index b9937d4..af152eb 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -64,31 +64,6 @@ typedef struct xfs_param {
  * xfs_panic_mask bit 0x8 turns the error reports into panics
  */
 
-enum {
-	/* XFS_REFCACHE_SIZE = 1 */
-	/* XFS_REFCACHE_PURGE = 2 */
-	/* XFS_RESTRICT_CHOWN = 3 */
-	XFS_SGID_INHERIT = 4,
-	XFS_SYMLINK_MODE = 5,
-	XFS_PANIC_MASK = 6,
-	XFS_ERRLEVEL = 7,
-	XFS_SYNCD_TIMER = 8,
-	/* XFS_PROBE_DMAPI = 9 */
-	/* XFS_PROBE_IOOPS = 10 */
-	/* XFS_PROBE_QUOTA = 11 */
-	XFS_STATS_CLEAR = 12,
-	XFS_INHERIT_SYNC = 13,
-	XFS_INHERIT_NODUMP = 14,
-	XFS_INHERIT_NOATIME = 15,
-	XFS_BUF_TIMER = 16,
-	XFS_BUF_AGE = 17,
-	/* XFS_IO_BYPASS = 18 */
-	XFS_INHERIT_NOSYM = 19,
-	XFS_ROTORSTEP = 20,
-	XFS_INHERIT_NODFRG = 21,
-	XFS_FILESTREAM_TIMER = 22,
-};
-
 extern xfs_param_t	xfs_params;
 
 #ifdef CONFIG_SYSCTL
-- 1.7.10.4 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
