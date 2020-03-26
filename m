Return-Path: <SRS0=JvtZ=5L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053E6C2D0E5
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF3C520748
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Mar 2020 13:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GUkAkRiX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCZNRJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Mar 2020 09:17:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:57666 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725994AbgCZNRJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Mar 2020 09:17:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585228627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F3+njpDWURZtvA/5SXScE8gx+MHhThXqybUjGClSV5Q=;
        b=GUkAkRiXTMPZ4gBvjIOSa3pgEydpNAJJwIW/bQsflMLYObC/OpebFy9drEGEOyQ6l3Ai3t
        w+naKJ98HAqYc9ZopCnTjwmRdu2XKTY6lmucjVWBceQmW04wwPYEkTN5ibrB6EreCewErF
        64DPRSFnU7paDAqbupdiX9zCfDGMC8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-o40Z5T7qNjekYXDy-Rykeg-1; Thu, 26 Mar 2020 09:17:05 -0400
X-MC-Unique: o40Z5T7qNjekYXDy-Rykeg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F7AE800D4E
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:04 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 639B61001925
        for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2020 13:17:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Date:   Thu, 26 Mar 2020 09:17:02 -0400
Message-Id: <20200326131703.23246-2-bfoster@redhat.com>
In-Reply-To: <20200326131703.23246-1-bfoster@redhat.com>
References: <20200326131703.23246-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A dquot flush currently blocks on the buffer lock for the underlying
dquot buffer. In turn, this causes xfsaild to block rather than
continue processing other items in the meantime. Update
xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
are handled, and return -EAGAIN if the lock fails. Fix up any
callers that don't currently handle the error properly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.c      |  6 +++---
 fs/xfs/xfs_dquot_item.c |  3 ++-
 fs/xfs/xfs_qm.c         | 14 +++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 711376ca269f..af2c8e5ceea0 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error =3D xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-				   &xfs_dquot_buf_ops);
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
 	if (error)
 		goto out_unlock;
=20
@@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
=20
 out_unlock:
 	xfs_dqfunlock(dqp);
-	return -EIO;
+	return error;
 }
=20
 /*
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index cf65e2e43c6e..baad1748d0d1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval =3D XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	}
+	} else if (error =3D=3D -EAGAIN)
+		rval =3D XFS_ITEM_LOCKED;
=20
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index de1d2c606c14..68c778d25c48 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -121,12 +121,11 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp =3D dqp->q_mount;
 	struct xfs_quotainfo	*qi =3D mp->m_quotainfo;
+	int			error =3D -EAGAIN;
=20
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs !=3D 0) {
-		xfs_dqunlock(dqp);
-		return -EAGAIN;
-	}
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs !=3D 0)
+		goto out_unlock;
=20
 	dqp->dq_flags |=3D XFS_DQ_FREEING;
=20
@@ -139,7 +138,6 @@ xfs_qm_dqpurge(
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp =3D NULL;
-		int		error;
=20
 		/*
 		 * We don't care about getting disk errors here. We need
@@ -149,6 +147,8 @@ xfs_qm_dqpurge(
 		if (!error) {
 			error =3D xfs_bwrite(bp);
 			xfs_buf_relse(bp);
+		} else if (error =3D=3D -EAGAIN) {
+			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
@@ -174,6 +174,10 @@ xfs_qm_dqpurge(
=20
 	xfs_qm_dqdestroy(dqp);
 	return 0;
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
 }
=20
 /*
--=20
2.21.1

