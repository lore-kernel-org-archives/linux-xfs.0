Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E6DC7EE24
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 13:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjFFNnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 09:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjFFNni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 09:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 230FBE6B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 06:43:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EC3361AE4
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 13:43:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83FAC433D2
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 13:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686059015;
        bh=JjEzdi+naVIjmpf/aPcd7VxUwX43we1n3zkXK5T9UHw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=mQpyFlbIGVO5wEofgXAnS4MRyLeRaLZwJQUo1iE6Ckv4zqo7FNEClxVIZa3leXTQh
         6bgL74J41xv8jTz8YTzmwm8qEIjvAXL7kxeKpmSklEQXFluKH9GCblmidTc47vFreX
         ZHtG5jVYBoElQ/pZS1o/aMKwVcF4BDa5V/DZ385ICmHnN5nvb9i/z6AWl0zr0mrDi7
         Ok1v0Q/smOaaG1yHANSp5WnW4P0vcf8pU/r3XsMe4mb2eK7tZu7aHz31fH7YZEWwY1
         ZyYt+5I3e4gy6vp/wfWv/A/zRO9VeuuIFzQjuypwGUHbsspFfXtgOTyUWEPTDrPIR4
         zYY8Q0O2q1bjw==
Date:   Tue, 6 Jun 2023 15:43:31 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Comment out unreachable code within
 xchk_fscounters()
Message-ID: <20230606134331.hfh4ce24d7dsrlbz@andromeda>
References: <T_8tV8A10oGZEuptzXoj3XFlD_-Ubqx0imHpEcDfSogB7Zfy2zaQhiSq2U9pkW3E65U6VKUJ46394RCv5lGGMA==@protonmail.internalid>
 <20230606133710.674706-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606133710.674706-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 06, 2023 at 03:37:10PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Comment the code out so kernel test robot stop complaining about it
> every single test build.

Please, ignore this, as commenting out the unreachable code created another
warnings. I'll fix it and resend the patch. Sorry the noise.


> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  fs/xfs/scrub/fscounters.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index e382a35e98d88..b1148bea7fabc 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -452,6 +452,7 @@ xchk_fscounters(
>  	 */
>  	return 0;
> 
> +#if 0
>  	/*
>  	 * If ifree exceeds icount by more than the minimum variance then
>  	 * something's probably wrong with the counters.
> @@ -489,4 +490,5 @@ xchk_fscounters(
>  		xchk_set_corrupt(sc);
> 
>  	return 0;
> +#endif
>  }
> --
> 2.30.2
> 
