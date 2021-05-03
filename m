Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56652C433B4
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 11:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AE7761175
	for <linux-xfs@archiver.kernel.org>; Mon,  3 May 2021 11:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbhECLRo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 May 2021 07:17:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54839 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhECLRk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 May 2021 07:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620040607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4dPMykIYgoLlgQ2aS5U+UWiWk0ExDtyPtBR2+9pqFk8=;
        b=RZq//dLvW1SookAcrS5nLCjxxpQIcxeMeoFtdvvKb/DW1IcSsmKRz2ie0MB+ZVwV7sqRFV
        WVf1WWG6qJKnMX1uCrd886ODTqSPDse297GRIe2ZOBpilEFFg/+BWmJwveJFlHoD8R2ZKS
        u/BtiXl+cqvi8Vk0VZs9FQC3Xx21EmA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-g6CsVoHqOKS211s3M_kRtw-1; Mon, 03 May 2021 07:16:45 -0400
X-MC-Unique: g6CsVoHqOKS211s3M_kRtw-1
Received: by mail-qv1-f72.google.com with SMTP id h88-20020a0c82610000b02901b70a2884e8so4549145qva.20
        for <linux-xfs@vger.kernel.org>; Mon, 03 May 2021 04:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4dPMykIYgoLlgQ2aS5U+UWiWk0ExDtyPtBR2+9pqFk8=;
        b=gAnsp5LBS0NllYEzc7dGMiFdYaKpz8XofOg4PiaRA5RY3JKLt8fBdB3b/sXjfeAEfX
         mCQwVL7MyLMOffHBU1UUtjunf0wIf1hnxw7H0AjucuFQXpMMCuLlP1+myqxT/bLS5Tc0
         Oo9cdxnU445sjjMCmzgdiNxXvjPnj10d7uPGgr95Gc7jdX9wPTWvZ73DSUy1u4Z4D2+i
         4ZwS8/vPghvzLZpub7Q3+C9J6YvBdtoAXK7myB7sZ9zoVZy06Q7FRILzHM/4mSQa1TdM
         u6neGpsFHk6Ui9a0yaRt6zbdzujkvhM/gZ6591e4lUQzwz7KYKYNE5e53cHp4bsqy04B
         +beA==
X-Gm-Message-State: AOAM533kYPWiWpkV/9hjxip4FnrJAyfO6oJC3LkRzMqqaQLL8ajmBqDk
        TP00hQNF02F7wb+Cw8S/8l3wrP+j8gz27r/Rf9DOmGxeAbU0N9mJBNrrj5KVAdIhJxMKhuX4OPl
        qc923JYL3BFLKW6XXLc85
X-Received: by 2002:ac8:7648:: with SMTP id i8mr1073950qtr.305.1620040604749;
        Mon, 03 May 2021 04:16:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyUwgh84n2sF/mTF00qoqKa0MddRmI8XL/I1lpiAieVR3NTGewQJ0Cq3mPvmsiBfEppDyqeKw==
X-Received: by 2002:ac8:7648:: with SMTP id i8mr1073926qtr.305.1620040604407;
        Mon, 03 May 2021 04:16:44 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id n16sm8269271qtl.48.2021.05.03.04.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 04:16:43 -0700 (PDT)
Date:   Mon, 3 May 2021 07:16:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] mkfs: reject cowextsize after making final decision
 about reflink support
Message-ID: <YI/bmYUyDfFLCWwY@bfoster>
References: <20210501060745.GA7448@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210501060745.GA7448@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Apr 30, 2021 at 11:07:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> There's a snippet of code that rejects cowextsize option if reflink is
> disabled.  This really ought to be /after/ the last place where we can
> turn off reflink.  Fix it so that people don't see stuff like this:
> 
> $ mkfs.xfs -r rtdev=b.img a.img -f -d cowextsize=16
> illegal CoW extent size hint 16, must be less than 9600.
> 
> (reflink isn't supported when realtime is enabled)
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  mkfs/xfs_mkfs.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0eac5336..f84a42f9 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2164,13 +2164,6 @@ _("inode btree counters not supported without finobt support\n"));
>  		cli->sb_feat.inobtcnt = false;
>  	}
>  
> -	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
> -	    !cli->sb_feat.reflink) {
> -		fprintf(stderr,
> -_("cowextsize not supported without reflink support\n"));
> -		usage();
> -	}
> -
>  	if (cli->xi->rtname) {
>  		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
>  			fprintf(stderr,
> @@ -2187,6 +2180,13 @@ _("rmapbt not supported with realtime devices\n"));
>  		cli->sb_feat.rmapbt = false;
>  	}
>  
> +	if ((cli->fsx.fsx_xflags & FS_XFLAG_COWEXTSIZE) &&
> +	    !cli->sb_feat.reflink) {
> +		fprintf(stderr,
> +_("cowextsize not supported without reflink support\n"));
> +		usage();
> +	}
> +
>  	/*
>  	 * Copy features across to config structure now.
>  	 */
> 

