Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFEDA7F50
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 12:04:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6CFB8F8054
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 10:04:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zdz7wjiHiawlaTri (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 10:04:08 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t45H46h2005749
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 5 May 2015 13:04:07 -0400
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t45H45pU023780
	for <xfs@oss.sgi.com>; Tue, 5 May 2015 13:04:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix quota block reservation leak when tp allocates and
	frees blocks
Date: Tue,  5 May 2015 13:04:04 -0400
Message-Id: <1430845444-48060-1-git-send-email-bfoster@redhat.com>
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

Al Viro reports that generic/231 fails frequently on XFS and bisected
the problem to the following commit:

	5d11fb4b xfs: rework zero range to prevent invalid i_size updates

... which is just the first commit that happens to cause fsx to
reproduce the problem. fsx reproduces via zero range calls. The
aforementioned commit overhauls zero range to use hole punch and
fallocate. As it turns out, the problem is reproducible on demand using
basic hole punch as follows:

$ mkfs.xfs -f -m crc=1,finobt=1 <dev>
$ mount <dev> /mnt -o uquota
$ xfs_io -f -c "falloc 0 50m" /mnt/file
$ for i in $(seq 1 20); do xfs_io -c "fpunch ${i}m 32k" /mnt/file; done
$ rm -f /mnt/file
$ repquota -us /mnt
...
User            used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --     32K      0K      0K              3     0     0

A file is allocated with a single 50m extent. The extent count increases
via hole punches until the bmap converts to btree format. The file is
removed but quota reports 32k of space usage for the user. This
reservation is effectively leaked for the lifetime of the mount.

The reason this occurs is because the quota block reservation tracking
is confused when a transaction happens to free and allocate blocks at
the same time. Consider the following sequence of events:

- tp is allocated from xfs_free_file_space() and reserves several blocks
  for btree management. Blocks are reserved against the dquot and marked
  as such in the transaction (qtrx->qt_blk_res).
- 8 blocks are accounted free when the 32k range is punched out.
  xfs_trans_mod_dquot() is called with XFS_TRANS_DQ_BCOUNT and sets
  ->qt_bcount_delta to -8.
- Subsequently, a block is allocated against the same transaction by
  xfs_bmap_extents_to_btree() for btree conversion. A call to
  xfs_trans_mod_dquot() increases qt_blk_res_used to 1 and qt_bcount_delta
  to -7.
- The transaction is dup'd and committed by xfs_bmap_finish().
  xfs_trans_dup_dqinfo() sets the first transaction up such that it has a
  matching qt_blk_res and qt_blk_res_used of 1. The remaining unused
  reservation is transferred to the duplicate tp.

When the transactions are committed, the dquots are fixed up in
xfs_trans_apply_dquot_deltas() according to one of two methods:

1.) If the transaction holds a block reservation (->qt_blk_res != 0),
_only_ the unused portion reservation is unaccounted from the dquot.
Note that the tp duplication behavior of xfs_bmap_finish() makes it such
that qt_blk_res is typically 0 for tp's with unused reservation.
2.) Otherwise, the dquot is fixed up based on the block delta
(->qt_bcount_delta) created by the transaction.

Therefore, if a transaction has a negative qt_bcount_delta and positive
qt_blk_res_used, the former set of blocks that have been removed from
the file are never factored out of the in-core dquot reservation.
Instead, *_apply_dquot_deltas() sees 1 block used out of a 1 block
reservation and believes there is nothing to fix up. The on-disk
d_bcount is updated independently from qt_bcount_delta, and thus is
correct (and allows the quota usage to correct on remount).

To deal with this situation, we effectively want the "used reservation"
part of the transaction to be consistent with any freed blocks with
respect to quota tracking. For example, if 8 blocks are freed, the
subsequent single block allocation does not need to consume the initial
reservation made by the tp. Instead, it simply borrows one from the
previously freed. One possible implementation of such borrowing is to
avoid the blks_res_used increment when bcount_delta is negative. This
alone is flawed logic in that it only handles the case where blocks are
freed before allocated, however.

Rather than add more complexity to manage synchronization between
bcount_delta and blks_res_used, kill the latter entirely. blk_res_used
is only updated in one place and always in sync with delta_bcount.
Therefore, the net block reservation consumption of the transaction is
always available from bcount_delta. Calculate the reservation
consumption on the fly where necessary based on whether the tp has a
reservation and results in a positive net block delta on the inode.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

Apologies for the long commit log description, this one is a bit hairy.
Hopefully it explains what's going on clearly enough. This passes my
testing so far. We still do have some similar failures in xfstests, but
many of them go away with allocsize=4k. FWIW, it looks like we could do
something similar with qt_rtblk_res_used as well... thoughts?

Brian

 fs/xfs/xfs_quota.h       |  1 -
 fs/xfs/xfs_trans_dquot.c | 28 +++++++++++++++++-----------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5376dd4..ce6506a 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -55,7 +55,6 @@ struct xfs_trans;
 typedef struct xfs_dqtrx {
 	struct xfs_dquot *qt_dquot;	  /* the dquot this refers to */
 	ulong		qt_blk_res;	  /* blks reserved on a dquot */
-	ulong		qt_blk_res_used;  /* blks used from the reservation */
 	ulong		qt_ino_res;	  /* inode reserved on a dquot */
 	ulong		qt_ino_res_used;  /* inodes used from the reservation */
 	long		qt_bcount_delta;  /* dquot blk count changes */
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 76a16df..58c0c6b 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -92,6 +92,7 @@ xfs_trans_dup_dqinfo(
 	xfs_dqtrx_t	*oq, *nq;
 	int		i,j;
 	xfs_dqtrx_t	*oqa, *nqa;
+	ulong		blk_res_used;
 
 	if (!otp->t_dqinfo)
 		return;
@@ -109,11 +110,16 @@ xfs_trans_dup_dqinfo(
 		oqa = otp->t_dqinfo->dqs[j];
 		nqa = ntp->t_dqinfo->dqs[j];
 		for (i = 0; i < XFS_QM_TRANS_MAXDQS; i++) {
+			blk_res_used = 0;
+
 			if (oqa[i].qt_dquot == NULL)
 				break;
 			oq = &oqa[i];
 			nq = &nqa[i];
 
+			if (oq->qt_blk_res && oq->qt_bcount_delta > 0)
+				blk_res_used = oq->qt_bcount_delta;
+
 			nq->qt_dquot = oq->qt_dquot;
 			nq->qt_bcount_delta = nq->qt_icount_delta = 0;
 			nq->qt_rtbcount_delta = 0;
@@ -121,8 +127,8 @@ xfs_trans_dup_dqinfo(
 			/*
 			 * Transfer whatever is left of the reservations.
 			 */
-			nq->qt_blk_res = oq->qt_blk_res - oq->qt_blk_res_used;
-			oq->qt_blk_res = oq->qt_blk_res_used;
+			nq->qt_blk_res = oq->qt_blk_res - blk_res_used;
+			oq->qt_blk_res = blk_res_used;
 
 			nq->qt_rtblk_res = oq->qt_rtblk_res -
 				oq->qt_rtblk_res_used;
@@ -239,10 +245,6 @@ xfs_trans_mod_dquot(
 		 * disk blocks used.
 		 */
 	      case XFS_TRANS_DQ_BCOUNT:
-		if (qtrx->qt_blk_res && delta > 0) {
-			qtrx->qt_blk_res_used += (ulong)delta;
-			ASSERT(qtrx->qt_blk_res >= qtrx->qt_blk_res_used);
-		}
 		qtrx->qt_bcount_delta += delta;
 		break;
 
@@ -423,15 +425,19 @@ xfs_trans_apply_dquot_deltas(
 			 * reservation that a transaction structure knows of.
 			 */
 			if (qtrx->qt_blk_res != 0) {
-				if (qtrx->qt_blk_res != qtrx->qt_blk_res_used) {
-					if (qtrx->qt_blk_res >
-					    qtrx->qt_blk_res_used)
+				ulong blk_res_used = 0;
+
+				if (qtrx->qt_bcount_delta > 0)
+					blk_res_used = qtrx->qt_bcount_delta;
+
+				if (qtrx->qt_blk_res != blk_res_used) {
+					if (qtrx->qt_blk_res > blk_res_used)
 						dqp->q_res_bcount -= (xfs_qcnt_t)
 							(qtrx->qt_blk_res -
-							 qtrx->qt_blk_res_used);
+							 blk_res_used);
 					else
 						dqp->q_res_bcount -= (xfs_qcnt_t)
-							(qtrx->qt_blk_res_used -
+							(blk_res_used -
 							 qtrx->qt_blk_res);
 				}
 			} else {
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
