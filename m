Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAA2C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 30 May 2022 13:36:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237597AbiE3Ngw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 30 May 2022 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiE3NgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 09:36:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D09109808E
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 06:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653917379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UDptAJl+uYFvCcxDFXfRmIlTNa3Yuv5SuAtq+XPxlPQ=;
        b=RD/tLobwiZKWpHlYSMpuwZGytdqDjuNlFionSZkYvgXv6zDgLI1pinCTRCwFeIzLKRMcCN
        GNCrcAMCIkganBwPK1h46w3f4Ie20cNC6yW4fxy+0GeckWzS64v9WZieJyIvn3Y37ZU7aG
        i6CrkmOwKXr4SeL0G03Hqbo8et/GO34=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-wUkNP76pMfuingy8Wl2hsg-1; Mon, 30 May 2022 09:29:38 -0400
X-MC-Unique: wUkNP76pMfuingy8Wl2hsg-1
Received: by mail-oi1-f199.google.com with SMTP id t206-20020aca5fd7000000b0032b53f108d3so3627661oib.5
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 06:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UDptAJl+uYFvCcxDFXfRmIlTNa3Yuv5SuAtq+XPxlPQ=;
        b=Wz95IIXnNsTwa4JJ+Z4WFv7ek64WndJ1kQpeaSVn0ttlJV9CQ+m6uDuWjaI8TFGR5A
         3IDdTvMuJBi0F18CoShBqvu3Y5GJlhJC5NwyVh8BXjxGDh2bCeVcdd7UJt6cvfUEG0//
         erFvTSbWxzPbJ0LuN2mPYKQyrn43PBjkSBrTw3yj8dENtfQYcNgELEH8VFgH6zVgosas
         qyJTUVEIPsuauFzsKtDcEWjLc/ZiXRxGA1dJQNTpIh/av/oWmme2Rh3/CnnvfdmCLbM/
         aD+CJShZQt+9ul2i7UMQMq5I4Lud/9e8ILCmst2XAnAk/+A+L+vzyQ4I4QPXenl7wxzP
         46Nw==
X-Gm-Message-State: AOAM5303L0neZO5CHGAw6KyUs+vCXeHYKNZCiXeRZWTbPmIVM/18Osub
        aH//jXcvepb0tDsx3zTdiaB3LZk5fpy7VyFFXVIe36gnYXBPWHJ5SvUAzgmrkwxllQgKJg/TRxy
        l9zH5pKT7RHAX/9699uTl
X-Received: by 2002:a05:6870:5702:b0:e2:9f03:dae1 with SMTP id k2-20020a056870570200b000e29f03dae1mr10659470oap.201.1653917377259;
        Mon, 30 May 2022 06:29:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwu/pXp4Z/Fvwc6wmxSd2IqK9Sx9IckVuTGZzO0QIetDq4O92xLhfJDslUVrt1C9DQHDNi3OQ==
X-Received: by 2002:a05:6870:5702:b0:e2:9f03:dae1 with SMTP id k2-20020a056870570200b000e29f03dae1mr10659455oap.201.1653917376984;
        Mon, 30 May 2022 06:29:36 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id cv18-20020a056870c69200b000e686d13883sm3519997oab.29.2022.05.30.06.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 06:29:36 -0700 (PDT)
Date:   Mon, 30 May 2022 21:29:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/623: fix test for runing on overlayfs
Message-ID: <20220530132930.hbvehsbu3nppq6y7@zlang-mailbox>
References: <20220530112905.79602-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530112905.79602-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 30, 2022 at 02:29:05PM +0300, Amir Goldstein wrote:
> For this test to run on overlayfs we open a different file to perform
> shutdown+fsync while keeping the writeback target file open.
> 
> We should probably perform fsync on the writeback target file, but
> the bug is reproduced on xfs and overlayfs+xfs also as is.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> I tested that this test passes for both xfs and overlayfs+xfs on v5.18
> and tested that both configs fail with the same warning on v5.10.109.
> 
> I tried changing fsync to syncfs for the test to be more correct in the
> overlayfs case, but then golden output of xfs and overlayfs+xfs differ
> and that would need some more output filtering (or disregarding output
> completely).
> 
> Since this minimal change does the job and does not change test behavior
> on xfs on any of the tested kernels, I thought it might be good enough.
> 
> Thanks,
> Amir.
> 
>  tests/generic/623 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/623 b/tests/generic/623
> index ea016d91..bb36ad25 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -24,10 +24,13 @@ _scratch_mount
>  # XFS had a regression where it failed to check shutdown status in the fault
>  # path. This produced an iomap warning because writeback failure clears Uptodate
>  # status on the page.
> +# For this test to run on overlayfs we open a different file to perform
> +# shutdown+fsync while keeping the writeback target file open.
>  file=$SCRATCH_MNT/file
>  $XFS_IO_PROG -fc "pwrite 0 4k" -c fsync $file | _filter_xfs_io
>  ulimit -c 0
> -$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" -c shutdown -c fsync \
> +$XFS_IO_PROG -x -c "mmap 0 4k" -c "mwrite 0 4k" \
> +	-c "open $(_scratch_shutdown_handle)" -c shutdown -c fsync \

Did you try to reproduce the original bug which this test case covers?

According to the "man xfs_io":

       open [[ -acdfrstRTPL ] path ]
              Closes the current file, and opens the file specified by path instead. Without any arguments, displays statistics about the current file - see the stat command.

Although I doubt if it always real close the current file, but you open to get
a new file descriptor, later operations will base on new fd. I don't know if
it still has original testing coverage.

I'd like to help this case to support overlay, presuppose original fs
testing isn't changed. Or it's not worth.

Welcome more review points from the author of this case and others.

Thanks,
Zorro

>  	-c "mwrite 0 4k" $file | _filter_xfs_io
>  
>  # success, all done
> -- 
> 2.25.1
> 

