Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A412C7CA0
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 19:48:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C497304081
	for <xfs@oss.sgi.com>; Fri,  3 Jun 2016 17:48:10 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gzfEN47xppd0tzAi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 03 Jun 2016 17:48:07 -0700 (PDT)
Date: Fri, 3 Jun 2016 17:47:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: June 2016 XFS reverse-mapping, reflink, and online fs scrub
Message-ID: <20160604004730.GA5737@birch.djwong.org>
References: <20160505202502.GA7297@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505202502.GA7297@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, bfoster@redhat.com, xfs@oss.sgi.com

Hi all,

Time for my monthly rmap+reflink code dump to github!  Kernel patches
are against 4.6.0, and xfsprogs patches are against ... 4.5. <shudder>
xfs/128 still fails when rmap is enabled.

On the plus side, CoW and reflink remapping is now atomic!  For rmap,
I also moved the 'unwritten' bit out of the rm_blockcount field so
that we can use all 32 bits.  I've fixed numerous silly bugs in
xfs_repair dealing with incorrect key handling, and worked in some
large(ish) performance improvements.  I also put in some tests that
inject errors into the deferred op finishing code so that we can crash
the FS at various points during a remapping multi-transaction to check
that the redo items actually work.

I plan to rebase the whole mess against 4.7-rc and for-next when I get
a chance; and properly integrate the new patches into the start of the
patchbomb.  (342 patches is a bit much).  The remaining work items are
to make sure that quota accounting works acceptably, fix swapext when
rmap is enabled, investigate caching the "is shared?" information in
core to speed up reflink, and fixing performance problems.  Maybe more
scrub work too some day.

Christoph: I've put in all your patches that you've sent me.

--D

Code-bomb:
https://github.com/djwong/linux/commits/djwong-devel
https://github.com/djwong/xfsprogs/commits/djwong-devel
https://github.com/djwong/xfstests/commits/djwong-devel
https://github.com/djwong/xfs-documentation/commits/djwong-devel
https://github.com/djwong/man-pages/commits/djwong-devel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
