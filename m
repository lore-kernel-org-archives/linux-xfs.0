Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0C9C4360C
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17D2D222C7
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 14:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIZOrg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 10:47:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfIZOrg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 10:47:36 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C414F121D
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 14:47:35 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id s19so1140908wmj.0
        for <linux-xfs@vger.kernel.org>; Thu, 26 Sep 2019 07:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=UsPJ7KKj5rDdwOK20+UXqBaKFYPpFaAjrcTnWhQRyb8=;
        b=ZcftGJAjj1RWVp3eWY9kwx0os8CSvWucPuCM+YNE0pMehF7eFAs+0iF8ozaOruWiyi
         hMz+Qxlpvgb8Nw2PChq2wA+v9f+4UzOmU2XK5qglWWx3OTArB+A/cF4eeBCdQ7RRoMLT
         zqYRlfOUQaEYNzbafO3fTYpTb2u2mMyudJBbkGI2iHvSfwRPipjE/5b5DD4qn1N+RTsx
         iI+ydP31qP+rqztSWA6F2cGxSlROGvVi/BWf9v+Ds1RmHcPMdNTWAkSOGOe0VeDEDfFq
         gbQ+HN/SWmy9/F2aDOHBAaKK9xzdVCRm4ySIOVcatatoycgqMbadW4CmBqOkW2XRGXg/
         zAbQ==
X-Gm-Message-State: APjAAAWGoeaaFtXPN8Cp2V+xCT9f5plE84heeo4inzlqOTJfkqChe1dD
        CwyStFgIi1yu31QlMW28skDOxcZZlgcqmGoAYOvlVe0Axf0nGwNGNTn7womIWvu7lw+Gsjuvxl0
        hAfz8ysGMg7JErnOe1C+a
X-Received: by 2002:a7b:cc91:: with SMTP id p17mr3236088wma.43.1569509254480;
        Thu, 26 Sep 2019 07:47:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw88pE0/30Mxts+g+Qjc6An31UCyo/+2khdU9NqvqJdJXhLbD/tLc0P2lRCCI9MVupLvV+hqw==
X-Received: by 2002:a7b:cc91:: with SMTP id p17mr3236077wma.43.1569509254275;
        Thu, 26 Sep 2019 07:47:34 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id n1sm6549204wrg.67.2019.09.26.07.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 07:47:33 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:47:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Max Reitz <mreitz@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Fix tail rounding in xfs_alloc_file_space()
Message-ID: <20190926144730.zf6kwjy2b7hraa2p@pegasus.maiolino.io>
Mail-Followup-To: Max Reitz <mreitz@redhat.com>, linux-xfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
References: <20190926142238.26973-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926142238.26973-1-mreitz@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 26, 2019 at 04:22:38PM +0200, Max Reitz wrote:
> To ensure that all blocks touched by the range [offset, offset + count)
> are allocated, we need to calculate the block count from the difference
> of the range end (rounded up) and the range start (rounded down).
> 
> Before this patch, we just round up the byte count, which may lead to
> unaligned ranges not being fully allocated:
> 
> $ touch test_file
> $ block_size=$(stat -fc '%S' test_file)
> $ fallocate -o $((block_size / 2)) -l $block_size test_file
> $ xfs_bmap test_file
> test_file:
>         0: [0..7]: 1396264..1396271
>         1: [8..15]: hole
> 
> There should not be a hole there.  Instead, the first two blocks should
> be fully allocated.
> 
> With this patch applied, the result is something like this:
> 
> $ touch test_file
> $ block_size=$(stat -fc '%S' test_file)
> $ fallocate -o $((block_size / 2)) -l $block_size test_file
> $ xfs_bmap test_file
> test_file:
>         0: [0..15]: 11024..11039
> 
> Signed-off-by: Max Reitz <mreitz@redhat.com>

For the patch:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


+1 for a test in xfstests


P.S.

You usually don't need to Cc: LKML for xfs-only patches, linux-xfs is enough.

> ---
>  fs/xfs/xfs_bmap_util.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 0910cb75b65d..4f443703065e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -864,6 +864,7 @@ xfs_alloc_file_space(
>  	xfs_filblks_t		allocatesize_fsb;
>  	xfs_extlen_t		extsz, temp;
>  	xfs_fileoff_t		startoffset_fsb;
> +	xfs_fileoff_t		endoffset_fsb;
>  	int			nimaps;
>  	int			quota_flag;
>  	int			rt;
> @@ -891,7 +892,8 @@ xfs_alloc_file_space(
>  	imapp = &imaps[0];
>  	nimaps = 1;
>  	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
> -	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
> +	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
> +	allocatesize_fsb = endoffset_fsb - startoffset_fsb;
>  
>  	/*
>  	 * Allocate file space until done or until there is an error
> -- 
> 2.23.0
> 

-- 
Carlos
