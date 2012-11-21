Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL82xnr008029 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 02:02:59 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4yuYKLIiExdbnWPT for <xfs@oss.sgi.com>;
	Wed, 21 Nov 2012 00:05:08 -0800 (PST)
Date: Wed, 21 Nov 2012 19:05:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02.5/32] xfs: remove xfs_tosspages
Message-ID: <20121121080502.GP2591@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-3-git-send-email-david@fromorbit.com>
	<20121114064247.GC1710@dastard> <50A3E807.5010403@sgi.com>
	<50A3E86A.2060402@sgi.com> <50A3F80C.7050502@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50A3F80C.7050502@sgi.com>
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
Cc: xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

On Wed, Nov 14, 2012 at 01:59:08PM -0600, Mark Tinguely wrote:
> On 11/14/12 12:52, Andrew Dahl wrote:
> >
> >Reversing the check on XFS_IOC_ZERO_RANGE.
> >
> >Range should be zeroed if the start is less than or equal to the end.
> >
> >Signed-off-by: Andrew Dahl<adahl@sgi.com>
> >
> >---
> 
> Tests correctly.

Actually, it doesn't. Test 242 still fails. Yeah, there was already
a regression test for this case, it's just that the golden output
wasn't correct so it never detected the single first block zero
failure even though it was tested.  Now it throws an md5sum mismatch
error, indicating that the behaviour has changed iin some unexpected
way and something is not right with the world.

$ sudo ./check 242
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 test-1 3.7.0-rc1-dgc+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
MOUNT_OPTIONS -- /dev/vdb /mnt/scratch

242      - output mismatch (see 242.out.bad)
--- 242.out     2012-11-21 13:13:22.000000000 +1100
+++ 242.out.bad 2012-11-21 15:41:02.000000000 +1100
@@ -74,4 +74,4 @@
 eecb7aa303d121835de05028751d301c
        17. data -> hole in single block file
 0: [0..7]: unwritten
-56819989ef2d9f40785adce8c06b64d0
+5fed275e7617a806f94c173746a2a723
Ran: 242
Failures: 242
Failed 1 of 1 tests

[ Here's a tip for the future: anything that changes allocation
corner cases needs to be run through the entire of xfstests suite
because they have a nasty habit of causing secondary problems.... ]

I can confirm that the page cache page is not being tossed for
this case (end is -1, start is 128) so the fix for the problem in
the commit is good, but there's more problems here. Clearly it is
that there is data in the page cache:

@@ -74,4 +74,7 @@
 eecb7aa303d121835de05028751d301c
        17. data -> hole in single block file
 0: [0..7]: unwritten
-56819989ef2d9f40785adce8c06b64d0
+0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
+*
+0001000
+5fed275e7617a806f94c173746a2a723

And that is wrong, wrong, wrong for an unwritten extent.

So, before even looking for the bug, what's the correct behaviour
here?  It's not directly specified in the man page, but XFS_IOC_ZERO
was really only implemented to zero whole blocks.  However, it makes
sense to handle partial blocks in a sane and consistent manner,
zeroing them correctly similar to XFS_IOC_UNRESVSP and hence
providing full byte range zeroing capability.

With this in mind, I look just looked at test 290 in more detail.
To me, the basic premise of the test is fundamentally wrong:

# Nothing should be tossed unless the range includes a page boundry

XFS_IOC_ZERO's functionality is not defined by page boundaries or
kernel internal behaviours - they may influence behaviour, but they
certainly don't define the behaviour. What I see in test 290 is an
encoding of the current truncate_pagecache_range() semantics, not an
encoding of the intent of XFS_IOC_ZERO_RANGE.  I didn't pay enough
attention to what this test was doing in the first place (my fault),
but the current behaviour is, IMO, borderline insane. :/

So, lets just make it sane by updating XFS_IOC_ZERO_RANGE to full
byte range granularity - it's simple enough to do. We can fix 242
and 290 quickly enough, anyway...

FWIW, this isn't currently optimal (we can avoid zeroing if the
partial blocks fall on holes or unwritten extents), but is a minor
problem compared to correct behaviour, and so that can be fixed
later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: byte range granularity for XFS_IOC_ZERO_RANGE

From: Dave Chinner <dchinner@redhat.com>

XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
aligned ranges. Neither test 242 or 290 exercise this correctly, so
the behaviour is completely busted even though the tests pass.

Fix it to support full byte range granularity as was originally
intended for this ioctl.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c     |    2 +-
 fs/xfs/xfs_vnodeops.c |   84 ++++++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_vnodeops.h |    1 +
 3 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 400b187..67284ed 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -86,7 +86,7 @@ xfs_rw_ilock_demote(
  *	valid before the operation, it will be read from disk before
  *	being partially zeroed.
  */
-STATIC int
+int
 xfs_iozero(
 	struct xfs_inode	*ip,	/* inode			*/
 	loff_t			pos,	/* offset in file		*/
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 2688079..544e9f1 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2095,6 +2095,61 @@ xfs_free_file_space(
 	return error;
 }
 
+
+STATIC int
+xfs_zero_file_space(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,
+	xfs_off_t		len,
+	int			attr_flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	uint			rounding;
+	xfs_off_t		start;
+	xfs_off_t		end;
+	int			error;
+
+	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+
+	/* round the range iof extents we are going to convert inwards */
+	start = round_up(offset, rounding);
+	end = round_down(offset + len, rounding);
+
+	ASSERT(start >= offset);
+	ASSERT(end <= offset + len);
+
+	if (!(attr_flags & XFS_ATTR_NOLOCK))
+		xfs_ilock(ip, XFS_IOLOCK_EXCL);
+
+	if (start < end - 1) {
+		/* punch out the page cache over the conversion range */
+		truncate_pagecache_range(VFS_I(ip), start, end - 1);
+		/* convert the blocks */
+		error = xfs_alloc_file_space(ip, start, end - start - 1,
+				    XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT,
+				    attr_flags);
+		if (error)
+			goto out_unlock;
+	} else {
+		/* it's a sub-rounding range */
+		ASSERT(offset + len <= rounding);
+		error = xfs_iozero(ip, offset, len);
+		goto out_unlock;
+	}
+
+	/* now we've handled the interior of the range, handle the edges */
+	if (start != offset)
+		error = xfs_iozero(ip, offset, start - offset);
+	if (!error && end != offset + len)
+		error = xfs_iozero(ip, end, offset + len - end);
+
+out_unlock:
+	if (!(attr_flags & XFS_ATTR_NOLOCK))
+		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	return error;
+
+}
+
 /*
  * xfs_change_file_space()
  *      This routine allocates or frees disk space for the given file.
@@ -2120,10 +2175,8 @@ xfs_change_file_space(
 	xfs_fsize_t	fsize;
 	int		setprealloc;
 	xfs_off_t	startoffset;
-	xfs_off_t	end;
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
-	int		prealloc_type;
 
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
@@ -2172,31 +2225,20 @@ xfs_change_file_space(
 	startoffset = bf->l_start;
 	fsize = XFS_ISIZE(ip);
 
-	/*
-	 * XFS_IOC_RESVSP and XFS_IOC_UNRESVSP will reserve or unreserve
-	 * file space.
-	 * These calls do NOT zero the data space allocated to the file,
-	 * nor do they change the file size.
-	 *
-	 * XFS_IOC_ALLOCSP and XFS_IOC_FREESP will allocate and free file
-	 * space.
-	 * These calls cause the new file data to be zeroed and the file
-	 * size to be changed.
-	 */
 	setprealloc = clrprealloc = 0;
-	prealloc_type = XFS_BMAPI_PREALLOC;
-
 	switch (cmd) {
 	case XFS_IOC_ZERO_RANGE:
-		prealloc_type |= XFS_BMAPI_CONVERT;
-		end = round_down(startoffset + bf->l_len, PAGE_SIZE) - 1;
-		if (startoffset <= end)
-			truncate_pagecache_range(VFS_I(ip), startoffset, end);
-		/* FALLTHRU */
+		error = xfs_zero_file_space(ip, startoffset, bf->l_len,
+						attr_flags);
+		if (error)
+			return error;
+		setprealloc = 1;
+		break;
+
 	case XFS_IOC_RESVSP:
 	case XFS_IOC_RESVSP64:
 		error = xfs_alloc_file_space(ip, startoffset, bf->l_len,
-						prealloc_type, attr_flags);
+						XFS_BMAPI_PREALLOC, attr_flags);
 		if (error)
 			return error;
 		setprealloc = 1;
diff --git a/fs/xfs/xfs_vnodeops.h b/fs/xfs/xfs_vnodeops.h
index 91a03fa..5163022 100644
--- a/fs/xfs/xfs_vnodeops.h
+++ b/fs/xfs/xfs_vnodeops.h
@@ -49,6 +49,7 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		int flags, struct attrlist_cursor_kern *cursor);
 
+int xfs_iozero(struct xfs_inode *, loff_t, size_t);
 int xfs_zero_eof(struct xfs_inode *, xfs_off_t, xfs_fsize_t);
 int xfs_free_eofblocks(struct xfs_mount *, struct xfs_inode *, bool);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
