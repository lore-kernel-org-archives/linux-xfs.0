Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E5CC38A2C
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BD0E2223D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qwh9emrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgDQPJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728426AbgDQPJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N7w98HjFzM7VvKglY0TQAbw1sk01i17T9bbL71Toa9M=;
        b=Qwh9emrsOxnC6eSH5aoi+t62WVfvO/BLDdQWIvALUnag482mWRer3jIG92BUdOEXvmoF7D
        jdfS3Y7nRCMn+sZ8oBTCq8zGegKSETlGqkUUCmYTeY7ei0W8P2XwZTrgfe01LGe4cIaYfl
        cadcAbGIsm028SzITWjXR+c5paXY9dA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-ejGue09oMKaibQ5uWbk3BQ-1; Fri, 17 Apr 2020 11:09:03 -0400
X-MC-Unique: ejGue09oMKaibQ5uWbk3BQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54806DBA6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:02 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1035360BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:01 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/12] xfs: ratelimit unmount time per-buffer I/O error warning
Date:   Fri, 17 Apr 2020 11:08:52 -0400
Message-Id: <20200417150859.14734-6-bfoster@redhat.com>
In-Reply-To: <20200417150859.14734-1-bfoster@redhat.com>
References: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

At unmount time, XFS emits a warning for every in-core buffer that
might have undergone a write error. In practice this behavior is
probably reasonable given that the filesystem is likely short lived
once I/O errors begin to occur consistently. Under certain test or
otherwise expected error conditions, this can spam the logs and slow
down the unmount. Ratelimit the warning to prevent this problem
while still informing the user that errors have occurred.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 93942d8e35dd..5120fed06075 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1685,11 +1685,10 @@ xfs_wait_buftarg(
 			bp =3D list_first_entry(&dispose, struct xfs_buf, b_lru);
 			list_del_init(&bp->b_lru);
 			if (bp->b_flags & XBF_WRITE_FAIL) {
-				xfs_alert(btp->bt_mount,
-"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!"=
,
+				xfs_alert_ratelimited(btp->bt_mount,
+"Corruption Alert: Buffer at daddr 0x%llx had permanent write failures!\=
n"
+"Please run xfs_repair to determine the extent of the problem.",
 					(long long)bp->b_bn);
-				xfs_alert(btp->bt_mount,
-"Please run xfs_repair to determine the extent of the problem.");
 			}
 			xfs_buf_rele(bp);
 		}
--=20
2.21.1

