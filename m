Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 03:54:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OAsA4p026343
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 03:54:53 -0700
Subject: PARTIAL TAKE 969608 - kill v_vfsp member from struct bhv_vnode
Message-Id: <20070824105405.60FA958C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 20:54:05 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill v_vfsp member from struct bhv_vnode

We can easily get at the vfsp through the super_block but it will soon
be gone anyway.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 20:53:35 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29494a
fs/xfs/xfsidbg.c - 1.325 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.325&r2=text&tr2=1.324&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/xfs_vnodeops.c - 1.711 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.711&r2=text&tr2=1.710&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/xfs_acl.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/xfs_inode.c - 1.474 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.474&r2=text&tr2=1.473&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_lrw.c - 1.265 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.265&r2=text&tr2=1.264&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.149 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.149&r2=text&tr2=1.148&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_file.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_vnode.c - 1.145 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.145&r2=text&tr2=1.144&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_vnode.h - 1.132 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.132&r2=text&tr2=1.131&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/linux-2.6/xfs_super.c - 1.386 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.386&r2=text&tr2=1.385&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/dmapi/xfs_dm_fsops.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- remove v_vfsp from bhv_vnode.

fs/xfs/dmapi/xfs_dm.c - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
	- remove v_vfsp from bhv_vnode.
