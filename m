Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCEnrrK104347 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:49:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FC731F49DCF
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:49:38 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2Yu6MnbUHboP7l5x for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 06:49:38 -0800 (PST)
Date: Mon, 12 Dec 2011 09:49:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for November 2011
Message-ID: <20111212144938.GA25014@infradead.org>
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

November saw stabilization of the Linux 3.2 release candidates, including
a few fixes for XFS.  In addition a lot of bug fixes were backported to
the 3.0 long term stable and 3.1-stable releases for users not on
bleeding edge kernels.

At the same time development for Linux 3.3 went on at a fast pace, although
no pages were merged into the development tree yet.  The highlights are:

 - further versions of the patches to log all file size updates instead of
   relying the the flaky VM writeback code for them
 - an initial version of SEEK_HOLE/SEEK_DATA support
 - removal of the old non-delaylog logging code, and cleanups resulting
   from the removal
 - large updates for the quota code

Userspace development was even more busy:

Xfsprogs saw the rushed 3.1.7 release which contains Debian packaging fixes,
a polish translation update and a xfs_repair fix.  In the meantime a lot of
xfs_repair fixes were posted but mostly not reviewed and commit yet.

Xfsdump grew support for using pthreads to write backup streams to multiple
tapes in parallel, and SGI_XFSDUMP_SKIP_FILE which has been deprecated in
favor of the nodump flag has finally been removed.

Xfstests saw an enormous amount of updates.  The fsstress tool saw major
updates to exercise even more system calls, and found numerous bugs in
all major Linux filesystems, additional ENOSPC tests, a new test for
btrfs-specific functionality and the usual amount of bug fixes and small
cleanups.  Also a series to clean up the very large filesystem testing,
including extending the support to ext4 was posted but not committed yet.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
