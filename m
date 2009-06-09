Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n59CY1cZ036715 for <xfs@oss.sgi.com>; Tue, 9 Jun 2009 07:34:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5025E2E0CA7
	for <xfs@oss.sgi.com>; Tue,  9 Jun 2009 05:34:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8A17DTOB4hNPE1Wm for
	<xfs@oss.sgi.com>; Tue, 09 Jun 2009 05:34:22 -0700 (PDT)
Date: Tue, 9 Jun 2009 08:34:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for May 2009
Message-ID: <20090609123421.GA15623@infradead.org>
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


In May Linux 2.6.30 was getting close to be released, and various
important XFS fixes made it during the latest release candidates.
In the meantime some big patch series to rework the sync code and
the inode allocator have been posted for the next merge window.

On the userspace side xfsprogs and xfsdump 3.0.1 were finally released,
quickly followed by 3.0.2 releases with updated Debian packaging.
After that various small patches that were held back made it into xfsprogs.
A patch to add the xfs_reno tool which allows to move inodes around to
fit into 32 bit inode number space has been posted which is also one
central aspect of future online shrinking support.

There has been major activity on xfstests including adding generic
filesystems support to allow running tests that aren't XFS-specific on
any Linux filesystems.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
