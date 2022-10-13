Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD1DC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJMWnU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiJMWnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:43:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 21C5710D6AB
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:43:19 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 61F8A1101703;
        Fri, 14 Oct 2022 09:43:18 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6v7-001ea0-Ai; Fri, 14 Oct 2022 09:43:17 +1100
Date:   Fri, 14 Oct 2022 09:43:17 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: return EINTR when a fatal signal terminates
 scrub
Message-ID: <20221013224317.GE3600936@dread.disaster.area>
References: <166473479505.1083393.7049311366138032768.stgit@magnolia>
 <166473479526.1083393.2162985380296325620.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473479526.1083393.2162985380296325620.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63489486
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=YQiTWrlbe06NoIBWxM0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:55AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the program calling online fsck is terminated with a fatal signal,
> bail out to userspace by returning EINTR, not EAGAIN.  EAGAIN is used by
> scrubbers to indicate that we should try again with more resources
> locked, and not to indicate that the operation was cancelled.  The
> miswiring is mostly harmless, but it shows up in the trace data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/common.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index 454145db10e7..b73648d81d23 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -25,7 +25,7 @@ xchk_should_terminate(
>  
>  	if (fatal_signal_pending(current)) {
>  		if (*error == 0)
> -			*error = -EAGAIN;
> +			*error = -EINTR;
>  		return true;
>  	}
>  	return false;

Makes sense.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
