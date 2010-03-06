Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26GFfE4101208 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 10:15:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8232113FF863
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 08:17:11 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id BE2nVZlpKGsn3rj5 for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 08:17:11 -0800 (PST)
Date: Sat, 6 Mar 2010 11:17:10 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for February 2010
Message-ID: <20100306161709.GA28346@infradead.org>
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

February saw the release of the Linux 2.6.33 kernel, which includes
a large XFS update.  The biggest user-visible change in Linux 2.6.33
is that XFS now support the generic Linux trace event infrastructure,
which allows tracing lots of XFS behavior with a normal production
built kernel.  Except for this Linux 2.6.33 has been mostly a bug-fix
release, fixing various user reported bugs in previous releases.
The total diffstat for XFS in Linux 2.6.33 looks like:


  84 files changed, 3023 insertions(+), 3550 deletions(-)

In addition to that the merge window for Linux 2.6.34 opened and the
first merge of the XFS tree made it into Linus tree.  Unlike Linux
2.6.33 this merge window includes major feature work.  The most
important change for users is a new algorithm for inode and quota
writeback that leads to better I/O locality and improved metadata
performance.  The second big change is a rewrite of the per-allocation
group data lookup which fixes a long-standing problem in the code
to grow a life filesystem and will also ease future filesystem
shrinking support.  Not merged through the XFS tree, but of great
importance for embedded users is a new API that allows XFS to properly
flush cache lines on it's log and large directory buffers, making
XFS work properly on architectures with virtually indexed caches,
such as parisc and various arm and mips variants.  Last but not
least there is an above average amount of cleanups that went into
Linus tree in this cycle.

There have been more patches on the mailing list that haven't made
it to Linus tree yet, including an optimized implementation of
fdatasync(2) and massive speedups for metadata workloads on
NFS exported XFS filesystems.

On the userspace side February has been a relatively quite month.
Lead by xfstests only a moderate amount of fixes made it into
the respective trees.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
