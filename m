Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664C1C07E95
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A1A361C99
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Jul 2021 11:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhGGL6V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Jul 2021 07:58:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231429AbhGGL6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 07:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625658940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=01t/M19/kHw7B+xIPC9qD3IENRynioNr014CNoPUsY8=;
        b=dJJcX3y7XjJGf8fUEIlsYJ7WOYRky5Htkp767jcWcQlnexYY3uvXycYZEA9FGAfuCE2XAa
        9bejeMk+NiYxrjpFl4kk7PPjK/++Pe0uUKp2pq8KyPOUYgfIYuQhbV8Y+olvSdRkfXlfpT
        pETg5115zODE8X0ABMe32WnRcVS3Vd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-CfjWZsIJMKy7wkjgOc4r5A-1; Wed, 07 Jul 2021 07:55:39 -0400
X-MC-Unique: CfjWZsIJMKy7wkjgOc4r5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24B16344A1;
        Wed,  7 Jul 2021 11:55:38 +0000 (UTC)
Received: from max.com (unknown [10.40.192.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 799885D6AB;
        Wed,  7 Jul 2021 11:55:36 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J . Wong" <djwong@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 3/3] iomap: Don't create iomap_page objects in iomap_page_mkwrite_actor
Date:   Wed,  7 Jul 2021 13:55:24 +0200
Message-Id: <20210707115524.2242151-4-agruenba@redhat.com>
In-Reply-To: <20210707115524.2242151-1-agruenba@redhat.com>
References: <20210707115524.2242151-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that we create those objects in iomap_writepage_map when needed,
there's no need to pre-create them in iomap_page_mkwrite_actor anymore.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/iomap/buffered-io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6330dabc451e..9f45050b61dd 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -999,7 +999,6 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 		block_commit_write(page, 0, length);
 	} else {
 		WARN_ON_ONCE(!PageUptodate(page));
-		iomap_page_create(inode, page);
 		set_page_dirty(page);
 	}
 
-- 
2.26.3

