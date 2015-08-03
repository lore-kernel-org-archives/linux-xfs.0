Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 21BA87F5A
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 06:45:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8D2AAC04B
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 04:45:47 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0103.hostedemail.com
	[216.40.44.103]) by cuda.sgi.com with ESMTP id D3K0uvlI25iu4mDQ
	for <xfs@oss.sgi.com>; Mon, 03 Aug 2015 04:45:45 -0700 (PDT)
Message-ID: <1438602342.30149.22.camel@perches.com>
Subject: [TRIVIAL PATCH] xfs: Correct misuse of %0x<decimal>
From: Joe Perches <joe@perches.com>
Date: Mon, 03 Aug 2015 04:45:42 -0700
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Correct misuse of 0x%u in logging message.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/xfs/xfs_discard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index e85a951..272c3f8 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -227,7 +227,7 @@ xfs_discard_extents(
                                GFP_NOFS, 0);
                if (error && error != -EOPNOTSUPP) {
                        xfs_info(mp,
-        "discard failed for extent [0x%llu,%u], error %d",
+        "discard failed for extent [0x%llx,%u], error %d",
                                 (unsigned long long)busyp->bno,
                                 busyp->length,
                                 error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
