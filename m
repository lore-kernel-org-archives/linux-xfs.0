Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF3EAC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D768610D0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Nov 2021 02:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhKDC2d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Nov 2021 22:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhKDC23 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Nov 2021 22:28:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F5C2610D0;
        Thu,  4 Nov 2021 02:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635992751;
        bh=EsI4JAfVFGJY+qV0ifihfWQz9K67lYYZamqRHwJZZRg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BZZcIh7RoMBKholifa4hRaKDRJuvbp87IozOpjkHx4IV93juFxtmpe/rhS83dfEsS
         b6xMdFn7q8EGJAIewuzTOQJBDxmxVov6U6GADLlD4iv1D8JLcL/9dUktEK/pDxrRWH
         f7e8aunUYOXY0wWOl8tDN2n5bhQeuf4Mh8Y+skPdjkX5b5zNphtPId+Ly8RxswAAMA
         VTttTrq3tb0k0TZIj9Mr6NMMPDHASmBhe35MKCjI4CCsn2RJ7BfQOCR1X5o7PkqVrl
         oVmNs9uTLXK3Q//jaWUfFaQZSsTmZlwx0UIdsBMgBReFTdpKwdBsRuSbUmCO+6/Vhm
         KtNlrmV1YtkEw==
Date:   Wed, 3 Nov 2021 19:25:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 61/61] mkfs: warn about V4 deprecation when creating new
 V4 filesystems
Message-ID: <20211104022550.GQ24307@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
 <163174752777.350433.15312061958254066456.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174752777.350433.15312061958254066456.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 15, 2021 at 04:12:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The V4 filesystem format is deprecated in the upstream Linux kernel.  In
> September 2025 it will be turned off by default in the kernel and five
> years after that, support will be removed entirely.  Warn people
> formatting new filesystems with the old format, particularly since V4 is
> not the default.

Friendly ping?  I don't see this in for-next, but OTOH there hasn't been
a release either... ;)

--D

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  mkfs/xfs_mkfs.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 53904677..b8c11ce9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2103,6 +2103,15 @@ _("Directory ftype field always enabled on CRC enabled filesystems\n"));
>  		}
>  
>  	} else {	/* !crcs_enabled */
> +		/*
> +		 * The V4 filesystem format is deprecated in the upstream Linux
> +		 * kernel.  In September 2025 it will be turned off by default
> +		 * in the kernel and in September 2030 support will be removed
> +		 * entirely.
> +		 */
> +		fprintf(stdout,
> +_("V4 filesystems are deprecated and will not be supported by future versions.\n"));
> +
>  		/*
>  		 * The kernel doesn't support crc=0,finobt=1 filesystems.
>  		 * If crcs are not enabled and the user has not explicitly
> 
