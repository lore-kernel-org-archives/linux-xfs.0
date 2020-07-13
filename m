Return-Path: <SRS0=4kkz=AY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8A3C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 20:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109B220720
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Jul 2020 20:21:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VBiYEWRD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgGMUV4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 16:21:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgGMUV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jul 2020 16:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594671715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D0/Xvxxx5YHKJ/Ib7PuxpQltL7eDZZDU4H48/YQcuTE=;
        b=VBiYEWRDS6JiaFCMdDSMv2pPKX6DhWgrFo1s8r7QX6yN54EK1ioRF/Yn+KSItaw3PSkv42
        rzahNK2PyW2Ey8VnwWBXhrgk85TE2syHP81361NG0aXTmiUZRKQkiX9achFDhOSakEmV1O
        HKONhKA2E1BfcPDzNdpQj55i0PiIEJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-igMJLCA6OuO2AMWt6gJAkA-1; Mon, 13 Jul 2020 16:21:53 -0400
X-MC-Unique: igMJLCA6OuO2AMWt6gJAkA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C107100CCC0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 20:21:52 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37F31710A1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2020 20:21:52 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: finish dfops on every insert range shift iteration
Date:   Mon, 13 Jul 2020 16:21:51 -0400
Message-Id: <20200713202151.64750-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The recent change to make insert range an atomic operation used the
incorrect transaction rolling mechanism. The explicit transaction
roll does not finish deferred operations. This means that intents
for rmapbt updates caused by extent shifts are not logged until the
final transaction commits. Thus if a crash occurs during an insert
range, log recovery might leave the rmapbt in an inconsistent state.
This was discovered by repeated runs of generic/455.

Update insert range to finish dfops on every shift iteration. This
is similar to collapse range and ensures that intents are logged
with the transactions that make associated changes.

Fixes: dd87f87d87fa ("xfs: rework insert range into an atomic operation")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_bmap_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index afdc7f8e0e70..feb277874a1f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1165,7 +1165,7 @@ xfs_insert_file_space(
 		goto out_trans_cancel;
 
 	do {
-		error = xfs_trans_roll_inode(&tp, ip);
+		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.21.3

