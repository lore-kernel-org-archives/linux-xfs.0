Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 15:27:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLNQrqw025064
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 15:26:55 -0800
Subject: TAKE 950149 - XFSQA: Assert fail !(iomapp->iomap_flags & IOMAP_DELAY) in test 083
Message-Id: <20061221232558.92B5058CA546@chook.melbourne.sgi.com>
Date: Fri, 22 Dec 2006 10:25:58 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Clear unwritten buffer flag on partial page invalidation

If we have a page with unwritten extents on it, and we do a
partial page truncation, we fail to clear the private unwritten
buffer flag on buffers that are now past EOF. If we then
extend the file into those blocks via a write, we will make
the wrong allocation decision when writing the new data
to disk because of the incorrect unwritten flag on the buffer.

Hence we need to clear the unwritten flag in xfs_vm_invalidatepage
to ensure that the state of the buffers on the page beyond EOF
are in the correct state in case they are reused.

Date:  Fri Dec 22 10:25:11 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan,nathans@aconex.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27804a
fs/xfs/linux-2.6/xfs_aops.c - 1.137 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.137&r2=text&tr2=1.136&f=h
	- Clear private buffer flags in xfs_vm_invalidatepage to ensure
	  buffers are consistent for reuse after a partial page truncation.
