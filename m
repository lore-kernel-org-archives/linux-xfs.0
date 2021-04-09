Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8956C43462
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 850E1610C8
	for <linux-xfs@archiver.kernel.org>; Fri,  9 Apr 2021 14:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhDIOMb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48134 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233757AbhDIOM2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Apr 2021 10:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617977534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmGp3hWk/hICgmKsYGxVSOAqMz3WTbw5dpVyArlFYfA=;
        b=QpDaDYY+lp78+nlyjaj4xdvXE9DKKMXm8h6YaI380wd9LpbocOOSmudLIOTpjT+lHXZwQx
        5hMrtuFSNtZVt7Ul4NUP3okXkMCca3nNe3OTeX12H4bYI7ZxpGKGLmCHh2iBaSY3aBoPR1
        qBkmYHaXMg+bRLb1lhBTAl3o9AE9Re0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-2xXdJfMLNE24meb0PKa-dA-1; Fri, 09 Apr 2021 10:12:13 -0400
X-MC-Unique: 2xXdJfMLNE24meb0PKa-dA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4434DC7443
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:12 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05BBE59441
        for <linux-xfs@vger.kernel.org>; Fri,  9 Apr 2021 14:12:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 3/5] xfs: drop unused ioend private merge and setfilesize code
Date:   Fri,  9 Apr 2021 10:12:08 -0400
Message-Id: <20210409141210.1000155-4-bfoster@redhat.com>
In-Reply-To: <20210409141210.1000155-1-bfoster@redhat.com>
References: <20210409141210.1000155-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS no longer attaches anthing to ioend->io_private. Remove the
unnecessary ->io_private merging code. This removes the only remaining
user of xfs_setfilesize_ioend() so remove that function as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c | 46 +---------------------------------------------
 1 file changed, 1 insertion(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9d149fc5ec15..026e165d8371 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -85,31 +85,6 @@ xfs_setfilesize(
 	return __xfs_setfilesize(ip, tp, offset, size);
 }
 
-STATIC int
-xfs_setfilesize_ioend(
-	struct iomap_ioend	*ioend,
-	int			error)
-{
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	struct xfs_trans	*tp = ioend->io_private;
-
-	/*
-	 * The transaction may have been allocated in the I/O submission thread,
-	 * thus we need to mark ourselves as being in a transaction manually.
-	 * Similarly for freeze protection.
-	 */
-	xfs_trans_set_context(tp);
-	__sb_writers_acquired(VFS_I(ip)->i_sb, SB_FREEZE_FS);
-
-	/* we abort the update if there was an IO error */
-	if (error) {
-		xfs_trans_cancel(tp);
-		return error;
-	}
-
-	return __xfs_setfilesize(ip, tp, ioend->io_offset, ioend->io_size);
-}
-
 /*
  * IO write completion.
  */
@@ -163,25 +138,6 @@ xfs_end_ioend(
 	memalloc_nofs_restore(nofs_flag);
 }
 
-/*
- * If the to be merged ioend has a preallocated transaction for file
- * size updates we need to ensure the ioend it is merged into also
- * has one.  If it already has one we can simply cancel the transaction
- * as it is guaranteed to be clean.
- */
-static void
-xfs_ioend_merge_private(
-	struct iomap_ioend	*ioend,
-	struct iomap_ioend	*next)
-{
-	if (!ioend->io_private) {
-		ioend->io_private = next->io_private;
-		next->io_private = NULL;
-	} else {
-		xfs_setfilesize_ioend(next, -ECANCELED);
-	}
-}
-
 /* Finish all pending io completions. */
 void
 xfs_end_io(
@@ -201,7 +157,7 @@ xfs_end_io(
 	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
 			io_list))) {
 		list_del_init(&ioend->io_list);
-		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
+		iomap_ioend_try_merge(ioend, &tmp, NULL);
 		xfs_end_ioend(ioend);
 	}
 }
-- 
2.26.3

