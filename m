Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1897DC07E96
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5ECB61CE0
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Jul 2021 07:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhGHHWn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Jul 2021 03:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28293 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhGHHWn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Jul 2021 03:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625728801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EJW8UqY+1pdZ6xsvvsWand6PI/dK8kooHDV9STQXsSg=;
        b=LZTZxI1glExqAXJKwBQEsQDztm1y750+nWpSAYdvflgCg6iy6Mtkb+KvRD4RzpaiOnC17h
        1OfG7N9VKEweXo2k7CiHZnuaJfAIt68NRDgYkYZCDSFuCcRqeZYHa58XIKvBtYWsFpsg1S
        5DtBjpU4lZ/doEcdbo3MTXY+0TmyocQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-7SPbHtegPWuBiR_G-qmGdw-1; Thu, 08 Jul 2021 03:20:00 -0400
X-MC-Unique: 7SPbHtegPWuBiR_G-qmGdw-1
Received: by mail-ej1-f69.google.com with SMTP id ia10-20020a170907a06ab02904baf8000951so1405265ejc.10
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jul 2021 00:20:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=EJW8UqY+1pdZ6xsvvsWand6PI/dK8kooHDV9STQXsSg=;
        b=ZmJZcKjjVb4d9gJ1mFzwWSLndnKFN5afeO+TKJ8DMDpk2pGy/eXWExy7u3D12wg5eP
         bVZvYZi0ffx3n6gSYzGMfpjBumV5Xfg/pgrWckeHmeqUGPnkM/Op46oHhxeZLF7cDQrq
         EhfmCKcWUym9s0LMnQF0mcLBMWO3XPYhh2ucHJT3KT/HzpNNXZNTEb/SCeZWwYyMfNub
         vpkXvYrLHGd1e+173XEY41t7sdRl8cFFpJUeVYEH7mmZbnlcL+pvAS769d6tsQCe5k98
         t0SvpGSHsn0mZPwiUDh1wfr3u0VeINuJK4jVikkIciBUuNsyA9vbNY5WZ/OsZjDZw9rU
         rLLQ==
X-Gm-Message-State: AOAM533cyWf9BP8VSkN3rnksGqGCX+vJ3Zm0p03IReR96+OieutXLMJw
        A4pyRyFyn7vT8PmhpujBY6ZfLrtfBpqYVXjmRtYl1NG+FG1+q3X8dY+7tEz/9j1L3mVuRaFeRH8
        /jj9pbJJ8E3/cQ1B40HOJ
X-Received: by 2002:a17:907:3f06:: with SMTP id hq6mr27136935ejc.130.1625728799227;
        Thu, 08 Jul 2021 00:19:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4ybSVt2zgp49Z4vq9sUcrkqUaYFGisDTP1rxoV5UhPgNTd2wlhnorOAIEn6DNXOj8cQxppA==
X-Received: by 2002:a17:907:3f06:: with SMTP id hq6mr27136911ejc.130.1625728798973;
        Thu, 08 Jul 2021 00:19:58 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id d13sm736086eds.56.2021.07.08.00.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 00:19:58 -0700 (PDT)
Date:   Thu, 8 Jul 2021 09:19:56 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 2/2] mkfs: validate rt extent size hint when rtinherit is
 set
Message-ID: <20210708071956.zgchk7v5zxp4rsps@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com,
        hch@infradead.org
References: <162528106460.36302.18265535074182102487.stgit@locust>
 <162528107571.36302.10688550571764503068.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162528107571.36302.10688550571764503068.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 07:57:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Extent size hints exist to nudge the behavior of the file data block
> allocator towards trying to make aligned allocations.  Therefore, it
> doesn't make sense to allow a hint that isn't a multiple of the
> fundamental allocation unit for a given file.
> 
> This means that if the sysadmin is formatting with rtinherit set on the
> root dir, validate_extsize_hint needs to check the hint value on a
> simulated realtime file to make sure that it's correct.  Unfortunately,
> the gate check here was for a nonzero rt extent size, which is wrong
> since we never format with rtextsize==0.  This leads to absurd failures
> such as:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> # mkfs.xfs -f /dev/sdf -r extsize=7b -d rtinherit=0,extszinherit=13
> illegal extent size hint 13, must be less than 649088 and a multiple of 7.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mkfs/xfs_mkfs.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index f84a42f9..9c14c04e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2384,10 +2384,11 @@ _("illegal extent size hint %lld, must be less than %u.\n"),
>  	}
>  
>  	/*
> -	 * Now we do it again with a realtime file so that we know the hint and
> -	 * flag that get passed on to realtime files will be correct.
> +	 * If the value is to be passed on to realtime files, revalidate with
> +	 * a realtime file so that we know the hint and flag that get passed on
> +	 * to realtime files will be correct.
>  	 */
> -	if (mp->m_sb.sb_rextsize == 0)
> +	if (!(cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT))
>  		return;
>  
>  	flags = XFS_DIFLAG_REALTIME;
> 

-- 
Carlos

