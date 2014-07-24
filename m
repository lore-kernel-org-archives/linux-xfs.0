Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF5827F47
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 09:23:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CD22AC009
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 07:23:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ld5VciELc0zUwCE4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 24 Jul 2014 07:23:12 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s6OENA0E016643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:11 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s6OENA44017006
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 10:23:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 08/18] xfs: create helper to manage record overlap for sparse
	inode chunks
Date: Thu, 24 Jul 2014 10:22:58 -0400
Message-Id: <1406211788-63206-9-git-send-email-bfoster@redhat.com>
In-Reply-To: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
References: <1406211788-63206-1-git-send-email-bfoster@redhat.com>
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

Create xfs_spchunk_has_record() to receive the parameters of a new
sparse inode chunk allocation and identify whether a record exists that
is capable of tracking this sparse chunk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 27d3437..be57b51 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -351,6 +351,61 @@ xfs_ialloc_inode_init(
 }
 
 /*
+ * Determine whether part of a sparse inode chunk that has just been allocated
+ * is covered by an existing inobt record.
+ */
+STATIC int
+xfs_spchunk_has_record(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	struct xfs_buf			*agbp,
+	xfs_agino_t			newino,
+	xfs_agino_t			count,
+	xfs_btnum_t			btnum,
+	struct xfs_inobt_rec_incore	*orec)
+{
+	struct xfs_btree_cur		*cur;
+	struct xfs_agi			*agi = XFS_BUF_TO_AGI(agbp);
+	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
+	xfs_agino_t			previno;
+	int				error;
+	int				i;
+	struct xfs_inobt_rec_incore	rec;
+
+	orec->ir_startino = NULLAGINO;
+
+	cur = xfs_inobt_init_cursor(mp, tp, agbp, agno, btnum);
+
+	previno = newino + count - XFS_INODES_PER_CHUNK;
+	error = xfs_inobt_lookup(cur, previno, XFS_LOOKUP_GE, &i);
+	if (error)
+		goto error;
+	if (i == 0)
+		goto out;
+
+	error = xfs_inobt_get_rec(cur, &rec, &i);
+	if (error)
+		goto error;
+	XFS_WANT_CORRUPTED_GOTO(i == 1, error);
+
+	if (rec.ir_startino > newino)
+		goto out;
+
+	ASSERT(rec.ir_startino <= newino &&
+	       rec.ir_startino + XFS_INODES_PER_CHUNK > newino);
+	ASSERT(rec.ir_freecount + count <= XFS_INODES_PER_CHUNK);
+
+	*orec = rec;
+
+out:
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
  * Allocate new inodes in the allocation group specified by agbp.
  * Return 0 for success, else error code.
  */
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
