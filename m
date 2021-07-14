Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357FBC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C69F613CC
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbhGNXbe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235826AbhGNXbe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:31:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5AD360E08;
        Wed, 14 Jul 2021 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305321;
        bh=5GtBvPS+Q7lzfpohKJUQsASPQFVvY/GaRTIVbDysJ64=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KfsEZkEptC8vUY4ZOb/49c0UrEnG8u1fclvxS7TNmhHlp7iRxhyijBsylarakN9GL
         aBB7wwhP/nXKZ9M3Rnv/MDLqWYhhK1n6aTEXxWCBDy3XR1tphIluYLarpPAh/Rxmvw
         zZkBWzsAPQyWbWITiBtFfYDocWGTHv8HdpFnHjwsPjpZ7dZr5rEtQTz/qBgNcMOTm4
         IyaCRp47a8IXumCIQyxXs9UvV4HoDe4P0jB5H6UTeVTv8DI34aRCgLqZTHq9s/LIpJ
         Q86xgklWoHxQ/+eBQiHnQWQoIn5fLQeRR+XYt1O7mNaBVpA8pef/EZhy7+MWNhSVBB
         TAtwwA5kH8+rg==
Date:   Wed, 14 Jul 2021 16:28:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs/305: don't turn quota accounting off
Message-ID: <20210714232841.GM22402@magnolia>
References: <20210712111146.82734-1-hch@lst.de>
 <20210712111146.82734-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111146.82734-7-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:11:46PM +0200, Christoph Hellwig wrote:
> The test case tests just as much when just testing turning quota
> enforcement off, so switch it to that.  This is in preparation for
> removing support to turn quota accounting off.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/305 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/305 b/tests/xfs/305
> index 140557a0..0b89499a 100755
> --- a/tests/xfs/305
> +++ b/tests/xfs/305
> @@ -38,7 +38,7 @@ _exercise()
>  
>  	$FSSTRESS_PROG -d $QUOTA_DIR -n 1000000 -p 100 $FSSTRESS_AVOID >/dev/null 2>&1 &
>  	sleep 10
> -	xfs_quota -x -c "off -$type" $SCRATCH_DEV
> +	xfs_quota -x -c "disable -$type" $SCRATCH_DEV
>  	sleep 5
>  	$KILLALL_PROG -q $FSSTRESS_PROG
>  	wait
> -- 
> 2.30.2
> 
