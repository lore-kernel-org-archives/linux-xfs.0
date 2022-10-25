Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87AE4C38A2D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 22:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiJYWFy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 18:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJYWFx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 18:05:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B1F5FC3E
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:05:47 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id g24so7194862plq.3
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 15:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEy869ASQZgjqx6gi72WhLahxG9+EY9yegy6YkAdDU0=;
        b=dk6Ze1xo3weUBHraHZfsj3uLbdQV7/2ZeelGnT/+33Qggj7IobGyxaqE/A+GU6jZxD
         p1HPS+8zb8iJTlYKoOchKLb+V+uG1pCBm9NaD63mCLGO9qLi0Neu4V3QPrDbd49Irjjw
         cx6uQB/DQsygJYgxzAyIr/ErqyRU/yLoDgsPZjlo0DkB9ELhCigz1a09q9RzxxDs5pLd
         5t91U+HC2MFMLIPFfnDUJ/3RIRnWkwUg8FjJZyn1wQNXFJmarahVy4ob8htFJQE2L9pR
         BTwGqy6aF4j4+GAS5ZyUrNpreVO+aSCIpbSwyd0wsBsQ02YpdO5FUdGfRc6cIXluTZwz
         zidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cEy869ASQZgjqx6gi72WhLahxG9+EY9yegy6YkAdDU0=;
        b=zV0xvQ1l7PmIa3yRPneoShgs0UmgPnJGr2c6MEn+cYuvHFUOE9mqpc7Irh1BikUCFl
         6ujEk2uezl6DarB4yjrujRaHcfLO9mz/z8HoZ9UOGWAnjeBEAGBGMAGRUgmD7Wjb/aaC
         pYJe4n0WGByTTw5I6c0dxFjNQqwUSwzOFYlalRi34oTjbPih4lGhcz0QQAmGm/FPDmHa
         Om1ceCsv+c5UG9xs1DGorFdBLID2iwRcF63sWVbrXy8x8a51M5v0UuWvqZCZStItren6
         SDd/T+YsGeeECAV1PRR/WqnwrjRw2jlysxhG5tn+4JEBMc83ZL0kmMJ58R9MdT338JDu
         tyoA==
X-Gm-Message-State: ACrzQf17k1EnthfP4R45yDAukfwMTcZDaJUr1AWbCmQQE6t3zrRC1gwL
        qBAToLFyZ747xLV9+r9WG5yUM6I0K1Perw==
X-Google-Smtp-Source: AMsMyM6cpVV0cmmWoqpXyR9NgMvVzuHuab1j4rTJgWFCtJF0zE8EsOx0XJvSZAIgSjRGl6saldLxnQ==
X-Received: by 2002:a17:902:bd8e:b0:178:25ab:56cc with SMTP id q14-20020a170902bd8e00b0017825ab56ccmr40054344pls.86.1666735547303;
        Tue, 25 Oct 2022 15:05:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id k18-20020aa79732000000b0056bf29c9ba3sm1907285pfg.146.2022.10.25.15.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 15:05:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onS3L-006Ndd-F6; Wed, 26 Oct 2022 09:05:43 +1100
Date:   Wed, 26 Oct 2022 09:05:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: refactor all the EFI/EFD log item sizeof logic
Message-ID: <20221025220543.GG3600936@dread.disaster.area>
References: <166664715160.2688790.16712973829093762327.stgit@magnolia>
 <166664718541.2688790.5847203715269286943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664718541.2688790.5847203715269286943.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Refactor all the open-coded sizeof logic for EFI/EFD log item and log
> format structures into common helper functions whose names reflect the
> struct names.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_log_format.h |   48 ++++++++++++++++++++++++++++
>  fs/xfs/xfs_extfree_item.c      |   69 ++++++++++++----------------------------
>  fs/xfs/xfs_extfree_item.h      |   16 +++++++++
>  fs/xfs/xfs_super.c             |   12 ++-----
>  4 files changed, 88 insertions(+), 57 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 2f41fa8477c9..f13e0809dc63 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -616,6 +616,14 @@ typedef struct xfs_efi_log_format {
>  	xfs_extent_t		efi_extents[];	/* array of extents to free */
>  } xfs_efi_log_format_t;
>  
> +static inline size_t
> +xfs_efi_log_format_sizeof(
> +	unsigned int		nr)
> +{
> +	return sizeof(struct xfs_efi_log_format) +
> +			nr * sizeof(struct xfs_extent);
> +}

FWIW, I'm not really a fan of placing inline code in the on-disk
format definition headers because combining code and type
definitions eventually leads to dependency hell.

I'm going to say it's OK for these functions to be placed here
because they have no external dependencies and are directly related
to the on-disk structures, but I think we need to be careful about
how much code we include into this header as opposed to the type
specific header files (such as fs/xfs/xfs_extfree_item.h)...

> @@ -345,9 +318,8 @@ xfs_trans_get_efd(
>  	ASSERT(nextents > 0);
>  
>  	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
> -		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
> -				nextents * sizeof(struct xfs_extent),
> -				0);
> +		efdp = kmem_zalloc(xfs_efd_log_item_sizeof(nextents),
> +				GFP_KERNEL | __GFP_NOFAIL);

That looks like a broken kmem->kmalloc conversion. Did you mean to
convert this to allocation to use kzalloc() at the same time?

Everything else looks ok, so with the above fixed up

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
