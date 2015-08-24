Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2B2A77F37
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 20:51:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1D44E304032
	for <xfs@oss.sgi.com>; Sun, 23 Aug 2015 18:51:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	QyYfkcXu7cBrCuRQ for <xfs@oss.sgi.com>;
	Sun, 23 Aug 2015 18:51:34 -0700 (PDT)
Date: Mon, 24 Aug 2015 11:51:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfsprogs: Free all data in libxfs_umount; call from
	xfs_copy as well
Message-ID: <20150824015132.GT3902@dastard>
References: <55D61740.9070507@sandeen.net>
 <55D6179B.1040701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55D6179B.1040701@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 20, 2015 at 01:08:27PM -0500, Eric Sandeen wrote:
> libxfs_umount was failing to free a handful of resources; fix that up.
> Call it from xfs_copy as well, while we're at it; every other libxfs_mount
> has a libxfs_umount counterpart, at least on a clean exit.

xfs/077 6s ... - output mismatch (see /home/dave/src/xfstests-dev/results//xfs/077.out.bad)
    --- tests/xfs/077.out       2015-08-05 15:00:15.000000000 +1000
    +++ /home/dave/src/xfstests-dev/results//xfs/077.out.bad    2015-08-24 11:35:42.000000000 +1000
    @@ -18,4 +18,6 @@
     writing all SBs
     new UUID = <EXACTUUID>
     == xfs_copy with new UUID
    +cache_purge: shake on cache 0x64b2e0 left 1 nodes!?
     == xfs_copy with duplicate UUID
    +cache_purge: shake on cache 0x64b2e0 left 1 nodes!?
    ...

It would seem that this exposes a buffer refcount issue in xfs_copy?

Oh, yeah, the superblock. Patch modified to include this hunk:

@@ -696,6 +696,7 @@ main(int argc, char **argv)
 	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);
+	libxfs_putbuf(sbp);
 
 	mp = libxfs_mount(&mbuf, sb, xargs.ddev, xargs.logdev, xargs.rtdev, 0);
 	if (mp == NULL) {

Which makes the immediate problem go away.

Eric, can you send another patch here to abort xfs_copy if the
superblock is detected as corrupt by the verifier?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
