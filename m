Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:05:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OB5M4p029298
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:05:24 -0700
Subject: PARTIAL TAKE 969608 - move v_iocount from bhv_vnode to xfs_inode
Message-Id: <20070824110518.316B158C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:05:18 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

move v_iocount from bhv_vnode to xfs_inode

struct bhv_vnode is on it's way out, so move the I/O count to the XFS inode.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:04:54 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29497a
fs/xfs/xfs_vnodeops.c - 1.714 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.714&r2=text&tr2=1.713&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/xfs_vfsops.c - 1.529 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.529&r2=text&tr2=1.528&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/xfs_inode.c - 1.475 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.475&r2=text&tr2=1.474&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/xfs_inode.h - 1.229 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.229&r2=text&tr2=1.228&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_vnode.c - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_vnode.h - 1.134 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.134&r2=text&tr2=1.133&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_aops.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- move v_iocount from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_aops.h - 1.11 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.h.diff?r1=text&tr1=1.11&r2=text&tr2=1.10&f=h
	- move v_iocount from bhv_vnode to xfs_inode
