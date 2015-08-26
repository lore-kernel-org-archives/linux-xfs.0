Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDED97F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD0638F8040
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:25 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id CX9DN3QAoaqfpSOH (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:24 -0700 (PDT)
Subject: [PATCH v3 00/11] xfsprogs fuzzing fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:20 -0700
Message-ID: <20150826003220.23973.59731.stgit@birch.djwong.org>
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

This is a rollup of various fuzzing fixes for xfsprogs 4.2.0-rc3.

The first patch fixes a crash in xfs_repair where args.geo wasn't
getting initialized when killing a directory block.  Previously
sent by sandeen, but seemed to have fallen off everyone's radars?

Patch 2, a port of a kernel patch, ensures that the dir/attr verifier
marks the buffer corrupt if the magic number isn't recognized.  This
helps us to fail faster in the event of magic number corruption.

Patch 3 fixes libxfs' WANT_CORRUPTED macros to return negative error
codes like the rest of libxfs does.

Patch 4 amends libxfs_getbuf*() to clear the buffer state if the
buffer isn't dirty.  This prevents repair from throwing CRC errors if
a block is prefetched, freed without being examined (the exam clears
the UNCHECKED flag), reallocated to some other data structure, and
then read for a subsequent operation.

Patch 5 fixes a bug in xfs_repair wherein if xfs_repair fixes a broken
xattr block and later decides to unmap the block, the "repaired" flag
inadvertently prohibits the unmapping of that block.

Patch 6 forces repair's xattr block checker to take a look at the
header for incorrect owner data.  If the header info looks bad, we'll
discard the xattr block.

Patch 7 forces prefetch to mark corrupt bmbt blocks UNCHECKED so that
the regular bmbt examination will fix the bad CRC if it doesn't take
any other action against the block.  Without this, a corruption in the
unused area will trigger a kernel error yet never get fixed by repair.

Patch 8 implements a 'reflink' and 'dedupe' command in xfs_io.  This
will be used in future xfstests to test reflink and dedupe features of
btrfs and xfs filesystems.

Patch 9 fixes xfs_db/blocktrash to not fail write verification when
corrupting a block and allows trashing of log and symlink blocks.

Patch 10 enhances the blocktrash command with a '-z' option that
trashes the block at the top of the cursor stack and doesn't require
blockget to have been run.

Patch 11 implements blockget for v5 filesystems.  This is a second try
at a previous patch which didn't quite catch all the new magic numbers
and had some problems iterating directory index data.

I've tested these xfsprogs changes against the for-next branch as of
8/24.  The rmap/reflink patches will be dealt with separately.

Scary rewound github repo with everything attached:
https://github.com/djwong/xfsprogs

Fuzz tests and more are at:
https://github.com/djwong/xfstests

Comments and questions are, as always, welcome.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
