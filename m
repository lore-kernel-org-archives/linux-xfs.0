Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2E9E67CD2
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 08:36:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F07E58F8035
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 06:36:40 -0700 (PDT)
Received: from mail-pa0-f65.google.com (mail-pa0-f65.google.com
	[209.85.220.65]) by cuda.sgi.com with ESMTP id 4BUujTf76TP3pGUP
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 30 May 2016 06:36:38 -0700 (PDT)
Received: by mail-pa0-f65.google.com with SMTP id f8so21705094pag.0
	for <xfs@oss.sgi.com>; Mon, 30 May 2016 06:36:38 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v6 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
Date: Mon, 30 May 2016 21:34:33 +0800
Message-Id: <1464615294-9946-6-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
References: <1464615294-9946-1-git-send-email-ming.lei@canonical.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@canonical.com>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>

BIO_MAX_PAGES is used as maximum count of bvecs, so
replace BIO_MAX_SECTORS with BIO_MAX_PAGES since
BIO_MAX_SECTORS is to be removed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/xfs/xfs_buf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e71cfbd..e5d713b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1157,9 +1157,7 @@ xfs_buf_ioapply_map(
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
-	if (nr_pages > total_nr_pages)
-		nr_pages = total_nr_pages;
+	nr_pages = min(total_nr_pages, BIO_MAX_PAGES);
 
 	bio = bio_alloc(GFP_NOIO, nr_pages);
 	bio->bi_bdev = bp->b_target->bt_bdev;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
