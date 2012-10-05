Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9515waA247277 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 20:05:59 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0DkXiz0WqrhiSnQQ for <xfs@oss.sgi.com>;
	Thu, 04 Oct 2012 18:07:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TJwNa-0000bF-D7
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TJwNa-0003P5-9Q
	for xfs@oss.sgi.com; Fri, 05 Oct 2012 11:07:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] xfs: introduce XFS_BMAPI_STACK_SWITCH
Date: Fri,  5 Oct 2012 11:06:58 +1000
Message-Id: <1349399219-13024-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1349399219-13024-1-git-send-email-david@fromorbit.com>
References: <1349399219-13024-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Certain allocation paths through xfs_bmapi_write() are in situations
where we have limited stack available. These are almost always in
the buffered IO writeback path when convertion delayed allocation
extents to real extents.

The current stack switch occurs for userdata allocations, which
means we also do stack switches for preallocation, direct IO and
unwritten extent conversion, even those these call chains have never
been implicated in a stack overrun.

Hence, let's target just the single stack overun offended for stack
switches. To do that, introduce a XFS_BMAPI_STACK_SWITCH flag that
the caller can pass xfs_bmapi_write() to indicate it should switch
stacks if it needs to do allocation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_alloc.c |    2 +-
 fs/xfs/xfs_alloc.h |    1 +
 fs/xfs/xfs_bmap.c  |    4 ++++
 fs/xfs/xfs_bmap.h  |    5 ++++-
 fs/xfs/xfs_iomap.c |    4 +++-
 5 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
index 0287f3b..43f791b 100644
--- a/fs/xfs/xfs_alloc.c
+++ b/fs/xfs/xfs_alloc.c
@@ -2447,7 +2447,7 @@ xfs_alloc_vextent(
 {
 	DECLARE_COMPLETION_ONSTACK(done);
 
-	if (!args->userdata)
+	if (!args->stack_switch)
 		return __xfs_alloc_vextent(args);
 
 
diff --git a/fs/xfs/xfs_alloc.h b/fs/xfs/xfs_alloc.h
index 93be4a6..ef7d488 100644
--- a/fs/xfs/xfs_alloc.h
+++ b/fs/xfs/xfs_alloc.h
@@ -123,6 +123,7 @@ typedef struct xfs_alloc_arg {
 	struct completion *done;
 	struct work_struct work;
 	int		result;
+	char		stack_switch;
 } xfs_alloc_arg_t;
 
 /*
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index e1545ec..9125955 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -2441,6 +2441,7 @@ xfs_bmap_btalloc(
 	args.tp = ap->tp;
 	args.mp = mp;
 	args.fsbno = ap->blkno;
+	args.stack_switch = ap->stack_switch;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
 	args.maxlen = MIN(ap->length, XFS_ALLOC_AG_MAX_USABLE(mp));
@@ -4675,6 +4676,9 @@ xfs_bmapi_allocate(
 			return error;
 	}
 
+	if (flags & XFS_BMAPI_STACK_SWITCH)
+		bma->stack_switch = 1;
+
 	error = xfs_bmap_alloc(bma);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 803b56d..b68c598 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -77,6 +77,7 @@ typedef	struct xfs_bmap_free
  * from written to unwritten, otherwise convert from unwritten to written.
  */
 #define XFS_BMAPI_CONVERT	0x040
+#define XFS_BMAPI_STACK_SWITCH	0x080
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
@@ -85,7 +86,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_STACK_SWITCH, "STACK_SWITCH" }
 
 
 static inline int xfs_bmapi_aflag(int w)
@@ -133,6 +135,7 @@ typedef struct xfs_bmalloca {
 	char			userdata;/* set if is user data */
 	char			aeof;	/* allocated space at eof */
 	char			conv;	/* overwriting unwritten extents */
+	char			stack_switch;
 } xfs_bmalloca_t;
 
 /*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f858b90..a066cf1 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -575,7 +575,9 @@ xfs_iomap_write_allocate(
 			 * pointer that the caller gave to us.
 			 */
 			error = xfs_bmapi_write(tp, ip, map_start_fsb,
-						count_fsb, 0, &first_block, 1,
+						count_fsb,
+						XFS_BMAPI_STACK_SWITCH,
+						&first_block, 1,
 						imap, &nimaps, &free_list);
 			if (error)
 				goto trans_cancel;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
