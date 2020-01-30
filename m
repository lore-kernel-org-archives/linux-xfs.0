Return-Path: <SRS0=Xde3=3T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78768C33C9E
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 08:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 497BC206F0
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jan 2020 08:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eDpcAM6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgA3IHH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jan 2020 03:07:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55428 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgA3IHG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jan 2020 03:07:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mcACr4W9oLpnOmQRjpf37ACG6Vi7DI3ou3ovZqhIzPk=; b=eDpcAM6DvYInkBWBnBEa23Z1A
        Rq+cjhagKHCqoYwAOXQBn0YeWUQ8EJh7cRCn6jdmAhfCIFS58O7l+TZkxf4DY1dZT6O795djC03WQ
        L9nQUBGpDyqYPCJkRpjC39LQ4/ibMP8YTWfFJvpIQ8GgYIhaneI0Ejvh+T7xKVrme1huX+Hlf6toq
        0o/OSKdwOabnxSjRQXA3FG3FQRgHfbRdSqKLlq/QJ37zHAy/C631PZAbubznE1vIt4Mm9gslVUM0U
        Cxv2YzQmBQuluV0h0DBHNj3HeN6fy37aKXsVASt89Bj56hI4itCfijfFYw1YFnTg7498/CZvtBj1e
        x2D/psBuw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ix4qm-00087j-2g; Thu, 30 Jan 2020 08:06:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DFB143011F3;
        Thu, 30 Jan 2020 09:05:09 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 141832B78BF24; Thu, 30 Jan 2020 09:06:53 +0100 (CET)
Date:   Thu, 30 Jan 2020 09:06:53 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Dave Chinner <david@fromorbit.com>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Phil Auld <pauld@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched, fair: Allow a per-cpu kthread waking a task to
 stack on the same CPU
Message-ID: <20200130080653.GV14879@hirez.programming.kicks-ass.net>
References: <20200127143608.GX3466@techsingularity.net>
 <20200127223256.GA18610@dread.disaster.area>
 <20200128011936.GY3466@techsingularity.net>
 <20200128091012.GZ3466@techsingularity.net>
 <20200129173852.GP14914@hirez.programming.kicks-ass.net>
 <20200130004334.GF3466@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130004334.GF3466@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 30, 2020 at 12:43:34AM +0000, Mel Gorman wrote:
> On Wed, Jan 29, 2020 at 06:38:52PM +0100, Peter Zijlstra wrote:

> > I suppose the fact that it limits it to tasks that were running on the
> > same CPU limits the impact if we do get it wrong.
> > 
> 
> And it's limited to no other task currently running on the
> CPU. Now, potentially multiple sleepers are on that CPU waiting for
> a mutex/rwsem/completion but it's very unlikely and mostly likely due
> to the machine being saturated in which case searching for an idle CPU
> will probably fail. It would also be bound by a small window after the
> first wakeup before the task becomes runnable before the nr_running check
> mitigages the problem. Besides, if the sleeping task is waiting on the
> lock, it *is* related to the kworker which is probably finished.
> 
> In other words, even this patches worst-case behaviour does not seem
> that bad.

OK; let's just stick it in and see what, if anything, falls over :-)

I saw there is a v2 out (although I didn't see what changed in a hurry),
let me queue that one.
