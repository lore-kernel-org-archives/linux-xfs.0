Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 516967F37
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 16:40:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3D41530407A
	for <xfs@oss.sgi.com>; Sat, 26 Jan 2013 14:40:34 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 9dUrovwthgu4m2TJ for <xfs@oss.sgi.com>;
	Sat, 26 Jan 2013 14:40:34 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/8] libxfs: fix setup_cursor array allocation
Date: Sat, 26 Jan 2013 16:40:27 -0600
Message-Id: <1359240032-11576-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
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
Cc: Eric Sandeen <sandeen@redhat.com>

setup_cursor() wants an array of xfs_agbno_t's, but
it allocated a multiple of *pointers* to xfs_agbno_t's.
xfs_agbno_t is 4 bytes, so this is harmless other than
allocating twice as much memory as needed on a 64-bit
machine.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/phase5.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 7d5cd49..1f71cac 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -206,7 +206,7 @@ setup_cursor(xfs_mount_t *mp, xfs_agnumber_t agno, bt_status_t *curs)
 
 	ASSERT(big_extent_len > 0);
 
-	if ((curs->btree_blocks = malloc(sizeof(xfs_agblock_t *)
+	if ((curs->btree_blocks = malloc(sizeof(xfs_agblock_t)
 					* big_extent_len)) == NULL)
 		do_error(_("could not set up btree block array\n"));
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
