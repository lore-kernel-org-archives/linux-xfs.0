Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 28 Jul 2006 01:09:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S88xDW014214
	for <xfs@oss.sgi.com>; Fri, 28 Jul 2006 01:09:10 -0700
Date: Fri, 28 Jul 2006 18:08:13 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: XFS fixes for 2.6.18-rc2
Message-ID: <20060728180813.B2197701@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linus Torvalds <torvalds@osdl.org>
Cc: Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

Hi Linus,

Please pull from:
	git://oss.sgi.com:8090/nathans/xfs-rc-2.6

This will update the following files:

 fs/xfs/linux-2.6/xfs_buf.h   |    4 ++--
 fs/xfs/linux-2.6/xfs_super.c |    7 +++++++
 fs/xfs/quota/xfs_qm_bhv.c    |   19 +++++++++++++------
 fs/xfs/xfs_inode.c           |   17 ++++++++++-------
 fs/xfs/xfs_log.c             |   12 ++++++------
 fs/xfs/xfs_vfsops.c          |    2 +-
 6 files changed, 39 insertions(+), 22 deletions(-)

through these commits:

commit 2a293b7d5aa2f0d1e3d87b642f7ac263c2d664e3
Author: Christoph Hellwig <hch@lst.de>
Date:   Fri Jul 28 17:04:26 2006 +1000

    [XFS] All xfs_disk_dquot_t values are (as the name says) disk endian.
    Before putting them into struct statfs they should be endian-swapped.
    
    SGI-PV: 954580
    SGI-Modid: xfs-linux-melb:xfs-kern:26550a
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Nathan Scott <nathans@sgi.com>


commit f5faad799475c4058416264f672bb33bf8b5ef41
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Jul 28 17:04:44 2006 +1000

    [XFS] Fix remount vs no/barrier options by ensuring we clear unwanted
    flags from iclog buffers before submitting them for writing.
    
    SGI-PV: 954772
    SGI-Modid: xfs-linux-melb:xfs-kern:26605a
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>


commit b2ea401bac39e75ebb64038609ed22efbc799905
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Jul 28 17:05:13 2006 +1000

    [XFS] Fix a barrier related forced shutdown on mounts with quota enabled.
    
    SGI-PV: 912426
    SGI-Modid: xfs-linux-melb:xfs-kern:26622a
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>


commit 41ff715abc49324fb2cb20e66bc4e0290cfdbe51
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Jul 28 17:05:51 2006 +1000

    [XFS] Ensure bulkstat from an invalid inode number gets caught always with
    EINVAL.
    
    SGI-PV: 953819
    SGI-Modid: xfs-linux-melb:xfs-kern:26629a
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>


-- 
Nathan
