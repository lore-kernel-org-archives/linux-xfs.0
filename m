Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17931800B
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 18:47:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DD3B28F8037
	for <xfs@oss.sgi.com>; Mon,  3 Feb 2014 16:47:28 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3nLiGugt19hr59vx for <xfs@oss.sgi.com>;
	Mon, 03 Feb 2014 16:47:27 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1WAUAb-0000JY-Ob
	for xfs@oss.sgi.com; Tue, 04 Feb 2014 11:47:21 +1100
Date: Tue, 4 Feb 2014 11:47:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to 6e79202
Message-ID: <20140204004721.GY13997@dastard>
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

Hi Folks,

The xfsprogs repository at git://oss.sgi.com/xfs/cmds/xfsprogs has
just been updated.

The new head of the master branch is commit:

6e79202 metadump: fully support discontiguous directory blocks

New Commits:

Dave Chinner (9):
      [aaca101] xfs_repair: add support for validating dirent ftype field
      [7e3ab89] libxfs: add a flags field to libxfs_getbuf_map
      [6d5e5ee] libxfs: remove map from libxfs_readbufr_map
      [dd9093d] xfs_repair: fix discontiguous directory block support
      [878afc6] metadump: sanitise write_buf/index return values
      [1516a5b] metadump: support writing discontiguous io cursors
      [d452ae4] metadump: separate single block objects from multiblock objects
      [ed73748] metadump: walk single fsb objects a block at a time
      [6e79202] metadump: fully support discontiguous directory blocks


Code Diffstat:

 db/io.c              |   4 +-
 db/metadump.c        | 573 ++++++++++++++++++++++++++++++---------------------
 include/libxfs.h     |  11 +-
 include/xfs_dir2.h   |   3 +
 libxfs/rdwr.c        |  27 +--
 libxfs/trans.c       |   4 +-
 libxfs/xfs_dir2.c    |  16 ++
 repair/dino_chunks.c |  11 +
 repair/incore.h      |  27 ++-
 repair/incore_ino.c  |  30 ++-
 repair/phase6.c      | 246 +++++++++++++++-------
 repair/prefetch.c    | 120 +++++++++--
 repair/scan.c        |   4 +-
 13 files changed, 710 insertions(+), 366 deletions(-)

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
