Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11649C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 27 May 2022 13:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351915AbiE0Ned (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 27 May 2022 09:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiE0Nec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 09:34:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 915CA146436
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 06:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653658470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=D9U96tntVEzkkbUMr2JhUHN+MiACcAvyZ3btbqW4EIM=;
        b=cfjcF5GGg5cPyw0dVOiFie23p7WyqYOR8C7zFtl/q3X+BIIRVHAGgmzCVERdzRYL/5RYJO
        DR7UUttQ4zSOpVZgdH9P5xOnhEgWWb6G/vaPo0YISWmfvrOw6Ttj9h0L6btKuMMEwB4v79
        JYFOE+2eILhGnR3S5bD9W8WeDO4ZhGI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-uEiwFGvaOzefjNM7CHzEzw-1; Fri, 27 May 2022 09:34:29 -0400
X-MC-Unique: uEiwFGvaOzefjNM7CHzEzw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D7F2919EA0
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 13:34:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1716400F36
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 13:34:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix xfs_ifree() error handling to not leak perag ref
Date:   Fri, 27 May 2022 09:34:28 -0400
Message-Id: <20220527133428.2291945-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For some reason commit 9a5280b312e2e ("xfs: reorder iunlink remove
operation in xfs_ifree") replaced a jump to the exit path in the
event of an xfs_difree() error with a direct return, which skips
releasing the perag reference acquired at the top of the function.
Restore the original code to drop the reference on error.

Fixes: 9a5280b312e2e ("xfs: reorder iunlink remove operation in xfs_ifree")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index b2879870a17e..52d6f2c7d58b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2622,7 +2622,7 @@ xfs_ifree(
 	 */
 	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		return error;
+		goto out;
 
 	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
-- 
2.34.1

