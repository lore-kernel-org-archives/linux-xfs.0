Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2IMqLmo198210 for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:52:21 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10389304062
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 15:53:57 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o2IMruRJ001868
	for <xfs@oss.sgi.com>; Thu, 18 Mar 2010 17:53:56 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o2IMruwI001866
	for xfs@oss.sgi.com; Thu, 18 Mar 2010 17:53:56 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201003182253.o2IMruwI001866@stout.americas.sgi.com>
Date: Thu, 18 Mar 2010 17:53:56 -0500
Subject: [PATCH 3/7] xfs: simplify XLOG_SECTOR_ROUND*()
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
To: xfs@oss.sgi.com

XLOG_SECTOR_ROUNDUP_BBCOUNT() is defined in "fs/xfs/xfs_log_recover.c"
in an overly-complicated way.  It is basically roundup(), but that
is not at all clear from its definition.  (Actually, there is
another macro round_up() that applies for power-of-two-based masks
which I'll be using here.)

The operands in XLOG_SECTOR_ROUNDUP_BBCOUNT() are basically the
block number (bbs) and the log sector basic block mask
(log->l_sectbb_mask).  I'll call them B and M for this discussion.

The macro computes is value this way:
	M && (B & M) ? (B + M + 1) & ~M : B

Put another way, we can break it into 3 cases:
	1)  ! M          -> B			# 0 mask, no effect
	2)  ! (B & M)    -> B			# sector aligned
	3)  M && (B & M) -> (B + M + 1) & ~M	# round up otherwise

The round_up() macro is cleverly defined using a value, v, and a
power-of-2, p, and the result is the nearest multiple of p greater
than or equal to v.  Its value is computed something like this:
	((v - 1) | (p - 1)) + 1
Let's consider using this in the context of the 3 cases above.

When p = 2^0 = 1, the result boils down to ((v - 1) | 0) + 1, so it
just translates any value v to itself.  That handles case (1) above.

When p = 2^n, n > 0, we know that (p - 1) will be a mask with all n
bits 0..n-1 set.  The condition in this case occurs when none of
those mask bits is set in the value v provided.  If that is the
case, subtracting 1 from v will have 1's in all those lower bits (at
least).  Therefore, OR-ing the mask with that decremented value has
no effect, so adding the 1 back again will just translate the v to
itself.  This handles case (2).

Otherwise, the value v is greater than some multiple of p, and
decrementing it will produce a result greater than or equal to that
multiple.  OR-ing in the mask will produce a value 1 less than the
next multiple of p, so finally adding 1 back will result in the
desired rounded-up value.  This handles case (3).

Hopefully this is convincing.

While I was at it, I converted XLOG_SECTOR_ROUNDDOWN_BLKNO() to use
the round_down() macro.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_log_recover.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: b/fs/xfs/xfs_log_recover.c
===================================================================
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -61,14 +61,13 @@ STATIC void	xlog_recover_check_summary(x
  * Sector aligned buffer routines for buffer create/read/write/access
  */
 
-#define XLOG_SECTOR_ROUNDUP_BBCOUNT(log, bbs)	\
-	( ((log)->l_sectbb_mask && (bbs & (log)->l_sectbb_mask)) ? \
-	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
-#define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
-
 /* Number of basic blocks in a log sector */
 #define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
 
+#define XLOG_SECTOR_ROUNDUP_BBCOUNT(log, bbs) round_up((bbs), xlog_sectbb(log))
+#define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno) \
+		round_down((bno), xlog_sectbb(log))
+
 STATIC xfs_buf_t *
 xlog_get_bp(
 	xlog_t		*log,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
