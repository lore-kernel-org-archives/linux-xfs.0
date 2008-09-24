Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:25:47 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7Pdqh030122
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:25:39 -0700
Subject: TAKE 985583 - add generic btree types
Message-Id: <20080924072711.C648458C52AE@chook.melbourne.sgi.com>
Date: Wed, 24 Sep 2008 17:27:11 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

add generic btree types

Add generic union types for btree pointers, keys and records.  The generic
btree pointer contains either a 32 and 64bit big endian scalar for short
and long form btrees, and the key and record contain the relevant type for
each possible btree.

Split out from a bigger patch from Dave Chinner and simplified a little
further.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Sep 24 17:26:31 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-btree
Inspected by:  
dgc
billodo
lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32178a
fs/xfs/xfs_btree.h - 1.71 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_btree.h.diff?r1=text&tr1=1.71&r2=text&tr2=1.70&f=h
	- add generic btree types
