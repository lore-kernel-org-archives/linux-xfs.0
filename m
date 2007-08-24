Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 03:58:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OAvs4p027165
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 03:57:56 -0700
Subject: PARTIAL TAKE 969608 - kill the v_flag member in struct bhv_vnode
Message-Id: <20070824105749.ED8F758C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 20:57:49 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill the v_flag member in struct bhv_vnode

All flags previous handled at the vnode level are not in the xfs_inode
where we already have a flags mechanisms and free bits for flags
previously in the vnode.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 20:57:19 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29495a
fs/xfs/xfsidbg.c - 1.326 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.326&r2=text&tr2=1.325&f=h
	- move vnode flags to xfs inode.

fs/xfs/xfs_vnodeops.c - 1.712 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.712&r2=text&tr2=1.711&f=h
	- move vnode flags to xfs inode.

fs/xfs/xfs_iget.c - 1.228 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.228&r2=text&tr2=1.227&f=h
	- move vnode flags to xfs inode.

fs/xfs/xfs_inode.h - 1.227 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.227&r2=text&tr2=1.226&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_file.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_vnode.c - 1.146 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.146&r2=text&tr2=1.145&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_vnode.h - 1.133 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.133&r2=text&tr2=1.132&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_fs_subr.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_fs_subr.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_super.c - 1.387 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.387&r2=text&tr2=1.386&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_iops.c - 1.261 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.261&r2=text&tr2=1.260&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_aops.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- move vnode flags to xfs inode.

fs/xfs/linux-2.6/xfs_ioctl32.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl32.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- move vnode flags to xfs inode.

fs/xfs/dmapi/xfs_dm.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
	- move vnode flags to xfs inode.
