Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q48FZTCi199606 for <xfs@oss.sgi.com>; Tue, 8 May 2012 10:35:32 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	si0fvV6JpPxvp4vI (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 May 2012 08:35:27 -0700 (PDT)
Date: Tue, 8 May 2012 11:35:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for March 2012
Message-ID: <20120508153526.GA8176@infradead.org>
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

March saw the release of Linux 3.3, which saw an XFS update slightly smaller
than usual, and consisting largely of code removal and cleanups, with the
only user visible change being the removal of the old logging code, and thus
the "nodelaylog" mount option.  This is reflected in a diffstat with more
than twice as many deletions as additions:

  45 files changed, 954 insertions(+), 2182 deletions(-)

After that Linux 3.4 merge window opened, and a big XFS updates was merged
into mainline, again removing a lot more code than adding it.  The
highlight are quota changes to make in-memory quota caching a lot faster
and more scalable, as well as changes to log all metadata updates on a
live XFS filesystem, thus finishing the consolidation of all metadata I/O
code pathes to just after many years of hard work.

Development for the Linux 3.5 merge window also were in full steam,
including a series to kill the xfsbufd daemon in favour of on-stack
delayed buffer writeback lists.

On the user space side we finally saw the long awaited xfsprogs 3.1.8 
and xfsdump 3.1.0 releases.  The new xfsprogs release features a larger
number of repair fixes and speedups, as well as smaller updates to the
other tools.  All users are recommended to upgrade to this version.
Major updates in xfsdump 3.1.0 is support for dumping multiple I/O
streams in parallel, a new dump format to support all 32 bits of the
inode generation number, removal of support for the old SGI_XFSDUMP_SKIP_FILE
extended attribute, as well as various smaller fixes.

Development of xfstests included at its normal pace, with a few new
test cases for xfsdump, as well as various fixes for existing test cases
and the addition of a new "dangerous" group to skip tests that potentially
crash the system if an too old kernel is used.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
