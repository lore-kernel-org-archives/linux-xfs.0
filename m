Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Nov 2007 16:44:33 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAT0iOgG008037
	for <xfs@oss.sgi.com>; Wed, 28 Nov 2007 16:44:26 -0800
Subject: PARTIAL TAKE 971186 - kill superflous buffer locking (2nd attempt)
Message-Id: <20071129004429.34EA658C4C0F@chook.melbourne.sgi.com>
Date: Thu, 29 Nov 2007 11:44:29 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill superflous buffer locking (2nd attempt)

There is no need to lock any page in xfs_buf.c because we operate
on our own address_space and all locking is covered by the buffer
semaphore.  If we ever switch back to main blockdeive address_space
as suggested e.g. for fsblock with a similar scheme the locking will
have to be totally revised anyway because the current scheme is
neither correct nor coherent with itself.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Nov 29 11:43:17 AEDT 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-buflock
Inspected by:  hch
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30156a
fs/xfs/xfsidbg.c - 1.341 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.341&r2=text&tr2=1.340&f=h
fs/xfs/linux-2.6/xfs_buf.h - 1.123 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.123&r2=text&tr2=1.122&f=h
fs/xfs/linux-2.6/xfs_buf.c - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
	- kill superflous buffer locking (2nd attempt)
