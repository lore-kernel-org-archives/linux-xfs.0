Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 21:02:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA952YG8015282
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 21:02:38 -0800
Subject: TAKE 972915 - Fix broken inode cluster setup.
Message-Id: <20071109050229.2C8B058C38F7@chook.melbourne.sgi.com>
Date: Fri,  9 Nov 2007 16:02:29 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Fix broken inode cluster setup.

The radix tree based inode caches did away with the inode cluster hashes,
replacing them with a bunch of masking and gang lookups on the radix tree.

This masking got broken when moving the code to per-ag radix trees and
indexing by agino # rather than straight inode number. The result is
clustered inode writeback does not cluster and things can go extremely
slowly when there are lots of inodes to write.

Fix it up by comparing the agino # of the inode we just looked up
to the index of the cluster we are looking for.

Signed-off-by: Dave Chinner <dgc@sgi.com>
Tested-by:  Torsten Kaiser <just.for.lkml@googlemail.com>

Date:  Fri Nov  9 16:02:06 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30033a
fs/xfs/xfs_iget.c - 1.238 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.238&r2=text&tr2=1.237&f=h
	- Make the cluster lookup use the agino rather than full inode number
	  so that clusters are correctly built.
