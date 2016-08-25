Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B4CC7CA3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:28:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5F3F08F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 0y1JICFsOCvyzzQW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:28:23 -0700 (PDT)
Subject: [PATCH v8 00/13] xfstests: fixes and new tests for rmap/reflink/fsmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:19 -0700
Message-ID: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is the eighth revision of a patchset that adds to XFS kernel
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication), implements the beginnings of online
metadata scrubbing and preening, and implements reverse mapping for
the realtime device.  There shouldn't be any incompatible on-disk
format changes, pending a thorough review of the patches within.

The first several patches in this series fix various minor errors in a
variety of existing tests.  The biggest change fixes xfs_db usage to
work when an external log is specified.

The new tests in this series ensure that xfs_fsr works with files
having a high extent count and reverse mapping enabled.  Next come
more tests for the existing XFS rmap functionality, tests for the
realtime rmap patches against XFS, some quick sanity checks for the
proposed GETFSMAP ioctl, and tests of shared extent reporting via
GETBMAPX.

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
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v8 00/13] xfstests: fixes and new tests for rmap/reflink/etc

Hi all,

This is the eighth revision of a patchset that adds to xfstests
support for testing reverse-mappings of physical blocks to file and
metadata (rmap); support for testing multiple file logical blocks to
the same physical block (reflink); and implements the beginnings of
online metadata scrubbing.

The first eleven tests fix various bugs in existing reflink and rmap
tests, most of which were a result of not using helpers when I should
have.

After that, there are new tests to make sure that we can't clone_range
across mountpoints; test to make sure that swapext works with many
extents on a rmap filesystem; and tests for realtime reverse-mapping.
There are also revised patches for testing xfs_repair's ability to
rebuild filesystem indices correctly, and to run xfs_scrub during each
test.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3], and
documentation[4].  The kernel patches should apply to 4.8-rc3;
xfsprogs patches to for-next; and xfstest to master.

The patches have been xfstested with x64, i386, armv7l, and ppc64.
AFAICT these don't cause any new failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-experimental
[2] https://github.com/djwong/xfsprogs/tree/djwong-experimental
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
