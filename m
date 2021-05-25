Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3316EC47085
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 18:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15EA76141C
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 18:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhEYSLh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 14:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhEYSLg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 14:11:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D67C06138A
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 11:10:05 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so2235519pjr.0
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=WoDug4+CXTtAZ7sweqscjf9FzzuoYDrpzUh3duNxd0M=;
        b=Oi4ypauTpMTlbTHsjemSt/xTEJ/+9zAG69V7Bhfz4Ayw6ClXRcKNt44XVMLGCbhqsX
         XbEbUlylWlOhH8C0b40HQ5uKQmrzfduQmKMgiYMHbzM504zzscb2JaCHcyTBnyU3etmn
         iK2tkyAGMRu6Ux85N9WS/eFtPulNm/AU3nSXJb1E594u4tROoPYT1oRbC1doBf4ZsY0Z
         Esp0o73MzIi9i5OY8+7UeNmm1mu0SrW4gyq9NOR09EUQHs/T3ZhxKLmLXCw91X/jZ/W4
         GoDWITmSMH8TEfYoZWp6aOJ6hKSuUwJDSSRal+LvcixOXl22h4cDq9MTV1HBuyEnw10V
         4/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=WoDug4+CXTtAZ7sweqscjf9FzzuoYDrpzUh3duNxd0M=;
        b=IoukTT3NJnBFVOGWlxPneZShrb9hXX6gikxgyEevbzEbRTCAIShVKhjm5uwzwmWvu8
         SdPD0OBO6Va3OnTnDtioPotjdJLD6juHUJ6kLZZKhO/qEY6Qx/+idoHmHO7wkioRIefd
         NjedhqGIK/TSraySSqn2Q0anEgVLmjtgAAHKl9mjtj4S/L9wsSO6NOoRgSCG6fyHCp9f
         KZ80T16+FjH7JXiGyEi1c41pvfRoDINNqrVPMet+eAkW4DPdHvSumz9R1FxSiNyZ3qsY
         YlerMgW3uTG58XBAExzocVsOGU+Ze57BB/bTpDBKS9oWZ+BTLlFoZy7MJtxW0DRKTD1A
         Pp8w==
X-Gm-Message-State: AOAM533d2MAT7sbJ/+heNxgmrhsp5fJlKBXNXypqekXWbEUHxJWaaCBc
        wMAP3eMNjTbtqPwXZ17TFN/zhg==
X-Google-Smtp-Source: ABdhPJwZUZIrJ4p4qUHQ1CeHU6I/SbwijQWPeFZemxrafZqwOWR1QtCnvwxuT4le2otbNgRg2XMojw==
X-Received: by 2002:a17:90a:8a07:: with SMTP id w7mr31786769pjn.192.1621966204387;
        Tue, 25 May 2021 11:10:04 -0700 (PDT)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id n30sm15154975pgd.8.2021.05.25.11.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 11:10:04 -0700 (PDT)
Date:   Tue, 25 May 2021 18:10:00 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v8 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <YK09eG0xm9dphL/1@google.com>
References: <20210121230336.1373726-1-satyat@google.com>
 <CAF2Aj3jbEnnG1-bHARSt6xF12VKttg7Bt52gV=bEQUkaspDC9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF2Aj3jbEnnG1-bHARSt6xF12VKttg7Bt52gV=bEQUkaspDC9w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 25, 2021 at 01:57:28PM +0100, Lee Jones wrote:
> On Thu, 21 Jan 2021 at 23:06, Satya Tangirala <satyat@google.com> wrote:
> 
> > This patch series adds support for direct I/O with fscrypt using
> > blk-crypto.
> >
> 
> Is there an update on this set please?
> 
> I can't seem to find any reviews or follow-up since v8 was posted back in
> January.
> 
This patchset relies on the block layer fixes patchset here
https://lore.kernel.org/linux-block/20210325212609.492188-1-satyat@google.com/
That said, I haven't been able to actively work on both the patchsets
for a while, but I'll send out updates for both patchsets over the
next week or so.
> -- 
> Lee Jones [李琼斯]
> Linaro Services Senior Technical Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
