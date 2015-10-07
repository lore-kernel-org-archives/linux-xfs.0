Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1941E29EFE
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:13:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7E986AC006
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:13:03 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xDGMBJXfOKFyz66J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:13:01 -0700 (PDT)
Subject: [RFCv3 00/12] xfstests: test the btrfs/xfs reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:12:57 -0700
Message-ID: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi all,

This is part of the third revision of an RFC for adding to XFS support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.

This patchset aims to make xfstests perform more rigorous testing of
the btrfs/XFS file clone, reflink, and dedupe ioctls.  There are now
tests of the basic functionality of the three ioctls; tests to ensure
that the filesystem exhibits the expected copy on write semantics;
tests to try to suss out race conditions in the new write paths; tests
to ensure that the ioctls peform basic disk accounting correctly;
tests of the interaction between reflink and the various fallocate
verbs (allocate, punch, collapse, insert zeroes); and some attempts to
test the upper limits of reflinking and ENOSPC behavior.  The tests
have been totally rewritten since the last posting to drop FIEMAP
usage; this should enable the tests to cover NFS and CIFS.

Issues: 

 * I think the race checks for dedupe could be a little sharper at
   finding mistakes.

 * I started the numbering really high to prevent the tests from
   colliding with whatever new tests might arrive; this will require
   some intervention to fix.

 * I don't have any interesting NFS/CIFS setups for test. :(

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
They should just work with the btrfs that's in 4.3.

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux-xfs-dev/commits/master
[2] https://github.com/djwong/xfsprogs/commits/for-next
[3] https://github.com/djwong/xfstests/commits/master

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
