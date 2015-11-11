Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 523DF7F54
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 12:55:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 117CF30404E
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 10:55:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id b9NkDQChxnt5UlOf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 10:55:39 -0800 (PST)
Date: Wed, 11 Nov 2015 10:55:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: RFCv3+ WIP rollup of XFS reverse-mapping, reflink, and dedupe support
Message-ID: <20151111185510.GC2224@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: david@fromorbit.com, hch@infradead.org
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Hi all,

Today I've uploaded the latest WIP patches for XFS reverse mapping,
reflink, and dedupe support to github:

https://github.com/djwong/linux/tree/for-dave
https://github.com/djwong/xfsprogs/tree/for-dave
https://github.com/djwong/xfstests/tree/for-dave
https://github.com/djwong/xfs-documentation/tree/for-dave

I've cleaned things up so now you can pull the for-dave branch in any
of the four repositories.

I updated the XFS on-disk format documentation to fix numerous
omissions in the second edition and to reflect v5 XFS and the
rmap/reflink additions to the filesystem.

Since RFCv3, I restructured how bmbt updates get reflected in the
rmapbt -- now they're deferred until xfs_bmap_finish time, so that the
rmap btree updates obey AG locking order rules to avoid deadlocks.
I also fixed numerous minor bookkeeping bugs in the rmapbt and
refcountbt code.  Lastly, I pulled in Anna Schumaker and Peng Tao's
patches hoisting the reflink ioctls into the VFS, added patches to do
the same with the dedupe ioctl, and wired up XFS to both of the new
VFS operations.

The tests have been reworked (I hope) to play more nicely with NFS
reflink -- now we simply test the xfs_io reflink or dedupe commands on
the test or scratch FS to decide if we're going to run the test,
instead of inferring it from FS type.  The fiemap checks are gone,
replaced with umount, mount, and verifying file contents. 

xfsprogs hasn't changed much, other than porting kernel-side changes.

I will post the xfstests and xfs-documentation patches on the list
shortly.

I'm holding off on reposting the kernel and xfsprogs patches because
I'm still working on fixing CoW and don't really want to blast the
mailing lists again until I'm done with that.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
