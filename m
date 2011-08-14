Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ENCI0A011730 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 18:12:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1108DB1D2
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 16:12:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	DgXVkIhpMVyRqGxk for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 16:12:17 -0700 (PDT)
Date: Sun, 14 Aug 2011 19:12:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for July 2011
Message-ID: <20110814231217.GA30171@infradead.org>
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

July finally saw the release of Linux 3.0, including a relatively small XFS
update:

  37 files changed, 1168 insertions(+), 847 deletions(-)

The primary news in this release is a complete rework of the busy extent
tracking, which speeds up allocation heavy multithreaded workloads.  This
feature also allowed adding support for discard support at transaction
commit time using the discard mount option.  While the implementation of
discards in XFS is state of the art it should be considered mostly a
technology preview until various efficiency issue in the block layer
discard support are sorted out.  Another important feature visible to
users is that XFS now supports using external logs even when using volatile
write caches, although the implementation is not fully optimized yet,
the rest of the changes consists of the usual pile of bug fixes and a
relatively small set of cleanups.  After the release of Linux 3.0 the
merge window for Linux 3.1 also fell mostly into July.   The XFS merge
for 3.1 included further speedups for the AIL code, and a huge amount
of cleanups.

On the userspace side the biggest item was the merge of the libxfs resync
with the Linux 2.6.39 kernel code.  In addition to that xfsprogs saw small
xfs_repair updates, xfstests saw various fixes to fsx, and various build
system fixes were commit to all userspace repositories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
