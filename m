Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44Fvjhp082562 for <xfs@oss.sgi.com>; Wed, 4 May 2011 10:57:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AF19D12298D4
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 09:01:23 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6YRmcMVDHPuw7d5f for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 09:01:23 -0700 (PDT)
Date: Wed, 4 May 2011 12:01:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for April 2011
Message-ID: <20110504160122.GA7224@infradead.org>
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

April saw further stabilization work on the Linux 2.6.39 kernel, including
a number of XFS bug fixes.  Most importantly a series of patches fixes various
OOM problems due to bad interactions between the generic writeback code
and XFS inode reclaim, but there also were other patches for various smaller
issues.  In the meantime the XFS development tree saw the addition of the
optimized busy extent tracking, which allows large speedups for multi-threaded
meta data heavy workloads, and lays the groundwork for discard support on
transaction commit, and a few other smaller patches.

On the user space side the xfsprogs and xfsdump repositories saw a very quiet
month with no applied patches, although a few were posted and discussed on
the mailing list. The xfstests repository on the other hand saw a new test
cases exercising the xfs_metadump functionally as well as a fixes to existing
tests.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
