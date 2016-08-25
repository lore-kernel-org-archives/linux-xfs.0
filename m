Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A6EF47CB4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:30:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6FDA98F8033
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:30:47 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZRbN5vLRAzcBVe9n (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:30:45 -0700 (PDT)
Subject: [PATCH v8 0/6] vfs: help support reflink for XFS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:30:40 -0700
Message-ID: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
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
To: david@fromorbit.com, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-api@vger.kernel.org

Hi all,

This is the eighth revision of a patchset that adds to XFS kernel
support for mapping multiple file logical blocks to the same physical
block (reflink/deduplication), implements the beginnings of online
metadata scrubbing and preening, and implements reverse mapping for
the realtime device.  There shouldn't be any incompatible on-disk
format changes, pending a thorough review of the patches within.

The patches in this series implement generic changes that will be
necessary for XFS' implementation of reflink and dedupe.  There are
some small fixes for the new VFS hoists of the dedupe ioctl, as well
as a patch adding the reflink and CoW extent size hints to the file
attr ioctl that ext4 and XFS now share.

The second half of the series are amendments to the iomap
infrastructure that Christoph Hellwig refactored in 4.8.  These
changes make it easier to implement CoW and to pass along various
flags through struct iomap.

If you're going to start using this mess, you probably ought to just
pull from my github trees for kernel[1], xfsprogs[2], xfstests[3],
xfs-docs[4], and man-pages[5].  The kernel patches in the git trees
should apply to 4.8-rc3; xfsprogs patches to for-next; and xfstest to
master.

The patches have been xfstested with x64, ppc64, and armhf; all tests
in the clone and rmap groups pass.  AFAICT they don't cause any new
failures for the 'auto' group.

This is an extraordinary way to eat your data.  Enjoy! 
Comments and questions are, as always, welcome.

--D

[1] https://github.com/djwong/linux/tree/djwong-devel
[2] https://github.com/djwong/xfsprogs/tree/djwong-devel
[3] https://github.com/djwong/xfstests/tree/djwong-devel
[4] https://github.com/djwong/xfs-documentation/tree/djwong-devel
[5] https://github.com/djwong/man-pages/tree/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
