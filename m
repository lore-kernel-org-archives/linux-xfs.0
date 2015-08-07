Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9CB997F59
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 874D98F804C
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NeKfmdLnaAK4qcEz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:32 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 099F23A1170
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:32 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFVX1023257
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 08/12] xfs: fix broken icreate log item cancellation
Date: Fri,  7 Aug 2015 17:15:24 -0400
Message-Id: <1438982128-38618-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
References: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

Inode cluster buffers are invalidated and cancelled when inode chunks
are freed to notify log recovery that previous logged updates to the
metadata buffer should be skipped. This ensures that log recovery does
not overwrite buffers that might have already been reused.

On v4 filesystems, inode chunk allocation and inode updates are logged
via the cluster buffers and thus cancellation is easily detected via
buffer cancellation items. v5 filesystems use the new icreate
transaction, which uses logical logging and ordered buffers to log a
full inode chunk allocation at once. The resulting icreate item often
spans multiple inode cluster buffers.

Log recovery checks for cancelled buffers when processing icreate log
items, but it has a couple problems. First, it uses the full length of
the inode chunk rather than the cluster size. Second, it uses the length
in FSB units rather than BB units. Either of these problems prevent
icreate recovery from identifying cancelled buffers and thus inode
initialization proceeds unconditionally.

Update xlog_recover_do_icreate_pass2() to iterate the icreate range in
cluster sized increments and check each increment for cancellation.
Since icreate is currently only used for the minimum atomic inode chunk
allocation, we expect that either all or none of the buffers will be
cancelled. Cancel the icreate if at least one buffer is cancelled to
avoid making a bad situation worse by initializing a partial inode
chunk, but detect such anomalies and warn the user.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log_recover.c | 49 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2ff62d3..c3de37d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3037,6 +3037,11 @@ xlog_recover_do_icreate_pass2(
 	unsigned int		count;
 	unsigned int		isize;
 	xfs_agblock_t		length;
+	int			blks_per_cluster;
+	int			bb_per_cluster;
+	int			cancel_count;
+	int			nbufs;
+	int			i;
 
 	icl = (struct xfs_icreate_log *)item->ri_buf[0].i_addr;
 	if (icl->icl_type != XFS_LI_ICREATE) {
@@ -3095,25 +3100,45 @@ xlog_recover_do_icreate_pass2(
 	}
 
 	/*
-	 * Inode buffers can be freed. Do not replay the inode initialisation as
-	 * we could be overwriting something written after this inode buffer was
-	 * cancelled.
+	 * The icreate transaction can cover multiple cluster buffers and these
+	 * buffers could have been freed and reused. Check the individual
+	 * buffers for cancellation so we don't overwrite anything written after
+	 * a cancellation.
+	 */
+	blks_per_cluster = xfs_icluster_size_fsb(mp);
+	bb_per_cluster = XFS_FSB_TO_BB(mp, blks_per_cluster);
+	nbufs = length / blks_per_cluster;
+	for (i = 0, cancel_count = 0; i < nbufs; i++) {
+		xfs_daddr_t	daddr;
+
+		daddr = XFS_AGB_TO_DADDR(mp, agno,
+					 agbno + i * blks_per_cluster);
+		if (xlog_check_buffer_cancelled(log, daddr, bb_per_cluster, 0))
+			cancel_count++;
+	}
+
+	/*
+	 * We currently only use icreate for a single allocation at a time. This
+	 * means we should expect either all or none of the buffers to be
+	 * cancelled. Be conservative and skip replay if at least one buffer is
+	 * cancelled, but warn the user that something is awry if the buffers
+	 * are not consistent.
 	 *
-	 * XXX: we need to iterate all buffers and only init those that are not
-	 * cancelled. I think that a more fine grained factoring of
-	 * xfs_ialloc_inode_init may be appropriate here to enable this to be
-	 * done easily.
+	 * XXX: This must be refined to only skip cancelled clusters once we use
+	 * icreate for multiple chunk allocations.
 	 */
-	if (xlog_check_buffer_cancelled(log,
-			XFS_AGB_TO_DADDR(mp, agno, agbno), length, 0)) {
+	ASSERT(!cancel_count || cancel_count == nbufs);
+	if (cancel_count) {
+		if (cancel_count != nbufs)
+			xfs_warn(mp,
+	"WARNING: partial inode chunk cancellation, skipped icreate.");
 		trace_xfs_log_recover_icreate_cancel(log, icl);
 		return 0;
 	}
 
 	trace_xfs_log_recover_icreate_recover(log, icl);
-	xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno, length,
-			      be32_to_cpu(icl->icl_gen));
-	return 0;
+	return xfs_ialloc_inode_init(mp, NULL, buffer_list, count, agno, agbno,
+				     length, be32_to_cpu(icl->icl_gen));
 }
 
 STATIC void
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
