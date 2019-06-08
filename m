Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbfFHQtU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Jun 2019 12:49:20 -0400
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 2/2] block: fix page leak in case of merging to same page
Date: Sun,  9 Jun 2019 00:48:53 +0800
Message-Id: <20190608164853.10938-3-ming.lei@redhat.com>
In-Reply-To: <20190608164853.10938-1-ming.lei@redhat.com>
References: <20190608164853.10938-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>

Different iovec may use one same page, then 'pages' array filled
by iov_iter_get_pages() may get reference of the same page several
times. If some page in 'pages' can be merged to same page in one bvec
by bio_add_page(), bio_release_pages() only drops the page's reference
once.

This way causes page leak reported by David Gibson.

This issue can be triggered since 576ed913 ("block: use bio_add_page in
bio_iov_iter_get_pages").

Fixes the issue by put the page's ref if it is merged to same page.

Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Link: https://lkml.org/lkml/2019/4/23/64
Fixes: 576ed913 ("block: use bio_add_page in bio_iov_iter_get_pages")
Reported-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c         | 14 ++++++++++++--
 include/linux/bio.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 39e3b931dc3b..5f7b46360c36 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -657,6 +657,10 @@ static inline bool page_is_mergeable(const struct bio_vec *bv,
 	WARN_ON_ONCE((flags & BVEC_MERGE_TO_SAME_PAGE) &&
 			(len + off) > PAGE_SIZE);
 
+	if ((flags & BVEC_MERGE_PUT_SAME_PAGE) &&
+			(flags & BVEC_MERGE_TO_SAME_PAGE))
+		put_page(page);
+
 	return true;
 }
 
@@ -924,8 +928,14 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		struct page *page = pages[i];
 
 		len = min_t(size_t, PAGE_SIZE - offset, left);
-		if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset) != len))
-			return -EINVAL;
+
+		if (!__bio_try_merge_page(bio, page, len, offset,
+					BVEC_MERGE_PUT_SAME_PAGE |
+					BVEC_MERGE_TO_SAME_PAGE)) {
+			if (WARN_ON_ONCE(bio_add_page(bio, page, len, offset)
+						!= len))
+				return -EINVAL;
+		}
 		offset = 0;
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 48a95bca1703..dec6cf683d8e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -422,6 +422,7 @@ void bio_chain(struct bio *, struct bio *);
 enum bvec_merge_flags {
 	BVEC_MERGE_DEFAULT,
 	BVEC_MERGE_TO_SAME_PAGE = BIT(0),
+	BVEC_MERGE_PUT_SAME_PAGE = BIT(1),
 };
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
-- 
2.20.1
