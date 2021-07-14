Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7C0C1B08C
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE693613CC
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhGNXi1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229535AbhGNXi1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:38:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E8D6109E;
        Wed, 14 Jul 2021 23:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305734;
        bh=wxteWzeYQZ9i4L+iDA44rh9CeZT8YNLWtsEcz5NQlBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=erB6GcrNuIi07PDrR3IitpQ24t5ChjncLulo1V2lo+14hi25iCYDLkHIXlCYXsGAF
         UPYjubWc9Gxfcjl2a5VA0PC/yC/QA87QLa+FxJbFNzywXxmQ29LOktDLsLCEHkz0g8
         /KrzGYdr7PM8+WzTz/GcB4FYDCVEKVNm1wjtD/3qpvJt2Pj1MAJBk6v7qq4C0j3Biw
         Jx1Vgl+HHSrOuKNTVyKVGUULBFF+uArH+MFD1hLvEj2xTCY942m0MhujosPY2qO9CQ
         7wSpuc9BKxWf9nqJVBtNo+ZjU2HpQKLV89jaFrA/uEn+wQ4Hp5RC23yroYQ1Wf325I
         0SYQCzj+RynPA==
Date:   Wed, 14 Jul 2021 16:35:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] common/quota: allow removing quota options entirely
 in _qmount_option
Message-ID: <20210714233534.GP22402@magnolia>
References: <20210712111146.82734-1-hch@lst.de>
 <20210712111146.82734-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712111146.82734-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 12, 2021 at 01:11:41PM +0200, Christoph Hellwig wrote:
> Add support for dropping all quota related options instead of only
> overriding them with new ones to _qmount_option.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/quota | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/quota b/common/quota
> index 883a28a2..7fa1a61a 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -263,7 +263,9 @@ _qmount_option()
>  			-e 's/prjquota/quota/g'`
>  	fi
>  	# Ensure we have the given quota option - duplicates are fine
> -	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $OPTS"
> +	if [ -n "$OPTS" ]; then
> +		export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $OPTS"
> +	fi

/me finds it a little weird and gross that repeated calls to
_qmount_option lead to a really ugly $MOUNT_OPTIONS, but disentangling
/that/ mess is probably best left for another time...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
>  }
>  
> -- 
> 2.30.2
> 
