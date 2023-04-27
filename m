Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE23C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344053AbjD0Wv6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjD0Wv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:51:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24CD2129
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47E0D63E19
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE68C433EF;
        Thu, 27 Apr 2023 22:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635915;
        bh=rCdubkJZubg0hIWmHFfHCMIeObp/C16Viu5DMTJ/1D0=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=T+bRCeWB115+547X3EaBNhIm90qNGGUfp6pkqP/ym479iDQbGoBTNEPvZbXQehXOi
         iSIsuQjBkJVF97mxNrY3/smuKtyTlTmz/Dy35894UCsXdhd7g+NMEW2VKscV6HfAG+
         /yHpXTTySZyRwkFN9wvGbIKfAZlbG0g4ZS4d0v5TtzAiphwLhZ3SdAzy7Mz8/QTqdd
         wXeFGyyP79OpyP7jaxqCtgMzqaQQNZCU14Y5kL1vofruHw5e7CnNu/9J+F7bwH1GVv
         xAJ/xm64QAP/gFHT5wrOt5JdkTIRzYh/krg8xJmGzvOHrsKSIgmtYiMJfiAwMfdDJd
         OwelOi/8LUM3g==
Date:   Thu, 27 Apr 2023 15:51:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCHSET 0/4] xfs: bug fixes for 6.4-rc1
Message-ID: <20230427225155.GF59213@frogsfrogsfrogs>
References: <168263569804.1717447.12960771904502687107.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263569804.1717447.12960771904502687107.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Disregard this, I got Dave's email wrong, copy-pasted it around the
automation, and then forgot to make sure that /all/ of them were
corrected. :(

Will resend....

--D

On Thu, Apr 27, 2023 at 03:48:18PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here are some assorted bug fixes for 6.4:
> 
>  * A regression fix for the allocator refactoring that we did in 6.3.
>  * Fix a bug that occurs when formatting an internal log with a stripe
>    alignment such that there's free space before the start of the log
>    but not after.
>  * Make scrub actually take the MMAPLOCK (to lock out page faults) when
>    scrubbing the COW fork
>  * If we call FUNSHARE on a hole in the data fork, don't create a
>    delalloc reservation in the cow fork for that hole.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=kernel-fixes-6.4
> ---
>  fs/xfs/libxfs/xfs_ag.c   |   10 +++++-----
>  fs/xfs/libxfs/xfs_bmap.c |    5 +++--
>  fs/xfs/scrub/bmap.c      |    4 ++--
>  fs/xfs/xfs_iomap.c       |    5 +++--
>  4 files changed, 13 insertions(+), 11 deletions(-)
> 
