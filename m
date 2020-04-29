Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0E99C83009
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B153420787
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ErdDWq/m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD2RWF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48695 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726774AbgD2RWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuVWk/xWLzfjHBJDCoCEl814B03ZaME19ukSpEDq0QY=;
        b=ErdDWq/mf4BPIBSRcephh6CK1G4lHawNU5wKaNMIrZY2amDvokprWzxBqCNMh4cErUAt66
        Y7oHrl0OpaeUCD7OchWZhnL5kwYWvvh1vsNIQ9Or6JE8gXu/wOHROnR2UCcXzPZJeOlU2F
        E9YPUItW8IDliJ7ENe1YO3jhOoVYJPU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-NPaE--PzPRq7kiwwIFi7UQ-1; Wed, 29 Apr 2020 13:22:00 -0400
X-MC-Unique: NPaE--PzPRq7kiwwIFi7UQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67D8B835B40
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:59 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 154D15C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 09/17] xfs: abort consistently on dquot flush failure
Date:   Wed, 29 Apr 2020 13:21:45 -0400
Message-Id: <20200429172153.41680-10-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The dquot flush handler effectively aborts the dquot flush if the
filesystem is already shut down, but doesn't actually shut down if
the flush fails. Update xfs_qm_dqflush() to consistently abort the
dquot flush and shutdown the fs if the flush fails with an
unexpected error.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 265feb62290d..ffe607733c50 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1068,6 +1068,7 @@ xfs_qm_dqflush(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp =3D dqp->q_mount;
+	struct xfs_log_item	*lip =3D &dqp->q_logitem.qli_item;
 	struct xfs_buf		*bp;
 	struct xfs_dqblk	*dqb;
 	struct xfs_disk_dquot	*ddqp;
@@ -1083,32 +1084,16 @@ xfs_qm_dqflush(
=20
 	xfs_qm_dqunpin_wait(dqp);
=20
-	/*
-	 * This may have been unpinned because the filesystem is shutting
-	 * down forcibly. If that's the case we must not write this dquot
-	 * to disk, because the log record didn't make it to disk.
-	 *
-	 * We also have to remove the log item from the AIL in this case,
-	 * as we wait for an emptry AIL as part of the unmount process.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		struct xfs_log_item	*lip =3D &dqp->q_logitem.qli_item;
-		dqp->dq_flags &=3D ~XFS_DQ_DIRTY;
-
-		xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
-
-		error =3D -EIO;
-		goto out_unlock;
-	}
-
 	/*
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error =3D xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
 				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
 				   &bp, &xfs_dquot_buf_ops);
-	if (error)
+	if (error =3D=3D -EAGAIN)
 		goto out_unlock;
+	if (error)
+		goto out_abort;
=20
 	/*
 	 * Calculate the location of the dquot inside the buffer.
@@ -1123,9 +1108,8 @@ xfs_qm_dqflush(
 		xfs_alert(mp, "corrupt dquot ID 0x%x in memory at %pS",
 				be32_to_cpu(dqp->q_core.d_id), fa);
 		xfs_buf_relse(bp);
-		xfs_dqfunlock(dqp);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return -EFSCORRUPTED;
+		error =3D -EFSCORRUPTED;
+		goto out_abort;
 	}
=20
 	/* This is the only portion of data that needs to persist */
@@ -1174,6 +1158,10 @@ xfs_qm_dqflush(
 	*bpp =3D bp;
 	return 0;
=20
+out_abort:
+	dqp->dq_flags &=3D ~XFS_DQ_DIRTY;
+	xfs_trans_ail_remove(lip, SHUTDOWN_CORRUPT_INCORE);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 out_unlock:
 	xfs_dqfunlock(dqp);
 	return error;
--=20
2.21.1

