Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A72CC433B4
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 17:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6CB611ED
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Apr 2021 17:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243400AbhDPRjb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Apr 2021 13:39:31 -0400
Received: from sandeen.net ([63.231.237.45]:36330 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243749AbhDPRj3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Apr 2021 13:39:29 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 9810146C7E5;
        Fri, 16 Apr 2021 12:37:54 -0500 (CDT)
To:     Jeff Moyer <jmoyer@redhat.com>, linux-xfs@vger.kernel.org
References: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfsprogs: mkfs: don't default to the physical sector size
 if it's bigger than XFS_MAX_SECTORSIZE
Message-ID: <e93f4b34-e58f-d6c7-aae7-ac052f1186c9@sandeen.net>
Date:   Fri, 16 Apr 2021 12:39:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <x49h80ftviy.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/28/20 10:07 AM, Jeff Moyer wrote:
> Hi,
> 
> In testing on ppc64, I ran into the following error when making a file
> system:
> 
> # ./mkfs.xfs -b size=65536 -f /dev/ram0
> illegal sector size 65536
> 
> Which is odd, because I didn't specify a sector size!  The problem is
> that validate_sectorsize defaults to the physical sector size, but in
> this case, the physical sector size is bigger than XFS_MAX_SECTORSIZE.
> 
> # cat /sys/block/ram0/queue/physical_block_size 
> 65536
> 
> Fall back to the default (logical sector size) if the physical sector
> size is greater than XFS_MAX_SECTORSIZE.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Looks fine to me, sorry for the long delay; I think you answered the
question about checking the logical sector size (we validate it
later on)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 606f79da..dc9858af 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1803,8 +1803,13 @@ validate_sectorsize(
>  		if (!ft->lsectorsize)
>  			ft->lsectorsize = XFS_MIN_SECTORSIZE;
>  
> -		/* Older kernels may not have physical/logical distinction */
> -		if (!ft->psectorsize)
> +		/*
> +		 * Older kernels may not have physical/logical distinction.
> +		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
> +		 * In that case, a ramdisk or persistent memory device may
> +		 * advertise a physical sector size that is too big to use.
> +		 */
> +		if (!ft->psectorsize || ft->psectorsize > XFS_MAX_SECTORSIZE)
>  			ft->psectorsize = ft->lsectorsize;
>  
>  		cfg->sectorsize = ft->psectorsize;
> 
