Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3C5DD7D69
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 14:30:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A01DBAC001
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:30:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id H67FSCQJR615m1Vq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 12:30:44 -0700 (PDT)
Date: Fri, 15 Apr 2016 12:29:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reverse-mapping, reflink, and online fs scrub update
Message-ID: <20160415192935.GF18517@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: david@fromorbit.com
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4 <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

Since LSF is next week, I've pushed the rmap+reflink patches to github.
The kernel patches are against 4.6-rc3, the xfsprogs patches against
for-next, and xfstests patches are against master.

The djwong-devel branches in the kernel/xfsprogs/xfstests repositories should
be fairly stable.  The djwong-experimental branches contain all the patches to
implement "multiple bmaps become one rmap" and the beginnings of deferring
rmaps across transaction rolls via redo intent items to maintain atomicity.
Unfortunately I didn't get that part done in time for LSF and there's some
bug that (I think) happens when we're deleting records from the rmapbt on
reflink filesystems that causes test failures.

So, basically, djwong-devel if you want to run code, and djwong-experimental
if you don't mind HBD and bugs everywhere.  This is basically a code dump.

Also, the online scrub patches (kernel and userspace) are tacked on the
end of the -devel branches now.

Maybe see you all at LSF.  I get to fly through Denver in the middle of a
snow storm tomorrow!  Oh boy! <grumble> <crap flight options>

--D

Semi-sane:
https://github.com/djwong/linux/commits/djwong-devel
https://github.com/djwong/xfsprogs/commits/djwong-devel
https://github.com/djwong/xfstests/commits/djwong-devel
https://github.com/djwong/xfs-documentation/commits/djwong-devel
https://github.com/djwong/man-pages/commits/djwong-devel

HBD:
https://github.com/djwong/linux/commits/djwong-experimental
https://github.com/djwong/xfsprogs/commits/djwong-experimental

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
