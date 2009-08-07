Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n77HXXtt144782 for <xfs@oss.sgi.com>; Fri, 7 Aug 2009 12:33:34 -0500
Date: Fri, 7 Aug 2009 13:34:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PULL REQUEST] vfs/xfs: fix freeing of inodes not yet added to the
	inode cache
Message-ID: <20090807173423.GA19588@infradead.org>
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
To: torvalds@linux-foundation.org, felixb@sgi.com
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus, hi Felix,

not sure which way this should go, especially with Al being offline,
it's a fix for an XFS only bug, but mostly touching the VFS.

These three patches fix problems we intorduced when redoing the XFS
inode caching in 2.6.29 (yes, that long ago).  The actual fixes are
mostly in inode.c, but in functionality that was only exported in that
way for XFS and doesn't have other users, which the last patch just
mostly splits up a function in XFS to fix the way we delete inodes
that lost the race of adding them to the inode.  

As you can see by the Reported-by tags on the last patch tons of people
hit it (probably the most I've ever seen for a single bug), and it's been
harassing us for a long time, so I'd really like to see this getting
into 2.6.31.  It's been out on -fsdevel for review for a couple of days.


The following changes since commit 90bc1a658a53f8832ee799685703977a450e5af9:
  Linus Torvalds (1):
        Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/hch/xfs-icache-races.git master

Christoph Hellwig (3):
      vfs: fix inode_init_always calling convention
      vfs: add __destroy_inode
      xfs: fix freeing of inodes not yet added to the inode cache

 fs/inode.c         |   39 ++++++++------
 fs/xfs/xfs_iget.c  |  142 +++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_inode.h |   17 ------
 include/linux/fs.h |    3 +-
 4 files changed, 98 insertions(+), 103 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
