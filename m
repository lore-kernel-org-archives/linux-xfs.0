Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 05:18:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OCIR4p017868
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 05:18:33 -0700
Subject: TAKE 969608 - kill struct bhv_vfs
Message-Id: <20070824121823.555CF58C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 22:18:23 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill struct bhv_vfs

Now that struct bhv_vfs doesn't have any members left we can kill it
and go directly from the super_block to the xfs_mount everywhere.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 22:17:45 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29509a
fs/xfs/xfsidbg.c - 1.331 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.331&r2=text&tr2=1.330&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_iocore.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iocore.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_vfsops.c - 1.536 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.536&r2=text&tr2=1.535&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_iget.c - 1.232 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.232&r2=text&tr2=1.231&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_mount.h - 1.249 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.249&r2=text&tr2=1.248&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_mount.c - 1.408 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.408&r2=text&tr2=1.407&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_trans.c - 1.183 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.183&r2=text&tr2=1.182&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/xfs_fsops.c - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/Makefile-linux-2.6 - 1.213 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.213&r2=text&tr2=1.212&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_lrw.c - 1.266 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.266&r2=text&tr2=1.265&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_vfs.h - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_vfs.c - 1.83 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.c.diff?r1=text&tr1=1.83&r2=text&tr2=1.82&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_vnode.h - 1.138 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.138&r2=text&tr2=1.137&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_super.h - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_super.c - 1.395 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.395&r2=text&tr2=1.394&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.70 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.70&r2=text&tr2=1.69&f=h
	- remove struct bhv_vfs and go directly to the superblock.

fs/xfs/dmapi/xfs_dm.c - 1.52 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.52&r2=text&tr2=1.51&f=h
	- remove struct bhv_vfs and go directly to the superblock.
