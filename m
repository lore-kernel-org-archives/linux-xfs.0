Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D89487EC5
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:40:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4063DAC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:20 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 101sGUCefcIs1Sxq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:40:18 -0700 (PDT)
Subject: [PATCH v8 00/25] xfs: online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:40:13 -0700
Message-ID: <147216841262.3108.10746252464845687338.stgit@birch.djwong.org>
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

Online scrub support consists of three pieces -- first, an ioctl that
maps physical extents to their owners; second, various in-kernel
metadata scrubbing ioctls to examine metadata records and
cross-reference them with other filesystem metadata; and third, a
userspace component to initiate kernel scrubbing, walk all inodes and
the directory tree, and scrub data extents.

The first few patches in this series implements the GETFSMAP ioctl
that maps a device number and physical extent either to filesystem
metadata or to a range of file blocks.  The initial implementation
uses the reverse-mapping B+tree to supply the mapping information,
however a fallback implementation based on the free space btrees is
also provided.  The flexibility of having both implementations is
important when it comes to the userspace tool -- even without the
owner/offset data, we still have enough information to set up a read
verification.

The bulk of the patches implement in-kernel scrubbing.  This is
implemented as a new ioctl.  Pass in a metadata type and a control
number (when applicable); the kernel will examine each record in that
metadata structure looking for obvious logical errors.  External
corruption should be discoverable via the checksum embedded in each
(v5) filesystem metadata block.  When applicable, the metadata record
will be cross-referenced with the other metadata structures to look
for discrepancies.  Should any errors be found, an error code is
returned to userspace, which should take the filesystem offline and
repair it.

The final patch in the series enables xfs_scrub to query the per-AG
block reservations so that the summary counters can be sanity-checked.

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
