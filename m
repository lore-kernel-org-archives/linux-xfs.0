Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4N1Kej6232842 for <xfs@oss.sgi.com>; Sun, 22 May 2011 20:20:40 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 249CE1E3361A
	for <xfs@oss.sgi.com>; Sun, 22 May 2011 18:20:38 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	OC638eSmG9DAZfOB for <xfs@oss.sgi.com>;
	Sun, 22 May 2011 18:20:38 -0700 (PDT)
Date: Mon, 23 May 2011 11:20:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110523012034.GA32466@dastard>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard> <20110522075955.GA2341@citd.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110522075955.GA2341@citd.de>
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
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Marc Lehmann <schmorp@schmorp.de>, xfs@oss.sgi.com

On Sun, May 22, 2011 at 09:59:55AM +0200, Matthias Schniedermeyer wrote:
> On 22.05.2011 12:00, Dave Chinner wrote:
> > 
> > I don't really care what you think the problem is based on what
> > you've read in this email thread, or for that matter how you think
> > we should fix it. What I really want is your test cases that
> > reproduce the problem so I can analyse it for myself. Once I
> > understand what is going on, then we can talk about what the real
> > problem is and how to fix it.
> 
> What would interest me is why the following creates files with large 
> preallocations.
> 
> cp -a <somedir> target
> rm -rf target
> cp -a <somedir> target
> 
> After the first copy everything looks normal, `du` is about the 
> original value.
> 
> After the second run a `du` shows a much higher value, until the 
> preallocation is shrunk away.

That's obviously a bug. It's also a simple test case that is easy to
reproduce - exactly what I like in a bug report. ;)

The inodes are being recycled off the reclaimable list in the second
case i.e. we're short-circuiting the inode lifecycle and making it
new again because it has been reallocated. The XFS_IDIRTY_RELEASE
flag is not being cleared in this case, so we are not removing the
speculative preallocation when the fd is closed for the second copy.

The patch below fixes this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: clear inode dirty release flag when recycling it

From: Dave Chinner <dchinner@redhat.com>

The state used to track dirty inode release calls is not reset when
an inode is reallocated and reused from the reclaimable state. This
leads to specualtive preallocation not being truncated away in the
expected manner for local files until the inode is subsequently
truncated, freed or cycles out of the cache.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iget.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index cb9b6d1..e75e757 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -241,6 +241,13 @@ xfs_iget_cache_hit(
 		 */
 		ip->i_flags |= XFS_IRECLAIM;
 
+		/*
+		 * clear the dirty release state as we are now effectively a
+		 * new inode and so we need to treat speculative preallocation
+		 * accordingly.
+		 */
+		ip->i_flags &= ~XFS_IDIRTY_RELEASE;
+
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
