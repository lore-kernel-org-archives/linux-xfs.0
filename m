Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED10AC61DA4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 08:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjBVItA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBVItA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 03:49:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A793631E35
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 00:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45709612AB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E0C433D2;
        Wed, 22 Feb 2023 08:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677055738;
        bh=5VJsJUhfsk7IJAfJhPQ2fgO9ECjJ1WRAhWybzUekoEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r8QFLiZ7RJGhs3AwvU8MY3YWWafkXm6WMXd2kdNCUwIWcbBQx+el2ZXGDDo3cTOQi
         ighrFMLC/UdJ/y2sAC4ZS35Fq1NzR3/8AVvF9xbpdVV9n9hnmswGMXZTz4Lz8RKOgP
         nTOsNqsNPsmx49kjD4TrtSGeOA1xgGDMTb/IOrJHNLNzMEBIHz662nqww1ZrL6suDb
         AW+poGc2hXviW3l2QMAcFDu379CmS2khE2YeBK1tO6s+gGJf5ccUjMCa4jDFuhPRR+
         zPUJic5xEGcPPBuZevbChoOjlJvjfySh/poIJBHVLvDH2I609LWwmtbjjMs6FAGT4m
         jwUW9hh/9W6Jg==
Date:   Wed, 22 Feb 2023 09:48:54 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        daan.j.demeyer@gmail.com
Subject: Re: [PATCH 4/5] xfs_io: fix bmap command not detecting realtime
 files with xattrs
Message-ID: <20230222084854.psipute2rappob4m@andromeda>
References: <167658436759.3590000.3700844510708970684.stgit@magnolia>
 <gTWiH4LcNXFfAtKa89DsXv77fILxHNkaARl9twJncIcmc6LWZwsUGBEYxYW1Rt_dsVkoQr9DzLibvmx67XeUvA==@protonmail.internalid>
 <167658439020.3590000.194008272775624083.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167658439020.3590000.194008272775624083.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 16, 2023 at 01:53:10PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the bmap command so that it will detect a realtime file if any of
> the other file flags (e.g. xattrs) are set.  Observed via xfs/556.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  io/bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/io/bmap.c b/io/bmap.c
> index 27383ca6037..722a389baaa 100644
> --- a/io/bmap.c
> +++ b/io/bmap.c
> @@ -118,7 +118,7 @@ bmap_f(
>  			return 0;
>  		}
> 
> -		if (fsx.fsx_xflags == FS_XFLAG_REALTIME) {
> +		if (fsx.fsx_xflags & FS_XFLAG_REALTIME) {
>  			/*
>  			 * ag info not applicable to rt, continue
>  			 * without ag output.
> 

-- 
Carlos Maiolino
