Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F5807F5E
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 04:00:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EDAF8F8039
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 02:00:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MemxOQvd0zAZ5094 for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 02:00:54 -0700 (PDT)
Date: Wed, 16 Apr 2014 19:00:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/19] VFS: use GFP_NOFS rather than GFP_KERNEL in
	__d_alloc.
Message-ID: <20140416090051.GK15995@dastard>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040337.10604.61837.stgit@notabene.brown>
	<20140416062520.GG15995@dastard>
	<20140416164941.37587da6@notabene.brown>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140416164941.37587da6@notabene.brown>
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
To: NeilBrown <neilb@suse.de>
Cc: linux-mm@kvack.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Apr 16, 2014 at 04:49:41PM +1000, NeilBrown wrote:
> On Wed, 16 Apr 2014 16:25:20 +1000 Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Wed, Apr 16, 2014 at 02:03:37PM +1000, NeilBrown wrote:
> > > __d_alloc can be called with i_mutex held, so it is safer to
> > > use GFP_NOFS.
> > > 
> > > lockdep reports this can deadlock when loop-back NFS is in use,
> > > as nfsd may be required to write out for reclaim, and nfsd certainly
> > > takes i_mutex.
> > 
> > But not the same i_mutex as is currently held. To me, this seems
> > like a false positive? If you are holding the i_mutex on an inode,
> > then you have a reference to the inode and hence memory reclaim
> > won't ever take the i_mutex on that inode.
> > 
> > FWIW, this sort of false positive was a long stabding problem for
> > XFS - we managed to get rid of most of the false positives like this
> > by ensuring that only the ilock is taken within memory reclaim and
> > memory reclaim can't be entered while we hold the ilock.
> > 
> > You can't do that with the i_mutex, though....
> > 
> > Cheers,
> > 
> > Dave.
> 
> I'm not sure this is a false positive.
> You can call __d_alloc when creating a file and so are holding i_mutex on the
> directory.
> nfsd might also want to access that directory.
> 
> If there was only 1 nfsd thread, it would need to get i_mutex and do it's
> thing before replying to that request and so before it could handle the
> COMMIT which __d_alloc is waiting for.

That seems wrong - the NFS client in __d_alloc holds a mutex on a
NFS client directory inode. The NFS server can't access that
specific mutex - it's on the other side of the "network". The NFS
server accesses mutexs from local filesystems, so __d_alloc would
have to be blocked on a local filesystem inode i_mutex for the nfsd
to get hung up behind it...

However, my confusion comes from the fact that we do GFP_KERNEL
memory allocation with the i_mutex held all over the place. If the
problem is:

	local fs access -> i_mutex
.....
	nfsd -> i_mutex (blocked)
.....
	local fs access -> kmalloc(GFP_KERNEL)
			-> direct reclaim
			-> nfs_release_page
			-> <send write/commit request to blocked nfsds>
			   <deadlock>

then why is it just __d_alloc that needs this fix?  Either this is a
problem *everywhere* or it's not a problem at all.

If it's a problem everywhere it means that we simply can't allow
reclaim from localhost NFS mounts to run from contexts that could
block an NFSD. i.e. you cannot run NFS client memory reclaim from
filesystems that are NFS server exported filesystems.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
