Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Dec 2006 15:56:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB6Nu5aG014198
	for <xfs@oss.sgi.com>; Wed, 6 Dec 2006 15:56:07 -0800
Subject: TAKE 956832 - Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode()
Message-Id: <20061107063226.5E2B458FA27C@chook.melbourne.sgi.com>
Date: Tue,  7 Nov 2006 17:32:26 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Prevent a deadlock when xfslogd unpins inodes.

The previous fixes for the use after free in xfs_iunpin left a nasty
log deadlock when xfslogd unpinned the inode and dropped the last
reference to the inode. the ->clear_inode() method can issue
transactions, and if the log was full, the transaction could push on
the log and get stuck trying to push the inode it was currently
unpinning.

To fix this, we provide xfs_iunpin a guarantee that it will always
have a valid xfs_inode <-> linux inode link or a particular flag
will be set on the inode. We then use log forces during lookup to
ensure transactions are completed before we recycle the inode.
This ensures that xfs_iunpin will never use the linux inode after it
is being freed, and any lookup on an inode on the reclaim list will
wait until it is safe to attach a new linux inode to the xfs inode.

Date:  Tue Nov  7 17:31:17 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  stripathi@agami.com,t-nagano@ah.jp.nec.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27359a
fs/xfs/xfs_vnodeops.c - 1.687 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.687&r2=text&tr2=1.686&f=h
	- Set the reclaimable flag before we break the xfs inode - linux inode
	  link so that xfs_iunpin doesn't have to deal with linux-inode
	  use-after-free conditions during inode reclaim.

fs/xfs/xfs_iget.c - 1.224 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.224&r2=text&tr2=1.223&f=h
	- If we find a reclaimable inode, make sure it is not pinned before we
	  reuse it so we don't get inode unpinning running incorrectly on a
	  new linux inode. Also ensure that we don't remove unlinked reclaimable
	  inodes from the reclaim list which would cause them to leak.

fs/xfs/xfs_inode.c - 1.454 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.454&r2=text&tr2=1.453&f=h
	- Remove the igrab/iput form xfs_iunpin and provide it with a guarantee
	  that either the inode will be marked reclaimable or the xfs inode -
	  linux inode link will be intact. This fixes a deadlock that calling
	  iput() from the xfslogd can trigger while also providing us a
	  reliable method for avoiding use-after-free of the linux inode.
