Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51350 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751175AbeEBCyY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 22:54:24 -0400
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
From: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
        <1525102372-8430-3-git-send-email-axboe@kernel.dk>
        <20180430213120.GD13766@dastard>
        <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
        <20180430222852.GF13766@dastard>
        <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
        <799de885-34f0-0cae-ae64-bf7bc194965d@kernel.dk>
        <20180430232319.GV23861@dastard>
        <bacc9dbb-c38b-9258-cd95-7582c27a97f7@kernel.dk>
Date: Tue, 01 May 2018 22:54:15 -0400
In-Reply-To: <bacc9dbb-c38b-9258-cd95-7582c27a97f7@kernel.dk> (Jens Axboe's
        message of "Tue, 1 May 2018 09:23:13 -0600")
Message-ID: <yq1wowm7oo8.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de


Jens,

> diff --git a/block/blk-wbt.h b/block/blk-wbt.h
> index a232c98fbf4d..aec5bc82d580 100644
> --- a/block/blk-wbt.h
> +++ b/block/blk-wbt.h
> @@ -14,12 +14,17 @@ enum wbt_flags {
>  	WBT_TRACKED		= 1,	/* write, tracked for throttling */
>  	WBT_READ		= 2,	/* read */
>  	WBT_KSWAPD		= 4,	/* write, from kswapd */
> +	WBT_TRIM		= 8,

The term TRIM does not apply to NVMe, nor SCSI. Please call it
WBT_DISCARD.

-- 
Martin K. Petersen	Oracle Linux Engineering
