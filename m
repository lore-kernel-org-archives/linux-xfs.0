Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 02:17:02 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O9H0Zd014648
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 02:17:00 -0700
Subject: TAKE 985583 - kill xfs_bmbt_log_block and xfs_bmbt_log_recs
Message-Id: <20080924091827.84D3058C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 19:18:27 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill xfs_bmbt_log_block and xfs_bmbt_log_recs

These are equivalent to the xfs_btree_* versions, and the only remaining
caller can be switched to the generic one after they are exported.  Also
remove some now dead infrastructure in xfs_bmap_btree.c.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 19:17:50 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32207a
fs/xfs/xfs_bmap_btree.h - 1.90 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.h.diff?r1=text&tr1=1.90&r2=text&tr2=1.89&f=h
fs/xfs/xfs_bmap_btree.c - 1.194 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.194&r2=text&tr2=1.193&f=h
fs/xfs/xfs_btree.c - 1.141 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.141&r2=text&tr2=1.140&f=h
fs/xfs/xfs_btree.h - 1.94 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.94&r2=text&tr2=1.93&f=h
fs/xfs/xfs_bmap.c - 1.410 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.410&r2=text&tr2=1.409&f=h
	- kill xfs_bmbt_log_block and xfs_bmbt_log_recs
