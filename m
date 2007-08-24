Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 04:09:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OB9N4p030671
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 04:09:26 -0700
Subject: PARTIAL TAKE 969608 - move v_trace from bhv_vnode to xfs_inode
Message-Id: <20070824110919.22E8258C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 21:09:18 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

move v_trace from bhv_vnode to xfs_inode

struct bhv_vnode is on it's way out, so move the trace buffer to the
XFS inode.  Note that this makes the tracing macros rather misnamed,
but this kind of fallout will be fixed up incrementally later on.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:08:51 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29498a
fs/xfs/xfsidbg.c - 1.327 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.327&r2=text&tr2=1.326&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_vnodeops.c - 1.715 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.715&r2=text&tr2=1.714&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_iget.c - 1.229 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.229&r2=text&tr2=1.228&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_inode.c - 1.476 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.476&r2=text&tr2=1.475&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_inode.h - 1.230 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.230&r2=text&tr2=1.229&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_utils.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_utils.h - 1.37 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.37&r2=text&tr2=1.36&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_rename.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/xfs_dir2.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_ioctl.c - 1.150 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.150&r2=text&tr2=1.149&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_vnode.c - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_vnode.h - 1.135 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.135&r2=text&tr2=1.134&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_super.c - 1.388 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.388&r2=text&tr2=1.387&f=h
	- move v_trace from bhv_vnode to xfs_inode

fs/xfs/linux-2.6/xfs_aops.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
	- move v_trace from bhv_vnode to xfs_inode
