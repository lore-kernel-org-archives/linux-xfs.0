Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF39EC43217
	for <linux-xfs@archiver.kernel.org>; Fri, 22 Apr 2022 16:00:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358409AbiDVQDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 22 Apr 2022 12:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449862AbiDVQDQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Apr 2022 12:03:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0383A5E4
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 09:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1431E62020
        for <linux-xfs@vger.kernel.org>; Fri, 22 Apr 2022 16:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E147C385A0;
        Fri, 22 Apr 2022 16:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650643222;
        bh=H5yVCOfNxvve1PfiAO6BxFrh5Ru0IKoPHeuy+cXuprw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g4pbB28xdm54d2FCYM1TNSfZqZiSdsQAT1JSd7mFsAHqOwChdNG3OD8B1RK4oUTl9
         0dJX45LeSnc8HDcbYInx0RaFz1incRxNHac7QV76drQQU1FU67qyyzNshOYhXNyF+d
         ngyxUhl+QulYpwgRqY9GapLwKNncFuDJNWU4fLLPQNB072CRJpGHXwT6IKa1EeXZEy
         j6paRgSNaviEQs9A4+HjbBHjWoLmV1wt8aLxJ6SraBH6CzZ0NNr2TsjyxgAU5kAI7m
         pAXmsjwoWCePOhINH/j+G1FW/r26qGAvdPv3Ti6KGv269P/3ph5c1wfDsvAEnXncbr
         iaDDYz/Akcfkg==
Date:   Fri, 22 Apr 2022 09:00:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix soft lockup via spinning in filestream ag
 selection loop
Message-ID: <20220422160021.GB17025@magnolia>
References: <20220422141226.1831426-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422141226.1831426-1-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 22, 2022 at 10:12:26AM -0400, Brian Foster wrote:
> The filestream AG selection loop uses pagf data to aid in AG
> selection, which depends on pagf initialization. If the in-core
> structure is not initialized, the caller invokes the AGF read path
> to do so and carries on. If another task enters the loop and finds
> a pagf init already in progress, the AGF read returns -EAGAIN and
> the task continues the loop. This does not increment the current ag
> index, however, which means the task spins on the current AGF buffer
> until unlocked.
> 
> If the AGF read I/O submitted by the initial task happens to be
> delayed for whatever reason, this results in soft lockup warnings

Is there a specific 'whatever reason' going on here?

> via the spinning task. This is reproduced by xfs/170. To avoid this
> problem, fix the AGF trylock failure path to properly iterate to the
> next AG. If a task iterates all AGs without making progress, the
> trylock behavior is dropped in favor of blocking locks and thus a
> soft lockup is no longer possible.
> 
> Fixes: f48e2df8a877ca1c ("xfs: make xfs_*read_agf return EAGAIN to ALLOC_FLAG_TRYLOCK callers")

Ooops, this was a major braino on my part.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> I included the Fixes: tag because this looks like a regression in said
> commit, but I've not explicitly verified.
> 
> Brian
> 
>  fs/xfs/xfs_filestream.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 6a3ce0f6dc9e..be9bcf8a1f99 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -128,11 +128,12 @@ xfs_filestream_pick_ag(
>  		if (!pag->pagf_init) {
>  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
>  			if (err) {
> -				xfs_perag_put(pag);
> -				if (err != -EAGAIN)
> +				if (err != -EAGAIN) {
> +					xfs_perag_put(pag);
>  					return err;
> +				}
>  				/* Couldn't lock the AGF, skip this AG. */
> -				continue;
> +				goto next_ag;
>  			}
>  		}
>  
> -- 
> 2.34.1
> 
