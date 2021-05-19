Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB92FC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C340E6135A
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 22:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhESW2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 18:28:25 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:60556 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhESW2Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 18:28:25 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id C2E771140BC0;
        Thu, 20 May 2021 08:27:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljUeb-002wHl-OR; Thu, 20 May 2021 08:27:01 +1000
Date:   Thu, 20 May 2021 08:27:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/11] xfs: remove ->b_offset handling for page backed
 buffers
Message-ID: <20210519222701.GB664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519190900.320044-4-hch@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=7ETEpgt12au9JR_-KQIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 09:08:52PM +0200, Christoph Hellwig wrote:
> ->b_offset can only be non-zero for SLAB backed buffers, so remove all
> code dealing with it for page backed buffers.

Can you refer to these as _XBF_KMEM buffers, not "SLAB backed"? That
way there is no confusion as to what type of buffer needs to pay
attention to b_offset...

> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 459ca34f26f588..21b4c58fd2fa87 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -167,7 +167,8 @@ struct xfs_buf {
>  	atomic_t		b_pin_count;	/* pin count */
>  	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
>  	unsigned int		b_page_count;	/* size of page array */
> -	unsigned int		b_offset;	/* page offset in first page */
> +	unsigned int		b_offset;	/* page offset in first page,
> +						   only used for SLAB buffers */

Here too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
