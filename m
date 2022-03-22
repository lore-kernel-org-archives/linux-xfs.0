Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D17C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 22:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiCVWE2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiCVWE1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 18:04:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1502AD1;
        Tue, 22 Mar 2022 15:02:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id v4so16792629pjh.2;
        Tue, 22 Mar 2022 15:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWVyueIn5NVM+ofwpGBt38sB1Kdwj3XXE0hUGjn6kgE=;
        b=fDkX4OVK1mJtQ8UA/3xLghuoQA7GNeCC7aQF+9HNVDg1huO79Y+6J6prD3JPqAFvd0
         xDs6z9onYpNrjZBlzBMJZM4RzZK7sfw8dLMpe24vD+DzJw9uaCalnumfvqFyDmqsG8qd
         j7dgWq4bfguj76hiygTwvi2dO86pc1foG44KRIEvKF8CqTjBOT0ZkFLMLPCDFRzyL9bW
         3jI66JXkC2KJVf3tSaiZvSgrlRIIHfRO7NB3HgBhpPqsvriG1g0xKYc5wWVU2d/R93+a
         ChT3khBGJFhj3VZSfePUBYyB+xMNa3sgV1zGeY5UR2YSZ9DM1qwwPdxZsGrSX9cZciSi
         /g1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=OWVyueIn5NVM+ofwpGBt38sB1Kdwj3XXE0hUGjn6kgE=;
        b=ObB+RhmZ8hV5VDdV6uo8Spg2EX51cr9qiE/RI5wAtxFdAKHuDJ6SWmrF9YLOSzGxJQ
         dbVtF7KwC1VJHHNm1rHPVtMVleAOw3c/4/Rchnl2p8uAGb5k0slSdZnbI3AssMEgZNCD
         is+iar+dHCbEcG/FLgy8V1LyPVjd/E3Yvcu0YeMfwW5+GSMFZrQ+f2MGAT8h7pJr7/Mw
         UKU9Gr+smjv6x6bdphFXgDsQ0E7WxjglBVp3FW/GBE79VKTwnAs0nuEwhDoDgh6x5RFO
         pLtP94Ij/kfdDsnH0kyfHgyzcm+8hH8/zMywxiyBFUCPY1YQ9vLd4/anwFekOLb1OLc1
         HKZw==
X-Gm-Message-State: AOAM531C65Fb4xr6klGCESBBGbSHQoKn9AOrg1WT5McRLZzYoak1jEgJ
        d+mdIYZJnG/clY51P/MbnsQ=
X-Google-Smtp-Source: ABdhPJz74GZm8O2xF5X2E3BlEjCqCtxhK/Ecpo/tassA1Kxm6oSCDQXLAttn+wC2i4Hx8ksr0R3rww==
X-Received: by 2002:a17:90b:3908:b0:1c7:7a14:2083 with SMTP id ob8-20020a17090b390800b001c77a142083mr2327756pjb.230.1647986576462;
        Tue, 22 Mar 2022 15:02:56 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id oj16-20020a17090b4d9000b001c709bca712sm4241182pjb.29.2022.03.22.15.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 15:02:55 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Mar 2022 12:02:53 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <YjpHjRoq+WtOAmut@slm.duckdns.org>
References: <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322220007.GQ1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Wed, Mar 23, 2022 at 09:00:07AM +1100, Dave Chinner wrote:
> > Yeah, you detected multiple issues at the same time. xfs sync is
> > participating in memory reclaim
> 
> No it isn't. What makes you think it is part of memory reclaim?
> 
> The xfs-sync workqueue exists solely to perform async flushes of
> dirty data at ENOSPC via sync_inodes_sb() because we can't call
> sync_inodes_sb directly in the context that hit ENOSPC due to locks
> and transaction contexts held. The paths that need this are
> buffered writes and file create (on disk inode allocation), neither
> of which are in the the memory reclaim path, either.
> 
> So this work has nothing to do with memory reclaim, and as such it's
> not tagged with WQ_MEM_RECLAIM.

Hmmm... yeah, I actually don't know the exact dependency here and the
dependency may not be real - e.g. the conclusion might be that loop is
conflating different uses and needs to split its use of workqueues into two
separate ones. Tetsuo, can you post more details on the warning that you're
seeing?

Thanks.

-- 
tejun
