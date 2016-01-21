Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E676A7F37
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 04:21:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D62108F8054
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2016 02:21:37 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 4eJA9utaEZxp4mXL (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jan 2016 02:21:35 -0800 (PST)
Date: Thu, 21 Jan 2016 11:21:30 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
Message-ID: <20160121102129.GD29520@dhcp22.suse.cz>
References: <1452661968-11482-1-git-send-email-david@fromorbit.com>
	<20160120084750.GA14187@dhcp22.suse.cz>
	<20160120211944.GE20456@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160120211944.GE20456@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jkosina@suse.cz, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Hendrik Woltersdorf <hendrikw@arcor.de>, xfs@oss.sgi.com

[CCing Rafael - the thread starts here
http://lkml.kernel.org/r/1452661968-11482-1-git-send-email-david%40fromorbit.com]

On Thu 21-01-16 08:19:44, Dave Chinner wrote:
> On Wed, Jan 20, 2016 at 09:47:50AM +0100, Michal Hocko wrote:
> > On Wed 13-01-16 16:12:48, Dave Chinner wrote:
> > > This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
> > > prevents machines from suspending. This regression occurs when the
> > > xfsaild is idle on entry to suspend, and so there s no activity to
> > > wake it from it's idle sleep and hence see that it is supposed to
> > > freeze. Hence the freezer times out waiting for it and suspend is
> > > cancelled.
> > > 
> > > There is no obvious fix for this short of freezing the filesystem
> > > properly, so revert this change for now.
> > 
> > We had a similar report opensuse bugzilla just recently. I believe the
> > proper fix should be the following:
> ....
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index aa67339b9537..d6c9c3e9e02b 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> > @@ -520,14 +520,14 @@ xfsaild(
> >  		if (!xfs_ail_min(ailp) &&
> >  		    ailp->xa_target == ailp->xa_target_prev) {
> >  			spin_unlock(&ailp->xa_lock);
> > -			schedule();
> > +			freezable_schedule();
> 
> Oh, wonderful. A completely separate set of undocumented schedule
> functions defined inside the freezer header files that are needed
> just for freezable kthreads.

Yeah, I am not really happy about them either.

> Perhaps there should be some documentation somewhere on how to write
> suspend safe kthreads?

There is something in Documentation/power/freezing-of-tasks.txt but
freezable_schedule* is not mentioned there. Prhaps something like the
following would make it more clear?

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 85894d83b352..4df53f0c05a6 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -56,8 +56,11 @@ calling try_to_freeze().  The main loop of a freezable kernel thread may look
 If a freezable kernel thread fails to call try_to_freeze() after the freezer has
 initiated a freezing operation, the freezing of tasks will fail and the entire
 hibernation operation will be cancelled.  For this reason, freezable kernel
-threads must call try_to_freeze() somewhere or use one of the
-wait_event_freezable() and wait_event_freezable_timeout() macros.
+threads must call try_to_freeze() somewhere, use wait_event_freezable*()
+and wait_event_freezable_timeout() macros or use freezable_schedule* to hide
+the kernel thread from the suspend if it is guaranteed that a later wake up
+cannot interact with the suspend process (e.g. there is a try_to_freeze call
+or no IO is submitted or any of the suspended devices is not accessed etc..)
 
 After the system memory state has been restored from a hibernation image and
 devices have been reinitialized, the function thaw_processes() is called in

> This is too late for the current merge window, but I'll queue it up
> for the next one so we can get some testing on it first.

Sure, no problem and thanks!
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
