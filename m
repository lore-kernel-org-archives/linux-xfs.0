Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB8FC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C54D20718
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:14:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U3o/4mD2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgAABOG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:14:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:51412 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:14:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011E4pW094146
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IM9clUDZvILAtR3d8I6w8D7g3uPLKB5I0doek1/CG54=;
 b=U3o/4mD2a+A2sROmeb94/+Q/1zc8CIvGBW80a6DpOm+EeNAZk4Xzk7NrOh9MW9oTjbkL
 8vElX1mv0Uw60JBDrms+1IkkTJm3NBPkIicYEdsVotucxTbbfgPs4SnN0EtdNU8hMCqX
 8KbGoCjOUxGPlfH+PWhqad/o9Kt4UnhncH+4Pv/kt4fPqycJIpxPOU5aJhL4FQBMeaZm
 UAsw7XqlJ2CPxHuxxjjI+2OtTGuwgKcmKrqxTOeWOrjZ+vXSGtB5b3MxhEd3K0RLUgae
 wLlaHWpccx9Stm5LU0PgWjFfV8BTgPQAwwEwI741EZTvT7XInFKCIeMhA6xkvyh2XbOM wQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwj0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wqf172111
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:14:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj918vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:14:00 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011DxP8007413
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:59 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:59 -0800
Subject: [PATCH 13/21] xfs: hoist xfs_iunlink to libxfs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:56 -0800
Message-ID: <157784123666.1365473.16748683409913007199.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move xfs_iunlink and xfs_iunlink_remove to libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  424 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   13 +
 fs/xfs/xfs_inode.c             |  430 ----------------------------------------
 fs/xfs/xfs_inode.h             |    3 
 4 files changed, 440 insertions(+), 430 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 9e7eb1f2581c..c4928f4dc0ee 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -17,6 +17,8 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -490,3 +492,425 @@ xfs_dir_ialloc(
 
 	return 0;
 }
+
+/*
+ * Point the AGI unlinked bucket at an inode and log the results.  The caller
+ * is responsible for validating the old value.
+ */
+STATIC int
+xfs_iunlink_update_bucket(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	struct xfs_buf		*agibp,
+	unsigned int		bucket_index,
+	xfs_agino_t		new_agino)
+{
+	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
+	xfs_agino_t		old_value;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
+
+	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
+			old_value, new_agino);
+
+	/*
+	 * We should never find the head of the list already set to the value
+	 * passed in because either we're adding or removing ourselves from the
+	 * head of the list.
+	 */
+	if (old_value == new_agino) {
+		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
+	offset = offsetof(struct xfs_agi, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+}
+
+/* Set an on-disk inode's next_unlinked pointer. */
+STATIC void
+xfs_iunlink_update_dinode(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_buf		*ibp,
+	struct xfs_dinode	*dip,
+	struct xfs_imap		*imap,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
+
+	trace_xfs_iunlink_update_dinode(mp, agno, agino,
+			be32_to_cpu(dip->di_next_unlinked), next_agino);
+
+	dip->di_next_unlinked = cpu_to_be32(next_agino);
+	offset = imap->im_boffset +
+			offsetof(struct xfs_dinode, di_next_unlinked);
+
+	/* need to recalc the inode CRC if appropriate */
+	xfs_dinode_calc_crc(mp, dip);
+	xfs_trans_inode_buf(tp, ibp);
+	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	xfs_inobp_check(mp, ibp);
+}
+
+/* Set an in-core inode's unlinked pointer and return the old value. */
+STATIC int
+xfs_iunlink_update_inode(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		next_agino,
+	xfs_agino_t		*old_next_agino)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_dinode	*dip;
+	struct xfs_buf		*ibp;
+	xfs_agino_t		old_value;
+	int			error;
+
+	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
+
+	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
+	if (error)
+		return error;
+
+	/* Make sure the old pointer isn't garbage. */
+	old_value = be32_to_cpu(dip->di_next_unlinked);
+	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), __this_address);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/*
+	 * Since we're updating a linked list, we should never find that the
+	 * current pointer is the same as the new value, unless we're
+	 * terminating the list.
+	 */
+	*old_next_agino = old_value;
+	if (old_value == next_agino) {
+		if (next_agino != NULLAGINO) {
+			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
+					dip, sizeof(*dip), __this_address);
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+			error = -EFSCORRUPTED;
+		}
+		goto out;
+	}
+
+	/* Ok, update the new pointer. */
+	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			ibp, dip, &ip->i_imap, next_agino);
+	return 0;
+out:
+	xfs_trans_brelse(tp, ibp);
+	return error;
+}
+
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	xfs_agino_t		next_agino;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the pointer isn't garbage and that this inode
+	 * isn't already on the list.
+	 */
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (next_agino == agino ||
+	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
+		xfs_buf_corruption_error(agibp);
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	if (next_agino != NULLAGINO) {
+		struct xfs_perag	*pag;
+		xfs_agino_t		old_agino;
+
+		/*
+		 * There is already another inode in the bucket, so point this
+		 * inode to the current head of the list.
+		 */
+		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
+				&old_agino);
+		if (error)
+			return error;
+		ASSERT(old_agino == NULLAGINO);
+
+		/*
+		 * agino has been unlinked, add a backref from the next inode
+		 * back to agino.
+		 */
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_iunlink_add_backref(pag, agino, next_agino);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	/* Point the head of the list to point to this inode. */
+	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
+}
+
+/* Return the imap, dinode pointer, and buffer for an inode. */
+STATIC int
+xfs_iunlink_map_ino(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		agino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error;
+
+	imap->im_blkno = 0;
+	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_imap returned error %d.",
+				__func__, error);
+		return error;
+	}
+
+	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
+	if (error) {
+		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
+				__func__, error);
+		return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Walk the unlinked chain from @head_agino until we find the inode that
+ * points to @target_agino.  Return the inode number, map, dinode pointer,
+ * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
+ *
+ * @tp, @pag, @head_agino, and @target_agino are input parameters.
+ * @agino, @imap, @dipp, and @bpp are all output parameters.
+ *
+ * Do not call this function if @target_agino is the head of the list.
+ */
+STATIC int
+xfs_iunlink_map_prev(
+	struct xfs_trans	*tp,
+	xfs_agnumber_t		agno,
+	xfs_agino_t		head_agino,
+	xfs_agino_t		target_agino,
+	xfs_agino_t		*agino,
+	struct xfs_imap		*imap,
+	struct xfs_dinode	**dipp,
+	struct xfs_buf		**bpp,
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agino_t		next_agino;
+	int			error;
+
+	ASSERT(head_agino != target_agino);
+	*bpp = NULL;
+
+	/* See if our backref cache can find it faster. */
+	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
+	if (*agino != NULLAGINO) {
+		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
+		if (error)
+			return error;
+
+		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
+			return 0;
+
+		/*
+		 * If we get here the cache contents were corrupt, so drop the
+		 * buffer and fall back to walking the bucket list.
+		 */
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		WARN_ON_ONCE(1);
+	}
+
+	trace_xfs_iunlink_map_prev_fallback(mp, agno);
+
+	/* Otherwise, walk the entire bucket until we find it. */
+	next_agino = head_agino;
+	while (next_agino != target_agino) {
+		xfs_agino_t	unlinked_agino;
+
+		if (*bpp)
+			xfs_trans_brelse(tp, *bpp);
+
+		*agino = next_agino;
+		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
+				bpp);
+		if (error)
+			return error;
+
+		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
+		/*
+		 * Make sure this pointer is valid and isn't an obvious
+		 * infinite loop.
+		 */
+		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
+		    next_agino == unlinked_agino) {
+			XFS_CORRUPTION_ERROR(__func__,
+					XFS_ERRLEVEL_LOW, mp,
+					*dipp, sizeof(**dipp));
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+			error = -EFSCORRUPTED;
+			return error;
+		}
+		next_agino = unlinked_agino;
+	}
+
+	return 0;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi;
+	struct xfs_buf		*agibp;
+	struct xfs_buf		*last_ibp;
+	struct xfs_dinode	*last_dip = NULL;
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		next_agino;
+	xfs_agino_t		head_agino;
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(mp, tp, agno, &agibp);
+	if (error)
+		return error;
+	agi = XFS_BUF_TO_AGI(agibp);
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the head pointer isn't garbage.
+	 */
+	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(mp, agno, head_agino)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Set our inode's next_unlinked pointer to NULL and then return
+	 * the old pointer value so that we can update whatever was previous
+	 * to us in the list to point to whatever was next in the list.
+	 */
+	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
+	if (error)
+		return error;
+
+	/*
+	 * If there was a backref pointing from the next inode back to this
+	 * one, remove it because we've removed this inode from the list.
+	 *
+	 * Later, if this inode was in the middle of the list we'll update
+	 * this inode's backref to point from the next inode.
+	 */
+	if (next_agino != NULLAGINO) {
+		pag = xfs_perag_get(mp, agno);
+		error = xfs_iunlink_change_backref(pag, next_agino,
+				NULLAGINO);
+		if (error)
+			goto out;
+	}
+
+	if (head_agino == agino) {
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
+				next_agino);
+		if (error)
+			goto out;
+	} else {
+		struct xfs_imap	imap;
+		xfs_agino_t	prev_agino;
+
+		if (!pag)
+			pag = xfs_perag_get(mp, agno);
+
+		/* We need to search the list for the inode being freed. */
+		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
+				&prev_agino, &imap, &last_dip, &last_ibp,
+				pag);
+		if (error)
+			goto out;
+
+		/* Point the previous inode on the list to the next inode. */
+		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
+				last_dip, &imap, next_agino);
+
+		/*
+		 * Now we deal with the backref for this inode.  If this inode
+		 * pointed at a real inode, change the backref that pointed to
+		 * us to point to our old next.  If this inode was the end of
+		 * the list, delete the backref that pointed to us.  Note that
+		 * change_backref takes care of deleting the backref if
+		 * next_agino is NULLAGINO.
+		 */
+		error = xfs_iunlink_change_backref(pag, agino, next_agino);
+		if (error)
+			goto out;
+	}
+
+out:
+	if (pag)
+		xfs_perag_put(pag);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 95b58b18dd8b..c4e851589c57 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -46,4 +46,17 @@ int xfs_dir_ialloc(struct xfs_trans **tpp, const struct xfs_ialloc_args *args,
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
 		    struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
+
+/* The libxfs client must provide these iunlink helper functions. */
+int xfs_iunlink_init(struct xfs_perag *pag);
+void xfs_iunlink_destroy(struct xfs_perag *pag);
+xfs_agino_t xfs_iunlink_lookup_backref(struct xfs_perag *pag,
+		xfs_agino_t agino);
+int xfs_iunlink_add_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+int xfs_iunlink_change_backref(struct xfs_perag *pag, xfs_agino_t prev_agino,
+		xfs_agino_t this_agino);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 90102a77e445..83bd046de786 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -43,8 +43,6 @@
 kmem_zone_t *xfs_inode_zone;
 
 STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
-STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
-STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
 
 /*
  * These two are wrapper routines around the xfs_ilock() routine used to
@@ -1757,7 +1755,7 @@ static const struct rhashtable_params xfs_iunlink_hash_params = {
  * Return X, where X.next_unlinked == @agino.  Returns NULLAGINO if no such
  * relation is found.
  */
-static xfs_agino_t
+xfs_agino_t
 xfs_iunlink_lookup_backref(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino)
@@ -1803,7 +1801,7 @@ xfs_iunlink_insert_backref(
 }
 
 /* Remember that @prev_agino.next_unlinked = @this_agino. */
-static int
+int
 xfs_iunlink_add_backref(
 	struct xfs_perag	*pag,
 	xfs_agino_t		prev_agino,
@@ -1826,7 +1824,7 @@ xfs_iunlink_add_backref(
  * If @next_unlinked is NULLAGINO, we drop the backref and exit.  If there
  * wasn't any such entry then we don't bother.
  */
-static int
+int
 xfs_iunlink_change_backref(
 	struct xfs_perag	*pag,
 	xfs_agino_t		agino,
@@ -1899,428 +1897,6 @@ xfs_iunlink_destroy(
 	ASSERT(freed_anything == false || XFS_FORCED_SHUTDOWN(pag->pag_mount));
 }
 
-/*
- * Point the AGI unlinked bucket at an inode and log the results.  The caller
- * is responsible for validating the old value.
- */
-STATIC int
-xfs_iunlink_update_bucket(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	struct xfs_buf		*agibp,
-	unsigned int		bucket_index,
-	xfs_agino_t		new_agino)
-{
-	struct xfs_agi		*agi = XFS_BUF_TO_AGI(agibp);
-	xfs_agino_t		old_value;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(tp->t_mountp, agno, new_agino));
-
-	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, agno, bucket_index,
-			old_value, new_agino);
-
-	/*
-	 * We should never find the head of the list already set to the value
-	 * passed in because either we're adding or removing ourselves from the
-	 * head of the list.
-	 */
-	if (old_value == new_agino) {
-		xfs_buf_corruption_error(agibp);
-		xfs_agno_mark_sick(tp->t_mountp, agno, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
-	offset = offsetof(struct xfs_agi, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	return 0;
-}
-
-/* Set an on-disk inode's next_unlinked pointer. */
-STATIC void
-xfs_iunlink_update_dinode(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino,
-	struct xfs_buf		*ibp,
-	struct xfs_dinode	*dip,
-	struct xfs_imap		*imap,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
-
-	trace_xfs_iunlink_update_dinode(mp, agno, agino,
-			be32_to_cpu(dip->di_next_unlinked), next_agino);
-
-	dip->di_next_unlinked = cpu_to_be32(next_agino);
-	offset = imap->im_boffset +
-			offsetof(struct xfs_dinode, di_next_unlinked);
-
-	/* need to recalc the inode CRC if appropriate */
-	xfs_dinode_calc_crc(mp, dip);
-	xfs_trans_inode_buf(tp, ibp);
-	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	xfs_inobp_check(mp, ibp);
-}
-
-/* Set an in-core inode's unlinked pointer and return the old value. */
-STATIC int
-xfs_iunlink_update_inode(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		next_agino,
-	xfs_agino_t		*old_next_agino)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_dinode	*dip;
-	struct xfs_buf		*ibp;
-	xfs_agino_t		old_value;
-	int			error;
-
-	ASSERT(xfs_verify_agino_or_null(mp, agno, next_agino));
-
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &dip, &ibp, 0, 0);
-	if (error)
-		return error;
-
-	/* Make sure the old pointer isn't garbage. */
-	old_value = be32_to_cpu(dip->di_next_unlinked);
-	if (!xfs_verify_agino_or_null(mp, agno, old_value)) {
-		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
-				sizeof(*dip), __this_address);
-		xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-		error = -EFSCORRUPTED;
-		goto out;
-	}
-
-	/*
-	 * Since we're updating a linked list, we should never find that the
-	 * current pointer is the same as the new value, unless we're
-	 * terminating the list.
-	 */
-	*old_next_agino = old_value;
-	if (old_value == next_agino) {
-		if (next_agino != NULLAGINO) {
-			xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__,
-					dip, sizeof(*dip), __this_address);
-			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-			error = -EFSCORRUPTED;
-		}
-		goto out;
-	}
-
-	/* Ok, update the new pointer. */
-	xfs_iunlink_update_dinode(tp, agno, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			ibp, dip, &ip->i_imap, next_agino);
-	return 0;
-out:
-	xfs_trans_brelse(tp, ibp);
-	return error;
-}
-
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-STATIC int
-xfs_iunlink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
-	xfs_agino_t		next_agino;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-	trace_xfs_iunlink(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_corruption_error(agibp);
-		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	if (next_agino != NULLAGINO) {
-		struct xfs_perag	*pag;
-		xfs_agino_t		old_agino;
-
-		/*
-		 * There is already another inode in the bucket, so point this
-		 * inode to the current head of the list.
-		 */
-		error = xfs_iunlink_update_inode(tp, ip, agno, next_agino,
-				&old_agino);
-		if (error)
-			return error;
-		ASSERT(old_agino == NULLAGINO);
-
-		/*
-		 * agino has been unlinked, add a backref from the next inode
-		 * back to agino.
-		 */
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_add_backref(pag, agino, next_agino);
-		xfs_perag_put(pag);
-		if (error)
-			return error;
-	}
-
-	/* Point the head of the list to point to this inode. */
-	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index, agino);
-}
-
-/* Return the imap, dinode pointer, and buffer for an inode. */
-STATIC int
-xfs_iunlink_map_ino(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	int			error;
-
-	imap->im_blkno = 0;
-	error = xfs_imap(mp, tp, XFS_AGINO_TO_INO(mp, agno, agino), imap, 0);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	error = xfs_imap_to_bp(mp, tp, imap, dipp, bpp, 0, 0);
-	if (error) {
-		xfs_warn(mp, "%s: xfs_imap_to_bp returned error %d.",
-				__func__, error);
-		return error;
-	}
-
-	return 0;
-}
-
-/*
- * Walk the unlinked chain from @head_agino until we find the inode that
- * points to @target_agino.  Return the inode number, map, dinode pointer,
- * and inode cluster buffer of that inode as @agino, @imap, @dipp, and @bpp.
- *
- * @tp, @pag, @head_agino, and @target_agino are input parameters.
- * @agino, @imap, @dipp, and @bpp are all output parameters.
- *
- * Do not call this function if @target_agino is the head of the list.
- */
-STATIC int
-xfs_iunlink_map_prev(
-	struct xfs_trans	*tp,
-	xfs_agnumber_t		agno,
-	xfs_agino_t		head_agino,
-	xfs_agino_t		target_agino,
-	xfs_agino_t		*agino,
-	struct xfs_imap		*imap,
-	struct xfs_dinode	**dipp,
-	struct xfs_buf		**bpp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	xfs_agino_t		next_agino;
-	int			error;
-
-	ASSERT(head_agino != target_agino);
-	*bpp = NULL;
-
-	/* See if our backref cache can find it faster. */
-	*agino = xfs_iunlink_lookup_backref(pag, target_agino);
-	if (*agino != NULLAGINO) {
-		error = xfs_iunlink_map_ino(tp, agno, *agino, imap, dipp, bpp);
-		if (error)
-			return error;
-
-		if (be32_to_cpu((*dipp)->di_next_unlinked) == target_agino)
-			return 0;
-
-		/*
-		 * If we get here the cache contents were corrupt, so drop the
-		 * buffer and fall back to walking the bucket list.
-		 */
-		xfs_trans_brelse(tp, *bpp);
-		*bpp = NULL;
-		WARN_ON_ONCE(1);
-	}
-
-	trace_xfs_iunlink_map_prev_fallback(mp, agno);
-
-	/* Otherwise, walk the entire bucket until we find it. */
-	next_agino = head_agino;
-	while (next_agino != target_agino) {
-		xfs_agino_t	unlinked_agino;
-
-		if (*bpp)
-			xfs_trans_brelse(tp, *bpp);
-
-		*agino = next_agino;
-		error = xfs_iunlink_map_ino(tp, agno, next_agino, imap, dipp,
-				bpp);
-		if (error)
-			return error;
-
-		unlinked_agino = be32_to_cpu((*dipp)->di_next_unlinked);
-		/*
-		 * Make sure this pointer is valid and isn't an obvious
-		 * infinite loop.
-		 */
-		if (!xfs_verify_agino(mp, agno, unlinked_agino) ||
-		    next_agino == unlinked_agino) {
-			XFS_CORRUPTION_ERROR(__func__,
-					XFS_ERRLEVEL_LOW, mp,
-					*dipp, sizeof(**dipp));
-			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-			error = -EFSCORRUPTED;
-			return error;
-		}
-		next_agino = unlinked_agino;
-	}
-
-	return 0;
-}
-
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-STATIC int
-xfs_iunlink_remove(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi;
-	struct xfs_buf		*agibp;
-	struct xfs_buf		*last_ibp;
-	struct xfs_dinode	*last_dip = NULL;
-	struct xfs_perag	*pag = NULL;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		next_agino;
-	xfs_agino_t		head_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	trace_xfs_iunlink_remove(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(mp, tp, agno, &agibp);
-	if (error)
-		return error;
-	agi = XFS_BUF_TO_AGI(agibp);
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the head pointer isn't garbage.
-	 */
-	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(mp, agno, head_agino)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				agi, sizeof(*agi));
-		xfs_agno_mark_sick(mp, agno, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Set our inode's next_unlinked pointer to NULL and then return
-	 * the old pointer value so that we can update whatever was previous
-	 * to us in the list to point to whatever was next in the list.
-	 */
-	error = xfs_iunlink_update_inode(tp, ip, agno, NULLAGINO, &next_agino);
-	if (error)
-		return error;
-
-	/*
-	 * If there was a backref pointing from the next inode back to this
-	 * one, remove it because we've removed this inode from the list.
-	 *
-	 * Later, if this inode was in the middle of the list we'll update
-	 * this inode's backref to point from the next inode.
-	 */
-	if (next_agino != NULLAGINO) {
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_change_backref(pag, next_agino,
-				NULLAGINO);
-		if (error)
-			goto out;
-	}
-
-	if (head_agino == agino) {
-		/* Point the head of the list to the next unlinked inode. */
-		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
-				next_agino);
-		if (error)
-			goto out;
-	} else {
-		struct xfs_imap	imap;
-		xfs_agino_t	prev_agino;
-
-		if (!pag)
-			pag = xfs_perag_get(mp, agno);
-
-		/* We need to search the list for the inode being freed. */
-		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
-				&prev_agino, &imap, &last_dip, &last_ibp,
-				pag);
-		if (error)
-			goto out;
-
-		/* Point the previous inode on the list to the next inode. */
-		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
-				last_dip, &imap, next_agino);
-
-		/*
-		 * Now we deal with the backref for this inode.  If this inode
-		 * pointed at a real inode, change the backref that pointed to
-		 * us to point to our old next.  If this inode was the end of
-		 * the list, delete the backref that pointed to us.  Note that
-		 * change_backref takes care of deleting the backref if
-		 * next_agino is NULLAGINO.
-		 */
-		error = xfs_iunlink_change_backref(pag, agino, next_agino);
-		if (error)
-			goto out;
-	}
-
-out:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
-}
-
 /*
  * A big issue when freeing the inode cluster is that we _cannot_ skip any
  * inodes that are in memory - they all must be marked stale and attached to
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 79c26e8494a6..efc28b47578a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -501,9 +501,6 @@ bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
 void xfs_inode_inactivation_prep(struct xfs_inode *ip);
 void xfs_inode_inactivation_cleanup(struct xfs_inode *ip);
 
-int xfs_iunlink_init(struct xfs_perag *pag);
-void xfs_iunlink_destroy(struct xfs_perag *pag);
-
 void xfs_end_io(struct work_struct *work);
 
 #endif	/* __XFS_INODE_H__ */

