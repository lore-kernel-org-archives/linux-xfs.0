Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32F787F47
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 18:13:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 13358304032
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 16:13:01 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	swlcFqfVYpLlHrXj for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 16:12:59 -0800 (PST)
Date: Sat, 21 Feb 2015 11:12:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: PNFS block layout support for 3.20-rc1
Message-ID: <20150221001228.GS4251@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

Can you please pull the updates from the tree below? It contains the
changes to XFS needed to support the PNFS block layout server that
you pulled in through Bruce's NFS server tree merge. I originally
thought that I'd need to merge changes into the NFS server side,
but Bruce had already picked them up and so this is purely changes
to the fs/xfs/ codebase.

It should merge cleanly with your current tree - if it doesn't then
I've probably done something wrong.

-Dave.

The following changes since commit bad962662dbc60e76ec1baae34af56b1ba2dfa5f:

  Merge branch 'xfs-misc-fixes-for-3.20-4' into for-next (2015-02-10 09:24:25 +1100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-pnfs-for-linus-3.20-rc1

for you to fetch changes up to 781355c6e5ae87908de27dec3380a34918c33eee:

  xfs: recall pNFS layouts on conflicting access (2015-02-16 11:59:50 +1100)

----------------------------------------------------------------
xfs: pnfs block layout support for 3.20-rc1

This update contains the implementation of the PNFS server export
methods that enable use of XFS filesystems as a block layout target.

----------------------------------------------------------------
Christoph Hellwig (2):
      xfs: implement pNFS export operations
      xfs: recall pNFS layouts on conflicting access

 fs/xfs/Makefile     |    1 +
 fs/xfs/xfs_export.c |    6 +
 fs/xfs/xfs_file.c   |   14 ++-
 fs/xfs/xfs_fsops.c  |    6 +
 fs/xfs/xfs_ioctl.c  |    9 +-
 fs/xfs/xfs_iops.c   |   13 ++-
 fs/xfs/xfs_iops.h   |    1 +
 fs/xfs/xfs_mount.h  |   11 ++
 fs/xfs/xfs_pnfs.c   |  322 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_pnfs.h   |   18 +++
 10 files changed, 393 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/xfs_pnfs.c
 create mode 100644 fs/xfs/xfs_pnfs.h
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
