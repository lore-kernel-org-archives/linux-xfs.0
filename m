Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF327CCA47B
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 14:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiGEO25 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 10:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbiGEO2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 10:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13EAA25C0
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 07:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657031330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZCvkKDJOgRfLIl7bd3bpIzsajWcpXauVFm37vGIc+PY=;
        b=CKw8DktShyNtfp6eWyP2jjuuuZiOk7FPeZBi19YNWlpIpYRI8qTFSp8QRRhz55S4wrhlX3
        2x5l293QEnhumMXJwbZ/9E2iQqlJRThocjOAIbvn1od5MFxeAu41XcWZuzGiUbgtCkBmJF
        4q/ZcNfkisjYeit7N2D/YHwX+QWre2g=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-jsEqVKS7OqqHfz4F8EsbWw-1; Tue, 05 Jul 2022 10:28:47 -0400
X-MC-Unique: jsEqVKS7OqqHfz4F8EsbWw-1
Received: by mail-qt1-f199.google.com with SMTP id fw9-20020a05622a4a8900b0031e7a2ed350so4166598qtb.0
        for <linux-xfs@vger.kernel.org>; Tue, 05 Jul 2022 07:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZCvkKDJOgRfLIl7bd3bpIzsajWcpXauVFm37vGIc+PY=;
        b=sDCTk+NuoTqhdnV2AhkZRixI1mE6mLsgMRBHPPZ0LYY1vqojlStbDuTn5EMwKrrmlm
         a0wK2YmUcqGrwtlaGviTtN7oMh87z/P7yJY9HxCRUzoVX70vu7VRPMr1Gh1F4tTXWeom
         mEAfjys2XOKBXbAnfRZ+AB8jvoIdM3ClTX5xog4OfBKPNTGmdx7+tkVLwW+9SV/6uxbD
         GGxnduwKxRti/hyw5SIWyE0ObQZy71L1zGccgchso7Gz16ll/EDyx1nQSuA+JgS76/mb
         b+YzOe7tGu20zyinIp4N3Qu2JdY3m4cPmo8R8rHbDBhGfJn1HHP9/AZxNz2/A4ja3RL/
         LnTA==
X-Gm-Message-State: AJIora8AdEaqKKDgeqOmhHa8UeZx+lrNxjN6H2ny3RVpipHeaTgXGLnQ
        Ku0KfODrU4E8BF0IcnVEbx40VyMrANLF/9uBci10poGmKpb4Wcc718t9LaU8k1eKPC31HJO5DhP
        OR+2Z1fEOEAKaLtNUXsYI
X-Received: by 2002:a05:620a:459f:b0:6b1:f5c1:6e61 with SMTP id bp31-20020a05620a459f00b006b1f5c16e61mr20666847qkb.436.1657031327507;
        Tue, 05 Jul 2022 07:28:47 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sEfJR17IrV9JLR3EjeCvAXCsIQGw4I9dqG2ZDovK1prOtub+0eMHlK4y+0/G8w/F+cbKnFPA==
X-Received: by 2002:a05:620a:459f:b0:6b1:f5c1:6e61 with SMTP id bp31-20020a05620a459f00b006b1f5c16e61mr20666822qkb.436.1657031327196;
        Tue, 05 Jul 2022 07:28:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87a84000000b00307cac53129sm22056880qtr.42.2022.07.05.07.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:28:46 -0700 (PDT)
Date:   Tue, 5 Jul 2022 22:28:40 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/9] fstests: random fixes
Message-ID: <20220705142840.gycwt264xrda3bkr@zlang-mailbox>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 28, 2022 at 01:21:17PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Here's the usual batch of odd fixes for fstests.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

Hi Darrick,

JFYI, to push the proceeding of your patch merging, I've merged/pushed this
patchset, except patch 7/9 and 9/9 due to they haven't gotten any review.
I can review them, but patch 7/9 changes the case which Dave might care about,
so I'd like to wait more response.

Feel free to send these 2 patches with more your new patches, if you'd like to
do that :)

Thanks,
Zorro

> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
> ---
>  check                  |    3 +++
>  common/repair          |    1 +
>  src/seek_sanity_test.c |   12 ++++++++++-
>  tests/xfs/018          |   52 +++++++++++++++++++++++++++++++++++++++++++-----
>  tests/xfs/018.out      |   16 ++++-----------
>  tests/xfs/109          |    2 +-
>  tests/xfs/166          |   19 ++++++++++++++----
>  tests/xfs/547          |   14 +++++++++----
>  tests/xfs/843          |   51 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/843.out      |    2 ++
>  tests/xfs/844          |   33 ++++++++++++++++++++++++++++++
>  tests/xfs/844.out      |    3 +++
>  12 files changed, 181 insertions(+), 27 deletions(-)
>  create mode 100755 tests/xfs/843
>  create mode 100644 tests/xfs/843.out
>  create mode 100755 tests/xfs/844
>  create mode 100644 tests/xfs/844.out
> 

