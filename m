Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67ACCC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Mar 2022 22:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237838AbiCVWVR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 18:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237833AbiCVWVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 18:21:11 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198AE55BEA;
        Tue, 22 Mar 2022 15:19:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gb19so16839778pjb.1;
        Tue, 22 Mar 2022 15:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GXfG0dLHhcSc78SHKKLUp/gv80NUqVjr6FWI+zRyKPc=;
        b=g4CJCmPx1AXZJDujLKD0xR6PULiPIUbNCjmS5SA6NDp25yuKIquIA78zub8Cf+xbFy
         9PlgZKBSAk9S6SfCwrUEU58yXFIp7JTiS0ZBAzoyk5nwBWC4Au8h7bzk/3GgiSUYDC3D
         rKCzpiQsOlkgtvgkAGl/rCVBgbPXphLWPxkUDg0FtsFx3+30Onf22w4pZd/BQ5oXI5Tz
         UcpwoRk1Vl/hZEHLW+G91oG9MimgWJ8EKxabBujz42jG8NFWMrXMM0o2Jzt4aJMxHclZ
         D+1ERJgSixbJNVjPuHFJzdDII2JTsWe2IRf9wjhW01/AESDb3t1lqT4pybhVwmXiufWA
         Zd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=GXfG0dLHhcSc78SHKKLUp/gv80NUqVjr6FWI+zRyKPc=;
        b=G0VttvBoufUwIZflndAAzWbCBaQ8oN/+GhqFUkb3lzKrRCTHC5g1p1Ws3/nOjgQC3C
         Dz/yCpjNURj84AykjO/97/16Rm6R8nP5oblQJM89neXmE7RkynAHddbaZTLmzZ5RaOfX
         Bq1jnRheyoG2UV/Ly6kAX7hiJP11hw3eGPwnQf7niz6EsbGBf2aQTaeSa4M+5U8/I4a8
         gmjjgFTnl9RdCg7HsexkawYwt/Y7cgSsXN1DYOl499lCR7S+x5kY+Nwe9Bt0bQSFJLQ4
         t9DnWyud13H+9BLJkRwq6Y6/r+NAeqa3/ettUD5gjtJsKr1AJj7GzpDYOkL67P7+tSE0
         nYfA==
X-Gm-Message-State: AOAM532T8qgcdi7sNr4BZGHpJiLNRZpPvOdUHFqazgPDTXiB2Z0lCQfF
        vL864rIDI+fc4+13yGEpM/K2BzluF0LZyQ==
X-Google-Smtp-Source: ABdhPJyMhK+kjvTvBGOGvPyeCKbyWUdJWZUTbj5kDulUQgHb5ccbLzrGYWl3A6fI0/GR86o4OsPk2Q==
X-Received: by 2002:a17:902:860c:b0:153:36b3:89aa with SMTP id f12-20020a170902860c00b0015336b389aamr20538355plo.125.1647987582472;
        Tue, 22 Mar 2022 15:19:42 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-e24f-43ff-fee6-449f.res6.spectrum.com. [2603:800c:1a02:1bae:e24f:43ff:fee6:449f])
        by smtp.gmail.com with ESMTPSA id j7-20020a17090a31c700b001c6dbb70c94sm4040431pjf.18.2022.03.22.15.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 15:19:41 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 22 Mar 2022 12:19:40 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Dave Chinner <david@fromorbit.com>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        linux-block <linux-block@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] loop: add WQ_MEM_RECLAIM flag to per device workqueue
Message-ID: <YjpLfK+glfSPe09Q@slm.duckdns.org>
References: <YjiuGnLVjj0Ouxtd@slm.duckdns.org>
 <886dee4b-ea74-a352-c9bf-cac16acffaa9@I-love.SAKURA.ne.jp>
 <YjkEjYVjLuo8imtn@slm.duckdns.org>
 <1c455861-3b42-c530-a99e-cce13e932f53@I-love.SAKURA.ne.jp>
 <YjkJ3S/1c8PxiA2Q@slm.duckdns.org>
 <2ce1e26c-9050-9a4d-03b1-fb6ad57a5ccf@I-love.SAKURA.ne.jp>
 <Yjn+vpHZzvxiAUaK@slm.duckdns.org>
 <20220322220007.GQ1544202@dread.disaster.area>
 <YjpHjRoq+WtOAmut@slm.duckdns.org>
 <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <342c3dee-2acc-3983-ab38-7afe6c5ea677@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 23, 2022 at 07:05:56AM +0900, Tetsuo Handa wrote:
> > Hmmm... yeah, I actually don't know the exact dependency here and the
> > dependency may not be real - e.g. the conclusion might be that loop is
> > conflating different uses and needs to split its use of workqueues into two
> > separate ones. Tetsuo, can you post more details on the warning that you're
> > seeing?
> > 
> 
> It was reported at https://lore.kernel.org/all/20210322060334.GD32426@xsang-OptiPlex-9020/ .

Looks like a correct dependency to me. The work item is being flushed from
good old write path. Dave?

Thanks.

-- 
tejun
