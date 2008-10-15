Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 14 Oct 2008 22:49:50 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9F5nmSk009405
	for <xfs@oss.sgi.com>; Tue, 14 Oct 2008 22:49:48 -0700
Subject: TAKE 988236 - fix remount rw with unrecognized options
Message-Id: <20081015055124.1774158FA1E9@chook.melbourne.sgi.com>
Date: Wed, 15 Oct 2008 16:51:24 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

fix remount rw with unrecognized options

When we skip unrecognized options in xfs_fs_remount we should just break
out of the switch and not return because otherwise we may skip clearing
the xfs-internal read-only flag.  This will only show up on some
operations like touch because most read-only checks are done by the VFS
which thinks this filesystem is r/w.  Eventually we should replace the
XFS read-only flag with a helper that always checks the VFS flag to make
sure they can never get out of sync.

Bug reported and fix verified by Marcel Beister on #xfs.
Bug fix verified by updated xfstests/189.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Wed Oct 15 16:50:37 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de,sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32341a
fs/xfs/linux-2.6/xfs_super.c - 1.462 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.462&r2=text&tr2=1.461&f=h
	- fix remount rw with unrecognized options
