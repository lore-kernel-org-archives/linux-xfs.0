Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6464C8300C
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B289120787
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PrUeLL1l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgD2RWG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60380 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726814AbgD2RWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pw9banyOtjO3Qvf0aqxvQASxyUE+zAKJcHBHKb0Gl1U=;
        b=PrUeLL1l+bY4TC9xgKN8Xcg8g3CExIpWYme3MssOxeF5EeQ2PP6XKC2fPk0K6lToe8vPsf
        E2XGyblt9T2wmwi3YXsgJ9JO3WAC4lLjJ7kwAvMw0Y/7vghPuFcPN40y/AEp2g62gni88k
        HXoCF8WRSU0ffXqGUwzfEja3Q2GmhfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-_EbnvGydNue3NxXSISjesQ-1; Wed, 29 Apr 2020 13:22:01 -0400
X-MC-Unique: _EbnvGydNue3NxXSISjesQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A79B1800D4A
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:01 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA345C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:22:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 12/17] xfs: drop unused shutdown parameter from xfs_trans_ail_remove()
Date:   Wed, 29 Apr 2020 13:21:48 -0400
Message-Id: <20200429172153.41680-13-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The shutdown parameter of xfs_trans_ail_remove() is no longer used.
The remaining callers use it for items that legitimately might not
be in the AIL or from contexts where AIL state has already been
checked. Remove the unnecessary parameter and fix up the callers.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c   | 2 +-
 fs/xfs/xfs_dquot.c      | 2 +-
 fs/xfs/xfs_dquot_item.c | 2 +-
 fs/xfs/xfs_inode_item.c | 6 +-----
 fs/xfs/xfs_trans_priv.h | 3 +--
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 06e306b49283..47c547aca1f1 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -558,7 +558,7 @@ xfs_buf_item_put(
 	 * state.
 	 */
 	if (aborted)
-		xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+		xfs_trans_ail_remove(lip);
 	xfs_buf_item_relse(bip->bli_buf);
 	return true;
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 5fb65f43b980..497a9dbef1c9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1162,7 +1162,7 @@ xfs_qm_dqflush(
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
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 1d4d256a2e96..0e449d0a3d5c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -768,11 +768,7 @@ xfs_iflush_abort(
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
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index e4362fb8d483..ab0a82e90825 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -98,8 +98,7 @@ void xfs_trans_ail_delete(struct xfs_log_item *lip, int=
 shutdown_type);
=20
 static inline void
 xfs_trans_ail_remove(
-	struct xfs_log_item	*lip,
-	int			shutdown_type)
+	struct xfs_log_item	*lip)
 {
 	struct xfs_ail		*ailp =3D lip->li_ailp;
 	xfs_lsn_t		tail_lsn;
--=20
2.21.1

