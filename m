Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 04:39:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l72Bd1bm008854
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 04:39:02 -0700
Subject: PARTIAL TAKE 968563 - choose single default logbuf count & size
Message-Id: <20070802113857.DC9AC58F4B6D@chook.melbourne.sgi.com>
Date: Thu,  2 Aug 2007 21:38:57 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

choose single default logbuf count & size

Remove sizing of logbuf size & count based on physical memory;
this was never a very good gauge as it's looking at global
memory, but deciding on sizing per-filesystem; no account
is made of the total number of filesystems, for example.

For now just take the largest "default" case, as was set
for machines with >400MB - 8 x 32k buffers.  This can
always be tuned higher or lower with mount options
if necessary.  Removes one more user of xfs_physmem.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Aug  2 21:38:35 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29323a
fs/xfs/xfs_log.c - 1.334 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.334&r2=text&tr2=1.333&f=h
	- Don't size logbuf size and count based on physical memory.

fs/xfs/xfs_log_priv.h - 1.118 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_priv.h.diff?r1=text&tr1=1.118&r2=text&tr2=1.117&f=h
	- Don't size logbuf size and count based on physical memory.
