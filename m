Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337FCC83000
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF2720787
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TlOUb9HM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgD2RWE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726580AbgD2RWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y0gpB65s6+7BBrFhrXeGbWkWjcZh6nT/Kbt8MXNQCQk=;
        b=TlOUb9HM/EVXCJV8zIk1o79lR0bPS9FGgZ+Av5Z63DGM1LLQ4NkYBG5FkpD9+Hh5ByyJ/t
        UidOhbMaSRN5u2XqbxEYY+MLsZn5Jb35VepXI/SLo5LNGZmICVmZkQu4p8svbsfV/JXxxj
        RMj24TQISI0jAtcXLLUWATaELF9PhHU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-rzbVDJ1eNrKX7q2XMXWiLw-1; Wed, 29 Apr 2020 13:21:57 -0400
X-MC-Unique: rzbVDJ1eNrKX7q2XMXWiLw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EE4F800C78
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:56 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF6A55C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:55 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 03/17] xfs: simplify inode flush error handling
Date:   Wed, 29 Apr 2020 13:21:39 -0400
Message-Id: <20200429172153.41680-4-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Since xfs_iflush() is the only caller of xfs_iflush_cluster(), the
error handling between the two can be condensed in the top-level
function. If we update xfs_iflush_int() to always fall through to
the log item update and attach the item completion handler to the
buffer, any errors that occur after the first call to
xfs_iflush_int() can be handled with a buffer I/O failure.

Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
and consolidate with the existing error handling. This also replaces
the need to release the buffer because failing the buffer with
XBF_ASYNC drops the current reference.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 117 +++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 72 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 909ca7c0bac4..84f2ee9957dc 100644
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
@@ -3611,33 +3611,7 @@ xfs_iflush_cluster(
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
-	bp->b_flags |=3D XBF_ASYNC;
-	xfs_buf_ioend_fail(bp);
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
@@ -3693,17 +3667,16 @@ xfs_iflush(
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
@@ -3712,14 +3685,7 @@ xfs_iflush(
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
@@ -3729,28 +3695,29 @@ xfs_iflush(
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
+		bp->b_flags |=3D XBF_ASYNC;
+		xfs_buf_ioend_fail(bp);
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
@@ -3792,6 +3759,7 @@ xfs_iflush_int(
 	struct xfs_inode_log_item *iip =3D ip->i_itemp;
 	struct xfs_dinode	*dip;
 	struct xfs_mount	*mp =3D ip->i_mount;
+	int			error;
=20
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
@@ -3799,15 +3767,21 @@ xfs_iflush_int(
 	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip !=3D NULL && iip->ili_fields !=3D 0);
=20
-	/* set *dip =3D inode's place in the buffer */
 	dip =3D xfs_buf_offset(bp, ip->i_imap.im_boffset);
=20
+	/*
+	 * We don't flush the inode if any of the following checks fail, but we
+	 * do still update the log item and attach to the backing buffer as if
+	 * the flush happened. This is a formality to facilitate predictable
+	 * error handling as the caller will shutdown and fail the buffer.
+	 */
+	error =3D -EFSCORRUPTED;
 	if (XFS_TEST_ERROR(dip->di_magic !=3D cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: Bad inode %Lu magic number 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
-		goto corrupt_out;
+		goto flush_out;
 	}
 	if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
@@ -3817,7 +3791,7 @@ xfs_iflush_int(
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
-			goto corrupt_out;
+			goto flush_out;
 		}
 	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
@@ -3828,7 +3802,7 @@ xfs_iflush_int(
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
-			goto corrupt_out;
+			goto flush_out;
 		}
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
@@ -3839,14 +3813,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino,
 			ip->i_d.di_nextents + ip->i_d.di_anextents,
 			ip->i_d.di_nblocks, ip);
-		goto corrupt_out;
+		goto flush_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
-		goto corrupt_out;
+		goto flush_out;
 	}
=20
 	/*
@@ -3863,7 +3837,7 @@ xfs_iflush_int(
=20
 	/* Check the inline fork data before we write out. */
 	if (!xfs_inode_verify_forks(ip))
-		goto corrupt_out;
+		goto flush_out;
=20
 	/*
 	 * Copy the dirty parts of the inode into the on-disk inode.  We always
@@ -3906,6 +3880,8 @@ xfs_iflush_int(
 	 * need the AIL lock, because it is a 64 bit value that cannot be read
 	 * atomically.
 	 */
+	error =3D 0;
+flush_out:
 	iip->ili_last_fields =3D iip->ili_fields;
 	iip->ili_fields =3D 0;
 	iip->ili_fsync_fields =3D 0;
@@ -3915,10 +3891,10 @@ xfs_iflush_int(
 				&iip->ili_item.li_lsn);
=20
 	/*
-	 * Attach the function xfs_iflush_done to the inode's
-	 * buffer.  This will remove the inode from the AIL
-	 * and unlock the inode's flush lock when the inode is
-	 * completely written to disk.
+	 * Attach the inode item callback to the buffer whether the flush
+	 * succeeded or not. If not, the caller will shut down and fail I/O
+	 * completion on the buffer to remove the inode from the AIL and releas=
e
+	 * the flush lock.
 	 */
 	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
=20
@@ -3927,10 +3903,7 @@ xfs_iflush_int(
=20
 	ASSERT(!list_empty(&bp->b_li_list));
 	ASSERT(bp->b_iodone !=3D NULL);
-	return 0;
-
-corrupt_out:
-	return -EFSCORRUPTED;
+	return error;
 }
=20
 /* Release an inode. */
--=20
2.21.1

