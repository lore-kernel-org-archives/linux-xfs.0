Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:39:55 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7dq7P032598
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:39:52 -0700
Subject: TAKE 985583 - refactor btree validation helpers
Message-Id: <20080924074125.B894A58C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:41:25 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

refactor btree validation helpers

Move the various btree validation helpers around in xfs_btree.c so that
they are close to each other and in common #ifdef DEBUG sections.

Also add a new xfs_btree_check_ptr helper to check a btree ptr that
can be either long or short form.

Split out from a bigger patch from Dave Chinner with various small
changes applied by me.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:40:46 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32183a
fs/xfs/xfs_btree.c - 1.124 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.c.diff?r1=text&tr1=1.124&r2=text&tr2=1.123&f=h
fs/xfs/xfs_btree.h - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
	- refactor btree validation helpers
