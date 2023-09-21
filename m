Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52665E7D0AB
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 21:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjIUVAU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 Sep 2023 17:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbjIUU7r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2023 16:59:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DEFD86806
        for <linux-xfs@vger.kernel.org>; Thu, 21 Sep 2023 10:38:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF5CC4E76C;
        Thu, 21 Sep 2023 15:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695310427;
        bh=o+zN5p3RhVm3JQnukGguHzdMSg1q17JcKSCrffvv/5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mFagRDDv9HM7pw+y4RS73Zf3iNERYz01Fv8NFSpB7wBDB6vbF3Mw1Lx1wbQmxAV6n
         loG6Ywu3A/cMYzlupTjz1lx2U+3OX3UfyGq3jRvmfj9vSlr5mwjEpv6LNar35AyB2o
         fVq0sxCEE4APdjtEph8nPfTlhLlzOoRLWzov/x4JRVz9KzkcFg2NTn5Q/AzIy7zv/I
         25o1ckKsRjjm7xZUXp4prX5rgMt0Fz8/ScsKVouFZawnbEmd01OpXdCNNAAJhSqVSu
         fbgvbMdaSuqBykP15ou0M/0E+xwZ2bvlBCecwyquejq4VqURU8mana4jomE2P+jQk1
         Wn8H8bUbXNJ5g==
Date:   Thu, 21 Sep 2023 08:33:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: abort fstrim if kernel is suspending
Message-ID: <20230921153346.GA11391@frogsfrogsfrogs>
References: <20230921013945.559634-1-david@fromorbit.com>
 <20230921013945.559634-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230921013945.559634-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 21, 2023 at 11:39:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A recent ext4 patch posting from Jan Kara reminded me of a
> discussion a year ago about fstrim in progress preventing kernels
> from suspending. The fix is simple, we should do the same for XFS.
> 
> This removes the -ERESTARTSYS error return from this code, replacing
> it with either the last error seen or the number of blocks
> successfully trimmed up to the point where we detected the stop
> condition.

Kinda weird, actually, that FITRIM can do some discard work, hit an
error, and return the error without updating userspace about the work
that it /did/ get done.  Short writes work like that, so why not this?

Oh.  This is one of those syscalls that has no manpage, nor a
description in Documentation/, so the behavior of this is entirely
defined by calling code interpretation.  Yeah, not doing that today.

> References: https://bugzilla.kernel.org/show_bug.cgi?id=216322
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_discard.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f16b254b5eaa..d5787991bb5b 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -283,6 +283,12 @@ xfs_trim_gather_extents(
>  	return error;
>  }
>  
> +static bool
> +xfs_trim_should_stop(void)
> +{
> +	return fatal_signal_pending(current) || freezing(current);
> +}
> +
>  /*
>   * Iterate the free list gathering extents and discarding them. We need a cursor
>   * for the repeated iteration of gather/discard loop, so use the longest extent
> @@ -336,10 +342,9 @@ xfs_trim_extents(
>  		if (error)
>  			break;
>  
> -		if (fatal_signal_pending(current)) {
> -			error = -ERESTARTSYS;
> +		if (xfs_trim_should_stop())
>  			break;
> -		}
> +
>  	} while (tcur.ar_blockcount != 0);
>  
>  	return error;
> @@ -408,12 +413,12 @@ xfs_ioc_trim(
>  	for_each_perag_range(mp, agno, xfs_daddr_to_agno(mp, end), pag) {
>  		error = xfs_trim_extents(pag, start, end, minlen,
>  					  &blocks_trimmed);
> -		if (error) {
> +		if (error)
>  			last_error = error;
> -			if (error == -ERESTARTSYS) {
> -				xfs_perag_rele(pag);
> -				break;
> -			}
> +
> +		if (xfs_trim_should_stop()) {
> +			xfs_perag_rele(pag);
> +			break;
>  		}
>  	}
>  
> -- 
> 2.40.1
> 
