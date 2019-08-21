Return-Path: <SRS0=IGv+=WR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05A4FC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 13:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D03C222DD3
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Aug 2019 13:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbfHUNjH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Aug 2019 09:39:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfHUNjH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 09:39:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA6C310C0216;
        Wed, 21 Aug 2019 13:39:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 71AAC1001925;
        Wed, 21 Aug 2019 13:39:06 +0000 (UTC)
Date:   Wed, 21 Aug 2019 09:39:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: alignment check bio buffers
Message-ID: <20190821133904.GC19646@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-4-david@fromorbit.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Wed, 21 Aug 2019 13:39:06 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 06:38:20PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add memory buffer alignment validation checks to bios built in XFS
> to catch bugs that will result in silent data corruption in block
> drivers that cannot handle unaligned memory buffers but don't
> validate the incoming buffer alignment is correct.
> 
> Known drivers with these issues are xenblk, brd and pmem.
> 
> Despite there being nothing XFS specific to xfs_bio_add_page(), this
> function was created to do the required validation because the block
> layer developers that keep telling us that is not possible to
> validate buffer alignment in bio_add_page(), and even if it was
> possible it would be too much overhead to do at runtime.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_bio_io.c | 32 +++++++++++++++++++++++++++++---
>  fs/xfs/xfs_buf.c    |  2 +-
>  fs/xfs/xfs_linux.h  |  3 +++
>  fs/xfs/xfs_log.c    |  6 +++++-
>  4 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index e2148f2d5d6b..fbaea643c000 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -9,6 +9,27 @@ static inline unsigned int bio_max_vecs(unsigned int count)
>  	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
>  }
>  
> +int
> +xfs_bio_add_page(
> +	struct bio	*bio,
> +	struct page	*page,
> +	unsigned int	len,
> +	unsigned int	offset)
> +{
> +	struct request_queue	*q = bio->bi_disk->queue;
> +	bool		same_page = false;
> +
> +	if (WARN_ON_ONCE(!blk_rq_aligned(q, len, offset)))
> +		return -EIO;
> +
> +	if (!__bio_try_merge_page(bio, page, len, offset, &same_page)) {
> +		if (bio_full(bio, len))
> +			return 0;
> +		__bio_add_page(bio, page, len, offset);
> +	}
> +	return len;
> +}
> +

Seems reasonable to me. Looks like bio_add_page() with an error check.
;) Given that, what's the need to open-code bio_add_page() here rather
than just call it after the check?

>  int
>  xfs_rw_bdev(
>  	struct block_device	*bdev,
...
> @@ -36,9 +57,12 @@ xfs_rw_bdev(
>  		unsigned int	off = offset_in_page(data);
>  		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
>  
> -		while (bio_add_page(bio, page, len, off) != len) {
> +		while ((ret = xfs_bio_add_page(bio, page, len, off)) != len) {
>  			struct bio	*prev = bio;
>  
> +			if (ret < 0)
> +				goto submit;
> +

Hmm.. is submitting the bio really the right thing to do if we get here
and have failed to add any pages to the bio? If we're already seeing
weird behavior for bios with unaligned data memory, this seems like a
recipe for similar weirdness. We'd also end up doing a partial write in
scenarios where we already know we're returning an error. Perhaps we
should create an error path or use a check similar to what is already in
xfs_buf_ioapply_map() (though I'm not a fan of submitting a partial I/O
when we already know we're going to return an error) to call bio_endio()
to undo any chaining.

>  			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
>  			bio_copy_dev(bio, prev);
>  			bio->bi_iter.bi_sector = bio_end_sector(prev);
...
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7bd1f31febfc..a2d499baee9c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1294,7 +1294,7 @@ xfs_buf_ioapply_map(
>  		if (nbytes > size)
>  			nbytes = size;
>  
> -		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
> +		rbytes = xfs_bio_add_page(bio, bp->b_pages[page_index], nbytes,
>  				      offset);

Similar concern here. The higher level code seems written under the
assumption that bio_add_page() returns success or zero. In this case the
error is basically tossed so we can also attempt to split/chain an empty
bio, or even better, submit a partial write and continue operating as if
nothing happened (outside of the warning). The latter case should be
handled as a log I/O error one way or another.

Brian

>  		if (rbytes < nbytes)
>  			break;
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index ca15105681ca..e71c7bf3e714 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -145,6 +145,9 @@ static inline void delay(long ticks)
>  	schedule_timeout_uninterruptible(ticks);
>  }
>  
> +int xfs_bio_add_page(struct bio *bio, struct page *page, unsigned int len,
> +			unsigned int offset);
> +
>  /*
>   * XFS wrapper structure for sysfs support. It depends on external data
>   * structures and is embedded in various internal data structures to implement
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 1830d185d7fc..52f7d840d09e 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1673,8 +1673,12 @@ xlog_map_iclog_data(
>  		struct page	*page = kmem_to_page(data);
>  		unsigned int	off = offset_in_page(data);
>  		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
> +		int		ret;
>  
> -		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
> +		ret = xfs_bio_add_page(bio, page, len, off);
> +		WARN_ON_ONCE(ret != len);
> +		if (ret < 0)
> +			break;
>  
>  		data += len;
>  		count -= len;
> -- 
> 2.23.0.rc1
> 
