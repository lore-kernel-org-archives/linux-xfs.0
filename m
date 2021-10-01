Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC927C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 00:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA5860F4B
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Oct 2021 00:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbhJAAeJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Sep 2021 20:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhJAAeJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Sep 2021 20:34:09 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E99C06176A;
        Thu, 30 Sep 2021 17:32:26 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id p1so394679pfh.8;
        Thu, 30 Sep 2021 17:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vRDg5mQIB7ZkRlTt9NHHXUKd/NnUUj/ZwFb8QTzm2pI=;
        b=bVJ8x1hle3yHhKqyWoKwJ3VcAW/gT80m7vhzFvyOjM8fckvgo7EtgtoXYh0LYECRtx
         x9HYLQ2ypdrc2jiZGQCWTygaz8irpkRTEFgFMyOV/4PUjl4/P7apjH9XwD/BMMeomWqo
         gvrki6VUbm/aRILs1MHssWnNcb+XyUXysP0kL05mCwHg65etyITmdfsHsqpySQXpPEpV
         r4w9VV14xID2uMAjB779Yqkl3DL5IVMKANlED6FAlerFy6Nt+jhf/3oj/vSDACjf5BW6
         dI1lAWiIjo15hBZJAsJ0HJj/Ak8zDDbiWDC1qf809rch1+n38MNBw0uLWCm6eQJ1QfLs
         QprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vRDg5mQIB7ZkRlTt9NHHXUKd/NnUUj/ZwFb8QTzm2pI=;
        b=q0AoGmbtvBDQTLhZW+OQgI3wtHbYMd2n6eKQE56D12zV3rtkPiSJPJP5TvQMn4Nky3
         Tod5EV2Dy6nivFKTgXzC2T8177WBaEcMQXcqDxUNCKoJiweegsGQnnFMRBzhyyzYhFlK
         PjlZ4lsmMEEPgpIYpr+lr8dsolkpEw8pZzfZkPrC+34tGld+fpTp32FLS+5c/WInsCGE
         Hk9BAMrIx4dnNL1lwrXALlIsqcKCmmocOlqlwgtTaWazmT+btr/vMQ35a+frUHLIGJb0
         sfNf/IcY45uZBJL6bElhu2zoTG0Qy0iKPaiKyKWusCOI4Ws3hFAj9hQPUzgtshJV2lmG
         HHcA==
X-Gm-Message-State: AOAM533a8cH8gdJBRFmgsvz1VOluNhTTW2d5HGFZ4AmPncDPZ73X+tU2
        I6M5s2s1zFz23xUf9fyWt0Y=
X-Google-Smtp-Source: ABdhPJxM3nEsrkN+aXCGrXCmJM/MXQAksNTANwWDDOf+rFJW7wsqTSUAkUT9ZtASzSq2NXweULIYlA==
X-Received: by 2002:a65:6554:: with SMTP id a20mr7313562pgw.107.1633048345725;
        Thu, 30 Sep 2021 17:32:25 -0700 (PDT)
Received: from nuc10 (d50-92-229-34.bchsia.telus.net. [50.92.229.34])
        by smtp.gmail.com with ESMTPSA id b142sm4271980pfb.17.2021.09.30.17.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 17:32:25 -0700 (PDT)
Date:   Thu, 30 Sep 2021 17:32:23 -0700
From:   Rustam Kovhaev <rkovhaev@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>,
        Dave Chinner <david@fromorbit.com>
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Message-ID: <YVZXF3mbaW+Pe+Ji@nuc10>
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz>
 <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 30, 2021 at 11:10:10PM +0200, Vlastimil Babka wrote:
> On 9/30/21 8:48 PM, Rustam Kovhaev wrote:
> > On Thu, Sep 30, 2021 at 10:13:40AM +0200, Vlastimil Babka wrote:
> >>
> >> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
> >> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
> >> two together last 5 years anyway.
> > 
> > +1 for adding Kconfig option, it seems like some things are not meant to
> > be together.
> 
> But if we patch SLOB, we won't need it.

OK, so we consider XFS on SLOB a supported configuration that might be
used and should be tested.
I'll look into maybe adding a config with CONFIG_SLOB and CONFIG_XFS_FS
to syzbot.

It seems that we need to patch SLOB anyway, because any other code can
hit the very same issue.

> >> Maybe we could also just add the 4 bytes to all SLOB objects, declare
> >> kfree() is always fine and be done with it. Yes, it will make SLOB footprint
> >> somewhat less tiny, but even whan we added kmalloc power of two alignment
> >> guarantees, the impact on SLOB was negligible.
> > 
> > I'll send a patch to add a 4-byte header for kmem_cache_alloc()
> > allocations.
> 
> Thanks. Please report in the changelog slab usage from /proc/meminfo
> before and after patch (at least a snapshot after a full boot).

OK.

