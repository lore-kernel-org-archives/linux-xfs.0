Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o82ExJVe208914 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 09:59:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D2AE44D2F
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 08:00:00 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ionDgJ9mIMnOJ7VW for
	<xfs@oss.sgi.com>; Thu, 02 Sep 2010 08:00:00 -0700 (PDT)
Date: Thu, 2 Sep 2010 10:59:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for August 2010
Message-ID: <20100902145959.GA27887@infradead.org>
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

At the first of August we finally saw the release of Linux 2.6.35,
which includes a large XFS update.  The most prominent feature in
Linux 2.6.35 is the new delayed logging code which provides massive
speedups for metadata-intensive workloads, but there has been
a large amount of other fixes and cleanups, leading to the following
diffstat:

	 67 files changed, 4426 insertions(+), 3835 deletions(-)

Given the early release of Linux 2.6.35 the merge window for the
next release fully fell into the month of August.  The XFS updates
for Linux 2.6.36 include various additional performance improvements
in the delayed logging code, for direct I/O writes and for avoiding
synchronous transactions, as well as various fixed and large amount
of cleanups, including the removal of the remaining dead DMAPI
code.

On the userspace side we saw the 3.1.3 release of xfsprogs, which includes
various smaller fixes, support for the new XFS_IOC_ZERO_RANGE ioctl and
Debian packaging updates.  The xfstests package saw one new test case
and a couple of smaller patches, and xfsdump has not seen any updates at
all.

The XMLified versions of the XFS users guide, training labs and filesystem
structure documentation are now available as on the fly generated html on
the xfs.org website and can be found at:

	http://www.xfs.org/index.php/XFS_Papers_and_Documentation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
