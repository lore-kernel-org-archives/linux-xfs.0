Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C47BC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Feb 2022 17:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243687AbiBQRZj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:25:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243697AbiBQRZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Feb 2022 12:25:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1A122B354D
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 09:25:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645118723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YLX+6xw36AdkCV6ve33eZKotXM7KuJO4PDBGTJNhxjc=;
        b=TIz5GITmtckoYS+XNaj7e0COsokJOvxg5M+9vJ+Rlf/OvWlFuLv69WJfqlEZuvVdESD4ZV
        TgFKeKq/Nhx8DuA6d5FxqA1zeTKzfHSlJd2CbNKgH8rSwfTq7gy9pDBr6S9pyfhPkvGY+5
        mnkKKCU4Q+MgX4lQnwZHEt/h+x7Wl2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-pZXJC3zBORWA6rR4t-SoHA-1; Thu, 17 Feb 2022 12:25:21 -0500
X-MC-Unique: pZXJC3zBORWA6rR4t-SoHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9B931091DA4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 778E234949
        for <linux-xfs@vger.kernel.org>; Thu, 17 Feb 2022 17:25:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH RFC 3/4] xfs: crude chunk allocation retry mechanism
Date:   Thu, 17 Feb 2022 12:25:17 -0500
Message-Id: <20220217172518.3842951-4-bfoster@redhat.com>
In-Reply-To: <20220217172518.3842951-1-bfoster@redhat.com>
References: <20220217172518.3842951-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The free inode btree currently tracks all inode chunk records with
at least one free inode. This simplifies the chunk and allocation
selection algorithms as free inode availability can be guaranteed
after a few simple checks. This is no longer the case with busy
inode avoidance, however, because busy inode state is tracked in the
radix tree independent from physical allocation status.

A busy inode avoidance algorithm relies on the ability to fall back
to an inode chunk allocation one way or another in the event that
all current free inodes are busy. Hack in a crude allocation
fallback mechanism for experimental purposes. If the inode selection
algorithm is unable to locate a usable inode, allow it to return
-EAGAIN to perform another physical chunk allocation in the AG and
retry the inode allocation.

The current prototype can perform this allocation and retry sequence
repeatedly because a newly allocated chunk may still be covered by
busy in-core inodes in the radix tree (if it were recently freed,
for example). This is inefficient and temporary. It will be properly
mitigated by background chunk removal. This defers freeing of inode
chunk blocks from the free of the last used inode in the chunk to a
background task that only frees chunks once completely idle, thereby
providing a guarantee that a new chunk allocation always adds
non-busy inodes to the AG.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index b418fe0c0679..3eb41228e210 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -27,6 +27,7 @@
 #include "xfs_log.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_trans_space.h"
 
 /*
  * Lookup a record by ino in the btree given by cur.
@@ -1689,6 +1690,7 @@ xfs_dialloc_try_ag(
 			goto out_release;
 		}
 
+alloc:
 		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
 		if (error < 0)
 			goto out_release;
@@ -1706,8 +1708,22 @@ xfs_dialloc_try_ag(
 
 	/* Allocate an inode in the found AG */
 	error = xfs_dialloc_ag(*tpp, agbp, pag, parent, &ino);
-	if (!error)
+	if (!error) {
 		*new_ino = ino;
+	} else if (error == -EAGAIN) {
+		/*
+		 * XXX: Temporary hack to retry allocs until background chunk
+		 * freeing is worked out.
+		 */
+		error = xfs_mod_fdblocks(pag->pag_mount,
+			       -((int64_t)XFS_IALLOC_SPACE_RES(pag->pag_mount)),
+			       false);
+		if (error)
+			goto out_release;
+		(*tpp)->t_blk_res += XFS_IALLOC_SPACE_RES(pag->pag_mount);
+		goto alloc;
+	}
+
 	return error;
 
 out_release:
-- 
2.31.1

