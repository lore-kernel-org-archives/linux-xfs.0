Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36255 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726946AbeH0Cwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Aug 2018 22:52:49 -0400
Date: Mon, 27 Aug 2018 09:08:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/3] xfs: Reduce spinlock contention in log space
 slowpath code
Message-ID: <20180826230845.GD2234@dastard>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535316795-21560-1-git-send-email-longman@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Waiman Long <longman@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Aug 26, 2018 at 04:53:12PM -0400, Waiman Long wrote:
> v1->v2:
>  - For patch 1, remove wake_q_empty() & add task_in_wake_q().
>  - Rewrite patch 2 after comments from Dave Chinner and break it down
>    to 2 separate patches. Now the original xfs logic was kept. The
>    patches just try to move the task wakeup calls to outside the
>    spinlock.
> 
> While running the AIM7 microbenchmark on a small xfs filesystem, it
> was found that there was a severe spinlock contention problem in the
> current XFS log space reservation code. To alleviate the problem, the

Again I'll ask: what is the performance when the log is made large
enough that your benchmark is *not hammering the slow path*? 

i.e. does running "mkfs.xfs -l size=2000m ..." instead of using the
default tiny log on your tiny test filesystem make the problem
go away? Without that information, we have no idea what the slow
path impact on peformance actually is, and whether it is worth
persuing optimising slow path behaviour that very, very few
production environments see lock contention in....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
