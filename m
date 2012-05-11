Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BDnGCC025869
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 08:49:16 -0500
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id p7Letq6U9g5WnAO7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 11 May 2012 06:49:14 -0700 (PDT)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id
	q4BDnCL1012419
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 15:49:12 +0200
Message-ID: <4FAD18D4.3090102@itwm.fraunhofer.de>
Date: Fri, 11 May 2012 15:49:08 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: [PATCH] bio allocation failure due to bio_get_nr_vecs()
References: <jognqm$o21$1@dough.gmane.org>
	<4FABF01E.7080303@itwm.fraunhofer.de>
In-Reply-To: <4FABF01E.7080303@itwm.fraunhofer.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Jens Axboe <axboe@kernel.dk>, sandeen@sandeen.net, linux-xfs@oss.sgi.com, Tejun Heo <tj@kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>

>>> May 10 17:31:49 sgi01 kernel: XFS (sdb): Mounting Filesystem
>>> May 10 17:31:49 sgi01 kernel: XFS (sdb): Ending clean mount
>>> May 10 17:33:00 sgi01 kernel: BUG: unable to handle kernel NULL
>>> pointer dereference at (null)
>>> May 10 17:33:00 sgi01 kernel: IP: [<ffffffffa07f5483>]
>>> xfs_alloc_ioend_bio+0x33/0x50 [xfs]
> 
> Oh, there is a bio allocation path to return NULL:
> 
> bvec_alloc_bs(gfp_mask, nr_iovecs, ) =>  NULL when nr_iovecs>  BIO_MAX_PAGES
> bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
> bio_alloc(GFP_NOIO, nvecs)
> xfs_alloc_ioend_bio()
> 
> And nvecs/nr_iovecs is obtained by bio_get_nr_vecs(), which does not check for
> BIO_MAX_PAGES. Of course, all of that only happens with large IO sizes,
> which is exactly what I'm doing.
> As xfs_alloc_ioend_bio() is using GFP_NOIO it does not expect bio_alloc
> to fail, but as I'm trying to send large IOs I guess that is exactly what happens here.

I see that Kent already fixed an overflow issue 
in commit 5abebfdd02450fa1349daacf242e70b3736581e3. But even with this commit, 
bio_get_nr_vecs() still only checks for queue_max_segments(). As we have a maximum 
of 2048 segments, that does not help much here.
After cherry-picking 5abebfdd02450fa1349daacf242e70b3736581e3 and applying the patch
below, I didn't run into panics / NULL pointer dereferences anymore.


bio: bio_get_nr_vecs() must not return more than BIO_MAX_PAGES

From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>

The number of bio_get_nr_vecs() is passed down via bio_alloc() to
bvec_alloc_bs(), which fails the bio allocation if
nr_iovecs > BIO_MAX_PAGES. For the underlying caller this causes an
unexpected bio allocation failure.
Limiting to queue_max_segments() is not sufficient, as max_segments
also might be very large.

bvec_alloc_bs(gfp_mask, nr_iovecs, ) => NULL when nr_iovecs  > BIO_MAX_PAGES
bio_alloc_bioset(gfp_mask, nr_iovecs, ...)
bio_alloc(GFP_NOIO, nvecs)
xfs_alloc_ioend_bio()


Signed-off-by: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
---
 fs/bio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/bio.c b/fs/bio.c
index e453924..84da885 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	return min_t(unsigned,
+	int nr_pages;
+
+	nr_pages = min_t(unsigned,
 		     queue_max_segments(q),
 		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
+
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
