Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:45:42 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7jeUh001590
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:45:40 -0700
Subject: TAKE 985583 - make btree tracing generic
Message-Id: <20080924074713.2A8EC58C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:47:13 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

make btree tracing generic

Make the existing bmap btree tracing generic so that it applies to all
btree types.

Some fragments lifted from a patch by Dave Chinner.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:46:35 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32187a
fs/xfs/Makefile - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/Makefile.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
fs/xfs/xfsidbg.c - 1.366 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.366&r2=text&tr2=1.365&f=h
fs/xfs/xfs.h - 1.56 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs.h.diff?r1=text&tr1=1.56&r2=text&tr2=1.55&f=h
fs/xfs/xfs_ialloc_btree.c - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
fs/xfs/xfs_bmap_btree.h - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_bmap_btree.c - 1.179 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.179&r2=text&tr2=1.178&f=h
fs/xfs/xfs_btree.h - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
fs/xfs/xfs_inode.c - 1.523 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.523&r2=text&tr2=1.522&f=h
fs/xfs/xfs_inode.h - 1.258 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.258&r2=text&tr2=1.257&f=h
fs/xfs/xfs_alloc_btree.c - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.449 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.449&r2=text&tr2=1.448&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
	- make btree tracing generic
