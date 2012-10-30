Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9ULivIV074979 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 16:44:57 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dVwrS1cm8gMjBwbS (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Oct 2012 14:46:47 -0700 (PDT)
Date: Tue, 30 Oct 2012 17:46:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for September 2012
Message-ID: <20121030214646.GA12771@infradead.org>
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

September saw the release of Linux 3.6 which included a slightly smaller
than usual XFS update:

 51 files changed, 2607 insertions(+), 2455 deletions(-)

The bulk of the changes in Linux 3.6 is made up by native support for
discontinuous buffers, with various minor bug fixes and cleanups making up
the rest.  In the meantime the mailing list was busy with multiple revisions
of the sync/unmount code rewrite, and the patch series to make the inode64
mount option remountable and the default.

On the user space side xfsprogs saw new support for the preadv, pwritev and
sync_file_range system calls in xfs_io as well as minor fixes to libxcmd and
mkfs.xfs, xfsdump grew support for dumping and restoring 32-bit project ids
and and saw an update to the German translation.  Xfstests saw a large number
of fixes, and a single new test case.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
