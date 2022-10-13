Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A724EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJMWqy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJMWqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:46:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75F6F9594
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:46:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BAE371101769;
        Fri, 14 Oct 2022 09:46:52 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6yY-001ec6-Sr; Fri, 14 Oct 2022 09:46:50 +1100
Date:   Fri, 14 Oct 2022 09:46:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: don't retry repairs harder when EAGAIN is
 returned
Message-ID: <20221013224650.GG3600936@dread.disaster.area>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479553.1083393.17251197615976928220.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473479553.1083393.17251197615976928220.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6348955c
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=P_tMAwMATLE2UY0cj5gA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Repair functions will not return EAGAIN -- if they were not able to
> obtain resources, they should return EDEADLOCK (like the rest of online
> fsck) to signal that we need to grab all the resources and try again.
> Hence we don't need to deal with this case except as a debugging
> assertion.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/repair.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
> index 92c661b98892..f6c4cb013346 100644
> --- a/fs/xfs/scrub/repair.c
> +++ b/fs/xfs/scrub/repair.c
> @@ -61,7 +61,6 @@ xrep_attempt(
>  		sc->flags |= XREP_ALREADY_FIXED;
>  		return -EAGAIN;
>  	case -EDEADLOCK:
> -	case -EAGAIN:
>  		/* Tell the caller to try again having grabbed all the locks. */
>  		if (!(sc->flags & XCHK_TRY_HARDER)) {
>  			sc->flags |= XCHK_TRY_HARDER;
> @@ -73,6 +72,10 @@ xrep_attempt(
>  		 * so report back to userspace.
>  		 */
>  		return -EFSCORRUPTED;
> +	case -EAGAIN:
> +		/* Repair functions should return EDEADLOCK, not EAGAIN. */
> +		ASSERT(0);
> +		fallthrough;
>  	default:
>  		return error;
>  	}

I'd do this rather than ASSERT(0) and fall through:

	default:
		ASSERT(error != -EAGAIN);
		return error;
	}

but that's just personal preference. Change it if you want, either
way works so:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
