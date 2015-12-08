Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C8AF87F37
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 00:29:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7B07304059
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 22:29:09 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 94ZpYCcvfGhEvcee (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 22:29:08 -0800 (PST)
Subject: [PATCH v3.4 0/3] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 07 Dec 2015 22:28:44 -0800
Message-ID: <20151208062844.21871.23644.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Hi all,

This is a small patch set against the reflink/dedupe test cases in
xfstests.  The first patch is a rewrite of the tools to find the
lowest vacant ID number and to move a test case.  These two programs
are useful for staging a lot of new tests at a high number and moving
them to lower numbers when the maintainer wants to accept the new
tests.

The second patch updates the golden output for the test that examines
the results of feeding bad inputs to the two ioctls.  The new error
values are based on a discussion of how to react to bad file types on
the mailing lists and the ongoing work to hoist the ioctls to the VFS
level.

The third patch has a few more tests for things that I found while
rewriting XFS copy-on-write, and for explicitly testing the ability to
reflink/dedupe "to the end of the file" by setting len == 0.  These
tests are new and need more careful review than the first two patches.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3], and
xfs-docs[4].  They should just work with the btrfs that's in 4.4...
and somewhat buggily with the 4.4 XFS patched with [1].  The relevant
xfs_io support will be in xfsprogs 4.3 though it still needs a patch
to fix len == 0 support.  Probably easier just to grab [2] and build
that.

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/for-dave
[2] https://github.com/djwong/xfsprogs/tree/for-dave
[3] https://github.com/djwong/xfstests/tree/for-dave
[4] https://github.com/djwong/xfs-documentation/tree/for-dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
