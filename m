Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E456C4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Nov 2022 01:27:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbiKHB1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Nov 2022 20:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbiKHB1h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Nov 2022 20:27:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B12AE05
        for <linux-xfs@vger.kernel.org>; Mon,  7 Nov 2022 17:27:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF242611F4
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 01:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB88EC433C1;
        Tue,  8 Nov 2022 01:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667870856;
        bh=jUrTrioaCPOieWiAeeLQxrLLU2ibGJ7mBOO7KaqS4c4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HDsYF7FmqhfTu2vHvBJSesRBVoMCVmsdLwsvrDZNaa46et5pnl+IuJYuFczcJjFEV
         fAc/E/qnFcw2496WwT5wMZ/MgqneurcdYvY5OERtjUem7cpcJ4DxWS6naYboRhNnhJ
         SUqCiGcwahsqLE+ga6wsW9roGdp6WWhc9vintn5Tk3RVNtE55tsmw4cJbj+hBsEDbE
         WTPoOCX+SSMiJTPL8dRJyA2nx2/Nq+emiS4WwQfCZQPwZGN00CEUIK032tP2XWnZd+
         9xW2lQnYewH34a9BfXND31LT8W+3KYfhsCe92O3xGTtVHt//+fo+5TA4EIQmFBMqvV
         9orl9BWp9PynA==
Date:   Mon, 7 Nov 2022 17:27:35 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v23.2 4/4] xfs: don't return -EFSCORRUPTED from repair
 when resources cannot be grabbed
Message-ID: <Y2mwh34rTkP/7Ntj@magnolia>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479567.1083393.7668585289114718845.stgit@magnolia>
 <Y2V3oOMM85/MwK0i@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2V3oOMM85/MwK0i@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 04, 2022 at 01:35:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we tried to repair something but the repair failed with -EDEADLOCK,
> that means that the repair function couldn't grab some resource it
> needed and wants us to try again.  If we try again (with TRY_HARDER) but
> still can't get all the resources we need, the repair fails and errors
> remain on the filesystem.
> 
> Right now, repair returns the -EDEADLOCK to the caller as -EFSCORRUPTED,
> which results in XFS_SCRUB_OFLAG_CORRUPT being passed out to userspace.
> This is not correct because repair has not determined that anything is
> corrupt.  If the repair had been invoked on an object that could be
> optimized but wasn't corrupt (OFLAG_PREEN), the inability to grab
> resources will be reported to userspace as corrupt metadata, and users
> will be unnecessarily alarmed that their suboptimal metadata turned into
> a corruption.
> 
> Fix this by returning zero so that the results of the actual scrub will
> be copied back out to userspace.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v23.2: fix the commit message to discuss what's really going on in this
>        patch.
> ---
>  fs/xfs/scrub/repair.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 7323bd9fddfb..86f770af6737 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -69,9 +69,9 @@ xrep_attempt(
>  		/*
>  		 * We tried harder but still couldn't grab all the resources
>  		 * we needed to fix it.  The corruption has not been fixed,
> -		 * so report back to userspace.
> +		 * so exit to userspace with the corruption flags still set.

<groan> this wording is vague, i'll try again...

--D

>  		 */
> -		return -EFSCORRUPTED;
> +		return 0;
>  	default:
>  		/*
>  		 * EAGAIN tells the caller to re-scrub, so we cannot return
