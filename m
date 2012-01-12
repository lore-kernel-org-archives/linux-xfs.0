Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CJ2N0p013150 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 13:02:24 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	M4YkZs3JAA6I6b7i for <xfs@oss.sgi.com>;
	Thu, 12 Jan 2012 11:02:22 -0800 (PST)
Date: Thu, 12 Jan 2012 14:02:21 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for December 2011
Message-ID: <20120112190221.GA3108@infradead.org>
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

December saw further stabilization of the Linux 3.2 release candidates.
For XFS that meant two important fixes for sync() data integrity, to
work around issues introduced in the VFS sync code in the past few
kernel releases.  These fixes have also been backported to the 3.0-stable
release.

Development for the next merge windows continue in fast pace, although
only a relatively small amount of patches was merged into the development
tree for the Linux 3.3 window.  The most interesting topic in December
probably was further development of the SEEK_DATA /  SEEK_HOLE support,
including defining the exact semantics in presence of unwritten extents
and proper test coverage.

On the user space side December was fairly quite, with about a handful
fixes commit to xfsprogs, two new test cases and a couple of fixes in
xfstests, and no activity in xfsdump.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
