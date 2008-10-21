Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:35:27 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6ZP8e010049
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:35:25 -0700
Subject: TAKE 987246 - fix biosize option
Message-Id: <20081021063706.434F21EDD8C@chapter11.melbourne.sgi.com>
Date: Tue, 21 Oct 2008 17:37:06 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

fix biosize option

iosizelog shouldn't be the same as iosize but the logarithm of it.  Then
again the current biosize option doesn't make much sense to me as it
doesn't set the preferred I/O size as mentioned in the comment next to
it but rather the allocation size and thus is identical to the allocsize
option (except for the missing logarithm).  It's also not documented in
Documentation/filesystems/xfs.txt or the mount manpage.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Oct 21 17:36:43 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32373a
fs/xfs/linux-2.6/xfs_super.c - 1.466 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.466&r2=text&tr2=1.465&f=h
	- fix biosize option
