Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 20:28:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l953SRCe005452
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 20:28:31 -0700
Subject: TAKE 971064 - fix infinite loop in bulkstat
Message-Id: <20071005032823.C70A758C38F1@chook.melbourne.sgi.com>
Date: Fri,  5 Oct 2007 13:28:23 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

This fix prevents bulkstat from spinning in an infinite loop.

Here 'agino' increments through the inodes in an allocation group.
At the end of the innermost 'for' loop it will hold the value of the
next inode to look at (ie the first inode in the next cluster/chunk).
Assigning 'lastino' to 'agino' resets it to the last inode in the
last inode cluster we just looked at.  This causes us to look up
the very same cluster and examine all the inodes all over again,
and again, and again...

We also want to set 'lastino' for the cases when we're not interested
in the inode so that the next call to bulkstat wont re-examine the
same uninteresting inodes. 

Date:  Fri Oct  5 13:25:32 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29840a
fs/xfs/xfs_itable.c - 1.156 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.156&r2=text&tr2=1.155&f=h
	- fix infinite loop in bulkstat
