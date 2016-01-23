Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 42ACB7F4E
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 19:32:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB1F4AC001
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 17:31:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Zllq6RsXCarn4kL1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 17:31:57 -0800 (PST)
Date: Fri, 22 Jan 2016 17:31:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: RFCv4+ WIP rollup of XFS reverse-mapping, reflink, and dedupe support
Message-ID: <20160123013130.GC5496@birch.djwong.org>
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

Hi all,

I pushed all the current reflink/rmap code to github.  This time there are some
incompat disk format changes, since I added a separate CoW extent size hint per
discussion with Dave; and moved the reflink inode flag out of the way of the
DAX inode flag.

The last patch in the kernel tree tries to record extents being used to
satisfy CoW requests in the refcount btree so that if we crash we can later
find those extents (which are no longer pending) and free them.  I'm abandoning
the use of EFIs to auto-zap the pending extents because I don't want the log
size to be an upper bound on the number of CoW IOs we can have in flight at a
given time.

Furthermore, I think EFIs will interact badly with cowextsize -- since we must
maintain an EFI for every extent that is alloc'd but not yet mapped, a writeout
in the middle of the extent when the rest of the extent isn't yet dirty
requires us to log an EFD to kill the first EFI and then log two more EFIs.  If
the log happens to be /full/ (of pending EFIs) when we do this, we won't have
space to log the extra EFIs and boom.  All this assumes that we can relog EFIs
to avoid crashing the log head into the tail, which we can't at the moment.

Avoid running reflink and rmap at the same time -- there are some xfs_buf
deadlocks that I haven't sorted out yet.  xfs/821 fails until I figure out
a permanent solution to per-AG pools.

On the plus side, there's now an inheritable CoW extent size hint so that we
can fight fragmentation, and a lot more testing of IO errors and fragmentation
problems that crop up with CoW.

I'll rebase on upstream after the merge window closes on Sunday.

https://github.com/djwong/linux/commits/for-dave
https://github.com/djwong/xfsprogs/tree/for-dave
https://github.com/djwong/xfstests/tree/for-dave
https://github.com/djwong/xfs-documentation/tree/for-dave

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
