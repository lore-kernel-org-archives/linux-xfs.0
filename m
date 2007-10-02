Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 22:26:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l925QPFR025693
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 22:26:28 -0700
Subject: TAKE 970852 - kill xfs_iocore_t
Message-Id: <20071002052621.B4D1058C38F1@chook.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 15:26:21 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_iocore_t

xfs_iocore_t is a structure embedded in xfs_inode.  Except for one
field it just duplicates fields already in xfs_inode, and there is
nothing this abstraction buys us on XFS/Linux.  This patch removes
it and shrinks source and binary size of xfs aswell as shrinking
the size of xfs_inode by 60/44 bytes in debug/non-debug builds.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Sep 21 17:16:44 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29754a
fs/xfs/xfsidbg.c - 1.334 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.334&r2=text&tr2=1.333&f=h
fs/xfs/xfs_rw.h - 1.85 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rw.h.diff?r1=text&tr1=1.85&r2=text&tr2=1.84&f=h
fs/xfs/xfs_vnodeops.c - 1.723 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.723&r2=text&tr2=1.722&f=h
fs/xfs/xfs_iocore.c - 1.55 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iocore.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
fs/xfs/xfs_dfrag.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
fs/xfs/xfs_iget.c - 1.235 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.235&r2=text&tr2=1.234&f=h
fs/xfs/xfs_mount.h - 1.255 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.255&r2=text&tr2=1.254&f=h
fs/xfs/xfs_inode.c - 1.482 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.482&r2=text&tr2=1.481&f=h
fs/xfs/xfs_inode.h - 1.235 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.235&r2=text&tr2=1.234&f=h
fs/xfs/Makefile-linux-2.6 - 1.214 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile-linux-2.6.diff?r1=text&tr1=1.214&r2=text&tr2=1.213&f=h
fs/xfs/xfs_iomap.c - 1.59 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iomap.c.diff?r1=text&tr1=1.59&r2=text&tr2=1.58&f=h
fs/xfs/linux-2.6/xfs_lrw.h - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.h.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.270 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.270&r2=text&tr2=1.269&f=h
fs/xfs/linux-2.6/xfs_aops.c - 1.157 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.157&r2=text&tr2=1.156&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
fs/xfs/dmapi/xfs_dm.c - 1.55 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.55&r2=text&tr2=1.54&f=h
	- kill xfs_iocore_t
