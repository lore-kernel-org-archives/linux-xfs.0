Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02CFC43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83483613FF
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 18:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbhD1SFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 14:05:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241704AbhD1SFC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 14:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619633057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xytN0pNzBMfuQW8ZuNkzPJq4Fe6+Yb1JTf4mTX9Mv8w=;
        b=J13fABeIJFnKn9v8qWYAXQ/0E95V5VEQOJ7Berfv+gdQ3lwNJ++Yts4wWlFPWFMJH1FHr2
        8zYVPtxXkv3ZnR+9iMkW7RDZJX/c21aVMyCChF3zrYxE4WJiWZxZifM8Oh1qymeXNuJFDr
        x4gSmvi6udJ7h4ezx0Dv/zphmN6npBs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-499-DvrXmyt3MQa4BCdv8zzH7w-1; Wed, 28 Apr 2021 14:04:15 -0400
X-MC-Unique: DvrXmyt3MQa4BCdv8zzH7w-1
Received: by mail-qv1-f72.google.com with SMTP id h12-20020a0cf44c0000b02901c0e9c3e1d0so1373589qvm.4
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 11:04:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xytN0pNzBMfuQW8ZuNkzPJq4Fe6+Yb1JTf4mTX9Mv8w=;
        b=qwzQA+vCGizXD0saMcE6DoCZ6TE2f0SVtIq4wICNyr4QWUBDBxp9axd1AcGL8ee7Je
         YALktzUQ+vvDNUZ3dUjU0PF/XPaCse8Q/u3C+4t9pWbWxCNiJmqxhNYZL6a83aMhCfJy
         q154vBGvkTCSwqs4kh0ST8Hu4ah8uFt2TNeSMnJejw6WNs6cBeJHCiFbuJ4wQpSFpo9S
         H2XHoLuxOqMvNndg5ZChrUOzP+wjSX3rXVL++ezsALzzc4ulxzVO2ZNulR/EGUD/DPn1
         LL8DfgXQBVr4rFcx0ZE8LEsThqMI122MMASKzCFCRFynVCRM5eild/ZU9cIiZGJkYUDw
         G6fA==
X-Gm-Message-State: AOAM530nyD/ZOZ2FSRRSdyiReFxes36pt9Dw1p2VYKTEI3kPxOa0WXsR
        Bqgb8q3SFeXKtCFflx+NF11gcP6YxpFBVHrpAjdsU4q+Fyb59Vc0Y2HN3c6XkkRbOhWeAjkqvJh
        GGw/Au7/7W2Rxj37LXc4+
X-Received: by 2002:a05:620a:1085:: with SMTP id g5mr30320197qkk.332.1619633054549;
        Wed, 28 Apr 2021 11:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXKeAaUkfduPBayguRu8RIZvLZLaGVhRQsgB9+TkVv9QvS5Oj6Xp8ELvgI7qvSxkpJhyTV9Q==
X-Received: by 2002:a05:620a:1085:: with SMTP id g5mr30320182qkk.332.1619633054380;
        Wed, 28 Apr 2021 11:04:14 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id k18sm328158qkg.53.2021.04.28.11.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 11:04:13 -0700 (PDT)
Date:   Wed, 28 Apr 2021 14:04:11 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/3] rc: check dax mode in _require_scratch_swapfile
Message-ID: <YImjmxAcZ9u8rvVe@bfoster>
References: <161958296906.3452499.12678290296714187590.stgit@magnolia>
 <161958298115.3452499.907986597475080875.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958298115.3452499.907986597475080875.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:09:41PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> It turns out that the mm refuses to swapon() files that don't have a
> a_ops->readpage function, because it wants to be able to read the swap
> header.  S_DAX files don't have a readpage function (though oddly both
> ext4 and xfs link to a swapfile activation function in their aops) so
> they fail.  The recent commit 725feeff changed this from a _notrun to
> _fail on xfs and ext4, so amend this not to fail on pmem test setups.
> 
> Fixes: 725feeff ("common/rc: swapon should not fail for given FS in _require_scratch_swapfile()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/rc |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/common/rc b/common/rc
> index 6752c92d..429cc24d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2490,6 +2490,10 @@ _require_scratch_swapfile()
>  	# Minimum size for mkswap is 10 pages
>  	_format_swapfile "$SCRATCH_MNT/swap" $(($(get_page_size) * 10))
>  
> +	# swapfiles cannot use cpu direct access mode (STATX_ATTR_DAX) for now
> +	statx_attr="$($XFS_IO_PROG -c 'statx -r' $SCRATCH_MNT/swap 2>/dev/null | grep 'stat.attributes = ' | awk '{print $3}')"
> +	test "$((statx_attr & 0x200000))" -gt 0 && _notrun "swapfiles not supported on DAX"
> +
>  	# ext* and xfs have supported all variants of swap files since their
>  	# introduction, so swapon should not fail.
>  	case "$FSTYP" in
> 

