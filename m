Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86C3fGr076615 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 07:03:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 06B0D13EC5F
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 05:03:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	FAS23uLw06nyF8AK for <xfs@oss.sgi.com>;
	Tue, 06 Sep 2011 05:03:40 -0700 (PDT)
Date: Tue, 6 Sep 2011 08:03:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for August 2011
Message-ID: <20110906120340.GA19636@infradead.org>
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

August saw further release candidates of Linux 3.1, which had been quite
for XFS except for the bulk renaming of many XFS source files so that all
source files are now located directly underneath the fs/xfs/ directory.

A lot of development for the Linux 3.2 kernel series was going on,
including an overhaul of the data I/O completion handler, further buffer
cache speedups and cleanups, a major refactoring around xfs_bmapi, quota
locking changes, and optimization for direct I/O on high IOP solid state
devices.

On the userspace side xfsdump saw a lot of cleanups in preparation of porting
the multithreaded dump and restore code from IRIX.  Xfsprogs saw a few fix
to the xfs_quota tool and mkfs.xfs as well as a man page update.  This month
xfstests did not see any new test cases, but it got the usual amount of fixes
and  grew support for jfs and NFS v4.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
