Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FE14C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 17:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 258A564E15
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Feb 2021 17:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhBJRDh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Feb 2021 12:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232614AbhBJRDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Feb 2021 12:03:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612976531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NFdcvlqPvE3Fxr7GSAa+UDNrL2TfwlfmJzgaGBNWhjo=;
        b=RZ7ss1yuUWZDlBy+9pvNbeTLIBrenxSb3f7k8x6AvWF5IYG579Vaei05v2e1JxXvAEsPLg
        3NLZRObA3itfIaZ0WmY+4BAfiMflALt5xaXRMS8RavgsJGaXWNenWU4a9J+PF5kKZFrVIu
        rV4iljRhFhjrC8KBQmA4mGXx5qe7yeg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337--n713oQ8OEGvul6Hsbu8Dg-1; Wed, 10 Feb 2021 12:02:07 -0500
X-MC-Unique: -n713oQ8OEGvul6Hsbu8Dg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E1CB183CD1F
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 17:01:13 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-234.rdu2.redhat.com [10.10.113.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 566325D6B1
        for <linux-xfs@vger.kernel.org>; Wed, 10 Feb 2021 17:01:13 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: restore shutdown check in mapped write fault path
Date:   Wed, 10 Feb 2021 12:01:12 -0500
Message-Id: <20210210170112.172734-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS triggers an iomap warning in the write fault path due to a
!PageUptodate() page if a write fault happens to occur on a page
that recently failed writeback. The iomap writeback error handling
code can clear the Uptodate flag if no portion of the page is
submitted for I/O. This is reproduced by fstest generic/019, which
combines various forms of I/O with simulated disk failures that
inevitably lead to filesystem shutdown (which then unconditionally
fails page writeback).

This is a regression introduced by commit f150b4234397 ("xfs: split
the iomap ops for buffered vs direct writes") due to the removal of
a shutdown check and explicit error return in the ->iomap_begin()
path used by the write fault path. The explicit error return
historically translated to a SIGBUS, but now carries on with iomap
processing where it complains about the unexpected state. Restore
the shutdown check to xfs_buffered_write_iomap_begin() to restore
historical behavior.

Fixes: f150b4234397 ("xfs: split the iomap ops for buffered vs direct writes")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 70c341658c01..6594f572096e 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -860,6 +860,9 @@ xfs_buffered_write_iomap_begin(
 	int			allocfork = XFS_DATA_FORK;
 	int			error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
 		return xfs_direct_write_iomap_begin(inode, offset, count,
-- 
2.26.2

