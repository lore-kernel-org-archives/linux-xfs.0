Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0330AC74A5B
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Mar 2023 00:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjCRAis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Mar 2023 20:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjCRAis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Mar 2023 20:38:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9542BED6
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:38:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u5so7046165plq.7
        for <linux-xfs@vger.kernel.org>; Fri, 17 Mar 2023 17:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1679099926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADrZkDc47X0qgjC5CL7YDG19irYQqheJk6lFAAbZMuE=;
        b=W+8Jm5gxkJPbgcfA6pLLR3rGu2ER5mi4WQK/3q0ujA88bb3/c2w5Qp5wxvbAifiQM7
         0eJTNW0pLznQqsud+nInjuZsCbTqlTLeKrrdBRRIsQJYJ9ak4///+2J9NFr+JppHSpeX
         jREZABwZ272Ub3Wj2Di3w9yEtXpXecq+XvZS1D/EFJIXSqXjj7nDLoFcATg/A/VDkCgu
         CYQzFtvc8p6on2PkdcR2YyXFJMgVpNCo2clhwCWbmFVNvGIID19Hazxx3ugfYpFFMj2v
         UaYKmZCMoWMA+7a3M1UvKRjgl1K/+k1lOxWA9iGQ9LtvEbby/LZPzKe1Uj+m1l54b6Kz
         RFNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679099926;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADrZkDc47X0qgjC5CL7YDG19irYQqheJk6lFAAbZMuE=;
        b=tAf5e050pNOYO//BKs0aC+BL4xvHtgl9FrrPUzsZeqjKm7RZCg19s6AfMaUzb4WN5T
         Xep3iIMhRHNWSLUfuZ/CaJ0jG3Z0pVZ3tGBHfzcEO4dhyxB6TJR2xc+KDILskoHa9tq5
         +3e3s8bY/PG8dcakorG0JelU3AmZE7sJK5RBL86SBqrV2xK2xOyR1l49IlLscJ0AG/Bl
         VCXcGVaLn/3g1Z3hzWz50dtED1Q4yET3/zZiDaDJ5aULf8uVN4zdi5mQ/Vrd9Uc933tm
         dWruYV+0tG3KVtKXqjz23g6mVBeFmewYOwb5z+1Nvdz3+oLORQtd8JultvieQC2vIJC8
         oAtw==
X-Gm-Message-State: AO0yUKXTCwYXbPhMa6RdORQIC2wNmtEQAA7RNXlUCx8zg07X1kv2KgwY
        ST/6BY78E7JkrHLgmN1dtOttxA==
X-Google-Smtp-Source: AK7set8WgS65GOSrt/KGCZFJoXbLn2SKpj+XAHwlHZvy5GbuLT+G3ygMSjmqV5Oght9cbAkzRTL8wQ==
X-Received: by 2002:a17:902:e848:b0:19d:b02:cca5 with SMTP id t8-20020a170902e84800b0019d0b02cca5mr10341858plg.12.1679099925848;
        Fri, 17 Mar 2023 17:38:45 -0700 (PDT)
Received: from destitution (pa49-196-94-140.pa.vic.optusnet.com.au. [49.196.94.140])
        by smtp.gmail.com with ESMTPSA id io19-20020a17090312d300b001a053446764sm2109745plb.63.2023.03.17.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 17:38:45 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1pdKao-000J7y-2F;
        Sat, 18 Mar 2023 11:38:42 +1100
Date:   Sat, 18 Mar 2023 11:38:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: walk all AGs if TRYLOCK passed to
 xfs_alloc_vextent_iterate_ags
Message-ID: <ZBUIElGrUQnvxprN@destitution>
References: <20230316164721.GK11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316164721.GK11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 16, 2023 at 09:47:21AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Callers of xfs_alloc_vextent_iterate_ags that pass in the TRYLOCK flag
> want us to perform a non-blocking scan of the AGs for free space.  There
> are no ordering constraints for non-blocking AGF lock acquisition, so
> the scan can freely start over at AG 0 even when minimum_agno > 0.
> 
> This manifests fairly reliably on xfs/294 on 6.3-rc2 with the parent
> pointer patchset applied and the realtime volume enabled.  I observed
> the following sequence as part of an xfs_dir_createname call:
> 
> 0. Fragment the free space, then allocate nearly all the free space in
>    all AGs except AG 0.
> 
> 1. Create a directory in AG 2 and let it grow for a while.
> 
> 2. Try to allocate 2 blocks to expand the dirent part of a directory.
>    The space will be allocated out of AG 0, but the allocation will not
>    be contiguous.  This (I think) activates the LOWMODE allocator.
> 
> 3. The bmapi call decides to convert from extents to bmbt format and
>    tries to allocate 1 block.  This allocation request calls
>    xfs_alloc_vextent_start_ag with the inode number, which starts the
>    scan at AG 2.  We ignore AG 0 (with all its free space) and instead
>    scrape AG 2 and 3 for more space.  We find one block, but this now
>    kicks t_highest_agno to 3.
> 
> 4. The createname call decides it needs to split the dabtree.  It tries
>    to allocate even more space with xfs_alloc_vextent_start_ag, but now
>    we're constrained to AG 3, and we don't find the space.  The
>    createname returns ENOSPC and the filesystem shuts down.
> 
> This change fixes the problem by making the trylock scan wrap around to
> AG 0 if it doesn't like the AGs that it finds.  Since the current
> transaction itself holds AGF 0, the trylock of AGF 0 will succeed, and
> we take space from the AG that has plenty.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 8999e38e1bed..bd7112d430b6 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3326,11 +3326,14 @@ xfs_alloc_vextent_iterate_ags(
>  	uint32_t		flags)
>  {
>  	struct xfs_mount	*mp = args->mp;
> +	xfs_agnumber_t		restart_agno = minimum_agno;
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
> +	if (flags & XFS_ALLOC_FLAG_TRYLOCK)
> +		restart_agno = 0;
>  restart:
> -	for_each_perag_wrap_range(mp, start_agno, minimum_agno,
> +	for_each_perag_wrap_range(mp, start_agno, restart_agno,
>  			mp->m_sb.sb_agcount, agno, args->pag) {
>  		args->agno = agno;
>  		error = xfs_alloc_vextent_prepare_ag(args);
> @@ -3369,6 +3372,7 @@ xfs_alloc_vextent_iterate_ags(
>  	 */
>  	if (flags) {
>  		flags = 0;
> +		restart_agno = minimum_agno;
>  		goto restart;
>  	}

Looks good. Pretty much what we talked about on #xfs.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
