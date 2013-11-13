Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 726B47F89
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 23:40:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 275ED30405F
	for <xfs@oss.sgi.com>; Tue, 12 Nov 2013 21:40:17 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kmlgo37m5q7sZclQ for <xfs@oss.sgi.com>;
	Tue, 12 Nov 2013 21:40:11 -0800 (PST)
Date: Wed, 13 Nov 2013 16:40:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/4] xfs: parallel quota check
Message-ID: <20131113054006.GF6188@dastard>
References: <5281F4EB.9060108@oracle.com> <20131112210349.GA6188@dastard>
	<5282E3A4.4030506@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5282E3A4.4030506@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Nov 13, 2013 at 10:27:48AM +0800, Jeff Liu wrote:
> Thanks for your quick response!
> 
> On 11/13 2013 05:03 PM, Dave Chinner wrote:
> > On Tue, Nov 12, 2013 at 05:29:15PM +0800, Jeff Liu wrote:
> >> Hi Folks,
> >>
> >> We have a user report about skip quota check on first mount/boot several
> >> monthes ago, the original discussion thread can be found at:
> >> http://oss.sgi.com/archives/xfs/2013-06/msg00170.html.
> >>
> >> As per Dave's suggestion, it would be possible to perform quota check
> >> in parallel, this patch series is just trying to follow up that idea.
> >>
> >> Sorry for the too long day as I have to spent most of time dealing with
> >> personl things in the last few monthes, I was afraid I can not quickly
> >> follow up the review procedure.  Now the nightmare is over, it's time to
> >> revive this task.
> >>
> >> Also, my previous test results on my laptop and a poor desktop can not
> >> convience me that performs parallism quota check can really get benefits
> >> compare to the current single thread as both machines are shipped with
> >> slow disks, I even observed a little performance regression with millions
> >> of small files(e.g, 100 bytes) as quota check is IO bound, additionaly,
> >> it could affected by the seek time differences.  Now with a Mackbook Air
> >> I bought recently, it can show significant difference.
> > 
> > Results look good - they definitely point out that we can improve
> > the situation here.
> > 
> >> In order to get some more reasonable results, I ask a friend helping
> >> run this test on a server which were shown as following.
> >>
> >> test environment
> >> - 16core, 25G ram, normal SATA disk, but the XFS is resides on a loop dev. 
> > ....
> >>
> >> In this case, there is no regression although there is no noticeable
> >> improvements. :(
> > 
> > Which is no surprise - there isn't any extra IO parallelism that can
> > be extracted from a single spindle....
> > 
> >> test environment
> >> - Macbook Air i7-4650U with SSD, 8G ram
> >>
> >> - # of file(million)	default			patched
> >> 	1		real 0m6.367s		real 0m1.972s
> >> 			user 0m0.008s		user 0m0.000s
> >> 			sys  0m2.614s		sys  0m0.008s
> >>
> >> 	2		real 0m15.221s		real 0m3.772s
> >> 			user 0m0.000s		user 0m0.000s
> >> 			sys  0m6.269s		sys  0m0.007s
> >>
> >> 	5		real 0m36.036s		real 0m8.902s
> >> 			user 0m0.000s		user 0m0.002s
> >> 			sys  0m14.025s		sys  0m0.006s
> > 
> > But a SSD or large raid array does have unused IO parallelism we can
> > exploit. ;)
> > 
> > Note that there is also the possibility of applying too much
> > parallelism for the underlying storage (think of a filesystem with
> > hundreds of AGs on a limited number of spindles) and hence causing
> > degradations due to seeking. Hence it might be worthwhile to limit
> > the number of AGs being scanned concurrently...
> Ok, maybe it could be a new mount option to let user decide how to deal
> with it in this situation, let me think it over.

I'd prefer that we just do it automatically. There's a diminishing
return curve that adding more parallelism will result in, so as long
as we don't go too far down the tail of the curve it should not be a
problem.

Also, keep in mind if you issue too much readahead to a block device
and the queue becomes read congested, it will just drop new
readahead attempts. This is another reason for limiting the
parallelism and hence the amount of readahead we issue....

> >> Btw, The current implementation has a defeat considering the duplicated
> >> code at [patch 0/4] xfs: implement parallism quota check at mount time.
> >> Maybe it's better to introduce a new function xfs_bulkstat_ag() which can
> >> be used to bulkstat inodes per ag, hence it could shared at above patch while
> >> adjusting dquota usage per ag, i.e, xfs_qm_dqusage_adjust_perag().
> > 
> > Right, there are uses for AG-based parallelism of bulkstat for
> > userspace, so exposing single AG scans via the bulkstat ioctl is
> > something I've been intending to do for some time.  Hence I'd much
> > prefer to see xfs_bulkstat_ag() to be implemented and then the
> > quotacheck code converted to use it rather than duplicating the
> > algorithm and code specifically to parallelise quotacheck.
> Thanks for the confirmation, this change will be reflected in the next
> round of post.
> 
> > 
> > I like the factoring of the bulkstat code (about time we did that),
> > but I think the factored functions should remain in xfs-itable.c
> > with the rest of the bulkstat code for now...
> > 
> > Also, there's a race condition you haven't handled in the quotacheck
> > code: xfs_qm_quotacheck_dqadjust() can now be called concurrently on
> > a dquot from different threads to update the same dquot, and there's
> > no locking of the dquot to prevent this.
> Ah, will fix it, why I have not found this problem in the previous test? :-P

Because it is simply assumed that the quotacheck gets the
calculation correct? i.e. the calculated values are not actually
validated anywhere except in xfstests that have limited scope for
quotacheck parallelism...

> > As to the workqueues for threading, it seems overly complex. You
> > could create a permanent workqueue in xfs_init_workqueues() for
> > this, and you can use flush_workqueue() to execute and wait for all
> > the per-ag scans to complete once they have been queued. This gets
> > rid of all the lists and completions from the code.
> At that time, I thought the workqueue should be destroyed once the quota
> check procedure is complete as it only run once at mount time, will take care
> of it.

I understand. Having a workqueue sit around idle does not take up
any resources, so I don't think we need the complexity of making
them dynamic...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
