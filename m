Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12323C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 16:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE53860EE9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 16:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbhHDQVG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 12:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234064AbhHDQVE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 12:21:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0869F60F41;
        Wed,  4 Aug 2021 16:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628094052;
        bh=JUbAoe0mLOwvpJI5XBL+9Uq09QpAOOlPDAp4x57tn84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bycZDo91kjxSr6Vw3MmqS2f3ccnikZeSvYVj/ljJIHbKZ7mH4lrnF93wcVR+SB9Wc
         UluVx7MtE9A22stiZuBeKVPXBSSPUGnWtgp3QNHaXG/UxoqaWIL6zXo+lsAn4kc4WE
         IcrnuR6/mhCcA3Ns5AR6JY8GmCY0bCWjlHfe1XFoBr8lO29aJZ9+eMOcmlr+YmkFCT
         o43+uxM80QfnF4icxxTE6NWk5EZZPSqigo5iTK6z9my2CCm8aGmfjhwRYL/Wcpht4K
         QwYC+E85DcfQXHiBQ1PQQeF3zLcwmVQvtuhcrT2CflYyk/vAwB3j3/N4yfGycOGJn4
         OqO4JzdvOZZJA==
Date:   Wed, 4 Aug 2021 09:20:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH] xfs: don't run inodegc flushes when inodegc is not active
Message-ID: <20210804162051.GV3601443@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804104616.GL2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804104616.GL2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 08:46:16PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> A flush trigger on a frozen filesystem (e.g. from statfs)
> will run queued inactivations and assert fail like this:
> 
> XFS: Assertion failed: mp->m_super->s_writers.frozen < SB_FREEZE_FS, file: fs/xfs/xfs_icache.c, line: 1861
> 
> Bug exposed by xfs/011.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Odd that I didn't see any of these problems in my overnight tests,
but the reasoning looks solid.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 92006260fe90..f772f2a67a8b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1893,8 +1893,8 @@ xfs_inodegc_worker(
>   * wait for the work to finish. Two pass - queue all the work first pass, wait
>   * for it in a second pass.
>   */
> -void
> -xfs_inodegc_flush(
> +static void
> +__xfs_inodegc_flush(
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_inodegc	*gc;
> @@ -1913,6 +1913,14 @@ xfs_inodegc_flush(
>  	}
>  }
>  
> +void
> +xfs_inodegc_flush(
> +	struct xfs_mount	*mp)
> +{
> +	if (xfs_is_inodegc_enabled(mp))
> +		__xfs_inodegc_flush(mp);
> +}
> +
>  /*
>   * Flush all the pending work and then disable the inode inactivation background
>   * workers and wait for them to stop.
> @@ -1927,7 +1935,7 @@ xfs_inodegc_stop(
>  	if (!xfs_clear_inodegc_enabled(mp))
>  		return;
>  
> -	xfs_inodegc_flush(mp);
> +	__xfs_inodegc_flush(mp);
>  
>  	for_each_online_cpu(cpu) {
>  		gc = per_cpu_ptr(mp->m_inodegc, cpu);
