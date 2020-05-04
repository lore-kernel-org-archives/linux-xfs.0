Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 196B9C47257
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E473920757
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1Q8tNPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgEDOMC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:02 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728187AbgEDOMC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=POhoVK0cC2NLHPtNBDQTt3SR2J/mXVEPmbYYrn1wINw=;
        b=T1Q8tNPZLXDxh5BJl8G5Bx5tDKlDN6p15lYvzGnywEkVXS/ZVfcYW8XoYVLVriF1OTEqlk
        S9fFbvSGCiwdFftJCbnzW07N3nxDKGVWG4MEvV0X0kw5SUsrSU+aEp179823HOU/oV/R2k
        FK5H0zja7Qe084HLRcYhiIWDdGeHYJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-pG7tEa_MMlGDm4JuRsMg0g-1; Mon, 04 May 2020 10:11:59 -0400
X-MC-Unique: pG7tEa_MMlGDm4JuRsMg0g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75F6C835BC3
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:58 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EACE19C4F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 08/17] xfs: fix duplicate verification from xfs_qm_dqflush()
Date:   Mon,  4 May 2020 10:11:45 -0400
Message-Id: <20200504141154.55887-9-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The pre-flush dquot verification in xfs_qm_dqflush() duplicates the
read verifier by checking the dquot in the on-disk buffer. Instead,
verify the in-core variant before it is flushed to the buffer.

Fixes: 7224fa482a6d ("xfs: add full xfs_dqblk verifier")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index af2c8e5ceea0..265feb62290d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1116,13 +1116,12 @@ xfs_qm_dqflush(
 	dqb =3D bp->b_addr + dqp->q_bufoffset;
 	ddqp =3D &dqb->dd_diskdq;
=20
-	/*
-	 * A simple sanity check in case we got a corrupted dquot.
-	 */
-	fa =3D xfs_dqblk_verify(mp, dqb, be32_to_cpu(ddqp->d_id), 0);
+	/* sanity check the in-core structure before we flush */
+	fa =3D xfs_dquot_verify(mp, &dqp->q_core, be32_to_cpu(dqp->q_core.d_id)=
,
+			      0);
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
-				be32_to_cpu(ddqp->d_id), fa);
+				be32_to_cpu(dqp->q_core.d_id), fa);
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
--=20
2.21.1

