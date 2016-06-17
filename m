Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 73AA7850B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:48:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 43F6E8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:15 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Y9xjoJnFKEDYn9EL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:48:13 -0700 (PDT)
Subject: [PATCH v6 0/6] xfs-docs: reorganize chapters,
	rmapbt and refcountbt chapter updates
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:48:09 -0700
Message-ID: <146612808918.25586.1147874927753492795.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Hi all,

This is the sixth revision of a patchset that updates the xfs
documentation for tracking reverse-mappings of physical blocks to file
and metadata (rmap); support for mapping multiple file logical blocks
to the same physical block (reflink); and implements the beginnings of
online metadata scrubbing.  Given the significant amount of design
assumptions that change with block sharing, rmap and reflink are
provided together.  There shouldn't be any incompatible on-disk format
changes, pending a thorough review of the patches within.

This patch set does the following:

 * Adds a chapter discussing the importance of thoroughly testing new
   disk format changes with xfstests, and how to find the source code.

 * Adds in all the disk format changes for Linux 4.5.

 * Separates the btree sections into a separate chapter about the
   generic btree structure, and adds a section about the new support
   for overlapped interval records.

 * Adds chapters discussing reflink, the reference count btree, and
 * the reserve-mapping btree.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There are also updates for xfs-docs[4].  The kernel patches should
apply to dchinner's for-next; xfsprogs patches to for-next; and
xfstest to master.  The kernel git tree already has for-next included.

The patches have been xfstested with x64, i386, and armv7l--arm64,
ppc64, and ppc64le no longer boot in qemu.  All three architectures
pass all 'clone' group tests except xfs/128 (which is the swapext
test), and AFAICT don't cause any new failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
