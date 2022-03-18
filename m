Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2074C433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiCRMTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236137AbiCRMTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:19:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 326CC25EB7
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647605877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ocgJlzF1X7AQtwCb+svRQKw3Gyz9o6Jdc6i3cF9PkCI=;
        b=Nr0XuQqjD704Yk4EoyKDii/UGNZTvd6gsyhKuK8wxAjMF9JA1oyYr8l/80fOFPeQ7V6sQP
        LCmD1zHZ2QWLnPXfaJ+6VacHoRhcSgAYMvyOSSaUb031bxHofL4eh3cSkMxa8carDIvexp
        wXoQiWabv1yL33CwurERA69ly08HNtg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-mn-BkBDLNYOuPuvPQyQz7g-1; Fri, 18 Mar 2022 08:17:56 -0400
X-MC-Unique: mn-BkBDLNYOuPuvPQyQz7g-1
Received: by mail-qv1-f70.google.com with SMTP id kj16-20020a056214529000b00435218e0f0dso6139249qvb.3
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ocgJlzF1X7AQtwCb+svRQKw3Gyz9o6Jdc6i3cF9PkCI=;
        b=U7kdC9qVabxzLEepwQC5RkEhyNa+nBrZoyqY+o4/xNfxvw1lmMnwKAJg+chNNQH5of
         fgaPiz87jW6wD/o1L9IVExcwwtFJgNla3VVLb/bWKyBh7NjS8o99MStJA4lpIZs4RsUT
         BjC4plVKZIEJxjG74MwhFDlExq8JIY+8g53l1GtV3rEk5bqfVEzJ8a7DTalBKqcebZMm
         lAmFfRgEvu8GdrLJZvmVbKz759eYERCu/7jI6fH4ay5APzHpU+OBWIk14F58NZn1QELN
         e4fujkHyTompIOmVljYzkVkCLOuC7iwr2ia6eXeT++QWRk4xSYdn9FIUTSErqTrw83Kw
         gzoQ==
X-Gm-Message-State: AOAM530HWGHYBdo7EQxuxK++Fe7ARo9SCSxaSi2qDeqr7vUf2qkmwCjU
        /MLab/ov97aDZ4gxQLHI2jYNn2OFRCLF2iiC1qXKNYFXz+iEdMCxcgXGT8w8KLpXvHi+kcyylf2
        j2WSPHeyI008NHtNJQa/k
X-Received: by 2002:ac8:5f87:0:b0:2e1:b941:69b9 with SMTP id j7-20020ac85f87000000b002e1b94169b9mr7317032qta.173.1647605875989;
        Fri, 18 Mar 2022 05:17:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9Q4D6SHXM72hGH8eUblLpyJZQqXAlOs1vLxJXOG5BWU1DZ3pao3yyCVjw7xcul4O9URTWsA==
X-Received: by 2002:ac8:5f87:0:b0:2e1:b941:69b9 with SMTP id j7-20020ac85f87000000b002e1b94169b9mr7317013qta.173.1647605875728;
        Fri, 18 Mar 2022 05:17:55 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id f185-20020a37d2c2000000b0067e342d5e4dsm2947995qkj.105.2022.03.18.05.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:17:55 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:17:53 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/6] xfs: actually set aside enough space to handle a
 bmbt split
Message-ID: <YjR4cZ47tOutXB+e@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755206657.4194202.6609453202119841910.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755206657.4194202.6609453202119841910.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The comment for xfs_alloc_set_aside indicates that we want to set aside
> enough space to handle a bmap btree split.  The code, unfortunately,
> hardcodes this to 4.
> 
> This is incorrect, since file bmap btrees can be taller than that:
> 
> xfs_db> btheight bmapbt -n 4294967296 -b 512
> bmapbt: worst case per 512-byte block: 13 records (leaf) / 13 keyptrs (node)
> level 0: 4294967296 records, 330382100 blocks
> level 1: 330382100 records, 25414008 blocks
> level 2: 25414008 records, 1954924 blocks
> level 3: 1954924 records, 150379 blocks
> level 4: 150379 records, 11568 blocks
> level 5: 11568 records, 890 blocks
> level 6: 890 records, 69 blocks
> level 7: 69 records, 6 blocks
> level 8: 6 records, 1 block
> 9 levels, 357913945 blocks total
> 
> Fix this by using the actual bmap btree maxlevel value for the
> set-aside.  We subtract one because the root is always in the inode and
> hence never splits.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |    7 +++++--
>  fs/xfs/libxfs/xfs_sb.c    |    2 --
>  fs/xfs/xfs_mount.c        |    7 +++++++
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index bed73e8002a5..9336176dc706 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -652,6 +652,13 @@ xfs_mountfs(
>  
>  	xfs_agbtree_compute_maxlevels(mp);
>  
> +	/*
> +	 * Compute the amount of space to set aside to handle btree splits now
> +	 * that we have calculated the btree maxlevels.
> +	 */

"... to handle btree splits near -ENOSPC ..." ?

Otherwise LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
> +	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
> +
>  	/*
>  	 * Check if sb_agblocks is aligned at stripe boundary.  If sb_agblocks
>  	 * is NOT aligned turn off m_dalign since allocator alignment is within
> 

