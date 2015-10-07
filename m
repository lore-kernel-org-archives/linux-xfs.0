Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 894897FB6
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:05:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D559304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:05:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id fcr6jVGJrc3ZhXxl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:05:17 -0700 (PDT)
Subject: [RFCv3 00/51] xfsprogs: add reverse-mapping, reflink,
	and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:05:14 -0700
Message-ID: <20151007050513.1504.28089.stgit@birch.djwong.org>
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

This is the third revision of an RFC for adding to xfsprogs support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.  Given the
significant amount of re-engineering required to make the initial rmap
implementation compatible with reflink, I decided to publish both
features as an integrated patchset off of upstream.  This means that
rmap and reflink are now compatible with each other.

The patch set is based on the current (4.2.0+) for-next branch.  This
code should be relatively bug-free, and the bulk of the patches are to
teach xfs_repair how to record all mappings and to use that data both
to regenerate the reference count data (refcntbt) and the reverse
mapping index (rmapbt).  There are way too many patches to discuss
them individually, but roughly speaking they're grouped by functional
area:

0. Cleanups
1. Implement reflink and dedupe in xfs_io
2. Spot-check and fuzz v5 filesystems in xfs_db
   (otherwise the test/scratch fs checks in xfstests get unhappy)
3. rmapbt support
4. rmapbt rebuilding in xfs_repair
5. refcntbt support
6. refcntbt rebuilding in xfs_repair

Issues:

 * I'm not 100% sure xfs_repair correctly handles rebuilding all the
XFS_RMAP_OWN_AG rmap entries (which are the bnobt, cntbt, rmapbt, and
the AGFL).

 * General shakiness of the code that spots errors in the rmapbt and
refcntbt.  Given that we're either readonly or rebuilding them anyway,
I wonder if it matters...

 * Under certain circumstances, mkfs underestimates the minimum log
size and the kernel refuses to mount.  The last patch in the set
hacks around this in an ugly way.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].

This is an extraordinary way to eat your data.  Enjoy!

Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux-xfs-dev/commits/master
[2] https://github.com/djwong/xfsprogs/commits/for-next
[3] https://github.com/djwong/xfstests/commits/master

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
