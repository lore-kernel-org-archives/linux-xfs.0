Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEBD7C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 17:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiFFRm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 13:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiFFRm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 13:42:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9B6317179
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 10:42:55 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so13136329pjt.4
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 10:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mjf1ioIsO1gM3eJxhXnjKQH66MOn46Rpxg/nM5p4JWA=;
        b=TM9wjFA4hltgqrC2R/HBL9essAOQwJozlET7nLzd1aygG5uaM6yhPfsGJ72Cnpw4KT
         lDlieM9yWwrf7UsfAbl2CtDreAiDa/iCPl8REI9Nm8o4/LmrgON8ziw6c+Wcrk3ZLLZx
         fwDUUdQRVc9bdUQ4kZJih2d4IHtEvhw9G0nGUsg54xqzeQ4EiyA8Ufal7GhyjFz0ulOV
         PsxYmw7+6GEscdnv2NX2RBon38W/bCw3qpVx0B8mN67meH8qHfNWobfyil5qbbR4yoW+
         nI2K5ebG0WibVNDW2K/1OQsWm5s2316rc13jIFhRISDM5XbCzAe1kJUEcVFX5qBQS+sj
         e4Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mjf1ioIsO1gM3eJxhXnjKQH66MOn46Rpxg/nM5p4JWA=;
        b=LePcrSS3c1fTXa2wOMbc1/u7BewPfQHrOaiu36g1ACvalbSV3kyOxEAUBfR0xr1ALJ
         f+gvA315AVqVqqaS+IUSZlhCwMDCjO9YXNw70yzixs0AcUbeg3vIOK6vIabAhMO78JAj
         CPVLHd2WaAacrqI3dSi+xlLRH7gjHKrpId1dBUjSC7yOf3i9IzuM2skL1dInEquUnc8d
         Y9xVoECAUvuHbFcbRFJ5mIOI1177FbU1EBXYTK4ZBOeW+p2Bx6vJ9RdncmDJsfduIMGc
         IOe6lmGsQV6tkL99QjHHwppaaDrpyr65tYxAXLrl8tLqJLs+bhheDwQcBWnKq11OyzZK
         EI0Q==
X-Gm-Message-State: AOAM533wu7TvDO9WGOWY57Pw732BV9tMBjNJf6yHiE2ICDabbXSZY7j9
        dxS98qxwqjpbJ6nvsRHItMo=
X-Google-Smtp-Source: ABdhPJwi2VuN1Gg4BSFcu0Uu7ajJe7V/IA9BLu3dKdizZa9M4SKNBTxfVMd1KMr68AIWpz0Bjptysg==
X-Received: by 2002:a17:90b:3c6:b0:1e2:e9fc:4e79 with SMTP id go6-20020a17090b03c600b001e2e9fc4e79mr47650472pjb.192.1654537375101;
        Mon, 06 Jun 2022 10:42:55 -0700 (PDT)
Received: from google.com ([2620:0:1001:7810:60d:5ebb:8c17:f634])
        by smtp.gmail.com with ESMTPSA id x15-20020a17090a1f8f00b001cd4989fed4sm12810992pja.32.2022.06.06.10.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 10:42:54 -0700 (PDT)
Date:   Mon, 6 Jun 2022 10:42:52 -0700
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 5.15 00/15] xfs stable candidate patches for 5.15.y
Message-ID: <Yp48nGoE0cbdbteU@google.com>
References: <20220603184701.3117780-1-leah.rumancik@gmail.com>
 <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjzq1BQeO3-BkzLVKi8=95ohVU-UHJhR_zWZze5O_G=gA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 04, 2022 at 11:38:35AM +0300, Amir Goldstein wrote:
> On Sat, Jun 4, 2022 at 6:53 AM Leah Rumancik <leah.rumancik@gmail.com> wrote:
> >
> > From: Leah Rumancik <lrumancik@google.com>
> >
> > This first round of patches aims to take care of the easy cases - patches
> > with the Fixes tag that apply cleanly. I have ~30 more patches identified
> > which will be tested next, thanks everyone for the various suggestions
> > for tracking down more bug fixes. No regressions were seen during
> > testing when running fstests 3 times per config with the following configs:
> 
> Hi Leah!
> 
> I'll let the xfs developers comment on the individual patches.
> General comments about stable process and collaboration.
> 
> Some of the patches in this series are relevant to 5.10 and even apply
> cleanly to 5.10 (see below).
> They are in my queue but I did not get to test them thoroughly yet,
> because I am working chronologically.
> 
> To avoid misunderstanding with stable maintainers, when you post to
> stable, please make sure to state clearly in the cover letter that those
> patches have only been tested on 5.15.y and should only be applied
> to 5.15.y.
> I know you have 5.15 in subject, but I would rather be safe than sorry.

Fair concern, will do.

> 
> Luis has advised me to post up to 10 patches in each round.
> The rationale is that after we test and patches are applied to stable
> regressions may be detected and reported by downstream users.
> 
> Regressions will be easier to bisect if there are less fixes in every
> LTS release. For this reason, I am holding on to my part 2 patches
> until 5.10.120 is released. LTS releases are usually on weekly basis
> so the delay is not much.
> 
> I don't think that this series is terribly big, so I am fine with you
> posting it at one go, but please consider splitting it pre 5.16
> and post 5.16 or any other way that you see fit when you post
> to stable, but let's wait for xfs developers review - if they tell you to
> drop a few patches my comment will become moot ;-)
> 

Sure, that is no problem for me, I'll go ahead and split into sets of 10
or fewer.

Thanks for the comments!
Leah
