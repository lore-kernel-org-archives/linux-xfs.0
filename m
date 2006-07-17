Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Jul 2006 04:06:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6HB66DW024654
	for <xfs@oss.sgi.com>; Mon, 17 Jul 2006 04:06:20 -0700
Date: Mon, 17 Jul 2006 21:05:01 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH] xfs: i_state of inode is changed after the inode is freed
Message-ID: <20060717210501.A1895298@wobbly.melbourne.sgi.com>
References: <20060710103740.B1674239@wobbly.melbourne.sgi.com> <20060714192520m-saito@mail.aom.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060714192520m-saito@mail.aom.tnes.nec.co.jp>; from m-saito@tnes.nec.co.jp on Fri, Jul 14, 2006 at 07:25:20PM +0900
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Masayuki Saito <m-saito@tnes.nec.co.jp>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Fri, Jul 14, 2006 at 07:25:20PM +0900, Masayuki Saito wrote:
> Hi, Nathan.
> 
> >I'll leave it to Dave to comment more later (he's travelling at the
> >moment), since he's had his head deep in this area of the code most
> >recently - but my first thoughts on your patch are that its solving
> >the problem incorrectly.  We should not be in the destroy_inode code
> >if the inode reference counting is correct everywhere - I would have
> >expected the fix to be a get/put style change, rather than adding an
> >inode lock and new lock/unlock semantics around an individual field;
> >... and if that cannot be done to fix this (eh?), then some comments
> >as to why refcounting didn't solve the problem here.
> 
> On the basis of the above, I consider the get/put style fix which use
> i_count.
> 
> This problem is that i_state of the inode is changed while the inode
> is freed in xfs filesystem.  And the cause is that the inode release
> and xfs_iunpun() can run in parallel.
> 
> To fix this problem, I added a pair of igrab()/iput() before and behind
> mark_inode_dirty_sync() at xfs_iunpin().  I think this can change it as
> follows.
> 
> (1)The case that the inode release transaction runs after xfs_iunpin()
> is called.
> While mark_inode_dirty_sync() is running, igrab() promises that the
> inode is alive.
> 
> (2)The case that xfs_iunpin() is called after iput() in the inode
> release transaction is called(i_count is 0).
> mark_inode_dirty_sync() is not called because the igrab() can not get
> the inode.
> 
> I have made the following patch, but it is not yet tested.
> I would like to hear your comment, first.

If this fixes your test case, then I like the look of it. ;-)

It does seem much simpler and less invasive than the earlier fix
using a spinlock.  I'll run with this in my testing for awhile,
let me know how your own testing goes too, please (I especially
would like to hear if it fixes that reproducible failure case).

thanks!

-- 
Nathan
