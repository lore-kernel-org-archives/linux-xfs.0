Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4FF237CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:03:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EAFD7AC013
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 01:03:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Ni5oSnGrUMeQMPZ6 for <xfs@oss.sgi.com>;
	Fri, 24 May 2013 01:03:31 -0700 (PDT)
Date: Fri, 24 May 2013 18:03:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130524080300.GI24543@dastard>
References: <20130522051243.GH29466@dastard> <20130522052938.GA2573@redhat.com>
	<20130522055147.GI29466@dastard> <20130522215454.GL29466@dastard>
	<20130523184948.GA11151@redhat.com>
	<20130523223038.GB24543@dastard>
	<20130524004906.GA21171@redhat.com>
	<20130524012625.GH24543@dastard>
	<20130524015219.GA28486@redhat.com>
	<20130524030300.GA30760@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524030300.GA30760@redhat.com>
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
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Thu, May 23, 2013 at 11:03:00PM -0400, Dave Jones wrote:
> On Thu, May 23, 2013 at 09:52:19PM -0400, Dave Jones wrote:
>  > On Fri, May 24, 2013 at 11:26:25AM +1000, Dave Chinner wrote:
>  >  
>  >  > You want to print the debug output if the masked value != 0.
>  > 
>  > XFS (sda2): xfs_setattr_size: mask 0xaa69, masked 0x801 ii 0xffff8802129e98c0, d 0xffff88021757d970 path /davej/src/trinity/tmp/tmp.5/
> 
> ah, sneaky. There's some unprintable characters there that didn't
> show up in my terminal when I cut-n-pasted.  They made it to the
> logs though..
> 
> XFS (sda2): xfs_setattr_size: mask 0xaa69, masked 0x801 ii 0xffff8802129e98c0, d 0xffff88021757d970 path /davej/src/trinity/tmp/tmp.5/

So the mask is:

	ATTR_OPEN | ATTR_FILE | ATTR_KILL_SUID | ATTR_FORCE | \
	ATTR_CTIME | ATTR_MTIME | ATTR_MODE

And so the mask is tripping the assert is (ATTR_KILL_SUID |
ATTR_MODE).

Ok, that now makes sense - that's consistent with open(O_TRUNCATE)
on a suid file. How the hell has this gone unnoticed?

> Hexdump: of that part.. 706d 352e 012f 0a01 
> So filename is 0x01 0x01
> 
> Don't know if that's relevant to the bug or not..

No, it's not. It seems like the XFS code is simply broken, and has
been for a couple of years. This is the commit that changed the code
into the split we currently have now:

commit c4ed4243c40f97ed5b7b121777bbbc6aeaa722f0
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jul 8 14:34:23 2011 +0200

    xfs: split xfs_setattr
    
    Split up xfs_setattr into two functions, one for the complex truncate
    handling, and one for the trivial attribute updates.  Also move both
    new routines to xfs_iops.c as they are fairly Linux-specific.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Alex Elder <aelder@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>

Clearly there's a simple test that xfstests is missing, not to
mention every other test suite out there that is run regularly on
linux....

Awww, hell.

xfstest generic/193 is *supposed* to test behaviour of suid/sgid bits
and clearing them is various situations.

You know what I'm about to say, don't you? The test doesn't test
what it thinks it is testing. it puts the destination file in root
directory of the xfstests harness, not in the filesystems being
tested.

So, on all my machines, it runs on ext3 filesystems, never on the
ext4, btrfs, xfs, etc filesystems that I'm actually testing.

That's beside the point, because it doesn't test truncate behaviour.
But at least I know now why my attempts to reproduce the problem
didn't work...

Right, patch below should fix the problem.

What a frustrating bug. Now, where's my bottle of scotch?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: kill suid/sgid through the truncate path.

From: Dave Chinner <dchinner@redhat.com>

XFS has failed to kill suid/sgid bits correctly when truncating
files of non-zero size since commit c4ed4243 ("xfs: split
xfs_setattr") introduced in the 3.1 kernel. Fix it.

Fix it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d82efaa..c255382 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -455,6 +455,24 @@ xfs_vn_getattr(
 	return 0;
 }
 
+static void
+xfs_setattr_mode(
+	struct inode	*inode,
+	struct iattr	*iattr)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	umode_t		mode = iattr->ia_mode;
+
+	if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+		mode &= ~S_ISGID;
+
+	ip->i_d.di_mode &= S_IFMT;
+	ip->i_d.di_mode |= mode & ~S_IFMT;
+
+	inode->i_mode &= S_IFMT;
+	inode->i_mode |= mode & ~S_IFMT;
+}
+
 int
 xfs_setattr_nonsize(
 	struct xfs_inode	*ip,
@@ -606,18 +624,8 @@ xfs_setattr_nonsize(
 	/*
 	 * Change file access modes.
 	 */
-	if (mask & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-
-		ip->i_d.di_mode &= S_IFMT;
-		ip->i_d.di_mode |= mode & ~S_IFMT;
-
-		inode->i_mode &= S_IFMT;
-		inode->i_mode |= mode & ~S_IFMT;
-	}
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(inode, iattr);
 
 	/*
 	 * Change file access or modified times.
@@ -714,9 +722,8 @@ xfs_setattr_size(
 		return XFS_ERROR(error);
 
 	ASSERT(S_ISREG(ip->i_d.di_mode));
-	ASSERT((mask & (ATTR_MODE|ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
-			ATTR_MTIME_SET|ATTR_KILL_SUID|ATTR_KILL_SGID|
-			ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
+	ASSERT((mask & (ATTR_UID|ATTR_GID|ATTR_ATIME|ATTR_ATIME_SET|
+			ATTR_MTIME_SET|ATTR_KILL_PRIV|ATTR_TIMES_SET)) == 0);
 
 	if (!(flags & XFS_ATTR_NOLOCK)) {
 		lock_flags |= XFS_IOLOCK_EXCL;
@@ -860,6 +867,12 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
+	/*
+	 * Change file access modes.
+	 */
+	if (mask & ATTR_MODE)
+		xfs_setattr_mode(inode, iattr);
+
 	if (mask & ATTR_CTIME) {
 		inode->i_ctime = iattr->ia_ctime;
 		ip->i_d.di_ctime.t_sec = iattr->ia_ctime.tv_sec;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
