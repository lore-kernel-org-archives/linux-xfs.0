Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0i9Fl124912 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:44:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1D775256335
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:45:17 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	DOf0aurBmjvU1n4V for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:45:17 -0800 (PST)
Date: Wed, 12 Jan 2011 11:45:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: unaligned AIO DIO corruption fixes
Message-ID: <20110112004511.GM28803@dastard>
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
Cc: aelder@sgi.com

Hi Alex,

The reviewed series is ready to be pulled into the master XFS
branch. Thanks.

The following changes since commit d0eb2f38b250b7d6c993adf81b0e4ded0565497e:

  xfs: convert grant head manipulations to lockless algorithm (2010-12-21 12:29:14 +1100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git xfs-for-2.6.38

Dave Chinner (8):
      xfs: ensure sync write errors are returned
      xfs: factor common post-write isize handling code
      xfs: factor post-write newsize updates
      xfs: introduce xfs_rw_lock() helpers for locking the inode
      xfs: split direct IO write path from xfs_file_aio_write
      xfs: split buffered IO write path from xfs_file_aio_write
      xfs: factor common write setup code
      xfs: serialise unaligned direct IOs

 fs/xfs/linux-2.6/xfs_file.c |  535 +++++++++++++++++++++++++------------------
 1 files changed, 307 insertions(+), 228 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
