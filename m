Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAEFC47080
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA69161090
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Jun 2021 10:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232173AbhFAKpo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 06:45:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233237AbhFAKpl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jun 2021 06:45:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622544239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RGMOZaNFoS0KESyKtm0FszxvZE3rcGAuYW9+KlLzl+8=;
        b=KDTs0Bl/MSvvFX43uHJmlFTf5b8g0/XT5KOCg7XzXmSszn2c0/nzZ4kRo1fnWDw1wpwmIj
        jOtA7Udf5PKHa5s8IqDJ7NWnH4V7Mxi/9GQ7Cp61e4PFRI+PmRhF4kB75GmUF11BgnXxqV
        DeEpPaDICrTREt4mG4HEZHBfrmF0drk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-c9oxp4I8M8uLJanOfKsJ3Q-1; Tue, 01 Jun 2021 06:43:58 -0400
X-MC-Unique: c9oxp4I8M8uLJanOfKsJ3Q-1
Received: by mail-wm1-f72.google.com with SMTP id 19-20020a05600c2313b0290193637766d9so958724wmo.7
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jun 2021 03:43:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=RGMOZaNFoS0KESyKtm0FszxvZE3rcGAuYW9+KlLzl+8=;
        b=G2hd2WRbu68kdYxKmueDMqPoqfp8gStpcGzZKAYbLJZA1A/CKOUXJvmiMgtZog9tqJ
         V7UbUH9h+gwObtRcPPdKnrn00ry5OucN4YUjlL0hcP2KTHjcm2gnCpuCLNm765etS+pp
         07/1RWStjYzzsmoBD0XLcwpIy812Z8hjsfL251aZQa/DvKhGnjOogBKaTCw82EaBuuLR
         a1ZOsDaZK+XC9rxP108k2q96edzlowU4mmCzfbc+AdPbOK9UcfbeJTY7cq6tbsVkEzBB
         VHq3H4H/9/kdf5DwPiINstMQH7rq1o5K2T8u3UI9JvHN9Cc4DpIja6U4quq1j/C0Di8H
         a4BA==
X-Gm-Message-State: AOAM533M632W4lzWwDm/rykZ9OtbZ+PJR9pWDHD5DZwXWWYcKmH4Ku6C
        PwaSzM41LLSVhK+XAjqEBuMYvjSpq9kGg+vDRZmaYzkjOjuVftGYG2O3CDjT8ouD/ZS5C+MvEti
        7JHDe44kVmh0S6hV2Jcgf
X-Received: by 2002:a05:6000:114c:: with SMTP id d12mr26644419wrx.265.1622544236879;
        Tue, 01 Jun 2021 03:43:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/vqGMH7dXO/mH1gBWFbqot5rUkfo9qTDNvUJ05D5xLNu6LF7aMIzbXOwUX4OisWHCpEMSTQ==
X-Received: by 2002:a05:6000:114c:: with SMTP id d12mr26644396wrx.265.1622544236688;
        Tue, 01 Jun 2021 03:43:56 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id x11sm2803004wru.87.2021.06.01.03.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 03:43:56 -0700 (PDT)
Date:   Tue, 1 Jun 2021 12:43:54 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/3] xfs: clean up open-coded fs block unit conversions
Message-ID: <20210601104354.rnceaf2lwgv3tyk4@omega.lan>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, hch@infradead.org
References: <162250083252.490289.17618066691063888710.stgit@locust>
 <162250084368.490289.286869347542521014.stgit@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162250084368.490289.286869347542521014.stgit@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 31, 2021 at 03:40:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Replace some open-coded fs block unit conversions with the standard
> conversion macro.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |    2 +-
>  fs/xfs/xfs_iops.c             |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index f3254a4f4cb4..04ce361688f7 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -612,7 +612,7 @@ xfs_inode_validate_extsize(
>  	 */
>  
>  	if (rt_flag)
> -		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> +		blocksize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
>  	else
>  		blocksize_bytes = mp->m_sb.sb_blocksize;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index dfe24b7f26e5..93c082db04b7 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -543,7 +543,7 @@ xfs_stat_blksize(
>  	 * always return the realtime extent size.
>  	 */
>  	if (XFS_IS_REALTIME_INODE(ip))
> -		return xfs_get_extsz_hint(ip) << mp->m_sb.sb_blocklog;
> +		return XFS_FSB_TO_B(mp, xfs_get_extsz_hint(ip));
>  
>  	/*
>  	 * Allow large block sizes to be reported to userspace programs if the
> @@ -560,7 +560,7 @@ xfs_stat_blksize(
>  	 */
>  	if (mp->m_flags & XFS_MOUNT_LARGEIO) {
>  		if (mp->m_swidth)
> -			return mp->m_swidth << mp->m_sb.sb_blocklog;
> +			return XFS_FSB_TO_B(mp, mp->m_swidth);
>  		if (mp->m_flags & XFS_MOUNT_ALLOCSIZE)
>  			return 1U << mp->m_allocsize_log;
>  	}
> 

-- 
Carlos

