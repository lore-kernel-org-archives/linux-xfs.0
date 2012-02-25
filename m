Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1PC2NRt146854 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 06:02:23 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8HwvKLlsJCwplqOh (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 25 Feb 2012 04:02:18 -0800 (PST)
Date: Sat, 25 Feb 2012 07:02:16 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for January 2012
Message-ID: <20120225120216.GA21721@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

January saw the release of Linux 3.2, which as usual included a large
number of XFS changes, most notably an large speedup for removing files
that have external attribute blocks, speedups and livelock fixes for
sync while doing heavy I/O, and large internal cleanups of the inode
block map handling.  The diffstat for XFS in Linux 3.2 is:

 54 files changed, 2414 insertions(+), 2625 deletions(-)

which is slightly below the average of the last releases.

In the meantime development for 3.3 went ahead full speed, including
the removal of the deprecated pre-delaylog logging code, various
quota cleanups, a shrink of the inode, a great simplification of the file
write path as well as the usual batch of fixes and cleanups.

On the userland side xfs_repair saw various major fixes and speedups,
with few other fixes thrown in, while xfsdump got two commits fixing
longer standing issues recently reported on the mailing list.  For
xfstests January was an extremely slow month, seeing only two new test cases
and less than a handful of other updates.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
