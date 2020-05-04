Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1DFC47254
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC7D920705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EGQ6Y2Of"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEDOME (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55178 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728996AbgEDOMD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KbLwm/6itjVYZH+huMH+pg7ucgJAbLVu2vAFpYn+ai0=;
        b=EGQ6Y2Of7IkUHEBI3ucleH/wAcxS7lUnuc/jMKuyVST0FCPnYlx1qQIcz8oJnnxvepdPRa
        VYqodMHBfrgKALV82hj8gP8nvNdMDxyraA9j0Xe2mIaxE98meHiVyWL7KkN5LentPAQ5WW
        EQ1DCR7u1dFq49w39uT0MnL8eNkokOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-UdROrm0FOf6ZhxsvFCJX4Q-1; Mon, 04 May 2020 10:11:58 -0400
X-MC-Unique: UdROrm0FOf6ZhxsvFCJX4Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1210A835BC2
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:58 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B5B19C4F
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:57 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 07/17] xfs: ratelimit unmount time per-buffer I/O error alert
Date:   Mon,  4 May 2020 10:11:44 -0400
Message-Id: <20200504141154.55887-8-bfoster@redhat.com>
In-Reply-To: <20200504141154.55887-1-bfoster@redhat.com>
References: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At unmount time, XFS emits an alert for every in-core buffer that
might have undergone a write error. In practice this behavior is
probably reasonable given that the filesystem is likely short lived
once I/O errors begin to occur consistently. Under certain test or
otherwise expected error conditions, this can spam the logs and slow
down the unmount.

Now that we have a ratelimit mechanism specifically for buffer
alerts, reuse it for the per-buffer alerts in xfs_wait_buftarg().
Also lift the final repair message out of the loop so it always
prints and assert that the metadata error handling code has shut
down the fs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 594d5e1df6f8..8f0f605de579 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1657,7 +1657,8 @@ xfs_wait_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	LIST_HEAD(dispose);
-	int loop =3D 0;
+	int			loop =3D 0;
+	bool			write_fail =3D false;
=20
 	/*
 	 * First wait on the buftarg I/O count for all in-flight buffers to be
@@ -1685,17 +1686,23 @@ xfs_wait_buftarg(
 			bp =3D list_first_entry(&dispose, struct xfs_buf, b_lru);
 			list_del_init(&bp->b_lru);
 			if (bp->b_flags & XBF_WRITE_FAIL) {
-				xfs_alert(btp->bt_mount,
+				write_fail =3D true;
+				xfs_buf_alert_ratelimited(bp,
+					"XFS: Corruption Alert",
 "Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!"=
,
 					(long long)bp->b_bn);
-				xfs_alert(btp->bt_mount,
-"Please run xfs_repair to determine the extent of the problem.");
 			}
 			xfs_buf_rele(bp);
 		}
 		if (loop++ !=3D 0)
 			delay(100);
 	}
+
+	if (write_fail) {
+		ASSERT(XFS_FORCED_SHUTDOWN(btp->bt_mount));
+		xfs_alert(btp->bt_mount,
+	      "Please run xfs_repair to determine the extent of the problem.");
+	}
 }
=20
 static enum lru_status
--=20
2.21.1

