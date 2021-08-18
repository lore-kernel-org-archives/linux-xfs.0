Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF118C4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 03:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CBD560FA0
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 03:42:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHRDnC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 23:43:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236297AbhHRDnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Aug 2021 23:43:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629258147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pulQhynLIgsr2BBXIbhajFK9QNg+0OFrhUOO6RhNRVc=;
        b=YtvGQt8brd6puLjFK1q1FOKEhidhoKG/r/MDXNWe558HlYY3oE2Z65HnxMHaU/Fb242AHl
        nThG/vpiiObaubxHq/y9dLYs3Xwf7xvpjniZ5+D+0riQVVW8vgNWWTNGnmE+a2+fWZoFpG
        wXavw1Rdx4LOcw/d8bsz8A1R5d2qXxk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-zHkdILmdMTmzgp4-DuGNsg-1; Tue, 17 Aug 2021 23:42:24 -0400
X-MC-Unique: zHkdILmdMTmzgp4-DuGNsg-1
Received: by mail-pj1-f70.google.com with SMTP id nn1-20020a17090b38c100b0017941ed86c2so4082118pjb.6
        for <linux-xfs@vger.kernel.org>; Tue, 17 Aug 2021 20:42:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=pulQhynLIgsr2BBXIbhajFK9QNg+0OFrhUOO6RhNRVc=;
        b=LHbW7ss6X4osVSIaedoeAEpF58nq1h71LMVeoY4fBVGMxG1g50qe4Ohsg0y9V4OGfm
         3mToQJDhm1b5OZrrCVaV6Ij91sFMrHy0NXbR0zRObCfRQPZlJWq0OFCHCrfwEw/ivzWz
         XWihvZmmsLlylM2ntnEnj9ljC4YqHuBsBRD2QlQy10j8+fP0fv36epZV0DApMWEK1fGE
         gPf1bNNQGDBKrZuKl5P2JtLIkIXVhtQ+jb8SjL4gdFz1cqpOdh27Hcb7cfc7SBs56gc5
         NRddYX1okIKLneSP1LTHEsw2jCYELXCDhlTvsWzBzN4o600NFRoaSloGxDu1rkUOh63A
         Re7Q==
X-Gm-Message-State: AOAM531qTqGCazQe+q4mAI/mKXe5yHvo4TpPgHk9Q9ErH9Yg5cavdqM0
        oBVziRcF7oW8x8B+dWOaFua9ABUlPoKiUetJto0a1MK1JmrQbvIOnEmJlp31xhuMw9ZMWo2A5PT
        yUioYGtk/CqC3x1y29nT1
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr7076035pjk.236.1629258143439;
        Tue, 17 Aug 2021 20:42:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHIbkYbYlcDBhOXtrGUTi/iSDkvm6jQfB4am/HTJUpGsFvdHfaF6wGHHXq2yk36ZDuv9NUQA==
X-Received: by 2002:a17:90a:7185:: with SMTP id i5mr7076019pjk.236.1629258143137;
        Tue, 17 Aug 2021 20:42:23 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k12sm313056pjg.6.2021.08.17.20.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 20:42:22 -0700 (PDT)
Date:   Wed, 18 Aug 2021 11:55:04 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] scsi_debug: fix module removal loop
Message-ID: <20210818035504.eafll6xmmvgscg63@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <162924437987.779373.1973564511078951065.stgit@magnolia>
 <162924439095.779373.7171773658755331729.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162924439095.779373.7171773658755331729.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 17, 2021 at 04:53:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Luis' recent patch changing the "sleep 1" to a "udevadm settle"
> invocation exposed some race conditions in _put_scsi_debug_dev that
> caused regressions in generic/108 on my machine.  Looking at tracing
> data, it looks like the udisks daemon will try to open the device at
> some point after the filesystem unmounts; if this coincides with the
> final 'rmmod scsi_debug', the test fails.
> 
> Examining the function, it is odd to me that the loop condition is
> predicated only on whether or not modprobe /thinks/ it can remove the
> module.  Why not actually try (twice) actually to remove the module,
> and then complain if a third attempt fails?
> 
> Also switch the final removal attempt to modprobe -r, since it returns
> zero if the module isn't loaded.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/scsi_debug |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/common/scsi_debug b/common/scsi_debug
> index e7988469..abaf6798 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -49,9 +49,9 @@ _put_scsi_debug_dev()
>  	# use redirection not -q option of modprobe here, because -q of old
>  	# modprobe is only quiet when the module is not found, not when the
>  	# module is in use.
> -	while [ $n -ge 0 ] && ! modprobe -nr scsi_debug >/dev/null 2>&1; do
> +	while [ $n -ge 0 ] && ! modprobe -r scsi_debug >/dev/null 2>&1; do
>  		$UDEV_SETTLE_PROG
>  		n=$((n-1))
>  	done
> -	rmmod scsi_debug || _fail "Could not remove scsi_debug module"
> +	modprobe -r scsi_debug || _fail "Could not remove scsi_debug module"

Make sense, I don't understand why we need "dry-run" modprobe at here either.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  }
> 

