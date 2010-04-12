Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1IiRA177920 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:44 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 33DE91269E1F
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	zDzaZ47Igh8kZYhe for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:38 -0700 (PDT)
Date: Tue, 13 Apr 2010 08:32:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
Message-ID: <20100412223241.GM2493@dastard>
References: <201004050049.17952.hpj@urpla.net> <20100406231144.GF11036@dastard>
	<20100407014533.GI11036@dastard> <201004080002.21137.hpj@urpla.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201004080002.21137.hpj@urpla.net>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 08, 2010 at 12:02:20AM +0200, Hans-Peter Jansen wrote:
> On Wednesday 07 April 2010, 03:45:33 Dave Chinner wrote:
> >
> > However, if the memory pressure is purely inode cache (creating zero
> > length files or read-only traversal), then the OOM killer kicks a
> > while after the slab cache fills memory.  This doesn't need highmem;
> > I used a x86_64 kernel on a VM w/ 1GB RAM to reliably reproduce
> > this.  I'll add zero length file tests and traversals to my low
> > memory testing.
> 
> I'm glad, that you're able to reproduce it. My initial failure was during 
> disk to disk backup (with a simple cp -al & rsync combination).
> 
> > The best way to fix this, I think, is to trigger a shrinker callback
> > when memory is low to run the background inode reclaim. The problem
> > is that these inode caches and the reclaim state are per-filesystem,
> > not global state, and the current shrinker interface only works with
> > global state.
> >
> > Hence there are two patches to this fix - the first adds a context
> > to the shrinker callout, and the second adds the XFS infrastructure
> > to track the number of reclaimable inodes per filesystem and
> > register/unregister shrinkers for each filesystem.
> 
> I see, the first one will be interesting to get into mainline, given the 
> number of projects, that are involved. 
> 
> > With these patches, my reproducable test case which locked the
> > machine up with a OOM panic in a couple of minutes has been running
> > for over half an hour. I have much more confidence in this change
> > with limited testing than the reverting of the background inode
> > reclaim as the revert introduces
> >
> > The patches below apply to the xfs-dev tree, which is currently at
> > 34-rc1. If they don't apply, let me know and I'll redo them against
> > a vanilla kernel tree. Can you test them to see if the problem goes
> > away? If the problem is fixed, I'll push them for a proper review
> > cycle...
> 
> Of course, you did the original patch for a reason... Therefor I would love 
> to test your patches. I've tried to apply them to 2.6.33.2, but after 
> fixing the same reject as noted below, I'm stuck here:
> 
> /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c: 
> In function 'xfs_reclaim_inode_shrink':
> /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c:805: 
> error: implicit declaration of function 'xfs_perag_get'
> /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c:805: 
> warning: assignment makes pointer from integer without a cast
> /usr/src/packages/BUILD/kernel-default-2.6.33.2/linux-2.6.33/fs/xfs/linux-2.6/xfs_sync.c:807: 
> error: implicit declaration of function 'xfs_perag_put'
> 
> Now I see, that there happened a rename of the offending functions, but also 
> they've grown a radix_tree structure and locking. How do I handle that?

With difficulty. I'd need to backport it to match the .33 code,
which may or may not be trivial...

> BTW, your patches do not apply to Linus' current git tree either:
> patching file fs/xfs/quota/xfs_qm.c
> Hunk #1 succeeded at 72 (offset 3 lines).
> Hunk #2 FAILED at 2120.
> 1 out of 2 hunks FAILED -- saving rejects to file fs/xfs/quota/xfs_qm.c.rej
> I'm able to resolve this, but 2.6.34-current does give me some other 
> trouble, that I need to get by (PS2 keyboard stops working eventually)..

Yeah, there's another patch in my xfs-dev tree that changes that.
I'll rebase it on a clean linux tree before I post it again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
