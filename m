Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0675FC04A95
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 10:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiI1KFa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 06:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiI1KFF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 06:05:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA3452DC0
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664359498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YU/BGWnXlRXoh2G67W/0xPA2qhAFYYfuuFdHZ3ABn2E=;
        b=Z/+AKoXda2v4OasioYQnZ35+9zKiPgwMLncknKqyLHlvHwNUBK8jQzJ908LVGkJwn1EQiL
        hRZQTb9MVwRUa0X8wBgVLAd4iT/ZYvF3JceGR20klScnCDefj07DkX+D5ClTvPdJ6MH6kR
        41dDZavKyX15AAdWSYFp+uBiw+xVJwM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-sbk8nenUMSqmTFeZILxtxA-1; Wed, 28 Sep 2022 06:04:57 -0400
X-MC-Unique: sbk8nenUMSqmTFeZILxtxA-1
Received: by mail-qt1-f200.google.com with SMTP id g6-20020ac84b66000000b0035cf832dec9so8517132qts.6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 03:04:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=YU/BGWnXlRXoh2G67W/0xPA2qhAFYYfuuFdHZ3ABn2E=;
        b=Xnp+brLUoB9UtXrhp+1oicGABsRIbvzhBi8dobscJwCsz/UQwvBaipA6DFHzsqEPaQ
         bHDuQIZ0tOo6N/RyH7wNflOeZrz3X7yenGZfffwEot9j0UBmeUNu0hbgUvPfVmR89hFn
         Pyo6ZS09VbZHJ1Zl8Grrj4souN+FHBwqZl6d+6CbiY4n169cAAfvbvMeyFCsdkhKi3Mt
         1rWpaFW9Vec5CZjhPLABZuvObsMFEIqLfgqhV6EGfNp0B6AtIObtytZRkUQKimmzJWso
         RZziv2hpt6nGQRLqPAZhjsPHSmr3cZHhw2nRzLXtqXRJ1drINB28wteS/ruPybbYIv7e
         Hh1A==
X-Gm-Message-State: ACrzQf1CiOrp8sASv59rJ6A/klnO1MljOggUbMhYVeIJ4P/rspI+qn5j
        JNZpxquT9oXR2T1p2+A1xywc1NUi9IieOjKbgg5fcP246F+tWQ1h9dd6tTybBA026V4rAKv6CFG
        /LayVnV0JEYx5gTl6ZY1v
X-Received: by 2002:a05:622a:190b:b0:35b:b5a2:eceb with SMTP id w11-20020a05622a190b00b0035bb5a2ecebmr26024610qtc.529.1664359496827;
        Wed, 28 Sep 2022 03:04:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6IFNYBBsX8xJcYYI4IgtL0Du24e9asC2Gyz+xoOVRYcaHNrTZ2uC6q95kENOEteCuB8s61Mw==
X-Received: by 2002:a05:622a:190b:b0:35b:b5a2:eceb with SMTP id w11-20020a05622a190b00b0035bb5a2ecebmr26024596qtc.529.1664359496580;
        Wed, 28 Sep 2022 03:04:56 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q6-20020a37f706000000b006b5df4d2c81sm2590669qkj.94.2022.09.28.03.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 03:04:56 -0700 (PDT)
Date:   Wed, 28 Sep 2022 18:04:51 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] generic/092: skip test if file allocation unit isn't
 aligned
Message-ID: <20220928100451.n3fodsvfdnrffkjn@zlang-mailbox>
References: <166433903099.2008389.13181182359220271890.stgit@magnolia>
 <166433903671.2008389.15875549373880546579.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166433903671.2008389.15875549373880546579.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 27, 2022 at 09:23:56PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test exercises allocation behavior when truncating a preallocated
> file down to 5M and then up to 7M.  If those two sizes aren't aligned
> with the file allocation unit length, then the FIEMAP output will show
> blocks beyond EOF.  That will cause trouble with the golden output, so
> skip this test if that will be the case.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/092 |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> 
> diff --git a/tests/generic/092 b/tests/generic/092
> index 505e0ec84f..d7c93ca792 100755
> --- a/tests/generic/092
> +++ b/tests/generic/092
> @@ -28,6 +28,12 @@ _require_test
>  _require_xfs_io_command "falloc"
>  _require_xfs_io_command "fiemap"
>  
> +# If the truncation sizes (5M/7M) aren't aligned with the file allocation unit
> +# length, then the FIEMAP output will show blocks beyond EOF.  That will cause
> +# trouble with the golden output, so skip this test if that will be the case.
> +_require_congruent_file_oplen $TEST_DIR $((5 * 1048576))
> +_require_congruent_file_oplen $TEST_DIR $((7 * 1048576))

Make sense to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
>  # First test to make sure that truncating at i_size trims the preallocated bit
>  # past i_size
>  $XFS_IO_PROG -f -c "falloc -k 0 10M" -c "pwrite 0 5M" -c "truncate 5M"\
> 

