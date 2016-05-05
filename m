Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BAA2A7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 15:25:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2CAE1AC003
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 13:25:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id UkCKEDrvRZGRUGrn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 13:25:36 -0700 (PDT)
Date: Thu, 5 May 2016 13:25:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: May 2016 XFS reverse-mapping, reflink, and online fs scrub
Message-ID: <20160505202502.GA7297@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

I've pushed the rmap+reflink patches to github.  The kernel patches are against
4.6-rc6, the xfsprogs patches against for-next, and xfstests patches are
against master, same as last time.

I /think/ the overlapped interval btree is working correctly, and it's now
in djwong-devel.  The xfstests should all pass except generic/924 (check that
we can't swapon a reflink file) and xfs/128 (swapextents is broken with rmap).

djwong-experimental now contains the start of adding log intent items for
deferred operations.

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
