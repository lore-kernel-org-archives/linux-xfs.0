Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 16:43:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JNhF7V015215
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 16:43:15 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF3083AFA18
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 16:44:34 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id OucUoMqyik5vYHzA for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 16:44:34 -0700 (PDT)
Date: Wed, 20 Aug 2008 09:39:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/28] XFS: sync and reclaim rework
Message-ID: <20080819233933.GJ24344@disturbed>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com> <48AB5335.4030900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AB5335.4030900@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 20, 2008 at 09:11:49AM +1000, Mark Goodwin wrote:
> Thanks Dave - this is queued behind the btree factoring series;
> both need to be QA'd and stress/perf tested independently, which
> leads me to ask: how much QA has the sync/reclaim rework received?

It passes xfsqa. I've only been caring about correctness and getting
the code into a decent shape right now. Performance should not
change significantly for most workloads. The workload that
might benefit the most (cached lookups on a SMP NFS server) I
can't test myself anyway...

> (and could you make use of the machine Christoph has been using,
> since you're in non-overlapping TZs?)
> Also, if we were to change the inode / block offset direct mapping
> to an indirect method (e.g. inode32+), would this grossly affect
> the ascending inode number traversal optimization? If so, could that
> mechanism be made conditional?

Depends on the indirection mechanism. with inode32+, it was making
the AG number indirect. The per-ag radix trees only index the offset
of the inode into the AG, so such a change would not adversely
impact the new algorithm.

If we move to full location independence for inode numbers (not that
this will ever happen) then we'd fall back to the current situation
of effectively random order reclaim.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
