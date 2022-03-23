Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3819C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 00:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240887AbiCWALV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 20:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiCWALU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 20:11:20 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C078652E2;
        Tue, 22 Mar 2022 17:09:52 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q19so13754131pgm.6;
        Tue, 22 Mar 2022 17:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jgdleOfLqvIueyHSwi4fWJ4tDGfe4r9oabmW/ltVQfA=;
        b=avwhU6x1JfpTO8sJQ119s5PQOrOOWDFIVC6x29zlmMo5HnxbUrJ4/ayTBrAWKMI+0m
         8jqBbu6a/6+CxQ+UjRQOtNIn7szxxAoBA6p+h6f7cL6S1kdMC0FqiUqMDXr/j1oXr8VW
         sEwD+OjHyel6B3SwO03v9K+0050odi4b4seilPOFvCnfvUVLK7azgA86ZeddkeMR16ME
         1xa1Dy2+m0QkwroZQ3Yv7ud3XGHhae1Pl96/eUIOrpGG4TWEnT6lW/F6YJ8jFK9zHd1k
         icW47ZawSs7KPeR7jJs0nMQFCn+/IhM0mCdusruM29ObL+r6fSIyTzcmyMgTcNykKTuX
         lW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jgdleOfLqvIueyHSwi4fWJ4tDGfe4r9oabmW/ltVQfA=;
        b=MAdaEXuAVnA/8Ky3cdFNzDU5GwGAi7l5r6ST8hAm+6j3si+YzPxJDQqVq4Gzo5QsF1
         RqApKNU7umRhUxU/y0PQJ6GitJQfaXGJX/xlXW5oPeGgJAfZ1WaOPdeTMRprqztn0rXE
         damaTxWHR/gDfChn4h8al/Q5vzRh4H/W8tMkv3Niih8IcrvilTS0SpqvXJVNFSt02Ooe
         zBixgpQ3hx8jsmjw+FHW6789FFHUIJ7t5YNfWqUqcuucQ+o3eOmhjsKxjP6y+Fqkk+02
         /27hRwVxoC63vBg426WZIpVdPlOH9VZqla/WpKaKGwYRx3WWYW9Gk/rdQVSLP7kO4mrz
         cTHw==
X-Gm-Message-State: AOAM53171Veuj/KCoy4JXipnx+4AtZ7UH0OC7qcDmURDNsGb8tosmRSO
        ZG2/J5VL4iuy1QvWbk+l8CY=
X-Google-Smtp-Source: ABdhPJzjsD/JD2TnBKP/Y+UoUX4WheNMH0jDX1ojdZ1WPXEEXBmoepezJyf7z9NLaFvZkaPh1bmyhg==
X-Received: by 2002:a05:6a00:8d4:b0:4f6:6da0:f380 with SMTP id s20-20020a056a0008d400b004f66da0f380mr31516605pfu.34.1647994191702;
        Tue, 22 Mar 2022 17:09:51 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id t26-20020a056a00139a00b004faa13ba384sm9348071pfg.162.2022.03.22.17.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 17:09:51 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Mar 2022 14:09:49 -1000
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
Message-ID: <YjplTfleQUMjFV8C@slm.duckdns.org>
References: <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
 <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
 <YjpLfK+glfSPe09Q@slm.duckdns.org>
 <20220322225914.GR1544202@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322225914.GR1544202@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

On Wed, Mar 23, 2022 at 09:59:14AM +1100, Dave Chinner wrote:
> The filesystem buffered write IO path isn't part of memory reclaim -
> it's a user IO path and I think most filesystems will treat it that
> way.

We can argue the semantics but anything in fs / io path which sit on write
path should be marked MEM_RECLAIM because they can be depended upon while
cleaning dirty pages. This isn't a layering problem or anything. It's just
what that flag is for.

> If the loop device IO mechanism means that every ->write_iter path
> needs to be considered as directly in the memory reclaim path, then
> that means a huge amount of the kernel needs to be considered as "in
> memory reclaim". i.e. it's not just this one XFS workqueue that is
> going have this problem - it's any workqueue that can be waited on
> by the incoming IO path.
> 
> For example, network filesystem might put the network stack directly
> in the IO path. Which means if we then put loop on top of that
> filesystems, various workqueues in the network stack may now need to
> be considered as running under the memory reclaim path because of
> the loop block device.
> 
> I don't know what the solution is, but if the fix is "xfs needs to
> mark a workqueue that has nothing to do with memory reclaim as
> WQ_MEM_RECLAIM because of the loop device" then we're talking about
> playing workqueue whack-a-mole across the entire kernel forever
> more....

Yeah, all those workqueues must be and most of them are already tagged with
MEM_RECLAIM. The network drivers are kinda painful and we *can* make them
conditional (on it sitting in the io path) if that ever becomes necessary
but the number hasn't been problematic till now.

Thanks.

-- 
tejun
