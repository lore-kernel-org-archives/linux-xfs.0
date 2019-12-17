Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A810C43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 18:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66A9E20733
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 18:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rl120wI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbfLQSmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 13:42:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:55222 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726623AbfLQSmI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 13:42:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576608126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zBomYFUL0ibBY6NOPPjTJfB/kysXVF8kKTdfUsLvuoo=;
        b=Rl120wI16DpwAcD917nUmRk15r4bDa7Of1wtDPxFXTCNj6gXZ7TP1sGe1R916n34dMEXmO
        A9kMYy00zEXPnGfb+fUORtUdn6d4HdaNqK9hiVadLJTducd8tze1wTM/2mCyaSx0Knn5Fr
        88qJDpiWNfha4bGGW/a3w4s0q75cNx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-RA_ASdEsPceId9wMC_w-4A-1; Tue, 17 Dec 2019 13:42:05 -0500
X-MC-Unique: RA_ASdEsPceId9wMC_w-4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81C271800D42
        for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2019 18:42:04 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4CF1000325
        for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2019 18:42:04 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: use bitops interface for buf log item AIL flag check
Date:   Tue, 17 Dec 2019 13:42:03 -0500
Message-Id: <20191217184203.56997-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_log_item flags were converted to atomic bitops as of commit
22525c17ed ("xfs: log item flags are racy"). The assert check for
AIL presence in xfs_buf_item_relse() still uses the old value based
check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
and causes the assert to unconditionally pass. Fix up the check.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3458a1264a3f..3984779e5911 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -956,7 +956,7 @@ xfs_buf_item_relse(
 	struct xfs_buf_log_item	*bip =3D bp->b_log_item;
=20
 	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
=20
 	bp->b_log_item =3D NULL;
 	if (list_empty(&bp->b_li_list))
--=20
2.20.1

