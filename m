Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D405C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Mar 2022 12:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236169AbiCRMUO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 18 Mar 2022 08:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiCRMUK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Mar 2022 08:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26E0D19BFC9
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647605928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LXkU/cBrsyucgCuHhQbHpeIcZ3IZetyeuiXewvEYNHE=;
        b=IsKmACdId+QGAXqdKHUwrMDAGBGD/uMTbIfT3DFhTE3RAKTSmfj0T321sEk1eGZfo+unLk
        JAhRi4kvagbZ/GO/3tfFRu6IUdrIeyyRDGexdOvv4A+WeW3o7FUHoln9bRJcd2UH2p9Tmg
        L9En0NZyBgk5K+XRyjdPA4cpVS04Pc4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-rGOYo3hMNpyJLEYjcIWszg-1; Fri, 18 Mar 2022 08:18:47 -0400
X-MC-Unique: rGOYo3hMNpyJLEYjcIWszg-1
Received: by mail-qk1-f200.google.com with SMTP id 207-20020a3703d8000000b0067b14f0844dso5186380qkd.22
        for <linux-xfs@vger.kernel.org>; Fri, 18 Mar 2022 05:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LXkU/cBrsyucgCuHhQbHpeIcZ3IZetyeuiXewvEYNHE=;
        b=I9FFRKM8jjudqMffwz8nMmXJuOnqZrtNk7D5A92nXgWyYkFwgAa0yZrdAwPDEbBm1K
         Xbhx68qoeSJCXkicKie+yjTpjzf884ytB5eSXBX1KmaP+/nfCvS18a/c54DrlIPycLH4
         sfe8H2GrvintFTJYOmq/cQs7faLH2WlwKpsETl18FudpdkedCp+uiD9jt+w/gzK+JiDv
         u0h1htVNSUblvfGKM/yW2T46yKXmQteLenOHBdt6hGs1YhMfsZlcR8HTyO3Ug1SOdecH
         LBFVaMAl++TC2f8/Kg2Fop7y/qfmVgkT4B/yE2xpLiybz+roUZZlT0/dRKJejb+IobFk
         /ckQ==
X-Gm-Message-State: AOAM530g5sPrhfcKDgGM/YpP35Wzy9SqWKc7ZeiPMsHt8lSn6ISSTc/m
        gMeqX7ICZbb272Q9UcbPU2k28tkuFJ0XnA8VCN/GP4RAxkDm4gTGnrPg/P42uVUR15mKzbY2me+
        p5sVBo8mQvg0j+6ieMB86
X-Received: by 2002:a05:622a:1910:b0:2e1:ef94:63f1 with SMTP id w16-20020a05622a191000b002e1ef9463f1mr5934605qtc.360.1647605926665;
        Fri, 18 Mar 2022 05:18:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTvvxuG9NWlb0982z8H3r5SThGEzEeauCFRdFa/+Tdbo2L+TmtdISnKvI6K4xSbEsDn/YXWg==
X-Received: by 2002:a05:622a:1910:b0:2e1:ef94:63f1 with SMTP id w16-20020a05622a191000b002e1ef9463f1mr5934595qtc.360.1647605926434;
        Fri, 18 Mar 2022 05:18:46 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id d11-20020a05620a166b00b0067e380258e7sm2233823qko.73.2022.03.18.05.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:18:46 -0700 (PDT)
Date:   Fri, 18 Mar 2022 08:18:44 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
Message-ID: <YjR4pKJtbDuUcsmd@bfoster>
References: <164755205517.4194202.16256634362046237564.stgit@magnolia>
 <164755207773.4194202.7639088962184690301.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164755207773.4194202.7639088962184690301.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 02:21:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't spin in an infinite loop trying to reserve blocks -- if we can't
> do it after 30 tries, we're racing with a nearly full filesystem, so
> just give up.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_fsops.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index b71799a3acd3..4076b9004077 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -379,6 +379,7 @@ xfs_reserve_blocks(
>  	int64_t			fdblks_delta = 0;
>  	uint64_t		request;
>  	int64_t			free;
> +	unsigned int		tries;
>  	int			error = 0;
>  
>  	/* If inval is null, report current values and return */
> @@ -430,9 +431,16 @@ xfs_reserve_blocks(
>  	 * If the request is larger than the current reservation, reserve the
>  	 * blocks before we update the reserve counters. Sample m_fdblocks and
>  	 * perform a partial reservation if the request exceeds free space.
> +	 *
> +	 * The loop body estimates how many blocks it can request from fdblocks
> +	 * to stash in the reserve pool.  This is a classic TOCTOU race since
> +	 * fdblocks updates are not always coordinated via m_sb_lock.  We also
> +	 * cannot tell if @free remaining unchanged between iterations is due
> +	 * to an idle system or freed blocks being consumed immediately, so
> +	 * we'll try a finite number of times to satisfy the request.
>  	 */
>  	error = -ENOSPC;
> -	do {
> +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
>  		/*
>  		 * The reservation pool cannot take space that xfs_mod_fdblocks
>  		 * will not give us.
> @@ -462,7 +470,7 @@ xfs_reserve_blocks(
>  		spin_unlock(&mp->m_sb_lock);
>  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
>  		spin_lock(&mp->m_sb_lock);
> -	} while (error == -ENOSPC);
> +	}
>  
>  	/*
>  	 * Update the reserve counters if blocks have been successfully
> 

