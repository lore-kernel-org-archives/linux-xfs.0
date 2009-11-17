Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAH7NUCV260292 for <xfs@oss.sgi.com>; Tue, 17 Nov 2009 01:23:30 -0600
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 7/7] xfs: Don't use PF_MEMALLOC
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117162235.3DEB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Date: Tue, 17 Nov 2009 16:23:43 +0900 (JST)
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
To: LKML <linux-kernel@vger.kernel.org>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm <linux-mm@kvack.org>, kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>


Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org
Cc: xfs-masters@oss.sgi.com
Cc: xfs@oss.sgi.com
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 965df12..b9a06fc 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1724,8 +1724,6 @@ xfsbufd(
 	int		count;
 	xfs_buf_t	*bp;
 
-	current->flags |= PF_MEMALLOC;
-
 	set_freezable();
 
 	do {
-- 
1.6.2.5



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
