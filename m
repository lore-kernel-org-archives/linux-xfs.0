Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021F2C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 06:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbiK2GbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 01:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233838AbiK2GbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 01:31:10 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9178A43AC7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 22:31:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id mv18so11766677pjb.0
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2022 22:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xOPIHHFXReAGmbI6GC4ueZJyJskEbBklUjanPtEBiGg=;
        b=67fEWsOj/CsJfVw19X8YakAGKglr677rpJsYF0xcFr0JGiRprz+KjV+EL4izSTs+8D
         pOU9NTu+Ul2BdItyKYH0B0IhFJUa5qIPqINYFSC9upxCoD3ji70tf25GN0yqOV5K5bX8
         i9RDnAinUydMOOJkWFzzBUnriZEP6rxX05Y6TQbkRhaHrJ2Sj301zI2iLJnlYfLjtARS
         HayiFR6ZPKKHOaU1ydbug2soKK9buW1DmXiuMsk88eBd4VRaAYnPMOIcUpgvo4+ZBG2w
         kx69ndDXT2tF1Ls+jWGhaMV5qrOIlWk4Fx5PySs9srU4+Shfx/vItnIhenN7m9Erpsym
         o6GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOPIHHFXReAGmbI6GC4ueZJyJskEbBklUjanPtEBiGg=;
        b=lUl89B89Pf7tR81FGnjYzUuqz2CEpaXYuVxTxNXi6WBg+8sjKaPZytAN7ccYu2rZIM
         N7PoEjQaanXcirsEKKsCD7J9ksjGgrIU4/bA8uxfch+mKcn80XHOKRtga/AktHefO3vI
         AV11ecOrWxsrZkAUTJcm3k28OSE6CnmzM7czxRXJhhiAvdrx2szTf9n25n4wNjPPOfyw
         uY+gwDKVK72qcJZAAKtErDznyWaUxAdj2imzzU3kw9XKY7uyTYZ8vfxIYUBodNciIZap
         Xn7sqKBtBA8ybHbFwLJ0MfQIYseRTuSDokIyadAeDvROYYe/R3SPdmLCAE/jrGQnp00g
         Hi6Q==
X-Gm-Message-State: ANoB5plMMgu0IEnAqlEAgDmu6Du9Jmd7eIvFV2MH5l4DcNyJF5KTB1vO
        TQd208GhEqlOsOGXhN0Cewb5X6ZDWvfdEQ==
X-Google-Smtp-Source: AA0mqf5ESkGvzMbchGoA30pa+gSLMQr5Mi77toggKD7n0Y/mqMcL36DxDhqvyvNp0ZhPfFawkDmmuQ==
X-Received: by 2002:a17:903:32cd:b0:178:32b9:6f4f with SMTP id i13-20020a17090332cd00b0017832b96f4fmr35987018plr.94.1669703468096;
        Mon, 28 Nov 2022 22:31:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id c3-20020a17090a4d0300b00218998eb828sm531448pjg.45.2022.11.28.22.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 22:31:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ozu92-002KZ4-Lb; Tue, 29 Nov 2022 17:31:04 +1100
Date:   Tue, 29 Nov 2022 17:31:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/3] xfs: attach dquots to inode before reading data/cow
 fork mappings
Message-ID: <20221129063104.GD3600936@dread.disaster.area>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
 <Y4OuLTwPVdiHMBGi@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4OuLTwPVdiHMBGi@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 27, 2022 at 10:36:29AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I've been running near-continuous integration testing of online fsck,
> and I've noticed that once a day, one of the ARM VMs will fail the test
> with out of order records in the data fork.
> 
> xfs/804 races fsstress with online scrub (aka scan but do not change
> anything), so I think this might be a bug in the core xfs code.  This
> also only seems to trigger if one runs the test for more than ~6 minutes
> via TIME_FACTOR=13 or something.
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/tree/tests/xfs/804?h=djwong-wtf
.....
> So.  Fix this by moving the dqattach_locked call up, and add a comment
> about how we must attach the dquots *before* sampling the data/cow fork
> contents.
> 
> Fixes: a526c85c2236 ("xfs: move xfs_file_iomap_begin_delay around") # goes further back than this
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_iomap.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1bdd7afc1010..d903f0586490 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -984,6 +984,14 @@ xfs_buffered_write_iomap_begin(
>  	if (error)
>  		goto out_unlock;
>  
> +	/*
> +	 * Attach dquots before we access the data/cow fork mappings, because
> +	 * this function can cycle the ILOCK.
> +	 */
> +	error = xfs_qm_dqattach_locked(ip, false);
> +	if (error)
> +		goto out_unlock;
> +
>  	/*
>  	 * Search the data fork first to look up our source mapping.  We
>  	 * always need the data fork map, as we have to return it to the
> @@ -1071,10 +1079,6 @@ xfs_buffered_write_iomap_begin(
>  			allocfork = XFS_COW_FORK;
>  	}
>  
> -	error = xfs_qm_dqattach_locked(ip, false);
> -	if (error)
> -		goto out_unlock;
> -
>  	if (eof && offset + count > XFS_ISIZE(ip)) {
>  		/*
>  		 * Determine the initial size of the preallocation.
> 

Why not attached the dquots before we call xfs_ilock_for_iomap()?
That way we can just call xfs_qm_dqattach(ip, false) and just return
on failure immediately. That's exactly what we do in the
xfs_iomap_write_direct() path, and it avoids the need to mention
anything about lock cycling because we just don't care
about cycling the ILOCK to read in or allocate dquots before we
start the real work that needs to be done...

Hmmmmm - this means there's a potential problem with IOCB_NOWAIT
here - if the dquots are not in memory, we're going to drop and then
retake the ILOCK_EXCL without trylocks, potentially blocking a task
that should not get blocked. That's a separate problem, though, and
we probably need to plumb NOWAIT through to the dquot lookup cache
miss case to solve that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
