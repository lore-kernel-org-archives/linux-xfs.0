Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9F6C38A2B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE8F2223D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DXt+iXdG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgDQPJG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54296 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728308AbgDQPJF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MBZCa4WsZ0mADsgx0dDOHIgOH2b9EkV8D5sl3i1939Y=;
        b=DXt+iXdGxS3rD+iY7Lzi+w1h/Jei9Bnt3OvVkwDRuIG0/8Rj+bE8tH1yf0wSpB+B30MDhY
        xwnboXT6fWerhZifHcAKkMSiJI6genWmXySDHzPst2Dau10h2J/Gm0fdfTOTDr5AWvTExT
        HaiprmySTd67x17xGyN6d54QRMAROqM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-5lN9FIcoOPm-XYS3wH5JSw-1; Fri, 17 Apr 2020 11:09:02 -0400
X-MC-Unique: 5lN9FIcoOPm-XYS3wH5JSw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72AC1DBA3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DAE360BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/12] xfs: always attach iflush_done and simplify error handling
Date:   Fri, 17 Apr 2020 11:08:50 -0400
Message-Id: <20200417150859.14734-4-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode flush code has several layers of error handling between
the inode and cluster flushing code. If the inode flush fails before
acquiring the backing buffer, the inode flush is aborted. If the
cluster flush fails, the current inode flush is aborted and the
cluster buffer is failed to handle the initial inode and any others
that might have been attached before the error.

Since xfs_iflush() is the only caller of xfs_iflush_cluser(), the
error handling between the two can be condensed in the top-level
function. If we update xfs_iflush_int() to attach the item
completion handler to the buffer first, any errors that occur after
the first call to xfs_iflush_int() can be handled with a buffer
I/O failure.

Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
and consolidate with the existing error handling. This also replaces
the need to release the buffer because failing the buffer with
XBF_ASYNC drops the current reference.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 94 +++++++++++++++-------------------------------
 1 file changed, 30 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b539ee221ce5..4c9971ec6fa6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3496,6 +3496,7 @@ xfs_iflush_cluster(
 	struct xfs_inode	**cilist;
 	struct xfs_inode	*cip;
 	struct xfs_ino_geometry	*igeo =3D M_IGEO(mp);
+	int			error =3D 0;
 	int			nr_found;
 	int			clcount =3D 0;
 	int			i;
@@ -3588,11 +3589,10 @@ xfs_iflush_cluster(
 		 * re-check that it's dirty before flushing.
 		 */
 		if (!xfs_inode_clean(cip)) {
-			int	error;
 			error =3D xfs_iflush_int(cip, bp);
 			if (error) {
 				xfs_iunlock(cip, XFS_ILOCK_SHARED);
-				goto cluster_corrupt_out;
+				goto out_free;
 			}
 			clcount++;
 		} else {
@@ -3611,32 +3611,7 @@ xfs_iflush_cluster(
 	kmem_free(cilist);
 out_put:
 	xfs_perag_put(pag);
-	return 0;
-
-
-cluster_corrupt_out:
-	/*
-	 * Corruption detected in the clustering loop.  Invalidate the
-	 * inode buffer and shut down the filesystem.
-	 */
-	rcu_read_unlock();
-
-	/*
-	 * We'll always have an inode attached to the buffer for completion
-	 * process by the time we are called from xfs_iflush(). Hence we have
-	 * always need to do IO completion processing to abort the inodes
-	 * attached to the buffer.  handle them just like the shutdown case in
-	 * xfs_buf_submit().
-	 */
-	ASSERT(bp->b_iodone);
-	xfs_buf_iofail(bp, XBF_ASYNC);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-
-	/* abort the corrupt inode, as it was not attached to the buffer */
-	xfs_iflush_abort(cip, false);
-	kmem_free(cilist);
-	xfs_perag_put(pag);
-	return -EFSCORRUPTED;
+	return error;
 }
=20
 /*
@@ -3692,17 +3667,16 @@ xfs_iflush(
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		error =3D -EIO;
-		goto abort_out;
+		goto abort;
 	}
=20
 	/*
 	 * Get the buffer containing the on-disk inode. We are doing a try-lock
-	 * operation here, so we may get  an EAGAIN error. In that case, we
-	 * simply want to return with the inode still dirty.
+	 * operation here, so we may get an EAGAIN error. In that case, return
+	 * leaving the inode dirty.
 	 *
 	 * If we get any other error, we effectively have a corruption situatio=
n
-	 * and we cannot flush the inode, so we treat it the same as failing
-	 * xfs_iflush_int().
+	 * and we cannot flush the inode. Abort the flush and shut down.
 	 */
 	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
 			       0);
@@ -3711,14 +3685,7 @@ xfs_iflush(
 		return error;
 	}
 	if (error)
-		goto corrupt_out;
-
-	/*
-	 * First flush out the inode that xfs_iflush was called with.
-	 */
-	error =3D xfs_iflush_int(ip, bp);
-	if (error)
-		goto corrupt_out;
+		goto abort;
=20
 	/*
 	 * If the buffer is pinned then push on the log now so we won't
@@ -3728,28 +3695,28 @@ xfs_iflush(
 		xfs_log_force(mp, 0);
=20
 	/*
-	 * inode clustering: try to gather other inodes into this write
+	 * Flush the provided inode then attempt to gather others from the
+	 * cluster into the write.
 	 *
-	 * Note: Any error during clustering will result in the filesystem
-	 * being shut down and completion callbacks run on the cluster buffer.
-	 * As we have already flushed and attached this inode to the buffer,
-	 * it has already been aborted and released by xfs_iflush_cluster() and
-	 * so we have no further error handling to do here.
+	 * Note: Once we attempt to flush an inode, we must run buffer
+	 * completion callbacks on any failure. If this fails, simulate an I/O
+	 * failure on the buffer and shut down.
 	 */
-	error =3D xfs_iflush_cluster(ip, bp);
-	if (error)
-		return error;
+	error =3D xfs_iflush_int(ip, bp);
+	if (!error)
+		error =3D xfs_iflush_cluster(ip, bp);
+	if (error) {
+		xfs_buf_iofail(bp, XBF_ASYNC);
+		goto shutdown;
+	}
=20
 	*bpp =3D bp;
 	return 0;
=20
-corrupt_out:
-	if (bp)
-		xfs_buf_relse(bp);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-abort_out:
-	/* abort the corrupt inode, as it was not attached to the buffer */
+abort:
 	xfs_iflush_abort(ip, false);
+shutdown:
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	return error;
 }
=20
@@ -3798,6 +3765,13 @@ xfs_iflush_int(
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip !=3D NULL && iip->ili_fields !=3D 0);
=20
+	/*
+	 * Attach the inode item callback to the buffer. Whether the flush
+	 * succeeds or not, buffer I/O completion processing is now required to
+	 * remove the inode from the AIL and release the flush lock.
+	 */
+	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
+
 	/* set *dip =3D inode's place in the buffer */
 	dip =3D xfs_buf_offset(bp, ip->i_imap.im_boffset);
=20
@@ -3913,14 +3887,6 @@ xfs_iflush_int(
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
=20
-	/*
-	 * Attach the function xfs_iflush_done to the inode's
-	 * buffer.  This will remove the inode from the AIL
-	 * and unlock the inode's flush lock when the inode is
-	 * completely written to disk.
-	 */
-	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
-
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
=20
--=20
2.21.1

