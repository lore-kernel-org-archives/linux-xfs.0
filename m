Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 29 Aug 2006 21:24:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7U4OHDW022402
	for <xfs@oss.sgi.com>; Tue, 29 Aug 2006 21:24:29 -0700
Date: Wed, 30 Aug 2006 14:23:25 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: XFS update for 2.6.18-rc5
Message-ID: <20060830142325.A3184982@wobbly.melbourne.sgi.com>
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
	git://oss.sgi.com:8090/xfs/xfs-2.6.git

This will update the following files:

 MAINTAINERS       |    3 ++-
 fs/xfs/xfs_bmap.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

through these commits:

commit 1ad8f401b6e16e3ba8a70dcda466e7a0986f7e5e
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Aug 30 13:41:23 2006 +1000

    [XFS] Update the MAINTAINERS file entry for XFS.
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>


commit 7288026b8671061aff7663b1766037b3f2573627
Author: Adrian Bunk <bunk@stusta.de>
Date:   Wed Aug 30 13:41:58 2006 +1000

    [XFS] Fix char size overflow in bmap_alloc call for unwritten extent
    conversion.
    
    Since bma.conv is a char and XFS_BMAPI_CONVERT is 0x1000, bma.conv was
    always assigned zero. Spotted by the GNU C compiler (SVN version).
    
    SGI-PV: 947312
    SGI-Modid: xfs-linux-melb:xfs-kern:26887a
    
    Signed-off-by: Adrian Bunk <bunk@stusta.de>
    Signed-off-by: Nathan Scott <nathans@sgi.com>


-- 
Nathan
