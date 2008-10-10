Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Oct 2008 21:10:47 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9A4AcNV028677
	for <xfs@oss.sgi.com>; Thu, 9 Oct 2008 21:10:38 -0700
Subject: TAKE 988139 - Traverse inode trees when releasing dquots
Message-Id: <20081010041211.19AEE58C52B5@chook.melbourne.sgi.com>
Date: Fri, 10 Oct 2008 15:12:11 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Traverse inode trees when releasing dquots

Make releasing all inode dquots traverse the per-ag
inode radix trees rather than the mount inode list.
This removes another user of the mount inode list.

Version 3
o fix comment relating to avoiding trying to release the
  quota inodes and those in reclaim.

Version 2
o add comment explaining use of gang lookups for a single inode
o use IRELE, not VN_RELE
o move check for ag initialisation to caller.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Fri Oct 10 15:11:46 EST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-radix
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32286a
fs/xfs/linux-2.6/xfs_sync.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sync.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- Traverse inode trees when releasing dquots
