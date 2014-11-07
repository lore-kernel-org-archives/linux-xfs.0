Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9ABE27F3F
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 18:41:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 29C9AAC006
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 16:41:55 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PByhPfGayhtAyS98 for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 16:41:50 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1XmXcO-0000uv-FW
	for xfs@oss.sgi.com; Fri, 07 Nov 2014 11:41:36 +1100
Date: Fri, 7 Nov 2014 11:41:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 9851fd7
Message-ID: <20141107004136.GI23575@dastard>
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
To: xfs@oss.sgi.com

Hi folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated. Given all the fixes we've accumulated since
v3.2.1 was released, I'm thinking that we should do a 3.2.2 release
shortly, so please test this tree now...

The new head of the master branch is commit:

9851fd7 repair: AGFL rebuild fails if btree split required

New Commits:

Dave Chinner (2):
      [7c7c113] repair: fix XR_BLD_FREE_TRACE compilation errors
      [9851fd7] repair: AGFL rebuild fails if btree split required

Eric Sandeen (7):
      [bd9cc49] libxfs: use structure initializers for cache_operations
      [3e1e6f8] libxfs: fix endian mishap in xfs_dialloc_ag()
      [167d49c] libxfs: fix harmless sparse endian nit
      [24e0479] xfsprogs: two more completely harmless sparse nits
      [c7dd81c] xfs_io: add sync and syncfs commands
      [e21c11e] mkfs: ignore stripe geom if sunit or swidth == physical sector size
      [392e896] mkfs: don't warn about log sunit size if it was auto-discovered

Mark Tinguely (1):
      [5b547f3] xfsctl.3: fix XFS_IOC_FSSETXATTR fields


Code Diffstat:

 io/Makefile           |  6 ++++-
 io/init.c             |  3 ++-
 io/io.h               |  1 +
 io/sync.c             | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/rdwr.c         | 14 +++++------
 libxfs/xfs_ialloc.c   |  3 ++-
 m4/package_libcdev.m4 | 17 +++++++++++++
 man/man3/xfsctl.3     |  5 ++--
 man/man8/xfs_io.8     | 10 ++++++++
 mkfs/xfs_mkfs.c       | 48 ++++++++++++++++++++++-------------
 repair/phase5.c       | 61 +++++++++++++++++++++++++++++---------------
 repair/prefetch.c     |  2 +-
 rtcp/xfs_rtcp.c       |  2 +-
 13 files changed, 191 insertions(+), 51 deletions(-)
 create mode 100644 io/sync.c
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
