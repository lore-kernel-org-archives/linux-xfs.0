Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6DA9WP5040312 for <xfs@oss.sgi.com>; Mon, 13 Jul 2009 05:09:32 -0500
Date: Mon, 13 Jul 2009 12:10:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 1/2] fs/xfs: Drop unnecessary NULL test
Message-ID: <Pine.LNX.4.64.0907131209250.6808@ask.diku.dk>
MIME-Version: 1.0
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
To: felixb@sgi.com, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The result of container_of should not be NULL.  In particular, in this case
the argument to the enclosing function has passed though INIT_DELAYED_WORK,
which dereferences it, implying that its container cannot be NULL.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression x,e;
@@
x = container_of(...)
... when != x = e
* x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/xfs/xfs_mru_cache.c              |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mru_cache.c b/fs/xfs/xfs_mru_cache.c
index 4b0613d..0651ce7 100644
--- a/fs/xfs/xfs_mru_cache.c
+++ b/fs/xfs/xfs_mru_cache.c
@@ -280,8 +280,8 @@ _xfs_mru_cache_reap(
 	xfs_mru_cache_t		*mru = container_of(work, xfs_mru_cache_t, work.work);
 	unsigned long		now, next;
 
-	ASSERT(mru && mru->lists);
-	if (!mru || !mru->lists)
+	ASSERT(mru->lists);
+	if (!mru->lists)
 		return;
 
 	spin_lock(&mru->lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
