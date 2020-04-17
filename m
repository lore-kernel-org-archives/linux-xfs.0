Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5FEC2D0EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D635021924
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S3HIwM6F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgDQPJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728865AbgDQPJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pZaGMY1hW/lUitibRHkcNURWUfqtoVcu62RcGDEm1ts=;
        b=S3HIwM6FgjcTX1rGQpFnJFpBv7GZ3eE5qxxMIcd9bbDAML0T8PdMKL9IiFzt5Xw1TDqLYp
        ELT3bn47eYaSVRx6R5CKMuhH98xcgGg2HWdIa3ImPdClhvvx+b2eyxuJYHqkJfVsvrGsCs
        DqK7X4u0V6NigkcTZ2vfR3xnRI+o1XU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-k9WzYsn9PMes8cQr2pj4wQ-1; Fri, 17 Apr 2020 11:09:03 -0400
X-MC-Unique: k9WzYsn9PMes8cQr2pj4wQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2774102C8D3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:02 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C68F60BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: remove duplicate verification from xfs_qm_dqflush()
Date:   Fri, 17 Apr 2020 11:08:53 -0400
Message-Id: <20200417150859.14734-7-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The dquot read/write verifier calls xfs_dqblk_verify() on every
dquot in the buffer. Remove the duplicate call from
xfs_qm_dqflush().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index af2c8e5ceea0..73032c18a94a 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1071,7 +1071,6 @@ xfs_qm_dqflush(
 	struct xfs_buf		*bp;
 	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddqp;
-	xfs_failaddr_t		fa;
 	int			error;
=20
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
@@ -1116,19 +1115,6 @@ xfs_qm_dqflush(
 	dqb =3D bp->b_addr + dqp->q_bufoffset;
 	ddqp =3D &dqb->dd_diskdq;
=20
-	/*
-	 * A simple sanity check in case we got a corrupted dquot.
-	 */
-	fa =3D xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
-	if (fa) {
-		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(ddqp->d_id), fa);
-		xfs_buf_relse(bp);
-		xfs_dqfunlock(dqp);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return -EFSCORRUPTED;
-	}
-
 	/* This is the only portion of data that needs to persist */
 	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
=20
--=20
2.21.1

