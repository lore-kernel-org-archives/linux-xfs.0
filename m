Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f180.google.com ([209.85.217.180]:35628 "EHLO
        mail-ua0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933192AbdCGVst (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Mar 2017 16:48:49 -0500
Received: by mail-ua0-f180.google.com with SMTP id q7so17227748uaf.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Mar 2017 13:48:49 -0800 (PST)
Date: Tue, 7 Mar 2017 16:48:42 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: How to favor memory allocations for WQ_MEM_RECLAIM threads?
Message-ID: <20170307214842.GA7500@htj.duckdns.org>
References: <201703031948.CHJ81278.VOHSFFFOOLJQMt@I-love.SAKURA.ne.jp>
 <20170303133950.GD31582@dhcp22.suse.cz>
 <20170303232512.GI17542@dastard>
 <20170307121503.GJ28642@dhcp22.suse.cz>
 <20170307193659.GD31179@htj.duckdns.org>
 <20170307212132.GQ17542@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170307212132.GQ17542@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Michal Hocko <mhocko@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-xfs@vger.kernel.org, linux-mm@kvack.org

Hello,

On Wed, Mar 08, 2017 at 08:21:32AM +1100, Dave Chinner wrote:
> > I don't see how whether something is running off of a rescuer or not
> > matters here.  The only thing workqueue guarantees is that there's
> > gonna be at least one kworker thread executing work items from the
> > workqueue.  Running on a rescuer doesn't necessarily indicate memory
> > pressure condition.
> 
> That's news to me. In what situations do we run the rescuer thread
> other than memory allocation failure when queuing work?

It's a timeout based mechanism.  Whevever the delay might be coming
from, the rescuer kicks in if the workqueue fails to make forward
progress for a while.  The only thing which can induce delay there is
kthread creation path, which usually gets blocked on memory pressure
but it could easily be something else - severe cpu contention,
somebody holding some mutex for too long, whatever.

> > It's implementable for sure.  I'm just not sure how it'd help
> > anything.  It's not a relevant information on anything.
> 
> Except to enable us to get closer to the "rescuer must make forwards
> progress" guarantee. In this context, the rescuer is the only
> context we should allow to dip into memory reserves. I'm happy if we
> have to explicitly check for that and set PF_MEMALLOC ourselves 
> (we do that for XFS kernel threads involved in memory reclaim),
> but it's not something we should set automatically on every
> IO completion work item we run....

Ah, okay, that does make sense to me.  Yeah, providing that test
shouldn't be difficult at all.  Lemme cook up a patch.

Thanks.

-- 
tejun
