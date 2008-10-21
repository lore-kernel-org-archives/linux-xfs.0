Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 00:33:15 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L7XAF5023668
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 00:33:11 -0700
Subject: TAKE 987246 - Trivial xfs_remove comment fixup
Message-Id: <20081021073447.E9FFD1EDD8C@chapter11.melbourne.sgi.com>
Date: Tue, 21 Oct 2008 18:34:47 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

The dp to ip comment should be for the unconditional xfs_droplink
call, and the "." link obviously only exists for directories,
so it should be in the is_dir conditional.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Oct 21 18:34:26 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,dave@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32374a
fs/xfs/xfs_vnodeops.c - 1.782 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.782&r2=text&tr2=1.781&f=h
	- Trivial xfs_remove comment fixup
