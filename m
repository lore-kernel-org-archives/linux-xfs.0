Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C962C433B4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 10:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 183FD6120E
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Apr 2021 10:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhDFK2H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:28:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234143AbhDFK2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Apr 2021 06:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617704878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BTrfFomjQfc9vhu6QmWT7kijdoTTBds+RwMgcs/zG/E=;
        b=VnsDXYW1XeAaN94qd+kfKkDiCL0hQxspq6rxuKd7eiVzAjhTnbNat+Zy7vh3k7tvLohoQv
        RYDqavpdBlO8jNLhcnhWDz5XZZGggeUtiZ6J6aXH/nLekCqzLQpOCRotNuuEJvhk2LgKaF
        JzPtmvbA1EH1fyZqUHBAb0uRIW7/cKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-z9NcJ9E2OZWMdNCJGpXpEA-1; Tue, 06 Apr 2021 06:27:56 -0400
X-MC-Unique: z9NcJ9E2OZWMdNCJGpXpEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B835106BB2F
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 10:27:55 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3F39560C17
        for <linux-xfs@vger.kernel.org>; Tue,  6 Apr 2021 10:27:55 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/4] iomap: remove unused private field from ioend
Date:   Tue,  6 Apr 2021 06:27:54 -0400
Message-Id: <20210406102754.795429-1-bfoster@redhat.com>
In-Reply-To: <20210405145903.629152-1-bfoster@redhat.com>
References: <20210405145903.629152-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only remaining user of ->io_private is the generic ioend merging
infrastructure. The only user of that is XFS, which no longer sets
->io_private or passes an associated merge callback. Remove the
unused parameter and the ->io_private field.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 7 +------
 fs/xfs/xfs_aops.c      | 2 +-
 include/linux/iomap.h  | 5 +----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 414769a6ad11..b7753a7907e2 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1134,9 +1134,7 @@ iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
 }
 
 void
-iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends,
-		void (*merge_private)(struct iomap_ioend *ioend,
-				struct iomap_ioend *next))
+iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends)
 {
 	struct iomap_ioend *next;
 
@@ -1148,8 +1146,6 @@ iomap_ioend_try_merge(struct iomap_ioend *ioend, struct list_head *more_ioends,
 			break;
 		list_move_tail(&next->io_list, &ioend->io_list);
 		ioend->io_size += next->io_size;
-		if (next->io_private && merge_private)
-			merge_private(ioend, next);
 	}
 }
 EXPORT_SYMBOL_GPL(iomap_ioend_try_merge);
@@ -1235,7 +1231,6 @@ iomap_alloc_ioend(struct inode *inode, struct iomap_writepage_ctx *wpc,
 	ioend->io_inode = inode;
 	ioend->io_size = 0;
 	ioend->io_offset = offset;
-	ioend->io_private = NULL;
 	ioend->io_bio = bio;
 	return ioend;
 }
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 87c2912f147d..e24e0a005b48 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -146,7 +146,7 @@ xfs_end_io(
 	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
 			io_list))) {
 		list_del_init(&ioend->io_list);
-		iomap_ioend_try_merge(ioend, &tmp, NULL);
+		iomap_ioend_try_merge(ioend, &tmp);
 		xfs_end_ioend(ioend);
 	}
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index d202fd2d0f91..c87d0cb0de6d 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -198,7 +198,6 @@ struct iomap_ioend {
 	struct inode		*io_inode;	/* file being written to */
 	size_t			io_size;	/* size of the extent */
 	loff_t			io_offset;	/* offset in the file */
-	void			*io_private;	/* file system private data */
 	struct bio		*io_bio;	/* bio being built */
 	struct bio		io_inline_bio;	/* MUST BE LAST! */
 };
@@ -234,9 +233,7 @@ struct iomap_writepage_ctx {
 
 void iomap_finish_ioends(struct iomap_ioend *ioend, int error);
 void iomap_ioend_try_merge(struct iomap_ioend *ioend,
-		struct list_head *more_ioends,
-		void (*merge_private)(struct iomap_ioend *ioend,
-				struct iomap_ioend *next));
+		struct list_head *more_ioends);
 void iomap_sort_ioends(struct list_head *ioend_list);
 int iomap_writepage(struct page *page, struct writeback_control *wbc,
 		struct iomap_writepage_ctx *wpc,
-- 
2.26.3

