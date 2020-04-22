Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10862C55191
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E01612075A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oqp28uN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDVRyk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41292 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726116AbgDVRyj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M6KnaZ9tnk/7zGjSS8cpLQomL68MQo9to5SZzWZ7t8U=;
        b=Oqp28uN4p4Xr8Y4GOfrI2sKVyyaLSoE2r3r/rgrjam0DWy8jlOwgzuBqBecOL9VDsR7QGk
        bt2acRN93sbKS8fJ0lVsX4nzQLJLJl37jfOr2RwsGFk0sxDZNury8MffNE4kcCxOSMCva6
        JbmSRHYjEjsHxZCEkfFxyrxPzN+DEwU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-_t1tBrHCOoSNqxYECUwk4A-1; Wed, 22 Apr 2020 13:54:35 -0400
X-MC-Unique: _t1tBrHCOoSNqxYECUwk4A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D9EA18538A7
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 281856084A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:34 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/13] xfs: clean up AIL log item removal functions
Date:   Wed, 22 Apr 2020 13:54:25 -0400
Message-Id: <20200422175429.38957-10-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We have two AIL removal functions with slightly different semantics.
xfs_trans_ail_delete() expects the caller to have the AIL lock and
for the associated item to be AIL resident. If not, the filesystem
is shut down. xfs_trans_ail_remove() acquires the AIL lock, checks
that the item is AIL resident and calls the former if so.

These semantics lead to confused usage between the two. For example,
the _remove() variant takes a shutdown parameter to pass to the
_delete() variant, but immediately returns if the AIL bit is not
set. This means that _remove() would never shut down if an item is
not AIL resident, even though it appears that many callers would
expect it to.

Make the following changes to clean up both of these functions:

- Most callers of xfs_trans_ail_delete() acquire the AIL lock just
  before the call. Update _delete() to acquire the lock and open
  code the couple of callers that make additional checks under AIL
  lock.
- Drop the unnecessary ailp parameter from _delete().
- Drop the unused shutdown parameter from _remove() and open code
  the implementation.

In summary, this leaves a _delete() variant that expects an AIL
resident item and a _remove() helper that checks the AIL bit. Audit
the existing callsites for use of the appropriate function and
update as necessary.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_buf_item.c      | 21 ++++++++-------------
 fs/xfs/xfs_dquot.c         | 12 +++++++-----
 fs/xfs/xfs_dquot_item.c    |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_inode_item.c    |  6 +-----
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 fs/xfs/xfs_trans_ail.c     |  3 ++-
 fs/xfs/xfs_trans_priv.h    | 17 +++++++++--------
 10 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ee6f4229cebc..909221a4a8ab 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -51,7 +51,7 @@ xfs_bui_release(
 {
 	ASSERT(atomic_read(&buip->bui_refcount) > 0);
 	if (atomic_dec_and_test(&buip->bui_refcount)) {
-		xfs_trans_ail_remove(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&buip->bui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_bui_item_free(buip);
 	}
 }
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 59906a6e49ae..55e215237b2b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -410,7 +410,6 @@ xfs_buf_item_unpin(
 {
 	struct xfs_buf_log_item	*bip =3D BUF_ITEM(lip);
 	xfs_buf_t		*bp =3D bip->bli_buf;
-	struct xfs_ail		*ailp =3D lip->li_ailp;
 	int			stale =3D bip->bli_flags & XFS_BLI_STALE;
 	int			freed;
=20
@@ -463,8 +462,7 @@ xfs_buf_item_unpin(
 			list_del_init(&bp->b_li_list);
 			bp->b_iodone =3D NULL;
 		} else {
-			spin_lock(&ailp->ail_lock);
-			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_LOG_IO_ERROR);
+			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 			xfs_buf_item_relse(bp);
 			ASSERT(bp->b_log_item =3D=3D NULL);
 		}
@@ -560,7 +558,7 @@ xfs_buf_item_put(
 	 * state.
 	 */
 	if (aborted)
-		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
 	xfs_buf_item_relse(bip->bli_buf);
 	return true;
 }
@@ -1201,22 +1199,19 @@ xfs_buf_iodone(
 	struct xfs_buf		*bp,
 	struct xfs_log_item	*lip)
 {
-	struct xfs_ail		*ailp =3D lip->li_ailp;
-
 	ASSERT(BUF_ITEM(lip)->bli_buf =3D=3D bp);
=20
 	xfs_buf_rele(bp);
=20
 	/*
-	 * If we are forcibly shutting down, this may well be
-	 * off the AIL already. That's because we simulate the
-	 * log-committed callbacks to unpin these buffers. Or we may never
-	 * have put this item on AIL because of the transaction was
-	 * aborted forcibly. xfs_trans_ail_delete() takes care of these.
+	 * If we are forcibly shutting down, this may well be off the AIL
+	 * already. That's because we simulate the log-committed callbacks to
+	 * unpin these buffers. Or we may never have put this item on AIL
+	 * because of the transaction was aborted forcibly.
+	 * xfs_trans_ail_delete() takes care of these.
 	 *
 	 * Either way, AIL is useless if we're forcing a shutdown.
 	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
+	xfs_trans_ail_delete(lip, SHUTDOWN_CORRUPT_INCORE);
 	xfs_buf_item_free(BUF_ITEM(lip));
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index baeb111ae9dc..36ffc09b1a31 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1021,6 +1021,7 @@ xfs_qm_dqflush_done(
 	struct xfs_dq_logitem	*qip =3D (struct xfs_dq_logitem *)lip;
 	struct xfs_dquot	*dqp =3D qip->qli_dquot;
 	struct xfs_ail		*ailp =3D lip->li_ailp;
+	xfs_lsn_t		tail_lsn;
=20
 	/*
 	 * Only pull the item from the AIL if its location in the log has not
@@ -1032,10 +1033,11 @@ xfs_qm_dqflush_done(
 		goto out;
=20
 	spin_lock(&ailp->ail_lock);
-	if (lip->li_lsn =3D=3D qip->qli_flush_lsn)
-		/* xfs_trans_ail_delete() drops the AIL lock */
-		xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
-	else
+	if (lip->li_lsn =3D=3D qip->qli_flush_lsn) {
+		/* xfs_ail_update_finish() drops the AIL lock */
+		tail_lsn =3D xfs_ail_delete_one(ailp, lip);
+		xfs_ail_update_finish(ailp, tail_lsn);
+	} else
 		spin_unlock(&ailp->ail_lock);
=20
 out:
@@ -1149,7 +1151,7 @@ xfs_qm_dqflush(
=20
 out_abort:
 	dqp->dq_flags &=3D ~XFS_DQ_DIRTY;
-	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
+	xfs_trans_ail_remove(lip);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
 	xfs_dqfunlock(dqp);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 5a7808299a32..8bd46810d5db 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -343,7 +343,7 @@ xfs_qm_qoff_logitem_relse(
 	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
 	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
 	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
-	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_trans_ail_remove(lip);
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qoff);
 }
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 6ea847f6e298..cd98eba24884 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -55,7 +55,7 @@ xfs_efi_release(
 {
 	ASSERT(atomic_read(&efip->efi_refcount) > 0);
 	if (atomic_dec_and_test(&efip->efi_refcount)) {
-		xfs_trans_ail_remove(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&efip->efi_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_efi_item_free(efip);
 	}
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0ae61844b224..f8dd9bb8c851 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -763,11 +763,7 @@ xfs_iflush_abort(
 	xfs_inode_log_item_t	*iip =3D ip->i_itemp;
=20
 	if (iip) {
-		if (test_bit(XFS_LI_IN_AIL, &iip->ili_item.li_flags)) {
-			xfs_trans_ail_remove(&iip->ili_item,
-					     stale ? SHUTDOWN_LOG_IO_ERROR :
-						     SHUTDOWN_CORRUPT_INCORE);
-		}
+		xfs_trans_ail_remove(&iip->ili_item);
 		iip->ili_logged =3D 0;
 		/*
 		 * Clear the ili_last_fields bits now that we know that the
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 8eeed73928cd..712939a015a9 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -50,7 +50,7 @@ xfs_cui_release(
 {
 	ASSERT(atomic_read(&cuip->cui_refcount) > 0);
 	if (atomic_dec_and_test(&cuip->cui_refcount)) {
-		xfs_trans_ail_remove(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&cuip->cui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_cui_item_free(cuip);
 	}
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4911b68f95dd..ff949b32c051 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -50,7 +50,7 @@ xfs_rui_release(
 {
 	ASSERT(atomic_read(&ruip->rui_refcount) > 0);
 	if (atomic_dec_and_test(&ruip->rui_refcount)) {
-		xfs_trans_ail_remove(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_delete(&ruip->rui_item, SHUTDOWN_LOG_IO_ERROR);
 		xfs_rui_item_free(ruip);
 	}
 }
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index e03643efdac1..4be7b40060f9 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -872,13 +872,14 @@ xfs_ail_delete_one(
  */
 void
 xfs_trans_ail_delete(
-	struct xfs_ail		*ailp,
 	struct xfs_log_item	*lip,
 	int			shutdown_type)
 {
+	struct xfs_ail		*ailp =3D lip->li_ailp;
 	struct xfs_mount	*mp =3D ailp->ail_mount;
 	xfs_lsn_t		tail_lsn;
=20
+	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
 		if (!XFS_FORCED_SHUTDOWN(mp)) {
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 9135afdcee9d..7563c78e2997 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -94,22 +94,23 @@ xfs_trans_ail_update(
 xfs_lsn_t xfs_ail_delete_one(struct xfs_ail *ailp, struct xfs_log_item *=
lip);
 void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_lsn_t old_lsn)
 			__releases(ailp->ail_lock);
-void xfs_trans_ail_delete(struct xfs_ail *ailp, struct xfs_log_item *lip=
,
-		int shutdown_type);
+void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
=20
 static inline void
 xfs_trans_ail_remove(
-	struct xfs_log_item	*lip,
-	int			shutdown_type)
+	struct xfs_log_item	*lip)
 {
 	struct xfs_ail		*ailp =3D lip->li_ailp;
+	xfs_lsn_t		tail_lsn;
=20
 	spin_lock(&ailp->ail_lock);
-	/* xfs_trans_ail_delete() drops the AIL lock */
-	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags))
-		xfs_trans_ail_delete(ailp, lip, shutdown_type);
-	else
+	/* xfs_ail_update_finish() drops the AIL lock */
+	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
+		tail_lsn =3D xfs_ail_delete_one(ailp, lip);
+		xfs_ail_update_finish(ailp, tail_lsn);
+	} else {
 		spin_unlock(&ailp->ail_lock);
+	}
 }
=20
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
--=20
2.21.1

