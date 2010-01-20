Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0K0WsRE227480 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 18:32:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FC44F25466
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 16:33:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	UrBVEHiDUzDu5Meu for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 16:33:53 -0800 (PST)
Date: Wed, 20 Jan 2010 11:33:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: Warning fixes for 2.6.34
Message-ID: <20100120003350.GF14035@discord.disaster>
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
To: aelder@sgi.com
Cc: xfs@oss.sgi.com

Alex,

This is the series that Christoph reviewed this morning. I've fixed
up the hunks that were in the wrong patch. Please pull.

----

The following changes since commit 4e23471a3f3aba885ea70100db47ccacb5f069f6:
  Christoph Hellwig (1):
        xfs: move more buffer helpers into xfs_buf.c

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git warnings

Dave Chinner (10):
      xfs: directory names are unsigned
      xfs: convert DM ops to use unsigned char names
      xfs: convert dirnameops to unsigned char names
      xfs: make xfs_dir_cilookup_result use unsigned char
      xfs: xfs_buf_iomove() doesn't care about signedness
      xfs: convert attr to use unsigned names
      xfs: clean up sign warnings in dir2 code
      xfs: make compile warn about char sign mismatches again
      xfs: suppress spurious uninitialised var warning in xfs_bmapi()
      xfs: rearrange xfs_mod_sb() to avoid array subscript warning

 fs/xfs/Makefile                |    2 +-
 fs/xfs/linux-2.6/xfs_acl.c     |   11 ++++++-----
 fs/xfs/linux-2.6/xfs_buf.c     |    2 +-
 fs/xfs/linux-2.6/xfs_buf.h     |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |   18 +++++++++---------
 fs/xfs/linux-2.6/xfs_ioctl.h   |   12 ++++++------
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 ++--
 fs/xfs/linux-2.6/xfs_iops.c    |    4 ++--
 fs/xfs/linux-2.6/xfs_xattr.c   |   27 +++++++++++++++++++--------
 fs/xfs/xfs_acl.h               |    4 ++--
 fs/xfs/xfs_attr.c              |   38 +++++++++++++++++++++++---------------
 fs/xfs/xfs_attr.h              |    2 +-
 fs/xfs/xfs_attr_leaf.c         |   28 ++++++++++++++--------------
 fs/xfs/xfs_attr_sf.h           |    2 +-
 fs/xfs/xfs_bmap.c              |    2 +-
 fs/xfs/xfs_da_btree.c          |    4 ++--
 fs/xfs/xfs_da_btree.h          |    5 +++--
 fs/xfs/xfs_dir2.c              |    8 ++++----
 fs/xfs/xfs_dir2.h              |    4 ++--
 fs/xfs/xfs_dir2_block.c        |    9 +++++----
 fs/xfs/xfs_dir2_leaf.c         |    2 +-
 fs/xfs/xfs_dir2_sf.c           |    2 +-
 fs/xfs/xfs_mount.c             |    7 +++----
 fs/xfs/xfs_mount.h             |    3 ++-
 fs/xfs/xfs_types.h             |    4 ++--
 fs/xfs/xfs_vnodeops.c          |    6 ++++--
 fs/xfs/xfs_vnodeops.h          |   10 +++++-----
 27 files changed, 123 insertions(+), 99 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
