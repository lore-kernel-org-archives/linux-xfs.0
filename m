Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303DCC7EE2C
	for <linux-xfs@archiver.kernel.org>; Fri, 19 May 2023 07:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjESHme (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 May 2023 03:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjESHmQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 May 2023 03:42:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEEA1A6
        for <linux-xfs@vger.kernel.org>; Fri, 19 May 2023 00:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684482085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ChgLSgSgCciGGEj2txPdAcXunor0ElTQJtr+fuEaFtA=;
        b=ZNZPJxdEYb0Zs5hKy7vMOBAZNqkX3Gw6GLaeWPFcRjjk7DYFRl3qunBOjigx/nWKMRyeSF
        YE5yIFd5mbWpLbbZ/ARw09keNgeeL1/xiLrYQmIk3+eeulMZPxSGWral9UNPCTMWDn3+X2
        02T7cXyiYc17SS/p35I4k/Gka9VXscY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-2UnIjJkHPT6ZoSIApCo6vg-1; Fri, 19 May 2023 03:41:20 -0400
X-MC-Unique: 2UnIjJkHPT6ZoSIApCo6vg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C96E101A58B;
        Fri, 19 May 2023 07:41:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D833E2166B27;
        Fri, 19 May 2023 07:41:16 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Christoph Hellwig <hch@lst.de>, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH v20 05/32] splice: Make splice from a DAX file use direct_splice_read()
Date:   Fri, 19 May 2023 08:40:20 +0100
Message-Id: <20230519074047.1739879-6-dhowells@redhat.com>
In-Reply-To: <20230519074047.1739879-1-dhowells@redhat.com>
References: <20230519074047.1739879-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make a read splice from a DAX file go directly to direct_splice_read() to
do the reading as filemap_splice_read() is unlikely to find any pagecache
to splice.

I think this affects only erofs, Ext2, Ext4, fuse and XFS.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Christoph Hellwig <hch@lst.de>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: Jens Axboe <axboe@kernel.dk>
cc: linux-erofs@lists.ozlabs.org
cc: linux-ext4@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-xfs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-mm@kvack.org
---
 fs/splice.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/splice.c b/fs/splice.c
index 1e0b7c7038b5..7b818b5b18d4 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -421,6 +421,11 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 	struct kiocb kiocb;
 	int ret;
 
+#ifdef CONFIG_FS_DAX
+	if (IS_DAX(in->f_mapping->host))
+		return direct_splice_read(in, ppos, pipe, len, flags);
+#endif
+
 	iov_iter_pipe(&to, ITER_DEST, pipe, len);
 	init_sync_kiocb(&kiocb, in);
 	kiocb.ki_pos = *ppos;

