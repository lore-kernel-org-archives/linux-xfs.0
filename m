Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36640EB64DD
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Aug 2023 09:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjHEJxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Aug 2023 05:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjHEJxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2023 05:53:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4914495
        for <linux-xfs@vger.kernel.org>; Sat,  5 Aug 2023 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691229161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jstZIoU+QqWoO1kxNlk2x1JDdHCq7hZS17gYR9lfuW8=;
        b=YnRnMWP3nex0TMXL1Xi2CgNdrb44AsO333F5r7eFW6xOybUfPDKxuZWVoyTvuseVz+H5wk
        SMLkYoXh0Bc3KxxWRtIbCxz5PsmQSYo0iCyNZ1GoCnVbaCJzFfYGrnllzzt3pNjr+5Kfeq
        oCVwZu95APj8lyi5Vk3XoxxIxhaX9aE=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-xVyWuf4COiS201GqZ3RHlA-1; Sat, 05 Aug 2023 05:52:39 -0400
X-MC-Unique: xVyWuf4COiS201GqZ3RHlA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-56c877bb4a9so4367643eaf.2
        for <linux-xfs@vger.kernel.org>; Sat, 05 Aug 2023 02:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691229159; x=1691833959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jstZIoU+QqWoO1kxNlk2x1JDdHCq7hZS17gYR9lfuW8=;
        b=MtgcDTXjsZKQlvGw8VYSvHWQhYPSmjABHkTcmnctUixIjlANrYaFqdXX90cDsqt02C
         VFdv4Ru79eRA4i5DiiIiQrxw2LJSF8fl8Ct2Q+K2+C8MpDhVsTh+9ZJhhnFRodieew0X
         iG/1iEcnZ4ytCPiFkyunDPNu8axMZGdeHclG8hw+JMgrAoNKP0QfMFIxTxkyBkGJAAGZ
         uWtwwN1OXbJMDX1KYVrOt/1FDYUK82arAA0wbNrTsEd7A+KVzCB7yKhPu2p1ob+26UdO
         tQEHIYDaIDyehrUmzS8ZtOMLeNZtbc6CFoTKU0LAYYXTXmpifk3ivrN2hF1EgVvnV7cz
         /tVA==
X-Gm-Message-State: AOJu0Yyd4GqgjFXnAVYB4hgs/Qep97XwZuOGCze4Dmf8loFAlIEUpvf/
        qvNSP/dYyUe0qCQ/NUxN1qDByPFs120md6BaGumdCyzhrp5J2BYhQNk+Xpb4cdQsvbdBeqR82hX
        CIw2iHmWL0CLWtPf3NXIk10uFGoEY19W83A==
X-Received: by 2002:a05:6358:419f:b0:135:6d9:2399 with SMTP id w31-20020a056358419f00b0013506d92399mr5557400rwc.30.1691229158914;
        Sat, 05 Aug 2023 02:52:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHrcz4EKPKdaG61eCIGrmm8gyZzwmfR0kjyB9iC0bPWq/4xj8mfWVW8aZcqqs0Uv9H0m8/BbA==
X-Received: by 2002:a05:6358:419f:b0:135:6d9:2399 with SMTP id w31-20020a056358419f00b0013506d92399mr5557381rwc.30.1691229158566;
        Sat, 05 Aug 2023 02:52:38 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ff17-20020a056a002f5100b006875493da20sm2842831pfb.3.2023.08.05.02.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Aug 2023 02:52:38 -0700 (PDT)
Date:   Sat, 5 Aug 2023 17:52:35 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic/642: fix SOAK_DURATION usage in generic/642
Message-ID: <20230805095235.ywdb63aebejeyjhq@zlang-mailbox>
References: <20230804211748.GN11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230804211748.GN11340@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 02:17:48PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Misspelled variable name.  Yay bash.
> 
> Fixes: 3e85dd4fe4 ("misc: add duration for long soak tests")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Quick fix, will merge it in the release this week, Thanks!

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/642 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/generic/642 b/tests/generic/642
> index e6a475a8b5..4d0c41fd5d 100755
> --- a/tests/generic/642
> +++ b/tests/generic/642
> @@ -49,7 +49,7 @@ for verb in attr_remove removefattr; do
>  done
>  args+=('-f' "setfattr=20")
>  args+=('-f' "attr_set=60")	# sets larger xattrs
> -test -n "$DURATION" && args+=(--duration="$DURATION")
> +test -n "$SOAK_DURATION" && args+=(--duration="$SOAK_DURATION")
>  
>  $FSSTRESS_PROG "${args[@]}" $FSSTRESS_AVOID -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
>  
> 

