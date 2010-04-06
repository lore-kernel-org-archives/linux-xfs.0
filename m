Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o36Epagr109152 for <xfs@oss.sgi.com>; Tue, 6 Apr 2010 09:51:37 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 622CE29F5A5
	for <xfs@oss.sgi.com>; Tue,  6 Apr 2010 07:53:24 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.187]) by cuda.sgi.com with ESMTP id
	51oomffbmHTAJCXp for <xfs@oss.sgi.com>;
	Tue, 06 Apr 2010 07:53:24 -0700 (PDT)
From: "Hans-Peter Jansen" <hpj@urpla.net>
Subject: Re: 2.6.34-rc3: simple du (on a big xfs tree) triggers oom killer
	[bisected: 57817c68229984818fea9e614d6f95249c3fb098]
References: <201004050049.17952.hpj@urpla.net>
	<201004051335.41857.hpj@urpla.net> <20100405230600.GA3335@dastard>
In-Reply-To: <20100405230600.GA3335@dastard>
MIME-Version: 1.0
Content-Disposition: inline
Date: Tue, 6 Apr 2010 16:52:57 +0200
Message-Id: <201004061652.58189.hpj@urpla.net>
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
To: Dave Chinner <david@fromorbit.com>
Cc: opensuse-kernel@opensuse.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Dave,

On Tuesday 06 April 2010, 01:06:00 Dave Chinner wrote:
> On Mon, Apr 05, 2010 at 01:35:41PM +0200, Hans-Peter Jansen wrote:
> > >
> > > Oh, this is a highmem box. You ran out of low memory, I think, which
> > > is where all the inodes are cached. Seems like a VM problem or a
> > > highmem/lowmem split config problem to me, not anything to do with
> > > XFS...

With all due respect, I disagree. See below.

> > Might be, I don't have a chance to test this on a different FS. Thanks
> > for the answer anyway, Dave. I hope, you don't mind, that I keep you
> > copied on this thread..
> >
> > This matter is, I cannot locate the problem from the syslog output.
> > Might be a "can't see the forest because all the trees" syndrome.
>
> Well, I have to ask why you are running a 32bit PAE kernel when your
> CPU is:
>
> <6>[    0.085062] CPU0: Intel(R) Xeon(R) CPU           X3460  @ 2.80GHz
> stepping 05
>
> 64bit capable.  Use a 64 bit kernel and this problem should go away.

Sure, but for compatibility reasons with a customer setup, that I'm fully 
responsible for and we strongly depend on, it is i586 still. (and it's a 
system, that I've full access on only for a few hours on sundays, which 
punishes my family..).

Dave, I really don't want to disappoint you, but a lengthy bisection session 
points to:

57817c68229984818fea9e614d6f95249c3fb098 is the first bad commit
commit 57817c68229984818fea9e614d6f95249c3fb098
Author: Dave Chinner <david@fromorbit.com>
Date:   Sun Jan 10 23:51:47 2010 +0000

    xfs: reclaim all inodes by background tree walks
    
    We cannot do direct inode reclaim without taking the flush lock to
    ensure that we do not reclaim an inode under IO. We check the inode
    is clean before doing direct reclaim, but this is not good enough
    because the inode flush code marks the inode clean once it has
    copied the in-core dirty state to the backing buffer.
    
    It is the flush lock that determines whether the inode is still
    under IO, even though it is marked clean, and the inode is still
    required at IO completion so we can't reclaim it even though it is
    clean in core. Hence the requirement that we need to take the flush
    lock even on clean inodes because this guarantees that the inode
    writeback IO has completed and it is safe to reclaim the inode.
    
    With delayed write inode flushing, we coul dend up waiting a long
    time on the flush lock even for a clean inode. The background
    reclaim already handles this efficiently, so avoid all the problems
    by killing the direct reclaim path altogether.
    
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Alex Elder <aelder@sgi.com>

:040000 040000 9cada5739037ecd59afb358cf5ed6186b82d5236 
8e6b6febccba69bc4cdbfd1886d545c369d64c41 M      fs

I will try to prove this by reverting this commit on a 2.6.33.2 build, but
that's going to take another day, or so.

> > It's hard to believe, that a current kernel on a current system with 12
> > GB, even if using the insane pae on i586 is not able to cope with an du
> > on a 1.1 TB file tree. Since du is invokable by users, this creates a
> > pretty ugly DOS attack for local users.
>
> Agreed. And FWIW, don't let your filesystems get near ENOSPC on
> 2.6.34-rc, either....
>
> (i.e. under sustained write load, 2.6.34-rc will hit the OOM killer
> on page cache allocation before the filesystem can report ENOSPC to
> the user application.  Test 224 in the xfsqa suite on a VM w/ 1GB
> RAM will trigger this with > 90% reliability....)

Hmm, thanks for the warning. Will resort to 2.6.33.2 for now on my servers
and keep an eye on the xfs commit logs...

Cheers && greetings to the orbit ;-),
Pete

For the sake of completeness, here's the revert:

---
commit dfe0d292280ad21c9cf3f240bb415913715d8980
Author: Hans-Peter Jansen <hpj@urpla.net>
Date:   Tue Apr 6 16:05:47 2010 +0200

    Revert "xfs: reclaim all inodes by background tree walks"
    
    This reverts commit 57817c68229984818fea9e614d6f95249c3fb098.
    
    Avoid triggering the oom killer with a simple du on a big xfs tree on i586.
    
    Signed-off-by: Hans-Peter Jansen <hpj@urpla.net>

:100644 100644 52e06b4... a76fc01... M	fs/xfs/linux-2.6/xfs_super.c

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 52e06b4..a76fc01 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -954,14 +954,16 @@ xfs_fs_destroy_inode(
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
 
 	/*
-	 * We always use background reclaim here because even if the
-	 * inode is clean, it still may be under IO and hence we have
-	 * to take the flush lock. The background reclaim path handles
-	 * this more efficiently than we can here, so simply let background
-	 * reclaim tear down all inodes.
+	 * If we have nothing to flush with this inode then complete the
+	 * teardown now, otherwise delay the flush operation.
 	 */
+	if (!xfs_inode_clean(ip)) {
+		xfs_inode_set_reclaim_tag(ip);
+		return;
+	}
+
 out_reclaim:
-	xfs_inode_set_reclaim_tag(ip);
+	xfs_ireclaim(ip);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
