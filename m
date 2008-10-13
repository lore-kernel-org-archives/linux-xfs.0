Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 12 Oct 2008 23:30:16 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9D6UDSf031709
	for <xfs@oss.sgi.com>; Sun, 12 Oct 2008 23:30:13 -0700
Subject: TAKE 988140 - Use struct inodes instead of vnodes to kill vn_grab
Message-Id: <20081013063153.C7F9258C38F4@chook.melbourne.sgi.com>
Date: Mon, 13 Oct 2008 17:31:53 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Use struct inodes instead of vnodes to kill vn_grab

With the sync code relocated to the linux-2.6 directory we can use
struct inodes directly. If we do the same thing for the quota
release code, we can remove vn_grab altogether.  While here, convert
the VN_BAD() checks to is_bad_inode() so we can remove vnodes
entirely from this code.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Mon Oct 13 17:31:33 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-sync
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32304a
fs/xfs/quota/xfs_qm_syscalls.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_syscalls.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.159 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.159&r2=text&tr2=1.158&f=h
fs/xfs/linux-2.6/xfs_sync.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Use struct inodes instead of vnodes to kill vn_grab
