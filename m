Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6D6A8800B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:30:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06904AC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id YVMQ6FffRFfkqb5I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:30:49 -0700 (PDT)
Subject: [PATCH v6 000/145] xfsprogs: add reverse mapping, reflink, dedupe,
	and online scrub support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:45 -0700
Message-ID: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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

This is the sixth revision of a patchset that adds to xfsprogs
support for tracking reverse-mappings of physical blocks to file and
metadata (rmap); support for mapping multiple file logical blocks to
the same physical block (reflink); and implements the beginnings of
online metadata scrubbing.  Given the significant amount of design
assumptions that change with block sharing, rmap and reflink are
provided together.  There shouldn't be any incompatible on-disk format
changes, pending a thorough review of the patches within.

The first few libxfs patches resync the xfsprogs libxfs with the
kernel libxfs so that the new feature development can branch off
(roughly) the same code.  All patches in the kernel patchset that
touch libxfs are provided here individually, and implement the same
code changes.

Patches to the actual xfsprogs programs are also provided -- xfs_db,
xfs_logprint, and xfs_metadump are taught to examine the new on-disk
data structures; xfs_io now knows how to inject errors for tests;
mkfs can format the new features; and xfs_repair has been taught to
check its own observations against the existing rmapbt and refcountbt
and to regenerate the two indices.

At the very end of the patchset is an initial implementation of twin
"fsmap" commands in xfs_db and xfs_io for offline and online analysis
of the filesystem.  The last patch implements xfs_scrub which performs
(very) limited online checking of the filesystem.  It should work on
any disk-based filesystem, and if it detects XFS it can trigger the
in-kernel metadata b+tree scrubbing.

The very first patch is a tool that can analyze xfs_buf deadlocks from
ftrace output, and the patches after that merge various kernel libxfs
changes into the xfsprogs libxfs so that the rest of the patches apply
consistently.

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
