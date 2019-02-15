Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52598 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbfBOLRe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Feb 2019 06:17:34 -0500
From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V15 15/18] block: always define BIO_MAX_PAGES as 256
Date: Fri, 15 Feb 2019 19:13:21 +0800
Message-Id: <20190215111324.30129-16-ming.lei@redhat.com>
In-Reply-To: <20190215111324.30129-1-ming.lei@redhat.com>
References: <20190215111324.30129-1-ming.lei@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>, Sagi Grimberg <sagi@grimberg.me>, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com, Ming Lei <ming.lei@redhat.com>

Now multi-page bvec can cover CONFIG_THP_SWAP, so we don't need to
increase BIO_MAX_PAGES for it.

CONFIG_THP_SWAP needs to split one THP into normal pages and adds
them all to one bio. With multipage-bvec, it just takes one bvec to
hold them all.

Reviewed-by: Omar Sandoval <osandov@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/bio.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9f77adcfde82..bdd11d4c2f05 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -34,15 +34,7 @@
 #define BIO_BUG_ON
 #endif
 
-#ifdef CONFIG_THP_SWAP
-#if HPAGE_PMD_NR > 256
-#define BIO_MAX_PAGES		HPAGE_PMD_NR
-#else
 #define BIO_MAX_PAGES		256
-#endif
-#else
-#define BIO_MAX_PAGES		256
-#endif
 
 #define bio_prio(bio)			(bio)->bi_ioprio
 #define bio_set_prio(bio, prio)		((bio)->bi_ioprio = prio)
-- 
2.9.5
