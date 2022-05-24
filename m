Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B7BFC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 04:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbiEXEeg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 00:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234450AbiEXEef (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 00:34:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD5595A11;
        Mon, 23 May 2022 21:34:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C619B81613;
        Tue, 24 May 2022 04:34:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F977C385AA;
        Tue, 24 May 2022 04:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653366870;
        bh=/4PzKarf9FLLX+CAcx710Fdds9eFxxCXnHAxyF1yTcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WNN/hP8+1WxYNdG/BGcwO5Luds+lsF2npcnIELGBbgMaJ/at6wh5oe3bBPC8OEF0x
         Ht0Du6ADFlo6EWA641CuDqqlxhcBAsI72ic30RmCzRppcnojGAAkex4jwa7r10HvWN
         EVxG+ASs6Fe16RKgRlrn9anfggDB1WXyL/y2/X0c7cTvyL6UZhFI4FEY03mcRn19vM
         KxOUSS2oFftcgC7PKFXpKO8HWRuevwVi9G3zt9HDjntmTdHA2S2se1NQ59z+bEyY7K
         PA5r5iGhmP6jAolokOOAQC78BdFH/mLwLff+NWkkakiUNdbSPsolw2EwfiUPmV+cuP
         /giiWNxLiQinQ==
Date:   Mon, 23 May 2022 22:34:27 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, Changhui Zhong <czhong@redhat.com>
Subject: Re: [PATCH V2] block: ignore RWF_HIPRI hint for sync dio
Message-ID: <YoxgU5/P460FZ3rl@kbusch-mbp.dhcp.thefacebook.com>
References: <20220420143110.2679002-1-ming.lei@redhat.com>
 <YowMVODoNIyaqVdC@kbusch-mbp.dhcp.thefacebook.com>
 <YowpjtLfZPld1H6T@T590>
 <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoxKz51EAu3j2qwK@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 23, 2022 at 09:02:39PM -0600, Keith Busch wrote:
> Here's a bandaid, though I assume it'll break something...

On second thought, maybe this is okay! The encoded hctx doesn't change after
this call, which is the only thing polling cares about. The tag portion doesn't
matter.

The only user for the rq tag part of the cookie is hybrid polling and falls
back to classic polling if the tag wasn't valid, so that scenario is already
hangled. And hybrid polling breaks down anyway if queue-depth is >1, so leaving
an invalid tag might be a good thing.
 
> ---
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index ed1869a305c4..348136dc7ba9 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1146,8 +1146,6 @@ void blk_mq_start_request(struct request *rq)
>  	if (blk_integrity_rq(rq) && req_op(rq) == REQ_OP_WRITE)
>  		q->integrity.profile->prepare_fn(rq);
>  #endif
> -	if (rq->bio && rq->bio->bi_opf & REQ_POLLED)
> -	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
>  }
>  EXPORT_SYMBOL(blk_mq_start_request);
>  
> @@ -2464,6 +2462,9 @@ static void blk_mq_bio_to_request(struct request *rq, struct bio *bio,
>  	WARN_ON_ONCE(err);
>  
>  	blk_account_io_start(rq);
> +
> +	if (rq->bio->bi_opf & REQ_POLLED)
> +	        WRITE_ONCE(rq->bio->bi_cookie, blk_rq_to_qc(rq));
>  }
>  
>  static blk_status_t __blk_mq_issue_directly(struct blk_mq_hw_ctx *hctx,
> --
