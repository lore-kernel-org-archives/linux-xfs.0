Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C494C83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75204208FE
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VsfTeBku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbgD2RWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:06 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42020 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726838AbgD2RWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bblx4sHapej+ZDdW+2K6FcqnzT62Q/DfQjdwHVe+p0w=;
        b=VsfTeBkuY8XaBBHh8zrg+SY+VP3s73wZBbc74cULaya4z1TkkCYHiIRSMRhSg+Zd/wGqzU
        T8trCZ1U2gAVr25S1EnKOKu25aMHQ4qnTbqmo3OXx7m6Lkp/lJ4tWdRgVmUqoJXocEHdeY
        BIv3GBKBXn5UI6Wcu7jtZUz/tyWtY6k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-vW8oBZGaM_WPUEZqLbe3og-1; Wed, 29 Apr 2020 13:22:02 -0400
X-MC-Unique: vW8oBZGaM_WPUEZqLbe3og-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F70145F
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B8125C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
Date:   Wed, 29 Apr 2020 13:21:49 -0400
Message-Id: <20200429172153.41680-14-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the functions and callers of
xfs_trans_ail_[remove|delete]() have been fixed up appropriately,
the only difference between the two is the shutdown behavior. There
are only a few callers of the _remove() variant, so make the
shutdown conditional on the parameter and combine the two functions.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c   |  2 +-
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot_item.c |  2 +-
 fs/xfs/xfs_inode_item.c |  2 +-
 fs/xfs/xfs_trans_ail.c  | 27 ++++++++-------------------
 fs/xfs/xfs_trans_priv.h | 17 -----------------
 6 files changed, 12 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 47c547aca1f1..9e75e8d6042e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -558,7 +558,7 @@ xfs_buf_item_put(
 	 * state.
 	 */
 	if (aborted)
-		xfs_trans_ail_remove(lip);
+		xfs_trans_ail_delete(lip, 0);
 	xfs_buf_item_relse(bip->bli_buf);
 	return true;
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 497a9dbef1c9..52e0f7245afc 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1162,7 +1162,7 @@ xfs_qm_dqflush(
=20
 out_abort:
 	dqp->dq_flags &=3D ~XFS_DQ_DIRTY;
-	xfs_trans_ail_remove(lip);
+	xfs_trans_ail_delete(lip, 0);
 	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
 	xfs_dqfunlock(dqp);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 8bd46810d5db..349c92d26570 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -343,7 +343,7 @@ xfs_qm_qoff_logitem_relse(
 	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
 	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
 	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
-	xfs_trans_ail_remove(lip);
+	xfs_trans_ail_delete(lip, 0);
 	kmem_free(lip->li_lv_shadow);
 	kmem_free(qoff);
 }
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0e449d0a3d5c..1a02058178d1 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -768,7 +768,7 @@ xfs_iflush_abort(
 	xfs_inode_log_item_t	*iip =3D ip->i_itemp;
=20
 	if (iip) {
-		xfs_trans_ail_remove(&iip->ili_item);
+		xfs_trans_ail_delete(&iip->ili_item, 0);
 		iip->ili_logged =3D 0;
 		/*
 		 * Clear the ili_last_fields bits now that we know that the
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index cfba691664c7..aa6a911e5c96 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -842,25 +842,13 @@ xfs_ail_delete_one(
 }
=20
 /**
- * Remove a log items from the AIL
+ * Remove a log item from the AIL.
  *
- * @xfs_trans_ail_delete_bulk takes an array of log items that all need =
to
- * removed from the AIL. The caller is already holding the AIL lock, and=
 done
- * all the checks necessary to ensure the items passed in via @log_items=
 are
- * ready for deletion. This includes checking that the items are in the =
AIL.
- *
- * For each log item to be removed, unlink it  from the AIL, clear the I=
N_AIL
- * flag from the item and reset the item's lsn to 0. If we remove the fi=
rst
- * item in the AIL, update the log tail to match the new minimum LSN in =
the
- * AIL.
- *
- * This function will not drop the AIL lock until all items are removed =
from
- * the AIL to minimise the amount of lock traffic on the AIL. This does =
not
- * greatly increase the AIL hold time, but does significantly reduce the=
 amount
- * of traffic on the lock, especially during IO completion.
- *
- * This function must be called with the AIL lock held.  The lock is dro=
pped
- * before returning.
+ * For each log item to be removed, unlink it from the AIL, clear the IN=
_AIL
+ * flag from the item and reset the item's lsn to 0. If we remove the fi=
rst item
+ * in the AIL, update the log tail to match the new minimum LSN in the A=
IL. If
+ * the item is not in the AIL, shut down if the caller has provided a sh=
utdown
+ * type. Otherwise return quietly as this state is expected.
  */
 void
 xfs_trans_ail_delete(
@@ -874,7 +862,7 @@ xfs_trans_ail_delete(
 	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (shutdown_type && !XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
@@ -883,6 +871,7 @@ xfs_trans_ail_delete(
 		return;
 	}
=20
+	/* xfs_ail_update_finish() drops the AIL lock */
 	tail_lsn =3D xfs_ail_delete_one(ailp, lip);
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index ab0a82e90825..cc046d9557ae 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -96,23 +96,6 @@ void xfs_ail_update_finish(struct xfs_ail *ailp, xfs_l=
sn_t old_lsn)
 			__releases(ailp->ail_lock);
 void xfs_trans_ail_delete(struct xfs_log_item *lip, int shutdown_type);
=20
-static inline void
-xfs_trans_ail_remove(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_ail		*ailp =3D lip->li_ailp;
-	xfs_lsn_t		tail_lsn;
-
-	spin_lock(&ailp->ail_lock);
-	/* xfs_ail_update_finish() drops the AIL lock */
-	if (test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
-		tail_lsn =3D xfs_ail_delete_one(ailp, lip);
-		xfs_ail_update_finish(ailp, tail_lsn);
-	} else {
-		spin_unlock(&ailp->ail_lock);
-	}
-}
-
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
 void			xfs_ail_push_all_sync(struct xfs_ail *);
--=20
2.21.1

