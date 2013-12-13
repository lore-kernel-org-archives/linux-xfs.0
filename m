Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C9C907F4E
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 19:42:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE9BA8F8052
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 17:41:54 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	X62WNmcXDTXpMQdt for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 17:41:36 -0800 (PST)
Date: Fri, 13 Dec 2013 12:41:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfstests: do not unmount tmpfs during remount.
Message-ID: <20131213014131.GP10988@dastard>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-6-git-send-email-jayr@google.com>
	<20131211074615.GE19248@infradead.org>
	<20131211224012.GJ10988@dastard>
	<20131212180130.GA19422@infradead.org>
	<20131212225657.GK10988@dastard>
	<CAFA30n9ea3A+V7JgCgqO5xOQchgB55oLP4AgtQ3KQpCMr9iEzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFA30n9ea3A+V7JgCgqO5xOQchgB55oLP4AgtQ3KQpCMr9iEzQ@mail.gmail.com>
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
To: Junho Ryu <jayr@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>, Boris Ranto <branto@redhat.com>, xfs@oss.sgi.com

On Thu, Dec 12, 2013 at 04:00:44PM -0800, Junho Ryu wrote:
> > I don't know what the solution here is - everything I think of is
> > either messy, ugly or unmaintainable. All I'm trying to do is find a
> > way to handle tmpfs filesystems in a way that is maintainable and
> > doesn't require every developer to be aware of the quirks of tmpfs
> > when writing and reviewing new generic tests....
> 
> If it is acceptable that tmpfs running tests which does not make much
> sense without actually re-mounting devices, all other developers need
> to care is using _scratch_remount() and _test_remount().

And how are they to know whether it makes sense ot run on tmpfs or
not? That's the point I'm trying to make - tmpfs adds new
restrictions on how tests are written or constructed, and we still
need a method of saying no to tmpfs....

> Even if someone does not use the functions, tests will only fail on
> tmpfs, and people like me who cares about it will be happy to fix it.

Yes, that's the game of whack-a-mole I was talking about.

> So far, generic/053 is the only test which does something else between
> umount and mount.

All the generic tests that use dm_flakey are likely to be busted.
Anything assumes SCRATCH_DEV or TEST_DEV are block devices are
busted. Do loop devices work properly when hosted on tmpfs
filesystems? And so on...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
