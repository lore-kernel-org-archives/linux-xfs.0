Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1E4C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Apr 2022 17:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381086AbiDTRah (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Apr 2022 13:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381084AbiDTRah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Apr 2022 13:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D500946B08
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 10:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9292EB82113
        for <linux-xfs@vger.kernel.org>; Wed, 20 Apr 2022 17:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39590C385A0;
        Wed, 20 Apr 2022 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650475668;
        bh=hGmTuqc7ksuyVYXhH43FLX8XT4RmeCHWAQBJkFw6fc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LEU77vyD5yZZ3OIqoA2WxUPX0HwE13RzHeeWej0kU7te2DSUHdgtr3T/NCltDPRht
         /gsdSD+eMBcCfqEW+F/1CWvzHOrjNoPJ45fE/f3dR0SZmLJ8C3nV0INbPIL4ZJq8Ig
         tzN2MJ6ib+YvrLBoYdbJrbrz6WWT236E6kEnA9jxaVbTpl2jRhNdXpd0cyd2L8SP9d
         so6w81YSJjzuPI1xT97HsWA5091dTNE9tdR8IlCiN8WME6F9EYiHMkBeyZzsEGI71x
         DCf/JN8aZ6ZTet26sk18Yvcanfj7rS+zl54NTG6jhNe4+GhfbOAAdDUDWYDtpJ9TJ2
         kxoiWqM5es2pg==
Date:   Wed, 20 Apr 2022 10:27:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/4] mkfs: round log size down if rounding log start up
 causes overflow
Message-ID: <20220420172747.GR17025@magnolia>
References: <164996213753.226891.14458233911347178679.stgit@magnolia>
 <20220415235758.GE17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415235758.GE17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 15, 2022 at 04:57:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If rounding the log start up to the next stripe unit would cause the log
> to overrun the end of the AG, round the log size down by a stripe unit.
> We already ensured that logblocks was small enough to fit inside the AG,
> so the minor adjustment should suffice.

Self NAK, Eric pointed out more ways this can fail.  New patch coming
soon.

--D

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index b932acaa..cfa38f17 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3219,9 +3219,19 @@ align_internal_log(
>  	int			max_logblocks)
>  {
>  	/* round up log start if necessary */
> -	if ((cfg->logstart % sunit) != 0)
> +	if ((cfg->logstart % sunit) != 0) {
>  		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
>  
> +		/*
> +		 * If rounding up logstart to a stripe boundary moves the end
> +		 * of the log past the end of the AG, reduce logblocks to get
> +		 * it back under EOAG.
> +		 */
> +		if (!libxfs_verify_fsbext(mp, cfg->logstart, cfg->logblocks) &&
> +		    cfg->logblocks > sunit)
> +			cfg->logblocks -= sunit;
> +	}
> +
>  	/* If our log start overlaps the next AG's metadata, fail. */
>  	if (!libxfs_verify_fsbno(mp, cfg->logstart)) {
>  		fprintf(stderr,
