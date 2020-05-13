Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993A6C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 15:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A36E2158C
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 14:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W2IwTRZU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388899AbgEMOxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 10:53:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37459 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728345AbgEMOxs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 10:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589381627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kTsoBEmagV/UCcATfylOS/f42Vd5f/OMiX/ev4k8oEE=;
        b=W2IwTRZUBwnOwkx2PocHfel3fyMbJNg8nMmYYyD8ASxkBMdqZ90qO30Zj71Fe887jR1KKa
        +oiFhQOMBGdDOpgJCA06YuadqWT1QYQ9IIm4NfBu3eXxqFHWl5zswNSVOJrjXSw/Uz+EE0
        Fp2jgyA6to1x1ApJA2+tjFaG87dAwDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-at7IX6XfOfOVqHElZYDeAA-1; Wed, 13 May 2020 10:53:44 -0400
X-MC-Unique: at7IX6XfOfOVqHElZYDeAA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 279DA80183C
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 14:53:44 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D730C60CD1
        for <linux-xfs@vger.kernel.org>; Wed, 13 May 2020 14:53:43 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: don't fail verifier on empty attr3 leaf block
Date:   Wed, 13 May 2020 10:53:43 -0400
Message-Id: <20200513145343.45855-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

v1:
- Remove the verifier check instead of warn.
rfc: https://lore.kernel.org/linux-xfs/20200511185016.33684-1-bfoster@redhat.com/

 fs/xfs/libxfs/xfs_attr_leaf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 863444e2dda7..6b94bb9de378 100644
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
-- 
2.21.1

