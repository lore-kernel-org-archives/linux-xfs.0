Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 079F9C5518C
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DABEB2075A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQU23dpD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgDVRyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30052 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726060AbgDVRyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mXaCRHcCBQkoEI1EWg5oNMig3P0vXdk6b6oBRFXn1ig=;
        b=FQU23dpDFav2hHS1aYheMlvIgfQB/RCEn6CILX7IkzCGtVqfyaRGD5aaosdq5YaRW9Sr34
        ySqug9nlfTluxeTqhPByBhjfgiRIhdKfd2+jeV5SYpXXEzU5yO+h+W+07tnXMAsmDV7hBi
        SEk/Pd714/L20zC7oT675agGzCG/Z1U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-jA7qO8nuN1ObsWCgVWnCyw-1; Wed, 22 Apr 2020 13:54:34 -0400
X-MC-Unique: jA7qO8nuN1ObsWCgVWnCyw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0144C107ACC7
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B00E06084A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:33 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 08/13] xfs: elide the AIL lock on log item failure tracking
Date:   Wed, 22 Apr 2020 13:54:24 -0400
Message-Id: <20200422175429.38957-9-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The log item failed flag is used to indicate a log item was flushed
but the underlying buffer was not successfully written to disk. If
the error configuration allows for writeback retries, xfsaild uses
the flag to resubmit the underlying buffer without acquiring the
flush lock of the item.

The flag is currently set and cleared under the AIL lock and buffer
lock in the ->iop_error() callback, invoked via ->b_iodone() at I/O
completion time. The flag is checked at xfsaild push time under AIL
lock and cleared under buffer lock before resubmission. If I/O
eventually succeeds, the flag is cleared in the _done() handler for
the associated item type, again under AIL lock and buffer lock.

As far as I can tell, the only reason for holding the AIL lock
across sets/clears is to manage consistency between the log item
bitop state and the temporary buffer pointer that is attached to the
log item. The bit itself is used to manage consistency of the
attached buffer, but is not enough to guarantee the buffer is still
attached by the time xfsaild attempts to access it. However since
failure state is always set or cleared under buffer lock (either via
I/O completion or xfsaild), this particular case can be handled at
item push time by verifying failure state once under buffer lock.

Remove the AIL lock protection from the various bits of log item
failure state management and simplify the surrounding code where
applicable. Use the buffer lock in the xfsaild resubmit code to
detect failure state changes and temporarily treat the item as
locked.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c   |  4 ----
 fs/xfs/xfs_dquot.c      | 41 +++++++++++++++--------------------------
 fs/xfs/xfs_inode_item.c | 11 +++--------
 fs/xfs/xfs_trans_ail.c  | 12 ++++++++++--
 fs/xfs/xfs_trans_priv.h |  5 -----
 5 files changed, 28 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 23cbfeb82183..59906a6e49ae 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1038,7 +1038,6 @@ xfs_buf_do_callbacks_fail(
 	struct xfs_buf		*bp)
 {
 	struct xfs_log_item	*lip;
-	struct xfs_ail		*ailp;
=20
 	/*
 	 * Buffer log item errors are handled directly by xfs_buf_item_push()
@@ -1050,13 +1049,10 @@ xfs_buf_do_callbacks_fail(
=20
 	lip =3D list_first_entry(&bp->b_li_list, struct xfs_log_item,
 			li_bio_list);
-	ailp =3D lip->li_ailp;
-	spin_lock(&ailp->ail_lock);
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
 		if (lip->li_ops->iop_error)
 			lip->li_ops->iop_error(lip, bp);
 	}
-	spin_unlock(&ailp->ail_lock);
 }
=20
 static bool
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index ffe607733c50..baeb111ae9dc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1023,34 +1023,23 @@ xfs_qm_dqflush_done(
 	struct xfs_ail		*ailp =3D lip->li_ailp;
=20
 	/*
-	 * We only want to pull the item from the AIL if its
-	 * location in the log has not changed since we started the flush.
-	 * Thus, we only bother if the dquot's lsn has
-	 * not changed. First we check the lsn outside the lock
-	 * since it's cheaper, and then we recheck while
-	 * holding the lock before removing the dquot from the AIL.
+	 * Only pull the item from the AIL if its location in the log has not
+	 * changed since it was flushed. Do a lockless check first to reduce
+	 * lock traffic.
 	 */
-	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags) &&
-	    ((lip->li_lsn =3D=3D qip->qli_flush_lsn) ||
-	     test_bit(XFS_LI_FAILED, &lip->li_flags))) {
-
-		/* xfs_trans_ail_delete() drops the AIL lock. */
-		spin_lock(&ailp->ail_lock);
-		if (lip->li_lsn =3D=3D qip->qli_flush_lsn) {
-			xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
-		} else {
-			/*
-			 * Clear the failed state since we are about to drop the
-			 * flush lock
-			 */
-			xfs_clear_li_failed(lip);
-			spin_unlock(&ailp->ail_lock);
-		}
-	}
+	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
+	    lip->li_lsn !=3D qip->qli_flush_lsn)
+		goto out;
=20
-	/*
-	 * Release the dq's flush lock since we're done with it.
-	 */
+	spin_lock(&ailp->ail_lock);
+	if (lip->li_lsn =3D=3D qip->qli_flush_lsn)
+		/* xfs_trans_ail_delete() drops the AIL lock */
+		xfs_trans_ail_delete(ailp, lip, SHUTDOWN_CORRUPT_INCORE);
+	else
+		spin_unlock(&ailp->ail_lock);
+
+out:
+	xfs_clear_li_failed(lip);
 	xfs_dqfunlock(dqp);
 }
=20
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1d4d256a2e96..0ae61844b224 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -682,9 +682,7 @@ xfs_iflush_done(
 	 * Scan the buffer IO completions for other inodes being completed and
 	 * attach them to the current inode log item.
 	 */
-
 	list_add_tail(&lip->li_bio_list, &tmp);
-
 	list_for_each_entry_safe(blip, n, &bp->b_li_list, li_bio_list) {
 		if (lip->li_cb !=3D xfs_iflush_done)
 			continue;
@@ -695,15 +693,13 @@ xfs_iflush_done(
 		 * the AIL lock.
 		 */
 		iip =3D INODE_ITEM(blip);
-		if ((iip->ili_logged && blip->li_lsn =3D=3D iip->ili_flush_lsn) ||
-		    test_bit(XFS_LI_FAILED, &blip->li_flags))
+		if (iip->ili_logged && blip->li_lsn =3D=3D iip->ili_flush_lsn)
 			need_ail++;
 	}
=20
 	/* make sure we capture the state of the initial inode. */
 	iip =3D INODE_ITEM(lip);
-	if ((iip->ili_logged && lip->li_lsn =3D=3D iip->ili_flush_lsn) ||
-	    test_bit(XFS_LI_FAILED, &lip->li_flags))
+	if (iip->ili_logged && lip->li_lsn =3D=3D iip->ili_flush_lsn)
 		need_ail++;
=20
 	/*
@@ -732,8 +728,6 @@ xfs_iflush_done(
 				xfs_lsn_t lsn =3D xfs_ail_delete_one(ailp, blip);
 				if (!tail_lsn && lsn)
 					tail_lsn =3D lsn;
-			} else {
-				xfs_clear_li_failed(blip);
 			}
 		}
 		xfs_ail_update_finish(ailp, tail_lsn);
@@ -746,6 +740,7 @@ xfs_iflush_done(
 	 */
 	list_for_each_entry_safe(blip, n, &tmp, li_bio_list) {
 		list_del_init(&blip->li_bio_list);
+		xfs_clear_li_failed(blip);
 		iip =3D INODE_ITEM(blip);
 		iip->ili_logged =3D 0;
 		iip->ili_last_fields =3D 0;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 2574d01e4a83..e03643efdac1 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -368,15 +368,23 @@ xfsaild_resubmit_item(
 {
 	struct xfs_buf		*bp =3D lip->li_buf;
=20
-	if (!xfs_buf_trylock(bp))
+	/*
+	 * Log item state bits are racy so we cannot assume the temporary buffe=
r
+	 * pointer is set. Treat the item as locked if the pointer is clear or
+	 * the failure state has changed once we've locked out I/O completion.
+	 */
+	if (!bp || !xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
+	if (!test_bit(XFS_LI_FAILED, &lip->li_flags)) {
+		xfs_buf_unlock(bp);
+		return XFS_ITEM_LOCKED;
+	}
=20
 	if (!xfs_buf_delwri_queue(bp, buffer_list)) {
 		xfs_buf_unlock(bp);
 		return XFS_ITEM_FLUSHING;
 	}
=20
-	/* protected by ail_lock */
 	list_for_each_entry(lip, &bp->b_li_list, li_bio_list)
 		xfs_clear_li_failed(lip);
=20
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 35655eac01a6..9135afdcee9d 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -158,9 +158,6 @@ xfs_clear_li_failed(
 {
 	struct xfs_buf	*bp =3D lip->li_buf;
=20
-	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
-	lockdep_assert_held(&lip->li_ailp->ail_lock);
-
 	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
 		lip->li_buf =3D NULL;
 		xfs_buf_rele(bp);
@@ -172,8 +169,6 @@ xfs_set_li_failed(
 	struct xfs_log_item	*lip,
 	struct xfs_buf		*bp)
 {
-	lockdep_assert_held(&lip->li_ailp->ail_lock);
-
 	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
 		xfs_buf_hold(bp);
 		lip->li_buf =3D bp;
--=20
2.21.1

