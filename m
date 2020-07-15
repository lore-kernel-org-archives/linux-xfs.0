Return-Path: <SRS0=dZhK=A2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17FA3C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7D4C2065D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jul 2020 19:33:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UI608SDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgGOTdP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jul 2020 15:33:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56357 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726479AbgGOTdP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jul 2020 15:33:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594841593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4eYnoC4YTFlCf/8SldMfnitGHGn4t5++rsy7vlgB2rg=;
        b=UI608SDeYBMGIQ8HZwqTpDF1XHSWSKPp43Bz+gZE7c7RR5zsmkSJhwpJXMQ7IAPWnLEf62
        82SrLdI+/MhyjpVhgCxNEtubZpj/+WOL/iFMARHsHidgx5o9xjZ8R429Mgkjns+fdhJKpU
        mZzRVMwYLmf+4Due0ZqIPDMhIzIY9RQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-4fe9414MOlqbb_WPF1Gydg-1; Wed, 15 Jul 2020 15:33:11 -0400
X-MC-Unique: 4fe9414MOlqbb_WPF1Gydg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0979F18A1DED
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 19:33:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-214.rdu2.redhat.com [10.10.113.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B771E19729
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2020 19:33:10 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix inode allocation block res calculation precedence
Date:   Wed, 15 Jul 2020 15:33:10 -0400
Message-Id: <20200715193310.22002-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The block reservation calculation for inode allocation is supposed
to consist of the blocks required for the inode chunk plus
(maxlevels-1) of the inode btree multiplied by the number of inode
btrees in the fs (2 when finobt is enabled, 1 otherwise).

Instead, the macro returns (ialloc_blocks + 2) due to a precedence
error in the calculation logic. This leads to block reservation
overruns via generic/531 on small block filesystems with finobt
enabled. Add braces to fix the calculation and reserve the
appropriate number of blocks.

Fixes: 9d43b180af67 ("xfs: update inode allocation/free transaction reservations for finobt")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_space.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 88221c7a04cc..c6df01a2a158 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -57,7 +57,7 @@
 	XFS_DAREMOVE_SPACE_RES(mp, XFS_DATA_FORK)
 #define	XFS_IALLOC_SPACE_RES(mp)	\
 	(M_IGEO(mp)->ialloc_blks + \
-	 (xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1 * \
+	 ((xfs_sb_version_hasfinobt(&mp->m_sb) ? 2 : 1) * \
 	  (M_IGEO(mp)->inobt_maxlevels - 1)))
 
 /*
-- 
2.21.3

