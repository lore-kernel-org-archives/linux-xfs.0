Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAJ5GVGA031815 for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 23:16:32 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70A6C1598258
	for <xfs@oss.sgi.com>; Tue, 18 Nov 2008 21:16:28 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id G888fjw7vBUNQRXh for <xfs@oss.sgi.com>;
	Tue, 18 Nov 2008 21:16:28 -0800 (PST)
Message-Id: <20081119044401.573365619@sandeen.net>
Date: Tue, 18 Nov 2008 22:44:01 -0600
From: sandeen@sandeen.net
Subject: [patch 00/11] RFC: compat ioctl fixes/cleanups/additions
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org

This should properly hook up all ioctls which need compat
handlers on intel or ppc; it passes the auto qa group on intel,
and does ok on ppc (there are still issues with xfsdump itself
if the ppc page size is large (64k in my case))

This might be a little overboard; I'm half tempted to remove the
handlers that only intel boxes need; would anyone be running 32-bit
apps calling xfs ioctls on x86_64 or ia64?  Seems unlikely; and
removing them would cut down the size of this patchset:

 linux-2.6/xfs_ioctl.c   |    6 
 linux-2.6/xfs_ioctl32.c |  651 +++++++++++++++++++++++++++++++++---------------
 linux-2.6/xfs_ioctl32.h |  209 +++++++++++++++
 xfs_fs.h                |    6 
 xfs_itable.c            |   45 ++-
 xfs_itable.h            |   14 +
 6 files changed, 716 insertions(+), 215 deletions(-)

If the sgi guys can toss this into qa, I'd be much obliged.  I
hope to have some xfsdump fixes at some point so we can actually
see most things pass (if your ppc box has < 64k pages, it might
work fine for you already...)

Thanks,
-Eric

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
