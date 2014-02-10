Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ACA147F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 18:22:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3A21CAC002
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 16:22:14 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	raM62jSypVhK4LC1 for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 16:22:09 -0800 (PST)
Date: Mon, 10 Feb 2014 11:22:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS on 3.14.0-rc1 (x86): xfs_isilocked() assertion on realtime
	subvolume
Message-ID: <20140210002204.GM13647@dastard>
References: <52F815EE.3030600@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F815EE.3030600@gmail.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 09, 2014 at 06:57:34PM -0500, Michael L. Semon wrote:
> Hi!  I was working with realtime subvolumes on a 3.14.0-rc1+ kernel, doing 
> something like this...
> 
> mkfs.xfs -l logdev=$TEST_LOGDEV -r rtdev=$TEST_RTDEV $TEST_DEV
> mount -t xfs -o logdev=$TEST_LOGDEV -o rtdev=$TEST_RTDEV $TEST_DEV $TEST_DIR
> 
> cd $TEST_DIR
> mkdir testrtdir
> xfs_io -c 'chattr +t' testrtdir
> cd testrtdir
> dd if=/dev/zero of=testrtfile bs=512 count=65536
> 
> ...and was greeted by this:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL), file: fs/xfs/xfs_bmap.c, line: 4016
.....
> Call Trace:
>  [<7916e73c>] xfs_bmapi_read+0x89/0x39f
>  [<791b421d>] xfs_rtbuf_get+0x59/0x132
>  [<791b4860>] xfs_rtmodify_summary+0x64/0xcb
>  [<791b2742>] xfs_rtallocate_range+0xb4/0x17b
>  [<791b2a26>] xfs_rtallocate_extent_exact+0xa4/0xe8
>  [<791b2aee>] xfs_rtallocate_extent_near+0x84/0x317
>  [<791b3be1>] xfs_rtallocate_extent+0x1e9/0x233

OK, so there's a check in xfs_rtallocate_extent like this:

	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));

Which means we definitely have the bitmap inode locked at this
point, but we assert failed because we don't have the summary inode
locked when we go to modify it.

>From a production perspective, this won't matter as access is
already serialised by the lock on the bitmap inode, but we should
fix this for debug kernels.

I suspect that this means we'll need yet another lockdep context for
these inodes, becase we'll be nesting them in an order that doesn't
match any of the other nested inode locking, too.

Thanks for reporting the issue, Michael.

> A bisect brought me here:
> 
> root@plbearer:/usr/src/kernel-git/linux# git bisect good
> eef334e5776c8ef547ada4cec17549929fe590b4 is the first bad commit
> commit eef334e5776c8ef547ada4cec17549929fe590b4
> Author: Christoph Hellwig <hch@infradead.org>
> Date:   Fri Dec 6 12:30:17 2013 -0800
> 
>     xfs: assert that we hold the ilock for extent map access
> 
>     Make sure that xfs_bmapi_read has the ilock held in some way, and that
>     xfs_bmapi_write, xfs_bmapi_delay, xfs_bunmapi and xfs_iread_extents are
>     called with the ilock held exclusively.
> 
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Reviewed-by: Dave Chinner <dchinner@redhat.com>
>     Signed-off-by: Ben Myers <bpm@sgi.com>

Yup, this is the second "regression" that has been exposed by this
patch. The first "regression" being a lockdep false positive, and
the second being this one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
