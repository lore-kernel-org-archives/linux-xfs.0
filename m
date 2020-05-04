Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE2DC4725C
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A84B220705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tbv4Q62n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgEDOMF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:05 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729000AbgEDOME (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601523;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cI6QY2mnTIjh2QeKk9jmhMhjLbWpjJbLKcHAl/C7krw=;
        b=Tbv4Q62nWYtXbKPNbbDAiQhKq4ZBq5pZZ8Yh19lp2fZILcY7bJALXc9DPVqNIbv9GehTBH
        6mxGVNur7+DzcuS+i/YEiVdewlS8ITwIt/icormET+0C2jT1o9zbW4JcQE0OlHvXJS/jkR
        /Xp+jUIfAMHfslugIpFIz4vk26myspg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-jvoljisaOJ2uAte0jU6frg-1; Mon, 04 May 2020 10:12:01 -0400
X-MC-Unique: jvoljisaOJ2uAte0jU6frg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9070108BD0A
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:12:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6237319C4F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:12:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 13/17] xfs: combine xfs_trans_ail_[remove|delete]()
Date:   Mon,  4 May 2020 10:11:50 -0400
Message-Id: <20200504141154.55887-14-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf_item.c   |  2 +-
 fs/xfs/xfs_dquot.c      |  2 +-
 fs/xfs/xfs_dquot_item.c |  2 +-
 fs/xfs/xfs_inode_item.c |  2 +-
 fs/xfs/xfs_trans_ail.c  | 24 ++----------------------
 fs/xfs/xfs_trans_priv.h | 17 -----------------
 6 files changed, 6 insertions(+), 43 deletions(-)

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
index cfba691664c7..bf09d4b4df58 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -841,27 +841,6 @@ xfs_ail_delete_one(
 	return 0;
 }
=20
-/**
- * Remove a log items from the AIL
- *
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
- */
 void
 xfs_trans_ail_delete(
 	struct xfs_log_item	*lip,
@@ -874,7 +853,7 @@ xfs_trans_ail_delete(
 	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (!XFS_FORCED_SHUTDOWN(mp)) {
+		if (shutdown_type && !XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
@@ -883,6 +862,7 @@ xfs_trans_ail_delete(
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

