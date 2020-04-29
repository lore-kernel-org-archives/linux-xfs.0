Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489B9C83009
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278AE208FE
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 17:22:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AUAxWTM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD2RWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 13:22:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:31033 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726580AbgD2RWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 13:22:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588180919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z4KHIDEJ8uhsGk3ZiKaNDL+C96ms3aOPYMAXkTKqF3Y=;
        b=AUAxWTM48OuT/DfcwBZnyP2+VtoSqvV7S+iwuNhkXKDNvyXaHwqySL9SPN6zp+mBLPfYlM
        Rqn4hCwGyIT4EeC9QqssmmhUyIHiisXzndFGx6V4oXJbtqXA1PtdqZR5HMb/7z0nWvV11r
        MQBnKdGGzDuv3NRY/Cwh7A6uy9uiMq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-zaBS9EHsN1CbHLeAzcBlDQ-1; Wed, 29 Apr 2020 13:21:58 -0400
X-MC-Unique: zaBS9EHsN1CbHLeAzcBlDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 439BE1083E80
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:57 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E21F55C1BE
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 17:21:56 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 05/17] xfs: reset buffer write failure state on successful completion
Date:   Wed, 29 Apr 2020 13:21:41 -0400
Message-Id: <20200429172153.41680-6-bfoster@redhat.com>
In-Reply-To: <20200429172153.41680-1-bfoster@redhat.com>
References: <20200429172153.41680-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The buffer write failure flag is intended to control the internal
write retry that XFS has historically implemented to help mitigate
the severity of transient I/O errors. The flag is set when a buffer
is resubmitted from the I/O completion path due to a previous
failure. It is checked on subsequent I/O completions to skip the
internal retry and fall through to the higher level configurable
error handling mechanism. The flag is cleared in the synchronous and
delwri submission paths and also checked in various places to log
write failure messages.

There are a couple minor problems with the current usage of this
flag. One is that we issue an internal retry after every submission
from xfsaild due to how delwri submission clears the flag. This
results in double the expected or configured number of write
attempts when under sustained failures. Another more subtle issue is
that the flag is never cleared on successful I/O completion. This
can cause xfs_wait_buftarg() to suggest that dirty buffers are being
thrown away due to the existence of the flag, when the reality is
that the flag might still be set because the write succeeded on the
retry.

Clear the write failure flag on successful I/O completion to address
both of these problems. This means that the internal retry attempt
occurs once since the last time a buffer write failed and that
various other contexts only see the flag set when the immediately
previous write attempt has failed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d5d6a68bb1e6..fd76a84cefdd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1197,8 +1197,10 @@ xfs_buf_ioend(
 		bp->b_ops->verify_read(bp);
 	}
=20
-	if (!bp->b_error)
+	if (!bp->b_error) {
+		bp->b_flags &=3D ~XBF_WRITE_FAIL;
 		bp->b_flags |=3D XBF_DONE;
+	}
=20
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
@@ -1274,7 +1276,7 @@ xfs_bwrite(
=20
 	bp->b_flags |=3D XBF_WRITE;
 	bp->b_flags &=3D ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
-			 XBF_WRITE_FAIL | XBF_DONE);
+			 XBF_DONE);
=20
 	error =3D xfs_buf_submit(bp);
 	if (error)
@@ -1996,7 +1998,7 @@ xfs_buf_delwri_submit_buffers(
 		 * synchronously. Otherwise, drop the buffer from the delwri
 		 * queue and submit async.
 		 */
-		bp->b_flags &=3D ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
+		bp->b_flags &=3D ~_XBF_DELWRI_Q;
 		bp->b_flags |=3D XBF_WRITE;
 		if (wait_list) {
 			bp->b_flags &=3D ~XBF_ASYNC;
--=20
2.21.1

