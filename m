Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B5687CA1
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 03:04:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6017A8F8035
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2016 01:04:33 -0700 (PDT)
Received: from mail-pf0-f193.google.com (mail-pf0-f193.google.com
	[209.85.192.193]) by cuda.sgi.com with ESMTP id
	61z1jJo6nHxiFWVE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2016 01:04:29 -0700 (PDT)
Received: by mail-pf0-f193.google.com with SMTP id h186so10995674pfg.2
	for <xfs@oss.sgi.com>; Tue, 06 Sep 2016 01:04:29 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfs: undo block reservation correctly in xfs_trans_reserve()
Date: Tue,  6 Sep 2016 16:03:59 +0800
Message-Id: <1473149039-30487-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>, xfs@oss.sgi.com

"blocks" should be added back to fdblocks at undo time, not taken
away, i.e. the minus sign should not be used.

Fixes: 0d485ada404b ("xfs: use generic percpu counters for free block counter")
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 5f3d33d..011dace 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -217,7 +217,7 @@ undo_log:
 
 undo_blocks:
 	if (blocks > 0) {
-		xfs_mod_fdblocks(tp->t_mountp, -((int64_t)blocks), rsvd);
+		xfs_mod_fdblocks(tp->t_mountp, ((int64_t)blocks), rsvd);
 		tp->t_blk_res = 0;
 	}
 
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
