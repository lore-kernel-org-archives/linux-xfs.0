Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8535AC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 19:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E54A20776
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 19:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391188AbgJLT3E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 15:29:04 -0400
Received: from sandeen.net ([63.231.237.45]:42548 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391183AbgJLT3E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 12 Oct 2020 15:29:04 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 31D7911662;
        Mon, 12 Oct 2020 14:27:55 -0500 (CDT)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <20201005163737.GE49547@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <763eff94-8828-ad8b-32ad-31bdec7a371e@sandeen.net>
Date:   Mon, 12 Oct 2020 14:29:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201005163737.GE49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/5/20 11:37 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function scrub_scan_estimate_blocks naïvely uses the statvfs counts
> to estimate the size and free blocks on the data volume.  Unfortunately,
> it fails to account for the fact that statvfs can return the size and
> free counts for the realtime volume if the root directory has the
> rtinherit flag set, which leads to phase 7 reporting totally absurd
> quantities.
> 
> Eric pointed out a further problem with statvfs, which is that the file
> counts are clamped to the current user's project quota inode limits.
> Therefore, we must not use statvfs for querying the filesystem summary
> counts.
> 
> The XFS_IOC_FSCOUNTS ioctl returns all the data we need, so use that
> instead.
> 
> Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: drop statvfs entirely
> ---
>  scrub/fscounters.c |   27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index f9d64f8c008f..e9901fcdf6df 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -130,38 +130,19 @@ scrub_scan_estimate_blocks(
>  	unsigned long long		*f_free)
>  {
>  	struct xfs_fsop_counts		fc;
> -	struct xfs_fsop_resblks		rb;
> -	struct statvfs			sfs;
>  	int				error;
>  
> -	/* Grab the fstatvfs counters, since it has to report accurately. */
> -	error = fstatvfs(ctx->mnt.fd, &sfs);
> -	if (error)
> -		return errno;
> -
>  	/* Fetch the filesystem counters. */
>  	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
>  	if (error)
>  		return errno;
>  
> -	/*
> -	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
> -	 * blocks back to the free data counts.
> -	 */
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
> -	if (error)
> -		return errno;
> -
> -	sfs.f_bfree += rb.resblks_avail;
> -
> -	*d_blocks = sfs.f_blocks;
> -	if (ctx->mnt.fsgeom.logstart > 0)
> -		*d_blocks += ctx->mnt.fsgeom.logblocks;
> -	*d_bfree = sfs.f_bfree;
> +	*d_blocks = ctx->mnt.fsgeom.datablocks;
> +	*d_bfree = fc.freedata;
>  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
>  	*r_bfree = fc.freertx;
> -	*f_files = sfs.f_files;
> -	*f_free = sfs.f_ffree;
> +	*f_files = fc.allocino;
> +	*f_free = fc.freeino;
>  
>  	return 0;
>  }
> 
