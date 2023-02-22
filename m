Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80266C64EC4
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Feb 2023 08:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjBVI2O (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Feb 2023 03:28:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBVI2N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Feb 2023 03:28:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7372278A
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 00:28:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37984B811CB
        for <linux-xfs@vger.kernel.org>; Wed, 22 Feb 2023 08:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F398FC433EF;
        Wed, 22 Feb 2023 08:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677054489;
        bh=4HaJM+S3opnG1Hzj0O974zbtYjjJ0rbz6esNugCR9GA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAJrw0kaGuH0UolZuk5RN7WQc6uX+n5yBi4vIbVaCbT91HqyH6Tl4U7W8tHe5fmhT
         aGydwDQedsNJS68ZbdWckYFDQ3UaLh+ypXjaOEcU0MoGIJVjCNmeO64GZU7WuTTOvq
         SBh786lIHAwUMVb6op1VXnL+XRdwVEG+Qvn5+ZbUNa5kFsByVvvx50XweBvq10vjAX
         MzddQWYtlW7Tl1E3d4gj49xxW5DF1alcmlp12zj9YqHBsnlKQHYw6NAYzBny5hH2JI
         Z41B0XDXPl1xJRJvULEj8MDVi8ikEMNBpASNdcKViyoG0shwxmVN7LykT1sv8sU+BM
         VZJjJewTW6iEQ==
Date:   Wed, 22 Feb 2023 09:28:05 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_io: fix bmap command not detecting realtime files
 with xattrs
Message-ID: <20230222082805.lgihqlryntakejy7@andromeda>
References: <yL-h_t2gPiyfv73J3Z4afr1fJFRLUKiKhKGx_rzDVHutzfEKbidpVNAfQcHs8nXQu7co8H6Fiv35lVnuxAKhwA==@protonmail.internalid>
 <Y+RcuAFlqnxNBw5I@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+RcuAFlqnxNBw5I@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 08, 2023 at 06:38:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix the bmap command so that it will detect a realtime file if any of
> the other file flags (e.g. xattrs) are set.  Observed via xfs/556.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  io/bmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io/bmap.c b/io/bmap.c
> index a78e0c65440..11bbc0629cf 100644
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

-- 
Carlos Maiolino
