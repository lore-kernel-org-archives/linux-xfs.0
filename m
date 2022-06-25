Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A368C433EF
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Jun 2022 03:23:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiFYDXX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Jun 2022 23:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiFYDXX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jun 2022 23:23:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F4FDF6D;
        Fri, 24 Jun 2022 20:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82B53B811C1;
        Sat, 25 Jun 2022 03:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5F7C34114;
        Sat, 25 Jun 2022 03:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656127399;
        bh=kQFw1V4sxrQx3KcuIL9NUOoaY2At3LJg5V8L+6AI+Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gR+Zjh/yR+Gc+zdAi/oRB183P9j6pYKeATPhgPiAINEkscD1S+fFNmnOy4VFeiZmI
         c0zP57i3JaDv2vzcCzOMjnKbkHpFhETSkvCXNNgMl60hz8EEBWokW67MxZAwqmbHPO
         r/MBQwtjTm7RXSGqTik2iM/dkOiCXF8mIB+oDyzR/OWuzgNrfjNbShIMSqOUQkZSVa
         jTmRyGe1TXcPRwCZYYI0mn277tcezz3PWFk7P9/gEpMruaBe57ADG5s9sKRHG8mPHf
         R29L50cKbMloqzxQeqcjriyFM/VuHXNNw2/WFC9PzFryDBilyKnj4UbhSJ5mCobaBr
         8ooR2JUAsTxUw==
Date:   Fri, 24 Jun 2022 20:23:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 50/51] fs/xfs: Use the enum req_op and blk_opf_t types
Message-ID: <YrZ/ptEsyMO9DAJ0@magnolia>
References: <20220623180528.3595304-1-bvanassche@acm.org>
 <20220623180528.3595304-51-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623180528.3595304-51-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[+linux-xfs]

On Thu, Jun 23, 2022 at 11:05:27AM -0700, Bart Van Assche wrote:
> Improve static type checking by using the enum req_op type for variables
> that represent a request operation and the new blk_opf_t type for the
> combination of a request operation with request flags.
> 
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks good to me, though I had to dig around to find out what these new
types were.

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bio_io.c      | 2 +-
>  fs/xfs/xfs_buf.c         | 4 ++--
>  fs/xfs/xfs_linux.h       | 2 +-
>  fs/xfs/xfs_log_recover.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
> index ae4345b37621..fe21c76f75b8 100644
> --- a/fs/xfs/xfs_bio_io.c
> +++ b/fs/xfs/xfs_bio_io.c
> @@ -15,7 +15,7 @@ xfs_rw_bdev(
>  	sector_t		sector,
>  	unsigned int		count,
>  	char			*data,
> -	unsigned int		op)
> +	enum req_op		op)
>  
>  {
>  	unsigned int		is_vmalloc = is_vmalloc_addr(data);
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index bf4e60871068..5e8f40d8c052 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1416,7 +1416,7 @@ xfs_buf_ioapply_map(
>  	int		map,
>  	int		*buf_offset,
>  	int		*count,
> -	int		op)
> +	blk_opf_t	op)
>  {
>  	int		page_index;
>  	unsigned int	total_nr_pages = bp->b_page_count;
> @@ -1493,7 +1493,7 @@ _xfs_buf_ioapply(
>  	struct xfs_buf	*bp)
>  {
>  	struct blk_plug	plug;
> -	int		op;
> +	blk_opf_t	op;
>  	int		offset;
>  	int		size;
>  	int		i;
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index cb9105d667db..f9878021e7d0 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -196,7 +196,7 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
>  }
>  
>  int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
> -		char *data, unsigned int op);
> +		char *data, enum req_op op);
>  
>  #define ASSERT_ALWAYS(expr)	\
>  	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5f7e4e6e33ce..940c8107cbd4 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -122,7 +122,7 @@ xlog_do_io(
>  	xfs_daddr_t		blk_no,
>  	unsigned int		nbblks,
>  	char			*data,
> -	unsigned int		op)
> +	enum req_op		op)
>  {
>  	int			error;
>  
