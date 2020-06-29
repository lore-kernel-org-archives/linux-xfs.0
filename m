Return-Path: <SRS0=2z4t=AK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994C6C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 20:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79BC620759
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Jun 2020 20:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593464246;
	bh=BVxfHHV5eeS071ZyTIkymXEwTnryixggHKSaYZaRJxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=POaLzYq8pV1YXG7P4VMYWi9X7Lotn/bCzN9phsTQuFRgF8G0lc1qRlvwN1tXu3fae
	 KUe7VjEqp/jZujsEG1uPSTH7pLMNHhvB+jZU7L/+XOBOXBu3PyipC2Yq3LMiPH+Urd
	 s9mvAL3ar9pE04UWKfZOwi+FFqNlEE3j3jf3IU90=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387842AbgF2U5Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgF2TNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jun 2020 15:13:06 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BD9C0147C0;
        Mon, 29 Jun 2020 01:22:13 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so15669757ejc.3;
        Mon, 29 Jun 2020 01:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mPrydynbK5+rnDYJyI/EITf6/MzUF0CRG2o081Vq5dc=;
        b=cAUwQQoKDC06YT4LHqdA4xDyz4JhAwt/ytb8hC2uFAgm3TaJ0OqssW2rznu5kn46N0
         JEfbQYCX8VjtVSYRhGVHgjVYgSFWExMm1vkZXi1UwgkfXGAynHOqVs6b8Uyz4VSmSm7d
         g8vZqCOtQq89cSyg0hzhyyAdIElZ9ayjmNLD5XwRybW4IiJvn7V3HaL/koa8Rn1Zk4F7
         LXKY7Wn3Qug30+dPR0hRk132yk2/ruEAxMLBk/x6JjQrK0mqQawVfXpByLN2YxpGFNJA
         +CRptDvNTYQkuOkCl7DSICXv2c9+yGZNOBEZtT2ghVeHYlDtKRZ0N+kEKvfD1WUSSt2Q
         gm9g==
X-Gm-Message-State: AOAM533eUkhnbbKD9GNDNyDTvijEnMJmgU0VUOBWOli7pTBGPUWkLY6Y
        sQL3l0vxf7X3S8m+C5hMF7o=
X-Google-Smtp-Source: ABdhPJxpOcTkL4osdGXouPGkUvoEu+LR2SWHbzDt5dJZtwUNOJWJOn7V0ppda1Dcr/qptC9T6ZT4xQ==
X-Received: by 2002:a17:906:fa9b:: with SMTP id lt27mr12396115ejb.365.1593418931557;
        Mon, 29 Jun 2020 01:22:11 -0700 (PDT)
Received: from localhost (ip-37-188-168-3.eurotel.cz. [37.188.168.3])
        by smtp.gmail.com with ESMTPSA id x10sm15592704ejc.46.2020.06.29.01.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 01:22:10 -0700 (PDT)
Date:   Mon, 29 Jun 2020 10:22:09 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Message-ID: <20200629082209.GC32461@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626230847.GI2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626230847.GI2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat 27-06-20 09:08:47, Dave Chinner wrote:
> On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > prevents both filesystem recursion and i/o recursion.
> > 
> > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > and PF_MEMALLOC_NOIO is not set.
> 
> Correct me if I'm wrong, but I think that will prevent swapping from
> GFP_NOFS memory reclaim contexts. IOWs, this will substantially
> change the behaviour of the memory reclaim system under sustained
> GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> quite common, so I really don't think we want to telling memory
> reclaim "you can't do IO at all" when all we are trying to do is
> prevent recursion back into the same filesystem.
> 
> Given that the loop device IO path already operates under
> memalloc_noio context, (i.e. the recursion restriction is applied in
> only the context that needs is) I see no reason for making that a
> global reclaim limitation....
> 
> In reality, we need to be moving the other way with GFP_NOFS - to
> fine grained anti-recursion contexts, not more broad contexts.

Absolutely agreed! It is not really hard to see system struggling due to
heavy FS metadata workload while there are objects which could be
reclaimed.

> That is, GFP_NOFS prevents recursion into any filesystem, not just
> the one that we are actively operating on and needing to prevent
> recursion back into. We can safely have reclaim do relcaim work on
> other filesysetms without fear of recursion deadlocks, but the
> memory reclaim infrastructure does not provide that capability.(*)
> 
> e.g. if memalloc_nofs_save() took a reclaim context structure that
> the filesystem put the superblock, the superblock's nesting depth
> (because layering on loop devices can create cross-filesystem
> recursion dependencies), and any other filesyetm private data the
> fs wanted to add, we could actually have reclaim only avoid reclaim
> from filesytsems where there is a deadlock possiblity. e.g:
> 
> 	- superblock nesting depth is different, apply GFP_NOFS
> 	  reclaim unconditionally
> 	- superblock different apply GFP_KERNEL reclaim
> 	- superblock the same, pass context to filesystem to
> 	  decide if reclaim from the sueprblock is safe.
> 
> At this point, we get memory reclaim able to always be able to
> reclaim from filesystems that are not at risk of recursion
> deadlocks. Direct reclaim is much more likely to be able to make
> progress now because it is much less restricted in what it can
> reclaim. That's going to make direct relcaim faster and more
> efficient, and taht's the ultimate goal we are aiming to acheive
> here...

Yes, we have discussed something like that few years back at LSFMM IIRC.
The scoped NOFS/NOIO api was just a first step to reduce explicit
NOFS/NOIO usage with a hope that we will get no-recursion entry points
much more well defined and get rid of many instances where "this is a fs
code so it has to use NOFS gfp mask".

Some of that has happened and that is really great. On the other hand
many people still like to use that api as a workaround for an immediate
problem because no-recursion scopes are much harder to recognize unless
you are supper familiar with the specific fs/IO layer implementation.
So this is definitely not a project for somebody to go over all code and
just do the clean up.

Thanks!
-- 
Michal Hocko
SUSE Labs
