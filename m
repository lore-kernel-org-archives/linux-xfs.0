Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B87B929E8C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2FCA4AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:01 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UD8s1Pf5EeomwDSn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:10:59 -0800 (PST)
Subject: [PATCH v4 00/11] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:10:52 -0800
Message-ID: <20151219091052.15320.94973.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is a small patch set against the reflink/dedupe test cases in
xfstests.  The first patch is a rewrite of the tools to find the
lowest vacant ID number and to move a test case.  These two programs
are useful for staging a lot of new tests at a high number and moving
them to lower numbers when the maintainer wants to accept the new
tests.

The second patch fixes some reflink tests that didn't clean up after
themselves.

Patch 3 updates the golden output for the test that examines the
results of feeding bad inputs to the two ioctls.  The new error values
are based on a discussion of how to react to bad file types on the
mailing lists and the ongoing work to hoist the ioctls to the VFS
level.

Patches 4-5 fix some minor errors found while testing with different
kernel config and block size options.

Patch 6 introduces new tests to check the behavior of unaligned CoW,
punch-while-CoWd, and ensures that passing len == 0 to reflink
actually runs to EOF.

Patch 7 introduces some XFS-specific ENOSPC testing, wherein we try to
crash the filesystem by allocating all the blocks in an AG and then
expanding the refcount and rmap btrees until the AG runs out of space.

Patch 8 introduces checks that CoW works with a variety of different
neighbor blocks -- delalloc, unwritten, hole, and regular.

Patch 9 introduces checks for CoW when blocksize < pagesize.

Patch 10 tries some large CoW operations to ensure that it works
correctly.

Patch 11 creates a 'dedupe' group for testing specifically dedupe
functionality.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  They should just work with the btrfs
that's in 4.4...  and somewhat buggily with the 4.4 XFS patched with
[1].  The relevant xfs_io support will be in xfsprogs 4.3 though it
still needs a patch to fix len == 0 support.  Probably easier just to
grab [2] and build that.

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave
[5] https://github.com/djwong/man-pages/commits/for-mtk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
