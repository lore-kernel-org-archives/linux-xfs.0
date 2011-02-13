Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1DIdhie070072 for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 12:39:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE01D15610EE
	for <xfs@oss.sgi.com>; Sun, 13 Feb 2011 10:42:19 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IoK7AhrSd3P4Kl7y for
	<xfs@oss.sgi.com>; Sun, 13 Feb 2011 10:42:19 -0800 (PST)
Date: Sun, 13 Feb 2011 13:42:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for January 2011
Message-ID: <20110213184219.GA22792@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On the 4th of January we saw the release of Linux 2.6.37, which contains a
large XFS update:

    67 files changed, 1424 insertions(+), 1524 deletions(-)

User visible changes are the new XFS_IOC_ZERO_RANGE ioctl which allows
to convert already allocated space into unwritten extents that return
zeros on a read, and support for 32-bit wide project IDs.  The other large
item are various changes to improve metadata scalability even further,
by changes to the the buffer cache, inode lookup and other parts of the
filesystem driver.

After that the XFS development tree for 2.6.38 was merged into mainline,
with an even larger set of changes.  Notable items include support for the
FITRIM ioctl to discard unused space on SSDs and thinly provisioned storage
systems, a buffer LRU scheme to improve hit rates for metadata, an
overhaul of the log subsystem locking, dramatically improving scalability
in that area, and much smarter handling of preallocations, especially
for files closed and reopened frequently, e.g. by the NFS server.

User space development has been very quite, with just a few fixes committed
to the xfstests repository, although various additional patches for xfsprogs
and xfstests that haven't been committed yet were discussed on the mailing list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
