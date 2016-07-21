Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 96F7C7CA4
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:56:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6575C8F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 2tSGdzLdegtQnysV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:56:13 -0700 (PDT)
Subject: [PATCH v7 00/47] xfs: add reverse mapping support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:55:55 -0700
Message-ID: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Hi all,

This is the seventh revision of a patchset that adds to XFS kernel
support for tracking reverse-mappings of physical blocks to file and
metadata (rmap).  Per reviewers' request with v6, I am splitting the
gigantic patchbombs into separate functional areas.  Given the
significant amount of design assumptions that change with block
sharing, rmap and reflink are provided together.  There shouldn't be
any incompatible on-disk format changes, pending a thorough review of
the patches within.

The reverse mapping implementation features a simple per-AG b+tree
containing tuples of (physical block, owner, offset, blockcount) with
the key being the first three fields.  The large record size will
enable us to reconstruct corrupt block mapping btrees (bmbt); the
large key size is necessary to identify uniquely each rmap record in
the presence of shared physical blocks.  In contrast to previous
iterations of this patchset, it is no longer a requirement that there
be a 1:1 correspondence between bmbt and rmapbt records; each rmapbt
record can cover multiple bmbt records.

Since the previous posting, I have made some major changes to the
underlying XFS common code.  First, I have extended the generic b+tree
implementation to support overlapping intervals, which is necessary
for the rmapbt on a reflink filesystem where there can be a number of
rmapbt records representing a physical block.  The new b+tree variant
introduces the notion of a "high key" for each record; it is the
highest key that can be used to identify a record.  On disk, an
overlapped-interval b+tree looks like a traditional b+tree except that
nodes store both the lowest key and the highest key accessible through
that subtree pointer.  There's a new interval query function that uses
both keys to iterate all records overlapping a given range of keys.
This change allows us to remove the old requirement that each bmbt
record correspond to a matching rmapbt record.

The second big change is to the xfs_bmap_free functions.  The existing
code implements a mechanism to defer metadata (specifically, free
space b+tree) updates across a transaction commit by logging redo
items that can be replayed during recovery.  It is an elegant way to
avoid running afoul of AG locking order rules /and/ it can in theory
be used to get around running out of transaction reservation.  That
said, I have refactored it into a generic "deferred operations"
mechanism that can defer arbitrary types of work to a subsequent
rolled transaction.  The framework thus allows me to schedule rmapbt,
refcountbt, and bmbt updates while maintaining correct redo in case of
failure.

At the very end of the patchset is an initial implementation of a
GETFSMAP ioctl for userland to query the physical block mapping of a
filesystem.

The first few patches fix various vfs/xfs bugs, adds an enhancement to
the xfs_buf tracepoints so that we can analyze buffer deadlocks, and
merges difference between the kernel and userspace libxfs so that the
rest of the patches apply consistently.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4] and man-pages[5].  The kernel
patches should apply to dchinner's for-next; xfsprogs patches to
for-next; and xfstest to master.

The patches have been xfstested with x64, i386, ppc64, and armv7l.
All three architectures pass all 'clone' group tests.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave-for-4.8
[2] https://github.com/djwong/xfsprogs/tree/djwong-experimental
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel
[5] https://github.com/djwong/man-pages/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
