Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E9627F51
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 16:41:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C52CAC004
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 14:41:16 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Bzs1NRa6RWw0OHT1 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 14:41:14 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1WHhjG-0003mR-O2
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 09:40:58 +1100
Date: Mon, 24 Feb 2014 09:40:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: master branch updated to da2b3c0
Message-ID: <20140223224058.GG4317@dastard>
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
just been updated.

The new head of the master branch is commit:

da2b3c0 xfs_io: add support for O_TMPFILE opens

New Commits:

Christoph Hellwig (1):
      [da2b3c0] xfs_io: add support for O_TMPFILE opens

Dave Chinner (2):
      [f388124] libxfs: contiguous buffers are not discontigous
      [203d38c] libxfs: clear stale buffer errors on write

Eric Sandeen (1):
      [d586858] xfs_repair: fix sibling pointer tests in verify_dir2_path()


Code Diffstat:

 io/file.c         |  5 +++--
 io/init.c         |  4 +++-
 io/io.h           |  1 +
 io/open.c         | 39 ++++++++++++++++++++++++++++++++++-----
 libxfs/rdwr.c     | 14 ++++++++++++++
 man/man8/xfs_io.8 | 12 ++++++++++--
 repair/dir2.c     |  2 +-
 7 files changed, 66 insertions(+), 11 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
