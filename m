Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AAB7ECAAD5
	for <linux-xfs@archiver.kernel.org>; Sun,  4 Sep 2022 13:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiIDNSx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Sep 2022 09:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiIDNSx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Sep 2022 09:18:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE69356D0
        for <linux-xfs@vger.kernel.org>; Sun,  4 Sep 2022 06:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662297531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FfuxrJ4oWqcvzN7vx/HjjBrDrn01TeGfS8uHSMGvNvk=;
        b=SxXFPZ+xODLaeoPdmK17RIyly7inBqGmCfrUk/6Y0mmi+rna8MiOlfdotuzgf1KX3xb25d
        nAzyOyrRvsUSqJK9+2I1NF58aZyZ0aSTk4IERCUik45fm1f3Kvv4irGppDCNaPu2FTTRSa
        qE+Jw7ZYasRRCrpy6vqi2F+Ua/s7BJM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-JqRM30u_NxyCQf5ijeZD0Q-1; Sun, 04 Sep 2022 09:18:50 -0400
X-MC-Unique: JqRM30u_NxyCQf5ijeZD0Q-1
Received: by mail-qk1-f200.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso5334801qkp.21
        for <linux-xfs@vger.kernel.org>; Sun, 04 Sep 2022 06:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=FfuxrJ4oWqcvzN7vx/HjjBrDrn01TeGfS8uHSMGvNvk=;
        b=W9Px5+8c+Cj7H6aPPV1bN7FHCz1jMavKKxao2KubHzl752Lsu62mBF1kCTkULev/Dz
         kFCnS5Qi+Wrqp7OGGD12h/TdPDSUO0gb107peXMMk8dPWT8IyObC2RmZOTwQVeTdt5rf
         c4RLvb77j7/xO6xKhsuJmOj8xvXQGJyHyrdiJJAKpUKugmcfA91jtvxCP+x0bwKAe/0B
         WDW2030rduLNzEaioT/2QV3q3OlhN1fB4WtgiOPP/NKlmk8M+klaUK+bSNULMXCiWoZg
         /G6OqXymDvohzfOW5vI4tDV+nClsVagHjxbdqrkn6gpT62x5qd0bMnWtgrXWhRl2SDi4
         rdAA==
X-Gm-Message-State: ACgBeo0SQTtPIAoPwynecOWORRLol6hmGTUVL5h30L6H1UgffX1d0Qz1
        kC8sQwgim8n/uCfmACefIpR2OLXnrJeuQiygaCzkFAWXXHeQUofxxtNCQxHSMnlVXGo93EU8Bx1
        uKt2KmCZ3kPEKiEQci3DI
X-Received: by 2002:ac8:5a83:0:b0:343:11f:a781 with SMTP id c3-20020ac85a83000000b00343011fa781mr35646723qtc.19.1662297529635;
        Sun, 04 Sep 2022 06:18:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7yW72RLqIs/eFRNsMSCVxL5Vwx5Il3R9HM8+6EBL+pVUueQ2hPSSEPU/C398OfY0WYLb1YPQ==
X-Received: by 2002:ac8:5a83:0:b0:343:11f:a781 with SMTP id c3-20020ac85a83000000b00343011fa781mr35646713qtc.19.1662297529414;
        Sun, 04 Sep 2022 06:18:49 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s6-20020a05620a29c600b006bbda80595asm6230445qkp.5.2022.09.04.06.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Sep 2022 06:18:48 -0700 (PDT)
Date:   Sun, 4 Sep 2022 21:18:44 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v2 0/3] fstests: fix some hangs in crash recovery
Message-ID: <20220904131844.yacyz3j4lxbocrr7@zlang-mailbox>
References: <165950054404.199222.5615656337332007333.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165950054404.199222.5615656337332007333.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 02, 2022 at 09:22:24PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> There are several tests in fstests (generic/019, generic/388,
> generic/475, xfs/057, etc.) that test filesystem crash recovery by
> starting a loop that kicks off a filesystem exerciser, waits a few
> seconds, and offlines the filesystem somehow.  Some of them use the
> block layer's error injector, some use dm-error, and some use the
> shutdown ioctl.
> 
> The crash tests that employ error injection have the unfortunate trait
> of causing occasional livelocks when tested against XFS because XFS
> allows administrators to configure the filesystem to retry some failed
> writes indefinitely.  If the offlining races with a full log trying to
> update the filesystem, the fs will hang forever.  Fix this by allowing
> XFS to go offline immediately.
> 
> While we're at it, fix the dmesg scrapers so they don't trip over XFS
> reporting these IO errors as internal errors.
> 
> v2: add hch reviews
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

I'd like to merge this patchset, after long time testing, it looks like not
bring in regression. It's stuck long time, let's keep moving :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-shutdown-test-hangs
> ---
>  check                    |    1 +
>  common/dmerror           |    4 ++++
>  common/fail_make_request |    1 +
>  common/rc                |   50 +++++++++++++++++++++++++++++++++++++++++-----
>  common/xfs               |   38 ++++++++++++++++++++++++++++++++++-
>  tests/xfs/006.out        |    6 +++---
>  tests/xfs/264.out        |   12 ++++++-----
>  7 files changed, 97 insertions(+), 15 deletions(-)
> 

