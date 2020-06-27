Return-Path: <SRS0=5xP4=AI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0CCC433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Jun 2020 18:31:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A71020760
	for <linux-xfs@archiver.kernel.org>; Sat, 27 Jun 2020 18:31:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C5RrWz/f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgF0SbF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 27 Jun 2020 14:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgF0SbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jun 2020 14:31:05 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECAE4C061794;
        Sat, 27 Jun 2020 11:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=EqUqgITG7ecsHU1e88clY3vesSjbEZhx3MeoTPdWfIg=; b=C5RrWz/fA6p/G3PTFtiwvmczon
        4mz/MmxNzJKyeo7VvdUJMBSd9TcPYjJG4+zfpLX4uw3yZdQ0WYKKZxpYYJ5IiJ40812UD0FoAnysS
        UlzrnQHO72zQ4UIuUymqAVVzNyP68SdX7PTQprTpl3MhKO1pEptFBAvdAxwbuV4C55KcgdZ2VfF9O
        1ImievnmyEYFw89GohdJXs1fH06ZBus1NZBNhWlhiSb8mKl2syj0g0XeizGlsO2DEBPjj7mIrBIIV
        MmmJ3Up5lcQxmx3DSuNHlt9zRLvGYf1YiQbISb7ddq5BjWFE5n5cGNiWk5LpBJ+JrbaMVm0yL4CkA
        pgXgZnIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jpFbB-0004Ve-DO; Sat, 27 Jun 2020 18:30:45 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id BB45F301A7A;
        Sat, 27 Jun 2020 20:30:42 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A3C7E22B8B6C1; Sat, 27 Jun 2020 20:30:42 +0200 (CEST)
Date:   Sat, 27 Jun 2020 20:30:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200627183042.GK4817@hirez.programming.kicks-ass.net>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
 <20200626223254.GH2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626223254.GH2005@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 27, 2020 at 08:32:54AM +1000, Dave Chinner wrote:
> Observation from the outside:
> 
> "However I'm having trouble convincing myself that's actually
> possible on x86_64.... "

Using the weaker rules of LKMM (as relevant to Power) I could in fact
make it happen, the 'problem' is that it's being observed on the much
stronger x86_64.

So possibly I did overlook a more 'sensible' scenario, but I'm pretty
confident the problem holds as it fully explains the failure mode.

> This scheduler code has fallen off a really high ledge on the memory
> barrier cliff, hasn't it?

Just a wee bit.. I did need pen and paper and a fair amount of
scribbling for this one.

> Having looked at this code over the past 24 hours and the recent
> history, I know that understanding it - let alone debugging and
> fixing problem in it - is way beyond my capabilities.  And I say
> that as an experienced kernel developer with a pretty good grasp of
> concurrent programming and a record of implementing a fair number of
> non-trivial lockless algorithms over the years....

All in the name of making it go fast, I suppose. It used to be much
simpler... like much of the kernel.

The biggest problem I had with this thing was that the reproduction case
we had (Paul's rcutorture) wouldn't readily trigger on my machines
(altough it did, but at a much lower rate, just twice in a week's worth
of runtime).

Also; I'm sure you can spot a problem in the I/O layer much faster than
I possibly could :-)

Anyway, let me know if you still observe any problems.
