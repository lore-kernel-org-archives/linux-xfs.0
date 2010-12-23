Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBN1Dqf9062696 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 19:13:52 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAC131CED6BC
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 17:15:49 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	U6QkYGXy9W5ihF3h for <xfs@oss.sgi.com>;
	Wed, 22 Dec 2010 17:15:49 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50291609-1927428
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 11:45:48 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1PVZmU-0004iZ-FV
	for xfs@oss.sgi.com; Thu, 23 Dec 2010 12:15:46 +1100
Date: Thu, 23 Dec 2010 12:15:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/34] xfs: scalability patchset for 2.6.38
Message-ID: <20101223011546.GK4907@dastard>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Tue, Dec 21, 2010 at 06:28:56PM +1100, Dave Chinner wrote:
> Folks,
> 
> I'm sending the entire series of scalability patches in a single
> patchbomb because I'm tired and it's too much like hard work to send
> it out in multiple patchsets (i.e. I'm being lazy). Overall there
> are relatively few changes:
> 
> - new patch for iolock lockdep annotations
> - new patch for allocations under ilock
> 
> rcu inode freeing and lookup:
> - reworked reclaim to use rcu read locking
> - removed synchronise_rcu() from lookup failure
> - cleaned up validity checks, added comments and rcu_read_lock_held
>   annotations
> 
> AIL locking
> - fixed aild sleep to use TASK_INTERRUPTABLE
> 
> Log grant scaling
> - made reserveq/writeq tracing just indicate if there are queued
>   tickets.
> - cleaned up some minor formatting nitpicks suggested by Christoph
> - split xlog_space_left() into __xlog_space_left() for AIl tail
>   pushing to work off a single tail lsn value.
> 
> I'm mainly concerned with getting reviews for the few remaining
> patches that don't currently have reviewed-by tags. Christoph, I
> think I've fixed all the things your last round of comments covered,
> so there should be relatively little remaining to be fixed up.
> 
> The series is in the following git tree which is based on the
> current OSS xfs tree. Alex, once I get the remaining reviews
> complete I'll update the branch and send you a pull request.

I've just pushed a new version out with all the new reviewed-by tags
and fixups noticed.

	git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git xfs-for-2.6.38

kernel.org is pretty slow right now, so it might take a while for
it to propagate through.

The patches I still need reviews for are:

lib: percpu counter add unless less than functionality
xfs: dynamic speculative EOF preallocation
xfs: convert l_tail_lsn to an atomic variable

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
