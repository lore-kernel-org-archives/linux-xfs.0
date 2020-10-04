Return-Path: <SRS0=mrUW=DL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E23FC4363C
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 22:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7502064C
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Oct 2020 22:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbgJDWbz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Oct 2020 18:31:55 -0400
Received: from sandeen.net ([63.231.237.45]:44950 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgJDWbz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 4 Oct 2020 18:31:55 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 8768F4872CE;
        Sun,  4 Oct 2020 17:30:59 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20201002201834.GC49524@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfs_scrub: don't use statvfs to collect data volume block
 counts
Message-ID: <b958b3f9-31b1-de2f-f73a-8ad6f4c15054@sandeen.net>
Date:   Sun, 4 Oct 2020 17:31:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002201834.GC49524@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/2/20 3:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function scrub_scan_estimate_blocks naïvely uses the statvfs counts
> to estimate the size and free blocks on the data volume.  Unfortunately,
> it fails to account for the fact that statvfs can return the size and
> free counts for the realtime volume if the root directory has the
> rtinherit flag set, which leads to phase 7 reporting totally absurd
> quantities.
> 
> The XFS_IOC_FSCOUNTS ioctl returns the size and free block count of both
> volumes correctly, so use that instead.
> 
> Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/fscounters.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index f9d64f8c008f..a2ca0b3f018c 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -154,10 +154,8 @@ scrub_scan_estimate_blocks(
>  
>  	sfs.f_bfree += rb.resblks_avail;
>  
> -	*d_blocks = sfs.f_blocks;
> -	if (ctx->mnt.fsgeom.logstart > 0)
> -		*d_blocks += ctx->mnt.fsgeom.logblocks;
> -	*d_bfree = sfs.f_bfree;
> +	*d_blocks = ctx->mnt.fsgeom.datablocks;
> +	*d_bfree = fc.freedata;
>  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
>  	*r_bfree = fc.freertx;
>  	*f_files = sfs.f_files;
> 

could this just use fc.freeino/fc.allocino too and drop statvfrsr altogether?
(or did I lose track of differences between the counters on the 2 interfaces...)

-Eric 
