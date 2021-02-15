Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB469C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Feb 2021 14:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F0E64E31
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Feb 2021 14:00:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhBOOAV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Feb 2021 09:00:21 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:40977 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhBOOAU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Feb 2021 09:00:20 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id BDAB32064792F;
        Mon, 15 Feb 2021 14:36:38 +0100 (CET)
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
To:     Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
 <20210107215444.GG331610@dread.disaster.area>
 <20210108165657.GC893097@bfoster> <20210111163848.GC1091932@bfoster>
 <20210113215348.GI331610@dread.disaster.area>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <8416da5f-e8e5-8ec6-df3e-5ca89339359c@molgen.mpg.de>
Date:   Mon, 15 Feb 2021 14:36:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210113215348.GI331610@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 13.01.21 22:53, Dave Chinner wrote:
> [...]
> I agree that a throttling fix is needed, but I'm trying to
> understand the scope and breadth of the problem first instead of
> jumping the gun and making the wrong fix for the wrong reasons that
> just papers over the underlying problems that the throttling bug has
> made us aware of...

Are you still working on this?

If it takes more time to understand the potential underlying problem, the fix for the problem at hand should be applied.

This is a real world problem, accidentally found in the wild. It appears very rarely, but it freezes a filesystem or the whole system. It exists in 5.7 , 5.8 , 5.9 , 5.10 and 5.11 and is caused by c7f87f3984cf ("xfs: fix use-after-free on CIL context on shutdown") which silently added a condition to the wakeup. The condition is based on a wrong assumption.

Why is this "papering over"? If a reminder was needed, there were better ways than randomly hanging the system.

Why is

     if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
         wake_up_all(&cil->xc_push_wait);

, which doesn't work reliably, preferable to

     if (waitqueue_active(&cil->xc_push_wait))
         wake_up_all(&cil->xc_push_wait);

which does?

Best
   Donald

> Cheers,
> 
> Dave
