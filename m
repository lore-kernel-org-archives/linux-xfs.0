Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAFFC83F01
	for <linux-xfs@archiver.kernel.org>; Thu, 31 Aug 2023 15:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244978AbjHaP2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 11:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241859AbjHaP2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2023 11:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FA0E4C
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 08:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693495658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mqLyafqQSr+xnWj5z2AjrZmROw9/VVucNrTT/jjha9c=;
        b=DQDK7Q+bUXQ4KewcD6ydb7+HsyuL6+00cRZBR+7bAGrqlVgNh8OLPOozkkWPu13AkhH4ro
        TQAa78FCPUFrlhjmCHE19l9L9wXYJ7/TQnTRcRWZIlV/tyFo0aIA/SRIUraoSCZ7r1ZeQ8
        k0NmZr6oI8pyD+KftaIEDGnT+a1vEUQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-hYclFbiQMs-FcgWRfPXxHQ-1; Thu, 31 Aug 2023 11:27:36 -0400
X-MC-Unique: hYclFbiQMs-FcgWRfPXxHQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-68a6cd7c6c0so1035737b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Aug 2023 08:27:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693495655; x=1694100455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mqLyafqQSr+xnWj5z2AjrZmROw9/VVucNrTT/jjha9c=;
        b=QxegYu8ZItqYKAPEBqw/dSTBuxte+251f7+s2q6XeV5VlWF7E1d071GOL60gnmRuZc
         /BimbbSNZog5jvPFzGduzQ8Z8+aZSrlp+9lDW18h7AtVo8qM9GOPrAl5EI74v+h5auQR
         gciuSMYz8D8HcbAmXaHB+NHVJW3txZZuPlklgn/NRLUV9Ut8RoqQWBSP5sMCuIqBWog3
         8dJSvTSW1ojww8gqXyQo6yBPmgOVtxo5Ik2M5BSpcrMslx9hlwfr/igmXSZm39j2qava
         Lb44zXHrkk3wnit8+P2SMfY9zhua0yOb5I82PHKSsHXORs2fqyCU6xbRtKpybnUDfHhk
         muxQ==
X-Gm-Message-State: AOJu0Yx0GP3e8EOlmEDgBv3r+tasJfNVXOtJs/gckdt73gH87YoJpnfM
        +4qGTUtdH5Jh0UFBB+ZMXNBRww3TiFbARIbzzFo4NoumZxhDdHcumxzlQKqXWZP6QEmCOQQEURS
        SUvnQPnb+BA9Kcxk0dlFC
X-Received: by 2002:a05:6a00:139c:b0:68c:33a9:e572 with SMTP id t28-20020a056a00139c00b0068c33a9e572mr94321pfg.29.1693495655387;
        Thu, 31 Aug 2023 08:27:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELOEDjedOa7OR0rCZRabfnf+qcHwAp0Jvx3wndeMwhLAwWpbIBt7GHp1ZCjCkIsQD8zkYjYA==
X-Received: by 2002:a05:6a00:139c:b0:68c:33a9:e572 with SMTP id t28-20020a056a00139c00b0068c33a9e572mr94308pfg.29.1693495655084;
        Thu, 31 Aug 2023 08:27:35 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g7-20020a63ad07000000b005649cee408fsm1497033pgf.0.2023.08.31.08.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 08:27:34 -0700 (PDT)
Date:   Thu, 31 Aug 2023 23:27:31 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic/650: add SOAK_DURATION controls
Message-ID: <20230831152731.wsqfdc2jvjkojcvs@zlang-mailbox>
References: <169335047228.3523635.3342369338633870707.stgit@frogsfrogsfrogs>
 <169335047798.3523635.5351250494233254529.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169335047798.3523635.5351250494233254529.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2023 at 04:07:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make this test controllable via SOAK_DURATION, for anyone who wants to
> perform a long soak test of filesystem vs. cpu hotplug.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

This makes sense to me, especially you add it to soak group:)

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/650 |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/650 b/tests/generic/650
> index 05a48ef0fd..05c939b84f 100755
> --- a/tests/generic/650
> +++ b/tests/generic/650
> @@ -8,7 +8,7 @@
>  # hotplugging to shake out bugs in the write path.
>  #
>  . ./common/preamble
> -_begin_fstest auto rw stress
> +_begin_fstest auto rw stress soak
>  
>  # Override the default cleanup function.
>  _cleanup()
> @@ -60,13 +60,18 @@ sentinel_file=$tmp.hotplug
>  touch $sentinel_file
>  exercise_cpu_hotplug &
>  
> +fsstress_args=(-w -d $stress_dir)
> +
>  # Cap the number of fsstress threads at one per hotpluggable CPU if we exceed
>  # 1024 IO threads, per maintainer request.
>  nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
>  test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
> +fsstress_args+=(-p $nr_cpus)
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
>  
>  nr_ops=$((25000 * TIME_FACTOR))
> -$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $stress_dir -n $nr_ops -p $nr_cpus >> $seqres.full
> +fsstress_args+=(-n $nr_ops)
> +$FSSTRESS_PROG $FSSTRESS_AVOID -w "${fsstress_args[@]}" >> $seqres.full
>  rm -f $sentinel_file
>  
>  # success, all done
> 

