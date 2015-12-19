Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5292880D6
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D84BFAC005
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:55 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id mkIPEvUM9ktkPRno (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:54 -0800 (PST)
Subject: [RFCv4 00/53] xfsprogs: add reverse-mapping, reflink,
	and dedupe support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:51 -0800
Message-ID: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

This is the fourth revision of an RFC for adding to xfsprogs support
for tracking reverse-mappings of physical blocks to file and metadata;
and support for mapping multiple file logical blocks to the same
physical block, more commonly known as reflinking.  Given the
significant amount of re-engineering required to make the initial rmap
implementation compatible with reflink, I decided to publish both
features as an integrated patchset off of upstream.  This means that
rmap and reflink are (still) compatible with each other.

The patch set is based on the current (4.3.0+) for-next branch.  This
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

 * Under certain circumstances, mkfs underestimates the minimum log
size and the kernel refuses to mount.  The last patch in the set
hacks around this in an ugly way.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
There's also repositories for xfs documentation[4] and man-pages[5].
These patches have not changed significantly since RFCv3.

This is an extraordinary way to eat your data.  Enjoy!

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
