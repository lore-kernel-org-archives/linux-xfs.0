Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC51E29DF8
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 21:19:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8E78304067
	for <xfs@oss.sgi.com>; Thu,  9 May 2013 19:19:45 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	D8P9OBC2pENvD5TZ for <xfs@oss.sgi.com>;
	Thu, 09 May 2013 19:19:44 -0700 (PDT)
Date: Fri, 10 May 2013 12:19:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rambling noise #1: generic/230 can trigger kernel debug lock
	detector
Message-ID: <20130510021942.GP23072@dastard>
References: <518B08D9.1060906@gmail.com> <20130509031646.GN24635@dastard>
	<20130509072045.GO24635@dastard> <518C54AA.7070908@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <518C54AA.7070908@gmail.com>
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
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, May 09, 2013 at 10:00:10PM -0400, Michael L. Semon wrote:
> On 05/09/2013 03:20 AM, Dave Chinner wrote:
> >On Thu, May 09, 2013 at 01:16:46PM +1000, Dave Chinner wrote:
> >>On Wed, May 08, 2013 at 10:24:25PM -0400, Michael L. Semon wrote:
> >>>Hi!  I'm trying to come up with a series of ramblings that may or
> >>>may not be useful in a mailing-list context, with the idea that one
> >>>bug report might be good, the next might be me thinking aloud with
> >>>data in hand because I know something's wrong but can't put my
> >>>finger on it.  An ex-girlfriend saw the movie "Rain Man" years ago
> >>>pointed to the screen and said, "Do you see that guy?  That's you!"
> >>>If only I could be so smart...or act as well as Dustin Hoffman.  The
> >>>noisy thinking is there, just not the brilliant insights...
> >>>
> >>>This report is to pass on a kernel lock detector message that might
> >>>be reproducible under a certain family of tests.  generic/230 may
> >>>not be at fault, it's just where the detector went off.
> >>
> >>No, there's definitely a bug there. Thanks for the report, Michael.
> >>Try the patch below.
> >
> >Actaully, there's a bug in the error handling in that version - it
> >fails to unlock the quotaoff lock properly on failure. The version
> >below fixes that problem.
> >
> >Cheers,
> >
> >Dave.
> 
> OK, I'll try this version as well.  The first version seemed to work
> just fine.

It should, the bug was in an error handling path you are unlikely to
hit.

> xfs/012 13s ...[ 1851.323902]
> [ 1851.325479] =================================
> [ 1851.326551] [ INFO: inconsistent lock state ]
> [ 1851.326551] 3.9.0+ #1 Not tainted
> [ 1851.326551] ---------------------------------
> [ 1851.326551] inconsistent {RECLAIM_FS-ON-R} -> {IN-RECLAIM_FS-W} usage.
> [ 1851.326551] kswapd0/18 [HC0[0]:SC0[0]:HE1:SE1] takes:
> [ 1851.326551]  (&(&ip->i_lock)->mr_lock){++++-+}, at: [<c11dcabf>]
> xfs_ilock+0x10f/0x190
> [ 1851.326551] {RECLAIM_FS-ON-R} state was registered at:
> [ 1851.326551]   [<c105e10a>] mark_held_locks+0x8a/0xf0
> [ 1851.326551]   [<c105e69c>] lockdep_trace_alloc+0x5c/0xa0
> [ 1851.326551]   [<c109c52c>] __alloc_pages_nodemask+0x7c/0x670
> [ 1851.326551]   [<c10bfd8e>] new_slab+0x6e/0x2a0
> [ 1851.326551]   [<c14083a9>] __slab_alloc.isra.59.constprop.67+0x1d3/0x40a
> [ 1851.326551]   [<c10c12cd>] __kmalloc+0x10d/0x180
> [ 1851.326551]   [<c1199b56>] kmem_alloc+0x56/0xd0
> [ 1851.326551]   [<c1199be1>] kmem_zalloc+0x11/0xd0
> [ 1851.326551]   [<c11c666e>] xfs_dabuf_map.isra.2.constprop.5+0x22e/0x520

Yup, needs a KM_NOFS allocation there because we come through
here outside a transaction and so it doesn't get KM_NOFS implicitly
in this case. There's been a couple of these reported in the past
week or two - I need to do an audit and sweep them all up....

Technically, though, this can't cause a deadlock on the inode we
hold a lock on here because it's a directory inode, not a regular
file and so it will never be seen in the reclaim data writeback path
nor on the inode LRU when the shrinker runs. So most likely it is a
false positive...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
