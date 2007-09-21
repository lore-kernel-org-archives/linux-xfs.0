Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Sep 2007 17:51:55 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8L0pngf019434
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2007 17:51:51 -0700
Date: Fri, 21 Sep 2007 10:55:07 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709210055.l8L0t77V010376@redback.melbourne.sgi.com>
Subject: TAKE 970841 - kill unnessecary ioops indirection
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill unnessecary ioops indirection

Currently there is an indirection called ioops in the XFS data I/O
path.  Various functions are called by functions pointers, but there
is no coherence in what this is for, and of course for XFS itself
it's entirely unused.  This patch removes it instead and significantly
reduces source and binary size of XFS while making maintaince easier.


Date:  Fri Sep 21 10:51:25 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29737a
fs/xfs/xfs_vnodeops.c - 1.721 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.721&r2=text&tr2=1.720&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_iocore.c - 1.54 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iocore.c.diff?r1=text&tr1=1.54&r2=text&tr2=1.53&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_vfsops.c - 1.540 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.540&r2=text&tr2=1.539&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_dfrag.c - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_mount.h - 1.251 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.251&r2=text&tr2=1.250&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_mount.c - 1.411 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.411&r2=text&tr2=1.410&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_inode.c - 1.480 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.480&r2=text&tr2=1.479&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_iomap.h - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.h.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- kill unnessecary ioops indirection

fs/xfs/xfs_iomap.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- kill unnessecary ioops indirection

fs/xfs/linux-2.6/xfs_lrw.h - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- kill unnessecary ioops indirection

fs/xfs/linux-2.6/xfs_lrw.c - 1.269 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.269&r2=text&tr2=1.268&f=h
	- kill unnessecary ioops indirection

fs/xfs/linux-2.6/xfs_aops.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
	- kill unnessecary ioops indirection

fs/xfs/linux-2.6/xfs_ksyms.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- kill unnessecary ioops indirection
