Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7SIOT7E169467 for <xfs@oss.sgi.com>; Fri, 28 Aug 2009 13:24:44 -0500
Date: Fri, 28 Aug 2009 14:24:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: pushing out a new xfsprogs release, was Re: [PATCH] xfsprogs: fix
	unaligned access in libxfs
Message-ID: <20090828182454.GA8217@infradead.org>
References: <20090828153718.GA26409@infradead.org>
	<4A9810C7.8010806@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A9810C7.8010806@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Gabriel Vlasiu <gabrielvlasiu@gmail.com>, nathans@debian.org, xfs@oss.sgi.com

On Fri, Aug 28, 2009 at 10:15:51AM -0700, Eric Sandeen wrote:
> Looks good to me.
>
> Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Thanks.  What do people thing about pushing out a 3.0.3 xfsprogs
release?

Since 3.0.1 (discounting 3.0.2 as a Debian-only thing quickly following
3.0.1): we have the following changes the list below.  It's not a whole
lot, but everything is relatively small fixes, the the unaligned thing
makes the 3.0 series so far unusable on strict alignment platforms.

If we go for it I can update the CHANGES ASAP for the release, and
ater that we can start putting in changes for a 3.1.0 release - I have
Barry's repair speedups ready for a wider audience, Eric has the
patch to make the lazy sb counters default and I can do the long
needed resync with the kernel code.


Changes from 3.0.1 to HEAD:



Christoph Hellwig (3):
      add release.sh
      Merge branch 'master' of git://oss.sgi.com/xfs/cmds/xfsprogs
      xfsprogs: fix unaligned access in libxfs

David Chinner (1):
      mkfs: allow to make larger logs

Eric Sandeen (11):
      xfsprogs: fix readline/editline for xfs_io and xfs_quota
      xfs_io: add fallocate command
      Update CHANGES file for recent commits
      xfs_repair: catch bad depth in traverse_int_dir2block
      xfs_io: fix test for fallocate on 32bit boxes
      xfs_repair: fix agcount*agblocks overflows
      xfs_metadump: agcount*agblocks overflow
      xfs_repair: clear inodes in incorrect btree format
      the freesp doesn't support "-f" so take it out of the usage().
      xfs_db: do bounds checking in frag's scanfunc_bmap
      xfs_io: actually issue 0 size writes

Felix Blyakher (2):
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev
      3.0.1 release

Nathan Scott (2):
      Resolve minor man page warnings reported by lintian tool.
      Debian packaging updates, and bumped minor version to 3.0.2.

Nathaniel W. Turner (1):
      xfs_repair: open filesystem device exclusively

Robert Herndon (1):
      add -x flags to include/install-sh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
