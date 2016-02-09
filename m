Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2B7817CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:12:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A43AFAC003
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:11:58 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MOpETrSfpIKiU6AG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:11:56 -0800 (PST)
Subject: [PATCH v4.1 00/23] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:11:45 -0800
Message-ID: <20160209011145.23099.95354.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Happy New Year!

Dave Chinner: I've renumbered the new tests and pushed to github[3] if
you'd like to pull.

This is a (no longer) small patch set against the reflink/dedupe test
cases in xfstests.  The first four patches fix errors in the existing
reflink tests, some of which are from Christoph Hellwig.

Patches 5-6 refactor the dmerror code so that we can use it to
simulate transient IO errors, then use this code to test that
unwritten extent conversion does NOT happen after a directio write to
an unwritten extent hits a disk error.   Due to a bug in the VFS
directio code, ext4 can disclose stale disk contents if an aio dio
write fails; XFS suffers this problem for any failing dio write to an
unwritten extent.  Christoph's kernel patchset titled "vfs/xfs:
directio updates to ease COW handling V2" (and a separate ext4 warning
cleanup) is needed to fix this.

Patches 7-9, 13, 15, 17, 18, 20, 21, and 23 exercise various parts
of the copy on write behavior that are necessary to support shared
blocks.  The earlier patches focus on correct CoW behavior in the
presence of IO errors during the copy-write, and the later patches
focus on XFS' new cow-extent-size hint that greatly reduces
fragmentation due to copy on write behavior by encouraging the
allocator to allocate larger extents of replacement blocks.

Patches 10-12 and 14 perform stress testing on reflink and CoW to
check the behaviors when we get close to maximum refcount, when we
specify obnxiously large offsets and lengths, and when we try to
reflink millions of extents at a time.

Patch 16 tests quota accounting behavior when reflink is enabled.

Patch 19 adds a few tests for the XFS reverse mapping btree to ensure
that things like metadump and growfs work correctly.

Patch 22 checks that get_bmapx and fiemap (on XFS) correctly flag
extents as having shared blocks.  XFS now follows btrfs and ocfs2
FIEMAP behavior such that if any blocks of a file's extent are shared,
the whole extent is marked shared.  This is in contrast to earlier
XFS-only behavior that reported shared and non-shared regions as
separate extents.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  All tests should pass on XFS.   I
tried btrfs this weekend and it failed 166, 175, 182, 266, 271, 272,
278, 281, 297, 298, 304, 333, and 334.  ocfs2 (when I jury-rigged it
to run the cp_reflink tests) seemed to have a quota bug and crashes
hard in 284 (but was otherwise fine).

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
