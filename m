Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A1807CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 07:22:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE53DAC004
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 05:22:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4h0CJS7l4lsZSwGp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 05:22:16 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfs: undo block reservation correctly in
	xfs_trans_reserve()
Date: Tue,  6 Sep 2016 20:14:40 +0800
Message-Id: <1473164080-7405-1-git-send-email-eguan@redhat.com>
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
To: linux-xfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

"blocks" should be added back to fdblocks at undo time, not taken
away, i.e. the minus sign should not be used.

This is a regression introduced by commit 0d485ada404b ("xfs: use
generic percpu counters for free block counter"). And it's found by
code inspection, I didn't it in real world, so there's no
reproducer.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2:
- Remove "Fixes:" tag and describe relevant commit in commit log
- Update commit log to mention that it's found by code inspection
- Remove outer () from the "int64_t" cast

 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5f3d33d..836eb80 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -217,7 +217,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		xfs_mod_fdblocks(tp->t_mountp, (int64_t)blocks, rsvd);
 		tp->t_blk_res = 0;
 	}
 
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
