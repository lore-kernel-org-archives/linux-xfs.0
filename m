Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E0B337CB1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 07:52:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B644F30404E
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 05:52:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 00bc6RpIELmb5663 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 05:52:13 -0700 (PDT)
Date: Wed, 6 Apr 2016 08:52:12 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 0/5] xfs; xfs_iflush_cluster vs xfs_reclaim_inode
Message-ID: <20160406125211.GD4188@bfoster.bfoster>
References: <1459934574-25543-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459934574-25543-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 07:22:49PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> There is a problem that RHEL QE tripped over on a long-running
> fsstress test on a RHEL 6.6. Brian did all the hard work of working
> out the initial cause of the GPF that was being tripped, but
> had not yet got past how to fix the issues around xfs_free_inode.
> The code is the same as the current upstream code, so the problem
> still exists....
> 
> The first patch fixes an obvious (now!) bug in xfs_iflush_cluster
> where it checks the wrong inode after lookup for validity. It still
> kind-of works, because the correct inode number is used for the "are
> we still in the right cluster" check, so it's not quite a hole the
> size of a truck. Still something that should not have slipped
> through 6 years ago and not been discovered until now...
> 
> The most important patch (#4) address the use-after-free issues that the
> xfs inode has w.r.t. RCU freeing and the lookup that
> xfs_iflush_cluster is doing under the rcu_read_lock. All the
> structures accessed under the RCU context need to be freed after the
> current RCU grace period expires, as RCU lookups may attempt to
> access them at any time during the grace period. hence we have to
> move them into the RCU callback so that we don't free them
> prematurely.
> 
> The rest of the patches are defensive in that they make
> xfs_iflush_cluster only act on relevant inodes and be able to
> guarantee detection inodes that are in the process of being freed.
> While these aren't absolutely necessary, it seems silly to ignore
> these obvious issues while I'm fixing up other issues with the same
> code.
> 
> There's some more detail on the fixes in the commit descriptions.
> 
> Brian, I've only run this through xfstests, so I have no real idea
> if it fixes the problem fsstress has uncovered. AIUI it takes 3 or 4
> days to reproduce the issue so this is kind of a pre-emptive strike
> on what I think is the underlying issue based on your description
> and commentary. I figured having code to explain the problems would
> save some time while you sleep....
> 
> Comments, thoughts, testing and flames all welcome...
> 

Thanks.. it looks mostly clean and logical to me on a first pass
through. I've reviewed the first three, which look straightforward, and
I'll follow up on the last couple once I've run through testing and had
a closer look.

To migrate some of the discussion over to the list... what I'm testing
now is an XFS_IRECLAIM flag check (and inode skip) on the inode in the
cluster flush path. This has run clean for the better part of yesterday
through overnight. While the test requires a few days to verify, the
hacked up kernel I've been testing with usually detects this a bit
sooner (within 6-8 hours or so), so I'm fairly confident that test at
least corners the problem.

The concern raised with the XFS_IRECLAIM check is that of performance
(skipping an inode flush when we don't need to). I'm not totally
convinced that's much of a problem considering how rare this situation
is. The best/only reproducer we have takes a couple days on a debug
kernel, for a bug that's been present for several years. The concern I
had with this approach was more that both codepaths seemed to have
trylock or checks that cause the reclaim or flush to "back off," and I
didn't want to create a situation where neither path would actually do
its job (potentially repeatedly) for a particular inode.

So that approach seemed cleaner than the alternative I was considering,
but the thought of pushing the i_itemp deallocation to the RCU callback
also crossed my mind later on yesterday after writing up my last report
on the bug. This series appears to move all of the deallocation (incl.
fork destruction) to the RCU cb, but that seems reasonable to me as
well. I think relying on RCU is probably the cleanest/most correct
approach so far, so I'll kill the currently running test, pull these
back to the rhel kernel and see how that goes.

Note that I haven't even attempted to reproduce this on an upstream
kernel simply because it's so difficult to reproduce. It's not even
consistently reproducible with the original kernel on different
hardware. I agree that the problem likely exists upstream, but I'm going
to continue to use the original kernel for verification because that
hw/kernel has provided a consistent reproducer...

Brian

> -Dave.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
