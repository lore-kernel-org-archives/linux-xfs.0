Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5FDJle0088266 for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 08:19:48 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC28D3C959C
	for <xfs@oss.sgi.com>; Tue, 15 Jun 2010 06:22:23 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id qTLOvgz5gxjMRS9w for <xfs@oss.sgi.com>;
	Tue, 15 Jun 2010 06:22:23 -0700 (PDT)
Date: Tue, 15 Jun 2010 09:22:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for May 2010
Message-ID: <20100615132221.GA17385@infradead.org>
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

In May 2010 we saw the long awaited release of Linux 2.6.34, which includes
a large XFS update.  The most important features appearing in 2.6.34 was the
new inode and quota flushing code, which leads to much better I/O patterns
for metadata-intensive workloads.  Additionally support for synchronous NFS
exports has been improved to give much better performance, and performance
for the fsync, fdatasync and sync system calls has been improved slightly.
A bug when resizing extremely busy filesystems has been fixed, which required
extensive modification to the data structure used for looking up the
per-allocation group data.  Last but not least there was a steady flow of
minor bug fixes and cleanups, leading to the following diffstat from
2.6.33 to 2.6.34:

  86 files changed, 3209 insertions(+), 3178 deletions(-)

Meanwhile active development aimed at 2.6.35 merge progressed.  The
major feature for this window is the merge of the delayed logging code,
which adds a new logging mode that dramatically reduces the bandwidth
required for log I/O.  See the documentation [1] for details.  Testers
for this new code are welcome.

In userland xfsprogs saw the long awaited 3.1.2 release, which can be
considered a bug fix release for xfs_repair, xfs_fsr and mkfs.xfs.  After
the release a few more fixes were merged into the development tree.
The xfstests package saw various new tests, including many tests to
exercise the quota code, and a few fixes to existing tests.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/filesystems/xfs-delayed-logging-design.txt;h=96d0df28bed323d5596fc051b0ffb96ed8e3c8df;hb=HEAD

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
