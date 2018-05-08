Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:46843 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755741AbeEHUo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 16:44:29 -0400
Received: by mail-pl0-f67.google.com with SMTP id 59-v6so2908824plc.13
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 13:44:29 -0700 (PDT)
Date: Tue, 8 May 2018 13:44:27 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 2/4] blk-wbt: account any writing command as a write
Message-ID: <20180508204427.GC27324@vader>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
 <1525709615-14395-3-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525709615-14395-3-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

On Mon, May 07, 2018 at 10:13:33AM -0600, Jens Axboe wrote:
> We currently special case WRITE and FLUSH, but we should really
> just include any command with the write bit set. This ensures
> that we account DISCARD.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-wbt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-wbt.c b/block/blk-wbt.c
> index f92fc84b5e2c..3e34b41bcefc 100644
> --- a/block/blk-wbt.c
> +++ b/block/blk-wbt.c
> @@ -701,7 +701,7 @@ static int wbt_data_dir(const struct request *rq)
>  
>  	if (op == REQ_OP_READ)
>  		return READ;
> -	else if (op == REQ_OP_WRITE || op == REQ_OP_FLUSH)
> +	else if (op_is_write(op))
>  		return WRITE;
>  
>  	/* don't account */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
