Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ADE6C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Jul 2022 07:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiGYHNo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Jul 2022 03:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGYHNn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jul 2022 03:13:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D83665B4
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 00:13:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A4F61160
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jul 2022 07:13:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50D8C341C6;
        Mon, 25 Jul 2022 07:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658733220;
        bh=/0zLFdNa6CToxZMY6Mpu1EY2cC/6oLp3UyjZvMS1pFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X9gw7PFa1JLoYHQaQnFLToa0IxAgKoQTXixsynaBXrHj0MAP7c3znfB9fuCU72jNh
         aAzOewq65HWVfifiiRf55TtzV5iHLnWAHcPj4j9TKrHmhpF5CHy/UydAfNPHit7Xxq
         BwFil1CPAUpbilyyuGd7Lt8CRW9etimE+EE1aX8Oc/Eu8XXZeMeOsVWIY+zqTWBGbF
         9YoXJ6jsNS+63MK6Yd+nlvo3ywBs/MfgO6mSSYvfT3e3hw+yEw5ffgvG1495gQjrja
         +qLRXbvNUzjpr3SWzPs8XeWUyxEE2Zxp97/V+0JHcWwxPPQ9i9FAr8yFnklETCmhln
         PC64Qrz8ZcNzA==
Date:   Mon, 25 Jul 2022 09:13:35 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] mkfs: ignore data blockdev stripe geometry for small
 filesystems
Message-ID: <20220725071335.wouylfmes63s56t3@orion>
References: <165826709801.3268874.7256134380224140720.stgit@magnolia>
 <Fya-HndAM5vSHn1wqLbwEO2ygz--nTfBYWauFLd0wIprOOw6fd7CEx0z3fcrFb0lQEomyj2wslDMuGKm5Kl5nw==@protonmail.internalid>
 <165826710360.3268874.3266999101684853751.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165826710360.3268874.3266999101684853751.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> ---
>  mkfs/xfs_mkfs.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index a5e2df76..68d6bd18 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2583,6 +2583,20 @@ _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\
>  				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
>  			ft->dsunit = 0;
>  			ft->dswidth = 0;
> +		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
> +			/*
> +			 * Don't use automatic stripe detection if the device
> +			 * size is less than 1GB because the performance gains
> +			 * on such a small system are not worth the risk that
> +			 * we'll end up with an undersized log.
> +			 */
> +			if (ft->dsunit || ft->dswidth)
> +				fprintf(stderr,
> +_("%s: small data volume, ignoring data volume stripe unit %d and stripe width %d\n"),
> +						progname, ft->dsunit,
> +						ft->dswidth);
> +			ft->dsunit = 0;
> +			ft->dswidth = 0;
>  		} else {
>  			dsunit = ft->dsunit;
>  			dswidth = ft->dswidth;
> 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

-- 
Carlos Maiolino
