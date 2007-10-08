Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 23:16:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l986FwMK019066
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 23:16:00 -0700
Subject: PARTIAL TAKE 971186 - kill superflous buffer locking
Message-Id: <20071008061554.4CC4A58C38F1@chook.melbourne.sgi.com>
Date: Mon,  8 Oct 2007 16:15:54 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

kill superflous buffer locking

There is no need to lock any page in xfs_buf.c because we operate
on our own address_space and all locking is covered by the buffer
semaphore.  If we ever switch back to main blockdeive address_space
as suggested e.g. for fsblock with a similar scheme the locking will
have to be totally revised anyway because the current scheme is
neither correct nor coherent with itself.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Oct  8 16:14:29 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-oss
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29845a
fs/xfs/xfsidbg.c - 1.339 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.339&r2=text&tr2=1.338&f=h
fs/xfs/linux-2.6/xfs_buf.h - 1.121 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.h.diff?r1=text&tr1=1.121&r2=text&tr2=1.120&f=h
fs/xfs/linux-2.6/xfs_buf.c - 1.245 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.245&r2=text&tr2=1.244&f=h
	- kill superflous buffer locking
