Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5FCAC7F50
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 13:07:28 -0600 (CST)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 38C5A8F8037
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 11:07:25 -0800 (PST)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r1OJ7Qvm002145
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2013 13:07:26 -0600 (CST)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130224190441.937509860@sgi.com>
Date: Sun, 24 Feb 2013 13:04:37 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfs: fix xfs_iomap_eof_prealloc_initial_size type
References: <20130224190436.906161932@sgi.com>
Content-Disposition: inline;
	filename=xfs-fix-xfs_iomap_eof_prealloc_initial_size-type.patch
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

Fix the return type of xfs_iomap_eof_prealloc_initial_size() to
xfs_fsblock_t to reflect the fact that the return value may be an
unsigned 64 bits if XFS_BIG_BLKNOS is defined.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_iomap.c
===================================================================
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -325,7 +325,7 @@ xfs_iomap_eof_want_preallocate(
  * rather than falling short due to things like stripe unit/width alignment of
  * real extents.
  */
-STATIC int
+STATIC xfs_fsblock_t
 xfs_iomap_eof_prealloc_initial_size(
 	struct xfs_mount	*mp,
 	struct xfs_inode	*ip,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
