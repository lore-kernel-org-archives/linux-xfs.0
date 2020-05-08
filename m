Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45031C38A2A
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 10:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB4E20870
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 10:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H1PiBNsc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgEHK4E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 06:56:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31461 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726811AbgEHK4E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 06:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588935363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+uEKdNDqKA8bE6QNQHehrk8teRBhMSuL3kBq3SvBwBw=;
        b=H1PiBNscMNpPIh2tZXP5XkBlugYDqT5N7UsDi9q8NQrMdwhLQrW0/zHFinLexu2VtKEoqW
        PL29Uiz9SDTDQYcsns8ixW+oCX8DK8ZDYK6KzEwwgoWnkjVKfwKxm6rqYHN8BwTrAMETLP
        sFnUyxlR5E2eCNhbw321+La2SmXNrrA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-rxuQjauuP6KCQkZSh1eOyg-1; Fri, 08 May 2020 06:56:01 -0400
X-MC-Unique: rxuQjauuP6KCQkZSh1eOyg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DCAD100960F;
        Fri,  8 May 2020 10:56:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ED0D5F7D5;
        Fri,  8 May 2020 10:55:59 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix unused variable warning in buffer completion on !DEBUG
Date:   Fri,  8 May 2020 06:55:59 -0400
Message-Id: <20200508105559.27037-1-bfoster@redhat.com>
In-Reply-To: <20200508111518.27b22640@canb.auug.org.au>
References: <20200508111518.27b22640@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The random buffer write failure errortag patch introduced a local
mount pointer variable for the test macro, but the macro is compiled
out on !DEBUG kernels. This results in an unused variable warning.

Access the mount structure through the buffer pointer and remove the
local mount pointer to address the warning.

Fixes: 7376d745473 ("xfs: random buffer write failure errortag")
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Feel free to fold this into the original commit or merge independently.
Sorry for the noise..

Brian

 fs/xfs/xfs_buf.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9d8841ac7375..9c2fbb6bbf89 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1289,11 +1289,10 @@ xfs_buf_bio_end_io(
 	struct bio		*bio)
 {
 	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
-	struct xfs_mount	*mp = bp->b_mount;
 
 	if (!bio->bi_status &&
 	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BUF_IOERROR))
+	    XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
 		bio->bi_status = BLK_STS_IOERR;
 
 	/*
-- 
2.21.1

