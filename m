Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB10BAcv246714 for <xfs@oss.sgi.com>; Fri, 30 Nov 2012 18:11:10 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	SJBdvCf6q1LoGYAF (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Nov 2012 16:13:29 -0800 (PST)
Date: Fri, 30 Nov 2012 19:13:28 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for October 2012
Message-ID: <20121201001327.GA8992@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kerrnel.org

October saw the merge of the XFS development tree for Linux 3.7 into
mainline as well as a few additional fixes for this new work.

Linux 3.7 will be a fairly boring release as far as XFS is concerned,
the biggest user visible changes are an intelligent implementation of
the lseek SEEK_HOLE/SEEK_DATA calls, and finally the switch to use
the inode64 allocator by default.

The XFS development tree for Linux 3.8 started getting commits in
October as well, most notably a large cleanup of the periodic sync
code.

On the user space side we saw release candidate for the next releases
of the XFS tools.  For xfsprogs the 3.1.9-rc1 release brings various
fixes in xfs_repair, especially dealing with directories as well as
various improvements in xfs_db and mkfs.xfs, three new  commands for
xfs_io and a few user visible fixes to xfs_quota.  The xfsdump 3.1.1-rc1
release adds a German string translation and support for 32-bit project
IDs.  xfstests saw its usual stream of fixes, but also a new ext4-specific
test case and a switch to use the util-linux version of fstrim instead
of a bundled one.  All user space projects saw various improvements to
the build system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
