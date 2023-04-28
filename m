Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 454A8C77B61
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 08:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345670AbjD1IJ1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Apr 2023 04:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345552AbjD1IJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Apr 2023 04:09:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859D40F8
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 01:09:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DEC463DD0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2023 08:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8162BC433EF;
        Fri, 28 Apr 2023 08:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682669353;
        bh=WiTkK1cog8mhBEqSVte3qQLZYliKhcpFDem+Ey/2q8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q6orC1xG6YS32Gj05WWwFkptA+OfFzTaGg7fXye1ycxQBjxO48ELb8y5+fpX1mtOp
         Nw97ezVJyrwkZyIHoUFY1kzpo7xpOh1ZVrrO9xP2zNfbOnQbdKVqExDVbo9fR/bxQJ
         yFFsXypaqL2Mi38Zn4rsdvcgi/gBxZMN1mrz7a8oelc+RNNEH8ilNXBwGTYTkoo52a
         AbJOpGBeidqK/kN+DxVl5SsDNzqpfULAkCJC7LFaQbWzN3I8FqW1xbhYgLh1le3R/f
         glUG9dCABU+dBms99VJZkYewP/YrpAsKLmf4BzAI4HkXoaP9jZBQcT/weOxNxeLoXy
         FdH3khdHCaMsA==
Date:   Fri, 28 Apr 2023 10:09:08 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: warning about misaligned AGs and RAID stripes is
 not an error
Message-ID: <20230428080908.x5vfnshss7hxjq7y@andromeda>
References: <CUQF8CitQG_-gWntD7C-tEAqv-GBVpBOalGxb-XROZN5CAL2JSIyhbtWoiKJSLbP2zPh516xKhV2L7bG9ncArQ==@protonmail.internalid>
 <20230427224540.GE59213@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427224540.GE59213@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:45:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I've noticed a fair number of fstests failures when we create a scratch
> device on a RAID device and the test specifies an explicit AG count or
> AG size:
> 
> --- /tmp/fstests/tests/xfs/042.out	2022-09-01 15:09:11.484679979 -0700
> +++ /var/tmp/fstests/xfs/042.out.bad	2023-04-25 19:59:04.040000000 -0700
> @@ -1,5 +1,8 @@
>  QA output created by 042
> -Make a 96 megabyte filesystem on SCRATCH_DEV and mount... done
> +Make a 96 megabyte filesystem on SCRATCH_DEV and mount... Warning: AG size is a multiple of stripe width.  This can cause performance
> +problems by aligning all AGs on the same disk.  To avoid this, run mkfs with
> +an AG size that is one stripe unit smaller or larger, for example 8160.
> +done
> 
> Emitting this warning on stderr is silly -- nothing has failed, and we
> aren't going to abort the format either.  Send the warning to stdout.

I agree with it, looks better printing it out to stdout other than stderr, so,
with one caveat below:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

I think this might impact user tools monitoring stderr, but for mkfs I don't
think it's a big deal, just wanted to raise this concern.

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 6dc0f335..2f2995e1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3167,11 +3167,12 @@ _("agsize rounded to %lld, sunit = %d\n"),
> 
>  		if (cli_opt_set(&dopts, D_AGCOUNT) ||
>  		    cli_opt_set(&dopts, D_AGSIZE)) {
> -			fprintf(stderr, _(
> +			printf(_(
>  "Warning: AG size is a multiple of stripe width.  This can cause performance\n\
>  problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
>  an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
>  				(unsigned long long)cfg->agsize - dsunit);
> +			fflush(stdout);
>  			goto validate;
>  		}
> 

-- 
Carlos Maiolino
