Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7Kxiak076055 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:44 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 7/8] xfsdump: path lookup cache must be thread specific
Date: Mon,  7 Nov 2011 14:58:30 -0600
Message-Id: <1320699511-12281-8-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The xfsrestore path lookup routine (maps an ino + generation number to a
pathname) contains a cache for fast lookups of consecutive files in the
same parent directory. This cache either needs to be protected by a lock
or a cache is needed per thread. I took the latter approach since it
doesn't add lock contention and it increases the cache hit rate (it's
relatively unlikely that each stream is processing files in the same
directory).

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 restore/tree.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index 7bddddf..9e4e83c 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -3441,7 +3441,7 @@ Node2path( nh_t nh, char *path, char *errmsg )
 static intgen_t
 Node2path_recurse( nh_t nh, char *buf, intgen_t bufsz, intgen_t level )
 {
-	static path_cache_t cache = { NH_NULL, 0, "" };
+	static __thread path_cache_t cache = { NH_NULL, 0, "" };
 	node_t *np;
 	nh_t parh;
 	xfs_ino_t ino;
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
