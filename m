Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E440B29DF8
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 20:46:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A380F304032
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 18:46:50 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	St1tpm15koWHi5xi for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 18:46:47 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WkOGx-0003B4-ES
	for xfs@oss.sgi.com; Wed, 14 May 2014 11:46:19 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WkOGx-0003fr-DM
	for xfs@oss.sgi.com; Wed, 14 May 2014 11:46:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: log vector rounding leaks log space
Date: Wed, 14 May 2014 11:46:19 +1000
Message-Id: <1400031979-14089-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The addition of direct formatting of log items into the CIL
linear buffer added alignment restrictions that the start of each
vector needed to be 64 bit aligned. Hence padding was added in
xlog_finish_iovec() to round up the vector length to ensure the next
vector started with the correct alignment.

This adds a small number of bytes to the size of
the linear buffer that is otherwise unused. The issue is that we
then use the linear buffer size to determine the log space used by
the log item, and this includes the unused space. Hence when we
account for space used by the log item, it's more than is actually
written into the iclogs, and hence we slowly leak this space.

This results on log hangs when reserving space, with threads getting
stuck with these stack traces:

Call Trace:
[<ffffffff81d15989>] schedule+0x29/0x70
[<ffffffff8150d3a2>] xlog_grant_head_wait+0xa2/0x1a0
[<ffffffff8150d55d>] xlog_grant_head_check+0xbd/0x140
[<ffffffff8150ee33>] xfs_log_reserve+0x103/0x220
[<ffffffff814b7f05>] xfs_trans_reserve+0x2f5/0x310
.....


The 4 bytes is significant. Brain Foster did all the hard work in
tracking down a reproducable leak to inode chunk allocation (it went
away with the ikeep mount option). His rough numbers were that
creating 50,000 inodes leaked 11 log blocks. This turns out to be
roughly 800 inode chunks or 1600 inode cluster buffers. That
works out at roughly 4 bytes per cluster buffer logged, and at that
I started looking for a 4 byte leak in the buffer logging code.

What I found was that a struct xfs_buf_log_format structure for an
inode cluster buffer is 28 bytes in length. This gets rounded up to
32 bytes, but the vector length remains 28 bytes. Hence the CIL
ticket reservation is decremented by 32 bytes (via lv->lv_buf_len)
for that vector rather than 28 bytes which are written into the log.

The fix for this problem is to separately track the bytes used by
the log vectors in the item and use that instead of the buffer
length when accounting for the log space that will be used by the
formatted log item.

Again, thanks to Brian Foster for doing all the hard work and long
hours to isolate this leak and make finding the bug relatively
simple.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.h     | 19 +++++++++++++------
 fs/xfs/xfs_log_cil.c |  7 ++++---
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 2c40044..84e0deb 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -24,7 +24,8 @@ struct xfs_log_vec {
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
 	char			*lv_buf;	/* formatted buffer */
-	int			lv_buf_len;	/* size of formatted buffer */
+	int			lv_bytes;	/* accounted space in buffer */
+	int			lv_buf_len;	/* aligned size of buffer */
 	int			lv_size;	/* size of allocated lv */
 };
 
@@ -52,15 +53,21 @@ xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
 	return vec->i_addr;
 }
 
+/*
+ * We need to make sure the next buffer is naturally aligned for the biggest
+ * basic data type we put into it.  We already accounted for this padding when
+ * sizing the buffer.
+ *
+ * However, this padding does not get written into the log, and hence we have to
+ * track the space used by the log vectors separately to prevent log space hangs
+ * due to inaccurate accounting (i.e. a leak) of the used log space through the
+ * CIL context ticket.
+ */
 static inline void
 xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
 {
-	/*
-	 * We need to make sure the next buffer is naturally aligned for the
-	 * biggest basic data type we put into it.  We already accounted for
-	 * this when sizing the buffer.
-	 */
 	lv->lv_buf_len += round_up(len, sizeof(uint64_t));
+	lv->lv_bytes += len;
 	vec->i_len = len;
 }
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 039c873..b3425b3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -97,7 +97,7 @@ xfs_cil_prepare_item(
 {
 	/* Account for the new LV being passed in */
 	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
-		*diff_len += lv->lv_buf_len;
+		*diff_len += lv->lv_bytes;
 		*diff_iovecs += lv->lv_niovecs;
 	}
 
@@ -111,7 +111,7 @@ xfs_cil_prepare_item(
 	else if (old_lv != lv) {
 		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
 
-		*diff_len -= old_lv->lv_buf_len;
+		*diff_len -= old_lv->lv_bytes;
 		*diff_iovecs -= old_lv->lv_niovecs;
 		kmem_free(old_lv);
 	}
@@ -239,7 +239,7 @@ xlog_cil_insert_format_items(
 			 * that the space reservation accounting is correct.
 			 */
 			*diff_iovecs -= lv->lv_niovecs;
-			*diff_len -= lv->lv_buf_len;
+			*diff_len -= lv->lv_bytes;
 		} else {
 			/* allocate new data chunk */
 			lv = kmem_zalloc(buf_size, KM_SLEEP|KM_NOFS);
@@ -259,6 +259,7 @@ xlog_cil_insert_format_items(
 
 		/* The allocated data region lies beyond the iovec region */
 		lv->lv_buf_len = 0;
+		lv->lv_bytes = 0;
 		lv->lv_buf = (char *)lv + buf_size - nbytes;
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
 
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
