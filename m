Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0542C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Apr 2022 18:32:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344735AbiDZSf4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 14:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDZSf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 14:35:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B478145055
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 11:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650997966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CGm5dniIEq2btOOTC3WDh+FAus5xJ5xjO75zt3KEYU8=;
        b=a3E4wgsdvUeX5n1XzVUStr1uxMrTUft3pnP9LAK6ZqMyQ+ZIJ2eEmcSYGUdmjEsChkLxXv
        z5p8w6a6DHWIGoJf9sqv4pWQSaHBZutJ4agrDT6mFb7WlBMozuq3+A+OcQ+3vLZswnWqsg
        Ru4QFsQIq6AVvzeO+Ovn+7FVik26xL0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-392-m9IBNYAyPE6sjSB2Dsy8dw-1; Tue, 26 Apr 2022 14:32:45 -0400
X-MC-Unique: m9IBNYAyPE6sjSB2Dsy8dw-1
Received: by mail-qv1-f69.google.com with SMTP id g10-20020a0562141cca00b00456332167ffso6325434qvd.13
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 11:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CGm5dniIEq2btOOTC3WDh+FAus5xJ5xjO75zt3KEYU8=;
        b=5Cy8WIXKUiS3hJ9yiP3BcEC2k210texuMpBnQLOxqHxrWaoUI3hh3Mwh1ilhXji5R4
         e6zXtiHAh3jhCbjoDDN0vQdUDpJQ+9uke4gl3mkVixC1SMmwIi9DMh73ihswGBrkSmYm
         GXvPULUa5LrzXegQA+ycqsLSMIb8oMUD7i/s+U67zPsm/JesgOetlVpRWqSAaB8EzkZR
         upwafX1g/8YIneuB56hDg7yviucDJ4/UeE9+wC08f1KBv9K51saZZOTcSuZIZ/hUGMvc
         X2pAnKRVeyq1tpC340i+LJeGi1kqfxhIBJW6jOcTGen3OHtYE2fPFVKd62rjJyUZjraS
         u0yQ==
X-Gm-Message-State: AOAM530WA5hXfxpKExqutghI8WqeK/JB5njEWPxvtlTAL8k1pPsd8oD6
        xICf3wmYo0NxmTh4f/ZGkpBJAAgA0X0RQWe+Ow8SHLWDe7pn7LsNZX2LQZV5oDS7Mqxm22md/I7
        puZfX3S0Tu+RLg2Dfbr5k
X-Received: by 2002:a05:620a:44c6:b0:69f:5a67:fee3 with SMTP id y6-20020a05620a44c600b0069f5a67fee3mr6786920qkp.476.1650997964885;
        Tue, 26 Apr 2022 11:32:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzeay718dO2fahGMB5MJjlWdZ4FzuvyRlrqTjVeBpp56qVa++FbcDBK6PmDgHRFLvc4jjrebg==
X-Received: by 2002:a05:620a:44c6:b0:69f:5a67:fee3 with SMTP id y6-20020a05620a44c600b0069f5a67fee3mr6786906qkp.476.1650997964668;
        Tue, 26 Apr 2022 11:32:44 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id 15-20020ac8594f000000b002f200ea2518sm8263344qtz.59.2022.04.26.11.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 11:32:44 -0700 (PDT)
Date:   Tue, 26 Apr 2022 14:32:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v1 0/2] xfs: remove quota warning limits
Message-ID: <Ymg6yvbrE//70InS@bfoster>
References: <20220421165815.87837-1-catherine.hoang@oracle.com>
 <43e8df67-5916-5f4a-ce85-8521729acbb2@sandeen.net>
 <20220425222140.GI1544202@dread.disaster.area>
 <20220426024331.GR17025@magnolia>
 <Ymf+k9EA2bY/af4Y@bfoster>
 <20220426145347.GV17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426145347.GV17025@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 26, 2022 at 07:53:47AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 26, 2022 at 10:15:47AM -0400, Brian Foster wrote:
> > On Mon, Apr 25, 2022 at 07:43:31PM -0700, Darrick J. Wong wrote:
> > ...
> > > 
> > > The biggest problem right now is that the pagecache is broken in 5.18
> > > and apparently I'm the only person who can trigger this.  It's the same
> > > problem willy and I have been working on since -rc1 (where the
> > > filemap/iomap debug asserts trip on generic/068 and generic/475) that's
> > > documented on the fsdevel list.  Unfortunately, I don't have much time
> > > to work on this, because as team lead:
> > > 
> > 
> > I seem to be able to reproduce this fairly reliably with generic/068.
> > I've started a bisect if it's of any use...
> 
> Thank you!  Matthew has hinted that he suspects this is a case of the
> page cache returning the wrong folio in certain cases, but neither of us
> have been able to narrow it down to a specific commit, or even a range.
> 

So my first stab at a bisect...

git bisect start 'fs' 'mm' 'include/'
...
# good: [65722ff6181aa52c3d5b0929004af22a3a63e148] drm/amdkfd: CRIU export dmabuf handles for GTT BOs
git bisect good 65722ff6181aa52c3d5b0929004af22a3a63e148
# good: [89695196f0ba78a17453f9616355f2ca6b293402] Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect good 89695196f0ba78a17453f9616355f2ca6b293402
# bad: [52deda9551a01879b3562e7b41748e85c591f14c] Merge branch 'akpm' (patches from Andrew)
git bisect bad 52deda9551a01879b3562e7b41748e85c591f14c
# bad: [169e77764adc041b1dacba84ea90516a895d43b2] Merge tag 'net-next-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect bad 169e77764adc041b1dacba84ea90516a895d43b2
# first bad commit: [169e77764adc041b1dacba84ea90516a895d43b2] Merge tag 'net-next-5.18' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next

... landed on a netdev merge commit. :/ That doesn't seem terribly
informative. I suspect either I was too aggressive with the testing or
source dir tree filtering. I've manually confirmed that the last couple
of marked merge commits are good and bad respectively, so I'll probably
try a new bisect of that range without any filtering and a bit more
deliberate testing (which will take a bit longer) and see if that yields
anything more useful.

Brian

> --D
> 
> > Brian
> > 
> 

