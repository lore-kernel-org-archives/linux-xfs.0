Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EF8EB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 04:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjGTEuk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 00:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjGTEuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 00:50:39 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979521FD2;
        Wed, 19 Jul 2023 21:50:38 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 40BF767373; Thu, 20 Jul 2023 06:50:35 +0200 (CEST)
Date:   Thu, 20 Jul 2023 06:50:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 1/6] iomap: cleanup up iomap_dio_bio_end_io()
Message-ID: <20230720045035.GA1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-2-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	/*
> +	 * Synchronous dio, task itself will handle any completion work
> +	 * that needs after IO. All we need to do is wake the task.
> +	 */
> +	if (dio->wait_for_completion) {
> +		struct task_struct *waiter = dio->submit.waiter;
> +		WRITE_ONCE(dio->submit.waiter, NULL);

I know the existing code got it wrong, but can you please add an empty
line after the variable declaration here?

> +	/*
> +	 * If this dio is an async write, queue completion work for async
> +	 * handling. Reads can always complete inline.
> +	 */
> +	if (dio->flags & IOMAP_DIO_WRITE) {
> +		struct inode *inode = file_inode(iocb->ki_filp);
> +
> +		WRITE_ONCE(iocb->private, NULL);
> +		INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
> +		queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
> +	} else {

If we already do the goto style I'd probably do it here as well instead
of the else.

Otherwise this looks good to me.

