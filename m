Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B0CC83F10
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 14:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344845AbjHaOTD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 10:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232317AbjHaOTD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 10:19:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3354D1
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 07:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693491498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qafh6v0n34Khu8fe79YTlgwWBLCbN/DtxxKzvIEWTSE=;
        b=JsyKSpUKhFM9VJ/PGC6ZvHq0Wo3fUkBnnFamuuaJJUXMv/KI9HOamO8c/8hsEljsgqNwQv
        y/hCJsjOPyrbT2JyChJj+/k5Re9qbHzvUh4pVM5b/72RHbehGFNIILpGuuzpyf2jVZelI2
        xLwiAtOZACuQS/PhvdQzTOPbU8QVU2M=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-KuoM2thhNcOXyzPxzTBK4g-1; Thu, 31 Aug 2023 10:18:16 -0400
X-MC-Unique: KuoM2thhNcOXyzPxzTBK4g-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-26f3fce5b0bso883348a91.2
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 07:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693491494; x=1694096294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qafh6v0n34Khu8fe79YTlgwWBLCbN/DtxxKzvIEWTSE=;
        b=DJi8Tk4pHu6eDeto6M18P77TQrE4+9pHkTkqa+3azPKNGSaol0jvaCubS4GIBlu5Yb
         fnisQ1StVfwUT87WADzrDdknlkMavjZo/fnRtL0I6KY6RGu5RHRp5Ow+H8SDwWqSVOKY
         aJbLRGCrC3gawTk9OmlcL3avzTTGW5Za0GBQ7AwXqjQweR7MlzrrzvbjzLQWG5G8Sz11
         iArkWTnlTM9xzRvLG7tEyRbCJCh/DBVDG1xwCweV5g5On2J1UcqWGbotcI/l4VZK6Sg4
         g0iXftj3eARF74HlmdcPTotbidYlwlZQNQ71yY5m6fhYCbZevOf/mK+ha1n5gzDnJmDO
         BakQ==
X-Gm-Message-State: AOJu0YypjgqJMbO6ZXxVSlEGYZAN827065gz/lYpDINKn9PlfRTcH8MG
        CP3kCLUZe6aSdpRMxZbWnOTT2DviE4Y51p0m0i7CGx0qlECGf6FYIMrODMHeLtniTMhwtXk0BAx
        qJ1SEmfEXwmePL+wnFGKg
X-Received: by 2002:a17:90a:6be1:b0:26b:726:118 with SMTP id w88-20020a17090a6be100b0026b07260118mr4934761pjj.19.1693491494727;
        Thu, 31 Aug 2023 07:18:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXXCE89W2KbVQBsW60A0+BWgataClwxQQ0ltZVmVIsQuXIG3cMLEtwOMrmNlZrsFtnBo/uug==
X-Received: by 2002:a17:90a:6be1:b0:26b:726:118 with SMTP id w88-20020a17090a6be100b0026b07260118mr4934745pjj.19.1693491494360;
        Thu, 31 Aug 2023 07:18:14 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v7-20020a17090a898700b0026f90d7947csm1404126pjn.34.2023.08.31.07.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 07:18:13 -0700 (PDT)
Date:   Thu, 31 Aug 2023 22:18:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/61[67]: support SOAK_DURATION
Message-ID: <20230831141810.htr6wj6svvcco3yg@zlang-mailbox>
References: <169335094811.3534600.13011878728080983620.stgit@frogsfrogsfrogs>
 <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335095385.3534600.13449847282467855019.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:15:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that I've finally gotten liburing installed on my test machine, I
> can actually test io_uring.  Adapt these two tests to support
> SOAK_DURATION so I can add it to that too.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This makes sense to me, but how these two cases into "soak" group. I'd like to
add all cases which supports "SOAK_DURATION" into "soak" group at least. Then
we can do soak tests better.

Thanks,
Zorro

>  tests/generic/616 |    1 +
>  tests/generic/617 |    1 +
>  2 files changed, 2 insertions(+)
> 
> 
> diff --git a/tests/generic/616 b/tests/generic/616
> index 538b480ba7..729898fded 100755
> --- a/tests/generic/616
> +++ b/tests/generic/616
> @@ -33,6 +33,7 @@ fsx_args+=(-N $nr_ops)
>  fsx_args+=(-p $((nr_ops / 100)))
>  fsx_args+=(-o $op_sz)
>  fsx_args+=(-l $file_sz)
> +test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
>  
>  run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
>  
> diff --git a/tests/generic/617 b/tests/generic/617
> index 3bb3112e99..f0fd1feb2e 100755
> --- a/tests/generic/617
> +++ b/tests/generic/617
> @@ -39,6 +39,7 @@ fsx_args+=(-r $min_dio_sz)
>  fsx_args+=(-t $min_dio_sz)
>  fsx_args+=(-w $min_dio_sz)
>  fsx_args+=(-Z)
> +test -n "$SOAK_DURATION" && fsx_args+=(--duration="$SOAK_DURATION")
>  
>  run_fsx "${fsx_args[@]}" | sed -e '/^fsx.*/d'
>  
> 

