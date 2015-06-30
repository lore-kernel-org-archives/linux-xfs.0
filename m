Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EB2F37F51
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:15:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D985E304043
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:15:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id nJ90wS854AbEcVTg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:15:30 -0700 (PDT)
Subject: [RFC 00/11] xfstests: test the btrfs/xfs reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:15:20 -0700
Message-ID: <20150630041519.2476.23059.stgit@birch.djwong.org>
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

This is a RFC-quality pass at making xfstests perform more rigorous
testing of the btrfs/xfs file clone, reflink, and dedupe ioctls.
There are now tests of the basic functionality of the three ioctls;
tests to ensure that the filesystem exhibits the expected copy on
write semantics; tests to try to suss out race conditions in the new
write paths; tests to ensure that the ioctls peform basic disk
accounting correctly; tests of the interaction between reflink and the
various fallocate verbs (allocate, punch, collapse, insert zeroes);
and some attempts to test the upper limits of reflinking.  The first
patch in the series adds fuzz testing to ext4 and XFS; aside from
being first in line, it isn't tied to any of the reflink
functionality.

To run these tests, you'll have to patch xfsprogs to have reflink and
dedupe support[1]; the patch ought to apply fairly cleanly against the
upstream git.  They should more or less work with the btrfs that
appears in 4.1, though if you want to test the XFS implementation,
you're going to have to apply a lot of patches to the kernel and
xfsprogs.  See the cover letters[2][3] for those patchsets for more
information.

Known issues: 
 * I think the race checks for dedupe could be a little sharper at
   finding mistakes.
 * I started the numbering really high to prevent the tests from
   colliding with whatever new tests might arrive; this will require
   some intervention to fix.
 * When ext4 gains reflink support, it shouldn't be difficult to make
   these tests run on it.  The patch set is based on the current
   xfstest master on kernel.org.
 * If the copy_file_range syscall ever comes around, we'll have to
   adapt xfs_io to use that in addition to the btrfs ioctls.

Comments and questions are, as always, welcome.

--D

[1] http://djwong.org/docs/03-xfs_io-reflink-and-dedupe.patch
[2] See thread "[RFC 00/15] xfsprogs: support the reflink btree" dated today.
[3] http://oss.sgi.com/archives/xfs/2015-06/msg00407.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
