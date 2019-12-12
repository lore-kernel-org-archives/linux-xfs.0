Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3626C2D0C8
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8295206DA
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:23:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EJNBm0jy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbfLLKXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:23:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38694 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728339AbfLLKXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:23:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IFLrETBaYvDuLlrtTw9nVCwAdrvTZDXVVkvqQo2PJU0=; b=EJNBm0jye4L2AlfkwLM9KUfOd
        RX3yYLvm/FjGDshAP6S14IpVWY94odiDbEAGfmTWkGjnAbj2d5lJDgnV+TQ2t7+A+1cQDGRMvkCpq
        GtTxYGxGmeYdjbwMgHnns4Cs1hOsD01DX3p7F5B6maP78NkoZG/E5Bk2IoGju8MatFsucAw35Uksg
        loWZDK9xdSGPyJr2VM0F5y0LEo2/9FsFawVrf1OqXkZxzMSKD2jfopyJVx4aefBR8S94/zRIQGT9Z
        2dGS9Zp6Qt8IPVybi3Al4tTpEsvSKtUBzrIgXYF9XH6Jk7g0bIJqLuONZzg/unMZnA8bT/eJ/q5ca
        usttVG64A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifLd3-0007KT-9K; Thu, 12 Dec 2019 10:23:29 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B6FAC304D2B;
        Thu, 12 Dec 2019 11:22:07 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 058AB2012196F; Thu, 12 Dec 2019 11:23:27 +0100 (CET)
Date:   Thu, 12 Dec 2019 11:23:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Phil Auld <pauld@redhat.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH v4] sched/core: Preempt current task in favour of bound
 kthread
Message-ID: <20191212102327.GI2871@hirez.programming.kicks-ass.net>
References: <20191120220313.GC18056@pauld.bos.csb>
 <20191121132937.GW4114@hirez.programming.kicks-ass.net>
 <20191209165122.GA27229@linux.vnet.ibm.com>
 <20191209231743.GA19256@dread.disaster.area>
 <20191210054330.GF27253@linux.vnet.ibm.com>
 <20191210172307.GD9139@linux.vnet.ibm.com>
 <20191211173829.GB21797@linux.vnet.ibm.com>
 <20191211224617.GE19256@dread.disaster.area>
 <20191212101031.GV2827@hirez.programming.kicks-ass.net>
 <20191212101424.GH2871@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212101424.GH2871@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 12, 2019 at 11:14:24AM +0100, Peter Zijlstra wrote:
> On Thu, Dec 12, 2019 at 11:10:31AM +0100, Peter Zijlstra wrote:
> > @@ -4156,13 +4159,13 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >  	if (delta_exec < sysctl_sched_min_granularity)
> >  		return;
> >  
> > -	se = __pick_first_entity(cfs_rq);
> > +	se = __pick_next_entity(cfs_rq, NULL);
> >  	delta = curr->vruntime - se->vruntime;
> >  
> >  	if (delta < 0)
> >  		return;
> 
> What I mean with the below comment is, when this isn't enough, try
> something like:
> 
> 	if (se == cfs_rq->next)
> 		ideal_runtime /= 2;
> 
> to make it yield sooner to 'next' buddies. Sadly, due to the whole
> cgroup mess, we can't say what actual task is on the end of it (without
> doing a full hierarchy pick, which is more expensive still).

Just for giggles, that'd look something like:

	while (!entity_is_task(se) {
		cfs_rq = group_cfs_rq(se);
		se = pick_next_entity(cfs_rq, cfs_rq->curr);
	}
	p = task_of(se);

	if (is_per_cpu_kthread(p))
		ideal_runtime /= 2;

the core-scheduling patch set includes the right primitive for this I
think, pick_task_fair().

> > -	if (delta > ideal_runtime)
> > +	if (delta > ideal_runtime) // maybe frob this too ?
> >  		resched_curr(rq_of(cfs_rq));
> >  }
