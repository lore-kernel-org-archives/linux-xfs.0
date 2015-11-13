Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 40B697F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:37:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 06C408F8035
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:13 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9meTbw9oPuVxgIZP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:11 -0800 (PST)
Subject: [RFCv3.2 00/12] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:36:43 -0800
Message-ID: <20151113213643.31124.80975.stgit@birch.djwong.org>
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

This is part of the third revision of an RFC for adding to XFS support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.

This patchset aims to make xfstests perform more rigorous testing of
the NFS/CIFS/btrfs/XFS file clone, reflink, and dedupe ioctls.
There are now tests of the basic functionality of the three ioctls;
tests to ensure that the filesystem exhibits the expected copy on
write semantics; tests to try to suss out race conditions in the new
write paths; tests to ensure that the ioctls peform basic disk
accounting correctly; tests of the interaction between reflink and the
various fallocate verbs (allocate, punch, collapse, insert zeroes);
and some attempts to test the upper limits of reflinking and ENOSPC
behavior.

Since the last posting, each test tries to reflink (or dedupe) on the
test or scratch FS to decide if they're going to run, instead of
guessing based on FS type.  Per Dave's suggestion, I also converted
the basic functionality tests to use fixed sizes so that I can use
md5sum in the golden output to check that the file contents match
exactly.

Since "RFCv3.1", I've made the following changes:

 * Renumbered the tests to the lowest numbers possible, per Dave's
   request.

 * Fixed the reflink and dedupe _require tests so that they can run
   on things like NFS which support reflink but not dedupe.

 * Added checks for lsattr/chattr support so that we don't produce
   bogus failures on NFS, and put the *attr tests in separate test
   files.

 * Appended a couple of tools I wrote to handle finding minimal test
   numbers and moving tests around.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3], and
xfs-docs[4].  They should just work with the btrfs that's in 4.3...
and somewhat buggily with the 4.3 XFS patched with [1].

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
