Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8EBCC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 22:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbiK2Wni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 17:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbiK2Wne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 17:43:34 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAEA5C746
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:43:33 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q12so11044357pfn.10
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 14:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l5YE1TXhC/KTHWPoNHJrYw5l7Dfd21t1MY0wJqd1YU4=;
        b=dwzkOKV8sx0Lc9bcGYwhUDaUsX3bgXrRjI1MXPk8+7Yx+p8j0IQzpRurTUPmwyu8eQ
         s/Esn0MGuz3KhRDAbsN5gqzMbZWEtI2zph073DKpi8GRih15xCkNhR1HXuKc3naEFcSx
         GwwxSZ1K0JvI54EMIDZ/qjHPzyDi+u+HEbsm7ogSCZCjIUJDi1YlMdz2WVWwLL2LYgHF
         dhhoB+BkmOYg1vRZjqpkOWWDBFSb8sNosfOLC4wM/TCqWTxeLoHptNpBwS9OXs6RlBpn
         XMVMDQbt9UcA9+M0+Ms6Uz8KpJa3EarK2OdUf/W2jy9YLL0IvmkVtbAf/n9HUGWCPiMw
         q6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5YE1TXhC/KTHWPoNHJrYw5l7Dfd21t1MY0wJqd1YU4=;
        b=KPKeLjNEwYXV4Pt9ZNizeb+MoOPyMCWQkSL5P3So6S6T3hZol1hmeIzDBS3vAAcMZK
         PXAqBgdIeObRyZgVS1jWoymRvFym3DQ2yM2EUd2W3aZ2CBUmwK6+odCisyBKRproJj6i
         JpqshkJ5V3Kk7HUREdS40ELO5SCI/b2HW4V5uLiB1Rq8EM4p7XJa0K0jzrXRAVPruruM
         2x8VKUNypzhM9Yr/Nbs5p+teYniMAFBDPmM4l0TX2Fxl/ARYozTCi+pHVl45knHY+TLf
         TQiBIeZhP9CzjY2lUiSEO2vyfIjAhMoIWCjmbkJZgXZoImy3HHcNPGVZlOzXzLXMZ3I0
         70YQ==
X-Gm-Message-State: ANoB5pn7ukvcvFEn+ZL3ghJ+6Y6Idge5cfEh6nRjJRKpD6+R8zBdWvzv
        WwuL1drcJaLcWD9gDTLarHETTsCPWckFLw==
X-Google-Smtp-Source: AA0mqf7djbqz4x8Ri4OENImf7Yv3kCskKowX0g6JRgRe3bssRFb9WMbzP4sMhozooPsUmTigJ5SB+g==
X-Received: by 2002:a63:1a52:0:b0:464:3985:3c63 with SMTP id a18-20020a631a52000000b0046439853c63mr34215986pgm.141.1669761751281;
        Tue, 29 Nov 2022 14:42:31 -0800 (PST)
Received: from dread.disaster.area (pa49-186-65-106.pa.vic.optusnet.com.au. [49.186.65.106])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b00189a50d2a3esm445238plx.241.2022.11.29.14.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 14:42:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1p09J5-002b6F-Qm; Wed, 30 Nov 2022 09:42:27 +1100
Date:   Wed, 30 Nov 2022 09:42:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH] xfs/179: modify test to trigger refcount update bugs
Message-ID: <20221129224227.GL3600936@dread.disaster.area>
References: <166975928548.3768925.15141817742859398250.stgit@magnolia>
 <Y4aCb+y2ej1TBE/R@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4aCb+y2ej1TBE/R@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 29, 2022 at 02:06:39PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upon enabling fsdax + reflink for XFS, this test began to report
> refcount metadata corruptions after being run.  Specifically, xfs_repair
> noticed single-block refcount records that could be combined but had not
> been.
> 
> The root cause of this is improper MAXREFCOUNT edge case handling in
> xfs_refcount_merge_extents.  When we're trying to find candidates for a
> record merge, we compute the refcount of the merged record, but without
> accounting for the fact that once a record hits rc_refcount ==
> MAXREFCOUNT, it is pinned that way forever.
> 
> Adjust this test to use a sub-filesize write for one of the COW writes,
> because this is how we force the extent merge code to run.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Seems like a reasonable modification to the test....

> ---
>  tests/xfs/179 |   28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/179 b/tests/xfs/179
> index ec0cb7e5b4..214558f694 100755
> --- a/tests/xfs/179
> +++ b/tests/xfs/179
> @@ -21,17 +21,28 @@ _require_scratch_nocheck
>  _require_cp_reflink
>  _require_test_program "punch-alternating"
>  
> +_fixed_by_kernel_commit XXXXXXXXXXXX "xfs: estimate post-merge refcounts correctly"

Though I really don't like these annotation because when the test
fails in future as I'm developing new code it's going to tell me I
need a fix I already have in the kernel. This is just extra noise
that I have to filter out of the results output. IMO a comment for
this information or a line in the commit message is fine - it
just doesn't belong in the test output....

Other than that:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
