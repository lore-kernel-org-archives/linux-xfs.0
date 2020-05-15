Return-Path: <SRS0=g8AD=65=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2271C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 16:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD26420671
	for <linux-xfs@archiver.kernel.org>; Fri, 15 May 2020 16:06:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D0oJrXVT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgEOQGx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 15 May 2020 12:06:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49033 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgEOQGx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 May 2020 12:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589558811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XGlQar4ePXqSlYzDd4TrmCKCmUPmm7eFnfe9K1yJLKk=;
        b=D0oJrXVTklk1pMy2nTnmXkRGNoca5g1UrbZf1XQvg4zr/XPBA9i5GuujsbH2ViscM4Oa8+
        c6gfqsVcXWVH4TXxN7hNyIstp/MgAwoayfn7WsOAixHsVQYWrLW/DurydSu7mDczLM+Dmo
        bFuRiPvMc3hye6DBufAwiRaDnY0/WjE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-vhgR094qMwanlmubflimQw-1; Fri, 15 May 2020 12:06:49 -0400
X-MC-Unique: vhgR094qMwanlmubflimQw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B42B1464
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2020 16:06:48 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F960648D1
        for <linux-xfs@vger.kernel.org>; Fri, 15 May 2020 16:06:48 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfs: don't fail verifier on empty attr3 leaf block
Date:   Fri, 15 May 2020 12:06:48 -0400
Message-Id: <20200515160648.56487-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The attr fork can transition from shortform to leaf format while
empty if the first xattr doesn't fit in shortform. While this empty
leaf block state is intended to be transient, it is technically not
due to the transactional implementation of the xattr set operation.

We historically have a couple of bandaids to work around this
problem. The first is to hold the buffer after the format conversion
to prevent premature writeback of the empty leaf buffer and the
second is to bypass the xattr count check in the verifier during
recovery. The latter assumes that the xattr set is also in the log
and will be recovered into the buffer soon after the empty leaf
buffer is reconstructed. This is not guaranteed, however.

If the filesystem crashes after the format conversion but before the
xattr set that induced it, only the format conversion may exist in
the log. When recovered, this creates a latent corrupted state on
the inode as any subsequent attempts to read the buffer fail due to
verifier failure. This includes further attempts to set xattrs on
the inode or attempts to destroy the attr fork, which prevents the
inode from ever being removed from the unlinked list.

To avoid this condition, accept that an empty attr leaf block is a
valid state and remove the count check from the verifier. This means
that on rare occasions an attr fork might exist in an unexpected
state, but is otherwise consistent and functional. Note that we
retain the logic to avoid racing with metadata writeback to reduce
the window where this can occur.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Add comment.
v1: https://lore.kernel.org/linux-xfs/20200513145343.45855-1-bfoster@redhat.com/
- Remove the verifier check instead of warn.
rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/

 fs/xfs/libxfs/xfs_attr_leaf.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 863444e2dda7..6d18e86bb9c7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -308,14 +308,6 @@ xfs_attr3_leaf_verify(
 	if (fa)
 		return fa;
 
-	/*
-	 * In recovery there is a transient state where count == 0 is valid
-	 * because we may have transitioned an empty shortform attr to a leaf
-	 * if the attr didn't fit in shortform.
-	 */
-	if (!xfs_log_in_recovery(mp) && ichdr.count == 0)
-		return __this_address;
-
 	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
@@ -331,6 +323,13 @@ xfs_attr3_leaf_verify(
 	    (char *)bp->b_addr + ichdr.firstused)
 		return __this_address;
 
+	/*
+	 * NOTE: This verifier historically failed empty leaf buffers because
+	 * we expect the fork to be in another format. Empty attr fork format
+	 * conversions are possible during xattr set, however, and format
+	 * conversion is not atomic with the xattr set that triggers it. We
+	 * cannot assume leaf blocks are non-empty until that is addressed.
+	*/
 	buf_end = (char *)bp->b_addr + mp->m_attr_geo->blksize;
 	for (i = 0, ent = entries; i < ichdr.count; ent++, i++) {
 		fa = xfs_attr3_leaf_verify_entry(mp, buf_end, leaf, &ichdr,
-- 
2.21.1

