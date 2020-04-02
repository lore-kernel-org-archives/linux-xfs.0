Return-Path: <SRS0=h0IP=5S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0220FC43331
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 10:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B6620658
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Apr 2020 10:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OqKnM4Fg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387865AbgDBK50 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 06:57:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728803AbgDBK50 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Apr 2020 06:57:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585825044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QA1kG4aDhDb8pUbspipi0w0cHedWtNqLR6LNt+Zz9FM=;
        b=OqKnM4FgdhfonANqe2Fktw68sdVs4PqYrVMHdcyybdJfCM87Ek61fmfTSN4ljKgfOoi80f
        I27/Q6P04jW3bYjSw/+Ecci0Qi9+aHU8Rr43RYpRVpte3dfjVZhQ7dVyRRznhW8Zr6tSGs
        iSR4vZ/tIbNsQrw2POAWmmpFZZf93t8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-fcit0BSYPRKWFVpFwoNInw-1; Thu, 02 Apr 2020 06:57:20 -0400
X-MC-Unique: fcit0BSYPRKWFVpFwoNInw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C87100550D;
        Thu,  2 Apr 2020 10:57:19 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A8FDA0A9F;
        Thu,  2 Apr 2020 10:57:18 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: fix inode number overflow in ifree cluster helper
Date:   Thu,  2 Apr 2020 06:57:18 -0400
Message-Id: <20200402105718.609-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Qian Cai reports seemingly random buffer read verifier errors during
filesystem writeback. This was isolated to a recent patch that
factored out some inode cluster freeing code and happened to cast an
unsigned inode number type to a signed value. If the inode number
value overflows, we can skip marking in-core inodes associated with
the underlying buffer stale at the time the physical inodes are
freed. If such an inode happens to be dirty, xfsaild will eventually
attempt to write it back over non-inode blocks. The invalidation of
the underlying inode buffer causes writeback to read the buffer from
disk. This fails the read verifier (preventing eventual corruption)
if the buffer no longer looks like an inode cluster. Analysis by
Dave Chinner.

Fix up the helper to use the proper type for inode number values.

Fixes: 5806165a6663 ("xfs: factor inode lookup from xfs_ifree_cluster")
Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Fixes the problem described here[1]. I wasn't sure if we planned on
fixing the original patch in for-next or wanted a separate patch. Feel
free to commit standalone or fold into the original...

Brian

[1] https://lore.kernel.org/linux-xfs/990EDC4E-1A4E-4AC3-84D9-078ACF5EB9C=
C@lca.pw/

 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0cac0d37e3ae..ae86c870da92 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2511,7 +2511,7 @@ static struct xfs_inode *
 xfs_ifree_get_one_inode(
 	struct xfs_perag	*pag,
 	struct xfs_inode	*free_ip,
-	int			inum)
+	xfs_ino_t		inum)
 {
 	struct xfs_mount	*mp =3D pag->pag_mount;
 	struct xfs_inode	*ip;
--=20
2.21.1

