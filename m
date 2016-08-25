Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FDE57FC1
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:43:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1811A8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Db3EDC1CIu1fHSV3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:30 -0700 (PDT)
Subject: [PATCH v8 00/20] xfs: add realtime reverse-mapping support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:43:26 -0700
Message-ID: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is the eighth revision of a patchset that adds to XFS kernel
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication), implements the beginnings of online
metadata scrubbing and preening, and implements reverse mapping for
the realtime device.  There shouldn't be any incompatible on-disk
format changes, pending a thorough review of the patches within.

At the beginning of the set are patches to implement storing B+tree
leaves in an inode root, since the realtime rmapbt is rooted in an
inode, unlike the regular rmapbt which is rooted in an AG block.
Prior to this, the only btree that could be rooted in the inode fork
was the block mapping btree; if all the extent records fit in the
inode, format would be switched from 'btree' to 'extents'.

The next few patches widen the reverse mapping routines to fit the
64-bit numbers required to store information about the realtime
device and establish a new b+tree type (rtrmapbt) for the realtime
variant of the rmapbt.  After that are a few patches to handle rooting
the rtrmapbt in a specific inode that's referenced by the superblock.

Finally, there are patches to implement GETFSMAP with the rtrmapbt and
scrub functionality for the rtrmapbt and rtbitmap.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  The kernel patches in the git trees
should apply to 4.8-rc3; xfsprogs patches to for-next; and xfstest to
master.

The patches have been xfstested with x64, ppc64, and armhf; all tests
in the clone and rmap groups pass.  AFAICT they don't cause any new
failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel
[5] https://github.com/djwong/man-pages/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
