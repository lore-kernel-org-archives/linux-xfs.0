Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46F6C7CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 22:13:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09F553040D0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 20:13:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HQM95YRNI9ui4grH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2016 20:13:28 -0700 (PDT)
Date: Tue, 16 Aug 2016 20:12:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS rmap, reflink, and online scrub git trees updated
Message-ID: <20160817031256.GB8268@birch.djwong.org>
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
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi everyone,

I've just rebased the rmap, reflink, and online scrub repositories
against kernel 4.8-rc2 and the xfsprogs dev branch:

https://github.com/djwong/linux/tree/djwong-experimental [766b9c8ffeb]
https://github.com/djwong/xfsprogs/commits/djwong-experimental [556a18344]

These development branches should be the most recent of the various dev trees
floating around out there.  Online scrub should be more or less finished,
including the kernel ioctls to check a btree and cross-reference it with other
btrees.  The copy on write code incorporates all of Christoph's changes in his
xfs-nfsd-clone.4 branch to make it work with the new iomap code.

-----

I have also produced a for-next branch with only the rmap userspace
support:

https://github.com/djwong/xfsprogs/commits/for-dave-for-4.8 [298f89e628]

I'm letting it run tests overnight; if it's clean I'll send it to the
mailing list tomorrow.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
