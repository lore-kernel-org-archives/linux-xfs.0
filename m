Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725616AbfFNBUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Jun 2019 21:20:01 -0400
Date: Fri, 14 Jun 2019 09:19:47 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: alternative take on the same page merging leak fix v2
Message-ID: <20190614011946.GB14436@ming.t460p>
References: <20190613095529.25005-1-hch@lst.de>
 <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
> On 6/13/19 3:55 AM, Christoph Hellwig wrote:
> > Hi Jens, hi Ming,
> > 
> > this is the tested and split version of what I think is the better
> > fix for the get_user_pages page leak, as it leaves the intelligence
> > in the callers instead of in bio_try_to_merge_page.
> > 
> > Changes since v1:
> >   - drop patches not required for 5.2
> >   - added Reviewed-by tags
> 
> Applied for 5.2, thanks.

Hi Jens & Christoph,

Looks the following change is missed in patch 1, otherwise kernel oops
is triggered during kernel booting:

diff --git a/block/bio.c b/block/bio.c
index 35b3c568a48f..9ccf07c666f7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -706,6 +706,8 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_vcnt > 0) {
+		bool same_page;
+
 		bvec = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page == bvec->bv_page &&
@@ -723,7 +725,7 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
 
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
+		if (page_is_mergeable(bvec, page, len, offset, &same_page) &&
 		    can_add_page_to_seg(q, bvec, page, len, offset)) {
 			bvec->bv_len += len;
 			goto done;

Thanks,
Ming
