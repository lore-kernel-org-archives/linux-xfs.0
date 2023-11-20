Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657C6C197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 16:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjKTQvz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjKTQvz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 11:51:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C0BA
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 08:51:51 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECB6C433C8;
        Mon, 20 Nov 2023 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700499111;
        bh=s6RVa5iWyx8L6JiivcUf34J5n73WQvEE80iZPoID7cM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FK2lCHf6DZQNE1XRrDge9ePY4Mk16Dbnab3vmbEc47XvClL4mx0WolZxRDowsHL7p
         iZt5s1LEiSs6VKpiY1T4fuZErAbDceX/+vaSOsI+eKtz1P7nkA24t/eKKaGzFhTtFg
         FJgLdrZtH3pxKgZZcfs8A4nvWZ+pFqwdnDnc73ArdzCjt54lVk2S9OG8i+PI1/2DU3
         p6BiDmEa6T8Ti3UjLR2LeTRspVckj98c45qrSo9626q7NixIi3WuvFxDJkUDYfatiq
         KCg4iqLWphkK/Yw28kEO4dwWdM3bfrHbzTCtD94zzc5sNTNn2mSPsB/s1f+ZgGuugC
         muJzgSrJ9bl+g==
Date:   Mon, 20 Nov 2023 08:51:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: Re: [PATCH 1/2] libxf-apply: Ignore Merge commits
Message-ID: <20231120165151.GD36190@frogsfrogsfrogs>
References: <20231120151056.710510-1-cem@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231120151056.710510-1-cem@kernel.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 20, 2023 at 04:10:46PM +0100, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Merge commits in the kernel tree, only polutes the patch list to be
> imported into libxfs, explicitly ignore them.
> 
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
> 
> I'm considering here my own usecase, I never used merge commits, and sometimes
> they break the synchronization, so they make no good for me during libxfs-sync.

The downside of ignoring merge commits is that Linus edited
xfs_rtbitmap.c in the 6.7 merge commit to get rid of the weird code that
casts a struct timespec64 to a u64 rtpick sequence counter and has
screwed things up for years.

--D

>  tools/libxfs-apply | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> index 097a695f9..aa2530f4d 100755
> --- a/tools/libxfs-apply
> +++ b/tools/libxfs-apply
> @@ -445,8 +445,8 @@ fi
>  
>  # grab and echo the list of commits for confirmation
>  echo "Commits to apply:"
> -commit_list=`git rev-list $hashr | tac`
> -git log --oneline $hashr |tac
> +commit_list=`git rev-list --no-merges $hashr | tac`
> +git log --oneline --no-merges $hashr |tac
>  read -r -p "Proceed [y|N]? " response
>  if [ -z "$response" -o "$response" != "y" ]; then
>  	fail "Aborted!"
> -- 
> 2.41.0
> 
