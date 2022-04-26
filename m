Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3121AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 02:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbiDZCPn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236331AbiDZCPm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Apr 2022 22:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419D038D87
        for <linux-xfs@vger.kernel.org>; Mon, 25 Apr 2022 19:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D97E261721
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 02:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB0FC385A9;
        Tue, 26 Apr 2022 02:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650939156;
        bh=0OgWeEQf85aRQ8kG3P3TDStcrHtZvCC70vyqr9gJXCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PAkkYscnP2NPGH+qQo1SkEV6mPwPxlPOQWumCzZshcFYVth8oVPZIka/zwCNdzmWp
         GxWbnXC4X2b82eMjcrLG7Ve+UZVQ6lz7dsb/xP2IHLnMbXuOAWhduNU8RufspW+fgX
         3c7qsH5vTfIQ2vuJOYksrdIaRS1M6hEwagNeIFvDHYgti3rpKr2HP6k0xXAP6XF43v
         g5ullX+G8TG5RYyzCP0ri9TGaZOhHYvIZrzBF42xr3bVI57/QHFzGb9giKvEb6PRyg
         it+4wTszgAvN8amIB9D2Q9QqCAUVg0xLRNHv6vMAUkKjvUGbvi2xbg//Gk7uh1hJEA
         uobH+Gyhp0Bbg==
Date:   Mon, 25 Apr 2022 19:12:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
        david@fromorbit.com
Subject: Re: [PATCH] xfs: revert "xfs: actually bump warning counts when we
 send warnings"
Message-ID: <20220426021235.GQ17025@magnolia>
References: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1650936818-20973-1-git-send-email-sandeen@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 25, 2022 at 08:33:38PM -0500, Eric Sandeen wrote:
> This reverts commit 4b8628d57b725b32616965e66975fcdebe008fe7.
> 
> XFS quota has had the concept of a "quota warning limit" since
> the earliest Irix implementation, but a mechanism for incrementing
> the warning counter was never implemented, as documented in the
> xfs_quota(8) man page. We do know from the historical archive that
> it was never incremented at runtime during quota reservation
> operations.
> 
> With this commit, the warning counter quickly increments for every
> allocation attempt after the user has crossed a quote soft
> limit threshold, and this in turn transitions the user to hard
> quota failures, rendering soft quota thresholds and timers useless.
> This was reported as a regression by users.
> 
> Because the intended behavior of this warning counter has never been
> understood or documented, and the result of this change is a regression
> in soft quota functionality, revert this commit to make soft quota
> limits and timers operable again.
> 
> Fixes: 4b8628d57b72 ("xfs: actually bump warning counts when we send warnings)
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Assuming you're also going to send a patch to nuke xfs/144 is on its
way...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_trans_dquot.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 9ba7e6b..ebe2c22 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -603,7 +603,6 @@
>  			return QUOTA_NL_ISOFTLONGWARN;
>  		}
>  
> -		res->warnings++;
>  		return QUOTA_NL_ISOFTWARN;
>  	}
>  
> -- 
> 1.8.3.1
> 
