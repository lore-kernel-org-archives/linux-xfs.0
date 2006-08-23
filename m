Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Aug 2006 21:50:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7N4nODW001957
	for <linux-xfs@oss.sgi.com>; Tue, 22 Aug 2006 21:49:38 -0700
Date: Wed, 23 Aug 2006 14:48:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Infinite loop in xfssyncd on full file system
Message-ID: <20060823044829.GD807872@melbourne.sgi.com>
References: <Pine.LNX.4.64.0608221318300.3139@madrid.max-t.internal> <20060823040218.GC807872@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060823040218.GC807872@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Stephane Doyon <sdoyon@max-t.com>
Cc: linux-xfs@oss.sgi.com, lnx1138@us.ibm.com

On Wed, Aug 23, 2006 at 02:02:18PM +1000, David Chinner wrote:
> On Tue, Aug 22, 2006 at 04:01:10PM -0400, Stephane Doyon wrote:
> > I'm seeing what appears to be an infinite loop in xfssyncd. It is 
> > triggered when writing to a file system that is full or nearly full. I 
> > have pinpointed the change that introduced this problem: it's
> > 
> >     "TAKE 947395 - Fixing potential deadlock in space allocation and
> >     freeing due to ENOSPC"
> > 
> > git commit d210a28cd851082cec9b282443f8cc0e6fc09830.
> 
> Thanks for tracking that down - I've been trying to isolate a test case
> for another report of this looping in xfssyncd.
> 
> [Luciano - this is the same problem we've been trying to track down.]
> 
> > I hope you XFS experts see what might be wrong with that bug fix. It's 
> > ironic but for me, this (apparent) infinite loop seems much easier to hit 
> > than the out-of-order locking problem that the commit in question was 
> > supposed to fix. Let me know if I can get you any more info.
> 
> Now we know what patch introduces the problem, we know where to look.
> Stay tuned...

I've had a quick look at the above commit. I'm not yet certain that
everything is correct in terms of the semantics laid down in the
change or that enough blocks are reserved for btree splits , but I
can see a hole in the implementation on multiprocessor machines.

Stephane/Luciano - can you test the following patch (note: compile
tested only) and see if it fixes the problem?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_mount.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2006-08-18 15:29:28.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2006-08-23 14:28:18.059385018 +1000
@@ -2108,11 +2108,11 @@ again:
 	case XFS_SBS_FDBLOCKS:
 		BUG_ON((mp->m_resblks - mp->m_resblks_avail) != 0);
 
-		lcounter = icsbp->icsb_fdblocks;
+		lcounter = icsbp->icsb_fdblocks - SET_ASIDE_BLOCKS;
 		lcounter += delta;
 		if (unlikely(lcounter < 0))
 			goto slow_path;
-		icsbp->icsb_fdblocks = lcounter;
+		icsbp->icsb_fdblocks = lcounter + SET_ASIDE_BLOCKS;
 		break;
 	default:
 		BUG();
