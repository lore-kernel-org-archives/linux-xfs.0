Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2KMjMwr022339 for <xfs@oss.sgi.com>; Tue, 20 Mar 2012 17:45:23 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0r820gOnspMClLtc for <xfs@oss.sgi.com>;
	Tue, 20 Mar 2012 15:45:20 -0700 (PDT)
Date: Wed, 21 Mar 2012 09:45:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/10] xfs: introduce an allocation workqueue
Message-ID: <20120320224517.GR5091@dastard>
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-6-git-send-email-david@fromorbit.com>
	<4F676330.1070005@sgi.com> <20120319222016.GZ3592@dastard>
	<4F68B188.4020407@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F68B188.4020407@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 20, 2012 at 11:34:16AM -0500, Mark Tinguely wrote:
> On 03/19/12 17:20, Dave Chinner wrote:
> >Yeah, I know. Stack usage has been a problem for years and years. I
> >even mentioned at last year's Kernel Summit that we needed to
> >consider increasing the size of the kernel stack to 16KB to support
> >typical storage configurations. That was met with the same old "so
> >what?" response: "your filesystem code is broken". I still haven;t
> >been able to get across that it isn't the filesystems that are
> >causing the problems.
> >
> >For example, what's a typical memory allocation failure stack look
> >like? Try this:
> >
> >
> >   0)     5152     256   get_page_from_freelist+0x52d/0x840
.....
> >  32)     1632     112   kmem_alloc+0x67/0xe0
> >  33)     1520     144   xfs_log_commit_cil+0xfe/0x540
> >  34)     1376      80   xfs_trans_commit+0xc2/0x2a0
> >  35)     1296     192   xfs_dir_ialloc+0x120/0x320
> >  36)     1104     208   xfs_create+0x4df/0x6b0
> >  37)      896     112   xfs_vn_mknod+0x8f/0x1c0
> >  38)      784      16   xfs_vn_create+0x13/0x20
> >  39)      768      64   vfs_create+0xb4/0xf0
> >....
> 
> 
> Wow, that much stack to clean and allocate a page. I am glad I did not
> know that week, I would have had a stroke instead of a rant.

It's not worth that much rage :P

> >Any metadata read we do that hits a pinned buffer needs a minimum
> >1500 bytes of stack before we hit the driver code, which from the
> >above swap trace, requires around 1300 bytes to dispatch safely for
> >the SCSI stack. So we can't safely issue a metadata *read* without
> >having about 3KB of stack available. And given that if we do a
> >double btree split and have to read in a metadata buffer, that means
> >we can't start the allocation with more than about 2KB of stack
> >consumed. And that is questionable when we add MD/DM layers into the
> >picture as well....
> >
> >IOWs, there is simply no way we can fit an allocation call chain
> >into an 8KB stack when even a small amount of stack is consumed
> >prior to triggering allocation. Pushing the allocation off into it's
> >own context is, AFAICT, the only choice we have here to avoid stack
> >overruns because nobody else wants to acknowledge there is a
> >problem.
> 
> Sigh. Also part of my rant that I can't believe that this is an issue
> in LINUX.

The problem is more of a political/perception problem than a
technical one. The code to make the stacks discontiguous, larger or
even only fall back to discontiguous vmap()d memory when contiguous
allocation fails is relatively simple to add.

> The other half of my rant is:
> 
> I haven't seen XFS on a stack reduction in new code nor existing code
> (splitting routines and local variables) but I know that can only go
> so far.

That's because we did a massive stack reduction push back around
2005-2007 that trimmed all the low hanging fruit from the tree.
Since then, it's major code refactoring efforts that have reduced
the stack footprint, but those are hard to do and test. For example,
removing all the xfs_iomap indirection from writeback. Refactoring
xfs_bmapi() in multiple functions and splitting the read and write
mappings into separate functions. Greatly simplifying the writeback
path and reducing the amount of state held in the .writepage path.

> Filesystems, network stacks, well any kernel services, can't play
> "Whack-a-mole" with the stack issues for long. The problems will just
> pop up somewhere else.

Right, that's exactly the problem we are seeing now. We played
filesystem whack-a-mole years ago, and now the problem is that all
the subsystems above and below have grown....

> I suspect it will take a big group of choir-members, the companies
> they work for and the customers they represent to change the situation.
> Sad. How can we get everyone in a rant over this situation?

Doesn't matter about companies - the only way to get such a change
through is to convince Linus and the inner cabal that it is
necessary. They are the ones that say "your code is broken" rather
than acknowledging that the ever increasing complexity of the
storage stack is the reason we are running out of stack....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
