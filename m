Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1072C4320A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 09:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAE9C60462
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Sep 2021 09:04:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbhIAJFI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 05:05:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241783AbhIAJFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 05:05:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630487050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cfro/hBm/nzGtPoQ51nc+mDpagE/EAoScu7Kx0RLdkw=;
        b=f8t1vLKOIn8wCpALbZ8BLmyUteSuCHPn2B+7eFdCkoxIN0ZQT2hqr04vcy8O8p5+hUFjFE
        Um7GNKoL5kTLoRVyYvWF6Hqjwce5FsvjFosmLbZ0PFiKn4J2yT/nMuDaUPEIhyqfPy0kgH
        uFFUoGdf+UWnm1WAZd4yA8qxEb0SiT8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-2qCosKf5NxKZD9EHDWyJiA-1; Wed, 01 Sep 2021 05:04:09 -0400
X-MC-Unique: 2qCosKf5NxKZD9EHDWyJiA-1
Received: by mail-pl1-f199.google.com with SMTP id l9-20020a170902f68900b00138fe47307eso667570plg.10
        for <linux-xfs@vger.kernel.org>; Wed, 01 Sep 2021 02:04:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=Cfro/hBm/nzGtPoQ51nc+mDpagE/EAoScu7Kx0RLdkw=;
        b=iiUB6WQJ2U32t4tZFoS9QKoGEN4CTG6JnSKOz5sKwxYzpb0NI2mig/FE1DyOQKKIlR
         PRBbaJtW/JS7rvf/6flNJmQ03STrlmOLGKOFZUSLl/78j9mUd3BqMuyZm9qNxzSPrpnB
         T+nLTJHH2u/OFGiqduRC1U1+AIGiWfEboDxYZFIeU73E9GdMhYW0ONNUHthUFh7DehN8
         Pcwb6vSMg9d8LF5/QolfrkkKbIMHGsRdWnI4fX0Zo5HpgVJwoqnR+LJSgYvAfDp9UAZU
         pkzmtK0lD6ctF5zEqV9SJOrkfA74BjZHZbXZuWzqOsXugjDW9CSbWwZJ4xvbFSfJDr52
         h/vg==
X-Gm-Message-State: AOAM532AdzK43WoMlRl/f9bA6A8Qgk1gS70pnm4VnjbIKw6gr5BiBTAe
        ibD7DTogdS8y7jtxBhdD4nuCy/tj82asZ6thkJuIK8wn4fB89wcMs4vVj4PEUGlN462bMW5un2c
        qzNACQbDrkpwzHu1m0Mwq
X-Received: by 2002:a17:902:6f01:b0:138:9aca:efda with SMTP id w1-20020a1709026f0100b001389acaefdamr8813455plk.19.1630487048297;
        Wed, 01 Sep 2021 02:04:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxzFVz4Sazd29bWpLJydqUW/UDChS3QQJK9ORalPU5IQqOGo6gVTCXUFT3YTqrhujfpAIImg==
X-Received: by 2002:a17:902:6f01:b0:138:9aca:efda with SMTP id w1-20020a1709026f0100b001389acaefdamr8813427plk.19.1630487048019;
        Wed, 01 Sep 2021 02:04:08 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 17sm17289840pfp.28.2021.09.01.02.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 02:04:07 -0700 (PDT)
Date:   Wed, 1 Sep 2021 17:24:52 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] common/xfs: skip xfs_check unless the test runner
 forces us to
Message-ID: <20210901092452.mqg5nq37fgkraaij@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <163045507051.769821.5924414818977330640.stgit@magnolia>
 <163045507618.769821.3650550873572768945.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163045507618.769821.3650550873572768945.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 31, 2021 at 05:11:16PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> At long last I've completed my quest to ensure that every corruption
> found by xfs_check can also be found by xfs_repair.  Since xfs_check
> uses more memory than repair and has long been obsolete, let's stop
> running it automatically from _check_xfs_filesystem unless the test
> runner makes us do it.
> 
> Tests that explicitly want xfs_check can call it via _scratch_xfs_check
> or _xfs_check; that part doesn't go away.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  README     |    4 ++++
>  common/xfs |   12 ++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/README b/README
> index 84c217ce..63f0641a 100644
> --- a/README
> +++ b/README
> @@ -125,6 +125,10 @@ Preparing system for tests:
>  	       time we should try a patient module remove. The default is 50
>  	       seconds. Set this to "forever" and we'll wait forever until the
>  	       module is gone.
> +             - Set FORCE_XFS_CHECK_PROG=yes to have _check_xfs_filesystem run
> +               xfs_check to check the filesystem.  As of August 2021,
> +               xfs_repair finds all filesystem corruptions found by xfs_check,
> +               and more, which means that xfs_check is no longer run by default.
>  
>          - or add a case to the switch in common/config assigning
>            these variables based on the hostname of your test
> diff --git a/common/xfs b/common/xfs
> index c5e39427..bfb1bf1e 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -595,10 +595,14 @@ _check_xfs_filesystem()
>  		ok=0
>  	fi
>  
> -	# xfs_check runs out of memory on large files, so even providing the test
> -	# option (-t) to avoid indexing the free space trees doesn't make it pass on
> -	# large filesystems. Avoid it.
> -	if [ "$LARGE_SCRATCH_DEV" != yes ]; then
> +	# xfs_check runs out of memory on large files, so even providing the
> +	# test option (-t) to avoid indexing the free space trees doesn't make
> +	# it pass on large filesystems. Avoid it.
> +	#
> +	# As of August 2021, xfs_repair completely supersedes xfs_check's
> +	# ability to find corruptions, so we no longer run xfs_check unless
> +	# forced to run it.

I have to say I've waited for this change long time :-D

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +	if [ "$LARGE_SCRATCH_DEV" != yes ] && [ "$FORCE_XFS_CHECK_PROG" = "yes" ]; then
>  		_xfs_check $extra_log_options $device 2>&1 > $tmp.fs_check
>  	fi
>  	if [ -s $tmp.fs_check ]; then
> 

