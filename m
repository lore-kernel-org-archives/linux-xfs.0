Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D779FCA0FE4
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Sep 2023 15:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234677AbjIAPpu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbjIAPpt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2023 11:45:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094A5AC
        for <linux-xfs@vger.kernel.org>; Fri,  1 Sep 2023 08:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693583107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b7XbrD8tGCXtvHoxqcZU7UP0/DK8Ou+8tHuvT5PdzIc=;
        b=VAlTUAOu0zuTSuUD842YP/isQAoJ+as/0DejrpXzCUowKlvSzbbiifXvsf2m5RnJMs66H5
        yQGcQ5Cz+Zwnq/Fw+8BM8gNcGc5ThuQXh3MaMo9BFiq0BcMFgGWAr0/O85xByxGmMo3/XY
        VvUolMCXdI0ptNpM60vIPLthRS/xrb0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-468-d6rlvub2N_aFiqlKeuYXuA-1; Fri, 01 Sep 2023 11:45:05 -0400
X-MC-Unique: d6rlvub2N_aFiqlKeuYXuA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-27183f4cc79so2463902a91.0
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2023 08:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693583104; x=1694187904;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7XbrD8tGCXtvHoxqcZU7UP0/DK8Ou+8tHuvT5PdzIc=;
        b=NNdY9pXK8o+CoLcYeOu6totSZOCXU36H4iMTrnwb7lQgP2kK0mB0mDweX0F/EEuH+8
         HBoa1tCJscs1unaPavHMJqW4JsRP9dNV9y/dX/QJ/1aju/ToJxnplWckMrO6s9P3BJWY
         zL9wvM91JHk0wpiDEafhGf5sAa+XYGCbyBzydO7K9OBllYkqzPaRT76FPYrfBoGWyFcN
         9M8cfZP3GlEWJvBCCzg/4cD+LV+u3nZ3SDHcNf8iuTOKCuiiaRK5vIRS9R4jKQEG+NtM
         FgVbIvPRv0GursXS/b2eQ7eHPZNEPSG4fqsK4frfKCP9ynEcoBXstz1VCld6KN7cgYwH
         VoWQ==
X-Gm-Message-State: AOJu0YxAluMVFLL9l+z3373OYo+a9TWVut1Lys/nqdczoUmNpUpnFoBW
        8Js8AgDZlt/aGFYz244GyEviRwpsel975SrVq9dtq/gmrCGXXaaxh8LsFf/1R/Avw9m5fl+orlA
        qfr5OOKSe8zg0sfabuuF9ptd5H1f/T+gtfg==
X-Received: by 2002:a17:90a:6649:b0:259:10a8:2389 with SMTP id f9-20020a17090a664900b0025910a82389mr2421055pjm.35.1693583104256;
        Fri, 01 Sep 2023 08:45:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwy2w4BVdve0afH794Zr0zj/YRLJ5XM1fM83AAHAZyvWHGGEbZEtK+07wjGJK2/F1p1ELiWw==
X-Received: by 2002:a17:90a:6649:b0:259:10a8:2389 with SMTP id f9-20020a17090a664900b0025910a82389mr2421044pjm.35.1693583103952;
        Fri, 01 Sep 2023 08:45:03 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id i10-20020a17090a2a0a00b002694fee879csm5122185pjd.36.2023.09.01.08.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 08:45:03 -0700 (PDT)
Date:   Fri, 1 Sep 2023 23:45:00 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/2] generic/61[67]: support SOAK_DURATION
Message-ID: <20230901154500.4mv37y4uafbzjy7n@zlang-mailbox>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
 <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
 <20230901145331.GP28186@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230901145331.GP28186@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 01, 2023 at 07:53:31AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that I've finally gotten liburing installed on my test machine, I
> can actually test io_uring.  Adapt these two tests to support
> SOAK_DURATION so I can add it to that too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: add to soak group
> ---

Thanks! This version looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/616 |    3 ++-
>  tests/generic/617 |    3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/616 b/tests/generic/616
> index 538b480ba7..5b0b02c5e4 100755
> --- a/tests/generic/616
> +++ b/tests/generic/616
> @@ -8,7 +8,7 @@
>  # fsx ops to limit the testing time to be an auto group test.
>  #
>  . ./common/preamble
> -_begin_fstest auto rw io_uring stress
> +_begin_fstest auto rw io_uring stress soak
>  
>  # Import common functions.
>  . ./common/filter
> @@ -33,6 +33,7 @@ fsx_args+=(-N $nr_ops)
>  fsx_args+=(-p $((nr_ops / 100)))
>  fsx_args+=(-o $op_sz)
>  fsx_args+=(-l $file_sz)
> +test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
>  
>  run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
>  
> diff --git a/tests/generic/617 b/tests/generic/617
> index 3bb3112e99..a977870023 100755
> --- a/tests/generic/617
> +++ b/tests/generic/617
> @@ -8,7 +8,7 @@
>  # fsx ops to limit the testing time to be an auto group test.
>  #
>  . ./common/preamble
> -_begin_fstest auto rw io_uring stress
> +_begin_fstest auto rw io_uring stress soak
>  
>  # Import common functions.
>  . ./common/filter
> @@ -39,6 +39,7 @@ fsx_args+=(-r $min_dio_sz)
>  fsx_args+=(-t $min_dio_sz)
>  fsx_args+=(-w $min_dio_sz)
>  fsx_args+=(-Z)
> +test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
>  
>  run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
>  
> 

