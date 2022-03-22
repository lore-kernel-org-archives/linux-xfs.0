Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2572FC433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 16:52:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239210AbiCVQxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 12:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiCVQxr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 12:53:47 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2965085671;
        Tue, 22 Mar 2022 09:52:17 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g19so18630911pfc.9;
        Tue, 22 Mar 2022 09:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/OlG/vq5gpUG8P+rYJ2xVKDcdc69R3el9tkAjuybST0=;
        b=TPKAtJX8K2GpxBZq/7KiqQlW6OE/664bmynj/dd5mAZUwgabJjzHNIHdKdxeQAVe2q
         9J3cHAunKSBTXVyGrks/RruHSJ+P9P/evFHkcPJ47zsksffrieAwFDs0k+uYoL7awkPo
         t662MpZUObc14EkbJsJTGeZENX6HByVIjxLdW+UdQaKC9ZJiWxAdyxG21d21oCmnQEOb
         OM1MtfDXPNvceEfBR77UYiCd++dTFzZ6HUrTrZ9tl5HUFuni1rpv9xVRPwINkjsxSDJT
         dOccLua7CrpoeWF//oNbf+TUUFpYBZ1FakOouSML1srXx1s1dQ1EkMOB5lm4m98vYfq0
         tE0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/OlG/vq5gpUG8P+rYJ2xVKDcdc69R3el9tkAjuybST0=;
        b=c1tnjEm6Xqi7pNSpFXVdcDoDYO+j8UZ1bzGNExbxH/ktRAGe9CqaJIg8iePdJKWky+
         z2MRlSeb99XUvh+GVeHIL8aUmd7hAwNqcy/jGsi1KY51wFUdEyzBATthlpflDgHKKpr3
         bthPuLOE/yGBA+yKJh0uXIU57K8ATUCeeKMICYfYaZd0m/XE7TADZsj4kTE0ruupU8d/
         jXOtn/BqrV8mY4Wbim5Ia3Xj4fQNpL//9HVkehgZw4CtMiEqiZyLEZCl2K5x4LpCC6up
         cDvupJC4uDpTqF3dbW9w/IYpHrbx7ZFYhyqiyCGy6AzUCzpE/tyINMeNP0z2RLeh7cWH
         BMYA==
X-Gm-Message-State: AOAM532//P87i0vLPMgiRQ7qyocQ5BkGfjOa5wuUH2ZYWHz9t8zCroyC
        kEDg972Qf/NwJxEOn4Yozlo=
X-Google-Smtp-Source: ABdhPJxxjk9/Sh2tjxAiwtp06qJHdhfmOSqL3UVzb4UzIpsVWqfucbaAT/djHcc9drZ83sdgVsZhcA==
X-Received: by 2002:a63:4c6:0:b0:385:f757:1e65 with SMTP id 189-20020a6304c6000000b00385f7571e65mr1979395pge.453.1647967936719;
        Tue, 22 Mar 2022 09:52:16 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id lp4-20020a17090b4a8400b001bedba2df04sm3279903pjb.30.2022.03.22.09.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 09:52:16 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Mar 2022 06:52:14 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
References: <YjNHzyTFHjh9v6k4@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <5542ef88-dcc9-0db5-7f01-ad5779d9bc07@I-love.SAKURA.ne.jp>
 <YjS+Jr6QudSKMSGy@slm.duckdns.org>
 <61f41e56-3650-f0fc-9ef5-7e19fe84e6b7@I-love.SAKURA.ne.jp>
 <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Tue, Mar 22, 2022 at 09:09:53AM +0900, Tetsuo Handa wrote:
> > The legacy flushing warning is telling us that those workqueues can be
> 
> s/can be/must be/ ?

Well, one thing that we can but don't want to do is converting all
create_workqueue() users to alloc_workqueue() with MEM_RECLAIM, which is
wasteful but won't break anything. We know for sure that the workqueues
which trigger the legacy warning are participating in memory reclaim and
thus need MEM_RECLAIM. So, yeah, the warning tells us that they need
MEM_RECLAIM and should be converted.

> ? Current /* internal: create*_workqueue() */ tells me nothing.

It's trying to say that it shouldn't be used outside workqueue proper and
the warning message is supposed to trigger the conversion. But, yeah, a
stronger comment can help.

> My question is: I want to add WQ_MEM_RECLAIM flag to the WQ used by loop module
> because this WQ is involved upon writeback operation. But unless I add both
> __WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used by loop module, we will hit
> 
> 	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
> 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
> 
> warning because e.g. xfs-sync WQ used by xfs module is not using WQ_MEM_RECLAIM flag.
> 
> 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
> 				XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);
> 
> You are suggesting that the correct approach is to add WQ_MEM_RECLAIM flag to WQs
> used by filesystems when adding WQ_MEM_RECLAIM flag to the WQ used by loop module
> introduces possibility of hitting
> 
> 	WARN_ONCE(worker && ((worker->current_pwq->wq->flags &
> 			      (WQ_MEM_RECLAIM | __WQ_LEGACY)) == WQ_MEM_RECLAIM),
> 
> warning (instead of either adding __WQ_LEGACY | WQ_MEM_RECLAIM flags to the WQ used
> by loop module or giving up WQ_MEM_RECLAIM flag for the WQ used by loop module),
> correct?

Yeah, you detected multiple issues at the same time. xfs sync is
participating in memory reclaim but doesn't have MEM_RECLAIM and loop is
marked with LEGACY but flushing other workqueues which are MEM_RECLIAM. So,
both xfs and loop workqueues need to be explicitly marked with MEM_RECLAIM.

Thanks.

-- 
tejun
