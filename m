Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EECD77CA0
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:46:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65027AC006
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id dDYkFDislh1boeHK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:46:23 -0700 (PDT)
Subject: [PATCH v7 00/17] xfstests: fixes and new tests for rmap/reflink/etc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:46:15 -0700
Message-ID: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is the seventh revision of a patchset that adds to xfstests
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
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4].  The kernel patches should
apply to dchinner's for-next; xfsprogs patches to for-next; and
xfstest to master.  The kernel git tree already has for-next included.

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
