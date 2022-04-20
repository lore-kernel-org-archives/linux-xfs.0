Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D61DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 12:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350541AbiDTM72 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343572AbiDTM70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 08:59:26 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A973E0FD;
        Wed, 20 Apr 2022 05:56:40 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3881968B05; Wed, 20 Apr 2022 14:56:37 +0200 (CEST)
Date:   Wed, 20 Apr 2022 14:56:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <20220420125637.GA28572@lst.de>
References: <20220420092651.2623016-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420092651.2623016-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> -	if (dio->iocb->ki_flags & IOCB_HIPRI) {
> -		bio_set_polled(bio, dio->iocb);
> -		dio->submit.poll_bio = bio;
> -	}
> -

> -	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
> +	WRITE_ONCE(iocb->private, NULL);

This will break io_uring async polling.

