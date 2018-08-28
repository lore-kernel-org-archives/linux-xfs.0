Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:17350 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725724AbeH1FPO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 01:15:14 -0400
Date: Tue, 28 Aug 2018 11:26:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 2/3] xfs: Prevent multiple wakeups of the same log
 space waiter
Message-ID: <20180828012600.GJ2234@dastard>
References: <1535316795-21560-1-git-send-email-longman@redhat.com>
 <1535316795-21560-3-git-send-email-longman@redhat.com>
 <20180827002134.GE2234@dastard>
 <c4ecb0d3-843b-3d9b-d7e0-acda77881f3a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ecb0d3-843b-3d9b-d7e0-acda77881f3a@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Waiman Long <longman@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Aug 27, 2018 at 11:34:13AM -0400, Waiman Long wrote:
> On 08/26/2018 08:21 PM, Dave Chinner wrote:
> > On Sun, Aug 26, 2018 at 04:53:14PM -0400, Waiman Long wrote:
> >> The current log space reservation code allows multiple wakeups of the
> >> same sleeping waiter to happen. This is a just a waste of cpu time as
> >> well as increasing spin lock hold time. So a new XLOG_TIC_WAKING flag is
> >> added to track if a task is being waken up and skip the wake_up_process()
> >> call if the flag is set.
> >>
> >> Running the AIM7 fserver workload on a 2-socket 24-core 48-thread
> >> Broadwell system with a small xfs filesystem on ramfs, the performance
> >> increased from 91,486 jobs/min to 192,666 jobs/min with this change.
> > Oh, I just noticed you are using a ramfs for this benchmark,
> >
> > tl; dr: Once you pass a certain point, ramdisks can be *much* slower
> > than SSDs on journal intensive workloads like AIM7. Hence it would be
> > useful to see if you have the same problems on, say, high
> > performance nvme SSDs.
> 
> Oh sorry, I made a mistake.
> 
> There were some problems with my test configuration. I was actually
> running the test on a regular enterprise-class disk device mount on /.
> 
> Filesystem                              1K-blocks     Used Available
> Use% Mounted on
> /dev/mapper/rhel_hp--xl420gen9--01-root  52403200 11284408  41118792  22% /
> 
> It was not an SSD, nor ramdisk. I reran the test on ramdisk, the
> performance of the patched kernel was 679,880 jobs/min which was a bit
> more than double the 285,221 score that I got on a regular disk.

Can you please re-run and report the results for each patch on the
ramdisk setup? And, please, include the mkfs.xfs or xfs_info output
for the ramdisk filesystem so I can see /exactly/ how much
concurrency the filesystems are providing to the benchmark you are
running.

> So the filesystem used wasn't tiny, though it is still not very large.

50GB is tiny for XFS. Personally, I've been using ~1PB
filesystems(*) for the performance testing I've been doing
recently...

Cheers,

Dave.

(*) Yes, petabytes. Sparse image files on really fast SSDs are a
wonderful thing.
-- 
Dave Chinner
david@fromorbit.com
