Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFD61C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 13:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiADNgs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 08:36:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:31830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbiADNgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 08:36:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641303406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KzTPGW2JymMzrDS1j8vpaZmq1mjrtuWjLdCBriVQUJ8=;
        b=NNhZsLraAT+ZC8RXGIip0dpih8S2p7Wu0F8CSno3gqQu3Dlus/BCFMDTpIx8dEuwkSfvCp
        0m0RjVvot+JEFDzzLpmPI7UWC76HLaVCat9a7pqqXoiQCxYnPmCyIiVhs/3UMXYGqfT+JH
        ZjnoB5OBNSyS45en38WItMpx482yrdo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-19-SajF8DTDNVuQSnddCaZyiA-1; Tue, 04 Jan 2022 08:36:45 -0500
X-MC-Unique: SajF8DTDNVuQSnddCaZyiA-1
Received: by mail-qk1-f197.google.com with SMTP id u12-20020a05620a0c4c00b00475a9324977so20877113qki.13
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jan 2022 05:36:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KzTPGW2JymMzrDS1j8vpaZmq1mjrtuWjLdCBriVQUJ8=;
        b=XP6XFK17A6et0TzJ+hQnp0Uwtmv6zVc7rAY8YEQlV+buEWcGTAMCEQL+ekQNManqir
         pqwtWeXnCb/q8+GlNcEMDrDfbdnwPTIw1Z5tulteUzNPYbzZB177thBylceQ6pWBS8Hm
         vOwbOfk/hFwLrf+L57s1sIUl+aBB7FnrfpPtplNeh+fQapYCCqEbTPhK9zO2QufnH+zZ
         wKLXfyonbrCUhpM2SXY4sQ3yHUSijYxKxowQPZNHgnZyx/HxBXjwn5ZYY8GOy5+sIOCN
         1xOuS9bCAHlosxHUuRzftPLprI64Rm0yX3SnuOED1k2amOIUV7bvdueSUeDYMeJWW/ME
         +FDw==
X-Gm-Message-State: AOAM530QzeAETWsUSSfIjn0/I4gelBpVCpuhVsM8mHIykJJxDHw2w/5G
        PggzKrM1M5qsZaVK0s0KoXiXGnZHSzIta3SryyzAQC5WFZiEFkQhFS7l0/XmctTcLcZQleD6Z4q
        vS4vcK1idPVpS9qQeTahQ
X-Received: by 2002:a37:a716:: with SMTP id q22mr35188719qke.249.1641303405040;
        Tue, 04 Jan 2022 05:36:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzr3X6E0Hb2ZXIDS/jRCm7BkGNJvh1DTGyzsgltkU4PR76XM32hvopdA+7cQ3D59BZXMHh/Ow==
X-Received: by 2002:a37:a716:: with SMTP id q22mr35188706qke.249.1641303404844;
        Tue, 04 Jan 2022 05:36:44 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id 8sm33838927qtz.28.2022.01.04.05.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 05:36:44 -0800 (PST)
Date:   Tue, 4 Jan 2022 08:36:42 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Trond Myklebust <trondmy@hammerspace.com>
Cc:     "david@fromorbit.com" <david@fromorbit.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "trondmy@kernel.org" <trondmy@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "djwong@kernel.org" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>
Subject: Re: [PATCH] iomap: Address soft lockup in iomap_finish_ioend()
Message-ID: <YdRNasL3WFugVe8c@bfoster>
References: <20211230193522.55520-1-trondmy@kernel.org>
 <Yc5f/C1I+N8MPHcd@casper.infradead.org>
 <6f746786a3928844fbe644e7e409008b4f50c239.camel@hammerspace.com>
 <20220101035516.GE945095@dread.disaster.area>
 <fb964769132eb01ed4e8b67d6972d50ee3387e24.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb964769132eb01ed4e8b67d6972d50ee3387e24.camel@hammerspace.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jan 01, 2022 at 05:39:45PM +0000, Trond Myklebust wrote:
...
> 
> Fair enough. As long as someone is working on a solution, then I'm
> happy. Just a couple of things:
> 
> Firstly, we've verified that the cond_resched() in the bio loop does
> suffice to resolve the issue with XFS, which would tend to confirm what
> you're saying above about the underlying issue being the ioend chain
> length.
> 
> Secondly, note that we've tested this issue with a variety of older
> kernels, including 4.18.x, 5.1.x and 5.15.x, so please bear in mind
> that it would be useful for any fix to be backward portable through the
> stable mechanism.
> 

I've sent a couple or so different variants of this in the past. The
last I believe was here [1], but still never seemed to go anywhere
(despite having reviews on the first couple patches). That one was
essentially a sequence of adding a cond_resched() call in the iomap code
to address the soft lockup warning followed by capping the ioend size
for latency reasons.

Brian

[1] https://lore.kernel.org/linux-xfs/20210517171722.1266878-1-bfoster@redhat.com/

> 
> Thanks, and Happy New Year!
> 
>   Trond
> 
> -- 
> Trond Myklebust
> Linux NFS client maintainer, Hammerspace
> trond.myklebust@hammerspace.com
> 
> 

