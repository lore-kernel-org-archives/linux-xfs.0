Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3FAR5tF061726 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 05:27:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2BCA914CEBE8
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 03:30:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id heOdl6TRVnFGEVDt for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 03:30:28 -0700 (PDT)
Date: Fri, 15 Apr 2011 06:30:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for March 2011
Message-ID: <20110415103028.GA19528@infradead.org>
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

March saw the release of Linux 2.6.39, which included a sizable XFS update.
The most prominent new features of XFS in Linux 2.6.39 is support for the
FITRIM ioctl that allows discarding unused space on the filesystem
periodically, better handling of persistent preallocations especially on
NFS servers, and further scalability improvements in the buffer cache
and log code.  In additions to that the release includes a wide range
of fixes and cleanups to the code base.  The diff stat for XFS in the
Linux 2.6.39 release is:

  57 files changed, 2964 insertions(+), 2528 deletions(-)

Which means the XFS code base actually had a minor growth in code size
this time around.  In the second half of March the XFS development
tree got merged into Linus' tree for Linux 2.6.39.  Linux 2.6.39 is going
to be a rather quiet release for XFS, mostly concentrating on settling
the large changes that went into the last releases and smaller cleanups.
The only user visible change will be that the delaylog option which
improves metadata performance and scalability is now turned on by default,
and a couple of fixes that make the realtime subvolume support usable
again.

On the user space side both xfsprogs and xfsdump saw new releases in March.
The xfsprogs 3.1.5 release contains various smaller updates to xfs_repair,
xfs_metadump and xfs_quota, as well as support for the new generic hole
punching in the falloc system call in the xfs_io tool.  The xfsdump 3.0.5
release now supports up to 4 billion directory entries, has much better
performance for large dumps, and some improvements to the inventory code
and dumping of quota information, as well as long overdue updates to the
build system.  The xfstests repository has seen various build system
improvements, better FIEMAP testing, falloc support for fsx and a few
cleanups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
