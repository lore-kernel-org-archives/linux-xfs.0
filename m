Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEA8EB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 05:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjGTFBZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 01:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjGTFBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 01:01:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F86B1FD2;
        Wed, 19 Jul 2023 22:01:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 192B567373; Thu, 20 Jul 2023 07:01:15 +0200 (CEST)
Date:   Thu, 20 Jul 2023 07:01:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 4/6] fs: add IOCB flags related to passing back dio
 completions
Message-ID: <20230720050114.GE1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-5-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

>  /* can use bio alloc cache */
>  #define IOCB_ALLOC_CACHE	(1 << 21)
> +/*
> + * IOCB_DIO_DEFER can be set by the iocb owner, to indicate that the
> + * iocb completion can be passed back to the owner for execution from a safe
> + * context rather than needing to be punted through a workqueue. If this
> + * flag is set, the completion handling may set iocb->dio_complete to a
> + * handler, which the issuer will then call from task context to complete
> + * the processing of the iocb. iocb->private should then also be set to
> + * the argument being passed to this handler.

Can you add an explanation when it is safe/destirable to do the deferred
completion?  As of the last patch we seem to avoid anything that does
I/O or transaction commits, but we'd still allow blocking operations
like mutexes used in the zonefs completion handler.  We need to catch
this so future usuers know what to do.

Similarly on the iomap side I think we need clear documentation for
what context ->end_io can be called in now.
