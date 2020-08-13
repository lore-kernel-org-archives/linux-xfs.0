Return-Path: <SRS0=yY6+=BX=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DB8EC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 06:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 599712078B
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Aug 2020 06:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HULmAaOC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgHMGDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Aug 2020 02:03:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25349 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726204AbgHMGDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Aug 2020 02:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597298610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qFLSxfJ/Au2GoliABl0heSh59wXsTWD2h2MhW2Aiv5A=;
        b=HULmAaOCu3prDqSQkWFEIrqLUyBluCdXFx/e9HEcXspolWoZNlIrDSr5pBR1UNIGSfFDEA
        rnhh585mxcEdk6vPzAjDRaYQ+p9YSGgahB9P5geawB/LyFuTJHHIeNSaSzdcmw8wI7t3f7
        WlNoXUiMsHOeyLm8CP9m1k7fq2VNn3o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-q-dUqiPqNci6_9ADTA3Ewg-1; Thu, 13 Aug 2020 02:03:29 -0400
X-MC-Unique: q-dUqiPqNci6_9ADTA3Ewg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20ABD180DE3A
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 06:03:28 +0000 (UTC)
Received: from bogon.redhat.com (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24FD45F1EF
        for <linux-xfs@vger.kernel.org>; Thu, 13 Aug 2020 06:03:26 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_db: use correct inode to set inode type
Date:   Thu, 13 Aug 2020 14:03:24 +0800
Message-Id: <20200813060324.8159-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A test fails as:
  # xfs_db -c "inode 133" -c "addr" -c "p core.size" -c "type inode" -c "addr" -c "p core.size" /dev/sdb1
  current
          byte offset 68096, length 512
          buffer block 128 (fsbno 16), 32 bbs
          inode 133, dir inode -1, type inode
  core.size = 123142
  current
          byte offset 65536, length 512
          buffer block 128 (fsbno 16), 32 bbs
          inode 128, dir inode 128, type inode
  core.size = 42

The "type inode" get wrong inode addr due to it trys to get the
beginning of an inode chunk, refer to "533d1d229 xfs_db: properly set
inode type".

We don't need to get the beginning of a chunk in set_iocur_type, due
to set_cur_inode(ino) will help to do all of that and make a proper
verification. We just need to give it a correct inode.

Reported-by: Jianhong Yin <jiyin@redhat.com>
Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 db/io.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db/io.c b/db/io.c
index 6628d061..61940a07 100644
--- a/db/io.c
+++ b/db/io.c
@@ -591,6 +591,7 @@ set_iocur_type(
 	/* Inodes are special; verifier checks all inodes in the chunk */
 	if (type->typnm == TYP_INODE) {
 		xfs_daddr_t	b = iocur_top->bb;
+		int		bo = iocur_top->boff;
 		xfs_ino_t	ino;
 
 		/*
@@ -598,7 +599,7 @@ set_iocur_type(
  		 * which contains the current disk location; daddr may change.
  		 */
 		ino = XFS_AGINO_TO_INO(mp, xfs_daddr_to_agno(mp, b),
-			((b << BBSHIFT) >> mp->m_sb.sb_inodelog) %
+			(((b << BBSHIFT) + bo) >> mp->m_sb.sb_inodelog) %
 			XFS_AGB_TO_AGINO(mp, mp->m_sb.sb_agblocks));
 		set_cur_inode(ino);
 		return;
-- 
2.20.1

