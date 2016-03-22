Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CB997CA0
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 01:13:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3E6AA304059
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:13:00 -0700 (PDT)
Received: from mail-pf0-f196.google.com (mail-pf0-f196.google.com
	[209.85.192.196]) by cuda.sgi.com with ESMTP id
	JPDbPHc6iEEZG7Yo (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:58 -0700 (PDT)
Received: by mail-pf0-f196.google.com with SMTP id n5so33916501pfn.1
	for <xfs@oss.sgi.com>; Mon, 21 Mar 2016 23:12:58 -0700 (PDT)
From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 5/8] fs: xfs: replace BIO_MAX_SECTORS with BIO_MAX_PAGES
Date: Tue, 22 Mar 2016 14:12:26 +0800
Message-Id: <1458627149-12988-6-git-send-email-ming.lei@canonical.com>
In-Reply-To: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
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
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, Philipp Reisner <philipp.reisner@linbit.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

BIO_MAX_PAGES is used as maximum count of bvecs, so
replace BIO_MAX_SECTORS with BIO_MAX_PAGES since
BIO_MAX_SECTORS is to be removed.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9a2191b..01ef6d2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1161,7 +1161,7 @@ xfs_buf_ioapply_map(
 
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);
+	nr_pages = BIO_MAX_PAGES;
 	if (nr_pages > total_nr_pages)
 		nr_pages = total_nr_pages;
 
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
