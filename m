Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BB7ECAAD1
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Sep 2022 10:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiIAK4N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Sep 2022 06:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiIAKzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Sep 2022 06:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18BFB53D02
        for <linux-xfs@vger.kernel.org>; Thu,  1 Sep 2022 03:55:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9075C6192C
        for <linux-xfs@vger.kernel.org>; Thu,  1 Sep 2022 10:55:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E502C433D6;
        Thu,  1 Sep 2022 10:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662029712;
        bh=g+5KI90pFtobCBKWjqqMcvyULX6IvSj3TDV2ovmnpY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdVa5rLBR1euPCySHLIKa8fPv8vaYvcdjIVBrJzV/lcfXW4E2Q0K09EiIeFxG80gC
         r+9HiP+y31HB6bHSC8dJNR8nfxZL0VtwfNPY2ZFbDmOtugQtQsDRFqL72prRm3gD0A
         rGht13ZpzjhGdz8rsFcQrb8ix3L3gGPzGNk3Hl93RV7PwZstMtsZKPMblT+6FY9IWN
         rfOJC8VIkrDtZcn4KjJSO5i9cm4HvY6dyBKG5u/iJXiiI5FP3BgnjgEcmevfs6Wlpy
         BOyw/d2aKf0Ums1s46MykAQUQgLKICjjnDFaYvzMBQakMqEodouY2lV4E6MOGEzkC9
         oo2H0XrYhKkwg==
Date:   Thu, 1 Sep 2022 12:55:08 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <20220901105508.kg5nu7xet6ylujcz@andromeda>
References: <20220830115220.5s2nlztp56fbf4xa@andromeda>
 <rlkM2eJNcyQy7rV6YFRttkV5Yq3MmPS6qjlDjTNpzPw-H5ShdMRTb6j_nnN1KmJ4nObvtiv45xwd1cm7No9Nyg==@protonmail.internalid>
 <Yw4o0fBFRqrCHQsY@magnolia>
 <20220831094325.5dwjygbcd5mcibok@andromeda>
 <HT423ktV0FhRyhlKnbnQThPSiTmpTHIEsg_RiUPLpiLZhpCjwcGwTUzCODDXtFk0wUuyabedh6rZaxdVrXn0qQ==@protonmail.internalid>
 <Yw95W6ZAvBqQe7qf@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yw95W6ZAvBqQe7qf@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> 
> Oh, the usual problems of adding a new interface...
> 
> 1. Who is responsible for setting m_sb_bp?
> 
> Should libxfs_mount attach m_sb_bp?  Should individual programs decide
> to do that if they require the functionality?  Should we instead have a
> xfs_getsb function that returns m_sb_bp if set, or libxfs_getbufr's a
> new buffer and tries to cmpxchg it with the pointer?
> 
> What about mkfs, which needs to libxfs_mount before it's even written
> anything to disk?
> 
> 2. Should it be a cached buffer so that any other program (e.g. xfs_db)
> doing open-coded accesses of the superblock will get the same cached
> buffer, or should it be uncached like the kernel?
> 
> If we decide on uncached, this will necessitate a full audit of xfsprogs
> to catch open-coded calls to libxfs_getbuf for the primary super, or
> else coherency problems will result.
> 
> If we decide on using a cached buffer and setting it in libxfs_mount,
> then the part of xfs_repair that tears down the buffer cache and
> reinitializes it with a different hash size will also have to learn to
> brelse m_sb_bp before destroying the cache and re-assign it afterwards.
> Alternately, I suppose it could learn to rehash itself.
> 
> This is a /lot/ to think about to solve one problem in one program.

Yeah, I do agree. Maybe it's better to go with your initial idea for 6.0, and we
postpone the SB buffer pinning to a later release avoiding people to hit this
issue ASAP?!


> 
> > I didn't have time to try to reproduce those deadlocks yet though.
> 
> If you modify cache_node_get like this to make reclaim more aggressive:
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index 139c7c1b..b5e1bcf8 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -448,10 +448,10 @@ cache_node_get(
>  		/*
>  		 * not found, allocate a new entry
>  		 */
> +		priority = cache_shake(cache, priority, false);
>  		node = cache_node_allocate(cache, key);
>  		if (node)
>  			break;
> -		priority = cache_shake(cache, priority, false);
>  		/*
>  		 * We start at 0; if we free CACHE_SHAKE_COUNT we get
>  		 * back the same priority, if not we get back priority+1.
> 
> It's trivially reproducible with xfs_repair (do not specify -n).

Thanks, I'm gonna try it :)

> 
> --D
> 
> > >
> > > [1] https://lore.kernel.org/linux-xfs/166007921743.3294543.7334567013352169774.stgit@magnolia/
> > > [2] https://lore.kernel.org/linux-xfs/20220811221541.GQ3600936@dread.disaster.area/
> >
> > --
> > Carlos Maiolino

-- 
Carlos Maiolino
