Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8348ErP231964 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 23:08:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E848347A06
	for <xfs@oss.sgi.com>; Thu,  2 Sep 2010 21:08:53 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IwztKMyRq7U4g9xz for <xfs@oss.sgi.com>;
	Thu, 02 Sep 2010 21:08:53 -0700 (PDT)
Date: Fri, 3 Sep 2010 14:08:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT PULL] xfs: fixes for 2.6.36
Message-ID: <20100903040850.GB705@dastard>
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

Hi Alex,

Can you please pull the following branch for your next 2.6.36
bug-fix update to linus? Thanks.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git 2.6.36-xfs-misc

Dave Chinner (2):
      xfs: improve buffer cache hash scalability
      xfs: prevent 32bit overflow in space reservation

 fs/xfs/linux-2.6/xfs_buf.c |    8 +-------
 fs/xfs/linux-2.6/xfs_buf.h |    1 -
 fs/xfs/xfs_vnodeops.c      |   13 ++++++++++---
 3 files changed, 11 insertions(+), 11 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
