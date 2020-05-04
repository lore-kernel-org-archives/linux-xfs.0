Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BE2C3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6664F20705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgbRp8hW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbgEDOMD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:03 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25901 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728985AbgEDOMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDK21OIZ8aIxPwWAPcll5OEFAjri9JkEVWrnbJiVevA=;
        b=UgbRp8hWbR7EqXh80L6gORKBQY/lY+x+sL81JngQzT6mJcIXlt19dsem0S2QKwttXCfpn8
        wghoViqbasNVFQ+Vn+pSyYrHIrARen8UpI9wl3UD4DhtNJ/yBExbH6PigAQhDyXOWluLku
        s+LFUAN17ksVwkG8FyDBjEsXGteV/V4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-XkY47VggMPGDYEhf87oHQQ-1; Mon, 04 May 2020 10:11:58 -0400
X-MC-Unique: XkY47VggMPGDYEhf87oHQQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24B5E18FF670
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:57 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D39C919C4F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:56 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 05/17] xfs: reset buffer write failure state on successful completion
Date:   Mon,  4 May 2020 10:11:42 -0400
Message-Id: <20200504141154.55887-6-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

