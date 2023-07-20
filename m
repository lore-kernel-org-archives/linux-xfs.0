Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DFDEB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 04:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjGTEvy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 00:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTEvx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 00:51:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D2B1FC8;
        Wed, 19 Jul 2023 21:51:53 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 738F367373; Thu, 20 Jul 2023 06:51:50 +0200 (CEST)
Date:   Thu, 20 Jul 2023 06:51:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 2/6] iomap: add IOMAP_DIO_INLINE_COMP
Message-ID: <20230720045150.GB1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-3-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	if (dio->flags & IOMAP_DIO_WRITE) {
> -		struct inode *inode = file_inode(iocb->ki_filp);
> -
> -		WRITE_ONCE(iocb->private, NULL);
> -		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> -		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> -	} else {
> +	if (dio->flags & IOMAP_DIO_INLINE_COMP) {
>  		WRITE_ONCE(iocb->private, NULL);
>  		iomap_dio_complete_work(&dio->aio.work);
> +		goto release_bio;
>  	}

I would have properly just structured the code to match this in the
lat path with a

	if (!(dio->flags & IOMAP_DIO_WRITE)) {

so that this becomes trivial.  But that's just nitpicking and the
result looks good to me.

