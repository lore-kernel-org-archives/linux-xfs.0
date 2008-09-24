Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:25:07 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8P49p007029
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:25:05 -0700
Subject: TAKE 985583 - implement generic xfs_btree_update
Message-Id: <20080924082637.D58B058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 18:26:37 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

implement generic xfs_btree_update

From: Dave Chinner <dgc@sgi.com>

The most complicated part here is the lastrec tracking for
the alloc btree.  Most logic is in the update_lastrec method
which has to do some hopefully good enough dirty magic to
maintain it.

[hch: split out from bigger patch and a rework of the lastrec
 logic]


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 18:25:59 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32194a
fs/xfs/xfs_ialloc.c - 1.205 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.205&r2=text&tr2=1.204&f=h
fs/xfs/xfs_ialloc_btree.h - 1.38 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.h.diff?r1=text&tr1=1.38&r2=text&tr2=1.37&f=h
fs/xfs/xfs_ialloc_btree.c - 1.97 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc_btree.c.diff?r1=text&tr1=1.97&r2=text&tr2=1.96&f=h
fs/xfs/xfs_bmap_btree.h - 1.86 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.86&r2=text&tr2=1.85&f=h
fs/xfs/xfs_bmap_btree.c - 1.186 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.186&r2=text&tr2=1.185&f=h
fs/xfs/xfs_btree.c - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
fs/xfs/xfs_btree.h - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
fs/xfs/xfs_alloc.c - 1.199 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.199&r2=text&tr2=1.198&f=h
fs/xfs/xfs_bmap.c - 1.406 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.406&r2=text&tr2=1.405&f=h
fs/xfs/xfs_alloc_btree.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/xfs_alloc_btree.c - 1.101 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc_btree.c.diff?r1=text&tr1=1.101&r2=text&tr2=1.100&f=h
	- implement generic xfs_btree_update
