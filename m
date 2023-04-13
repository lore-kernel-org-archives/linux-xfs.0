Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2CDC77B6C
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 10:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjDMKuj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 06:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjDMKu3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 06:50:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A3640C5
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681382922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCjKz28znp3whWGJmpFa21Qw61yr8yAyaMLtFqKLF8c=;
        b=ffyLoCDbMD+rxa2J1mynduA6IjbBJkwlxdSn0WxF4LKwPEuBjCM+HDe8/+tX9GWRkEmaWz
        rli7manrdaAYAbsdYlZMpg24xD8Vjgsy8N2L2fSsjH3N+TeVlJ/bHAi/v24CNrufMP6eP4
        TNbuTxINnApHpVPXKi5zOVvn9JqCebM=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-lupBdlrfPFCUq2RbItJqVw-1; Thu, 13 Apr 2023 06:48:41 -0400
X-MC-Unique: lupBdlrfPFCUq2RbItJqVw-1
Received: by mail-qt1-f197.google.com with SMTP id l20-20020a05622a051400b003e6d92a606bso6056789qtx.14
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 03:48:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681382920; x=1683974920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QCjKz28znp3whWGJmpFa21Qw61yr8yAyaMLtFqKLF8c=;
        b=N1U1AM1R45gvjg0D0qdFB3BYsub1eK76b4hsrONLCggmh9368k6Tb2awejuCkZ1ZuX
         yaixeydjNSYLV5vPvn0rhkumTN10BILeMELKypUGIdavTO4UwhMRmDD5U7586ou8osqg
         gFoAPmZhAqrsPqcLwAZ2O9uZOlSqczmiPwpmJXAVN00ZPYQyul3ZsPSi6+4DVIpXV5Hl
         Fv3+g7ApFXHplXjXbK6etSrnO5GrhXBDNuvkV7tCW02+ihADZczbgA+PQ3OyOr6eKlck
         deONgZ3XCuHevNUDAMjAlc9BVWM65NVP6YZIAlHta/+EGzCvMeMviUsalHytrH6LSODr
         Rm/w==
X-Gm-Message-State: AAQBX9fncjLBqM1k+fWAQXrshw9Ef4h+1G1pet/0T4oXLJh8ZUipIHDH
        iP1OQZiMr7BL3yDFy5QN8uPKOnILQOJNdSpMg8L1DvOmFEjjdhaC5j6alaLfkfIpMVFpiDNcw8s
        IhQ64+fwA0u05jVFtUUlUeS+jywI=
X-Received: by 2002:a05:6214:2428:b0:5eb:fc42:ea4f with SMTP id gy8-20020a056214242800b005ebfc42ea4fmr2522413qvb.33.1681382920477;
        Thu, 13 Apr 2023 03:48:40 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/0X2cgxMgcgiwkOwSefEVjVqYxP5Mr9WGWqlrWNaizFo94pzi0GeTQTZhRfI3BFATUkdwsw==
X-Received: by 2002:a05:6214:2428:b0:5eb:fc42:ea4f with SMTP id gy8-20020a056214242800b005ebfc42ea4fmr2522400qvb.33.1681382920125;
        Thu, 13 Apr 2023 03:48:40 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id j20-20020a05620a289400b0074a0051fcd4sm372299qkp.88.2023.04.13.03.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 03:48:39 -0700 (PDT)
Date:   Thu, 13 Apr 2023 12:48:36 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET 0/3] fstests: direct specification of looping test
 duration
Message-ID: <20230413104836.zw2uoe4mhocs3afz@aalbersh.remote.csb>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 11, 2023 at 11:13:46AM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> One of the things that I do as a maintainer is to designate a handful of
> VMs to run fstests for unusually long periods of time.  This practice I
> call long term soak testing.  There are actually three separate fleets
> for this -- one runs alongside the nightly builds, one runs alongside
> weekly rebases, and the last one runs stable releases.
> 
> My interactions with all three fleets is pretty much the same -- load
> current builds of software, and try to run the exerciser tests for a
> duration of time -- 12 hours, 6.5 days, 30 days, etc.  TIME_FACTOR does
> not work well for this usage model, because it is difficult to guess
> the correct time factor given that the VMs are hetergeneous and the IO
> completion rate is not perfectly predictable.
> 
> Worse yet, if you want to run (say) all the recoveryloop tests on one VM
> (because recoveryloop is prone to crashing), it's impossible to set a
> TIME_FACTOR so that each loop test gets equal runtime.  That can be
> hacked around with config sections, but that doesn't solve the first
> problem.
> 
> This series introduces a new configuration variable, SOAK_DURATION, that
> allows test runners to control directly various long soak and looping
> recovery tests.  This is intended to be an alternative to TIME_FACTOR,
> since that variable usually adjusts operation counts, which are
> proportional to runtime but otherwise not a direct measure of time.
> 
> With this override in place, I can configure the long soak fleet to run
> for exactly as long as I want them to, and they actually hit the time
> budget targets.  The recoveryloop fleet now divides looping-test time
> equally among the four that are in that group so that they all get ~3
> hours of coverage every night.
> 
> There are more tests that could use this than I actually modified here,
> but I've done enough to show this off as a proof of concept.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=soak-duration
> ---
>  check                 |   14 +++++++++
>  common/config         |    7 ++++
>  common/fuzzy          |    7 ++++
>  common/rc             |   34 +++++++++++++++++++++
>  common/report         |    1 +
>  ltp/fsstress.c        |   78 +++++++++++++++++++++++++++++++++++++++++++++++--
>  ltp/fsx.c             |   50 +++++++++++++++++++++++++++++++
>  src/soak_duration.awk |   23 ++++++++++++++
>  tests/generic/019     |    1 +
>  tests/generic/388     |    2 +
>  tests/generic/475     |    2 +
>  tests/generic/476     |    7 +++-
>  tests/generic/482     |    5 +++
>  tests/generic/521     |    1 +
>  tests/generic/522     |    1 +
>  tests/generic/642     |    1 +
>  tests/generic/648     |    8 +++--
>  17 files changed, 229 insertions(+), 13 deletions(-)
>  create mode 100644 src/soak_duration.awk
> 

The set looks good to me (the second commit has different var name,
but fine by me)
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

