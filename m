Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 21:30:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6P4UQor011926
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 21:30:26 -0700
Subject: TAKE 981498 - kill INDUCE_IO_ERROR
Message-Id: <20080725043134.7BEFC58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 25 Jul 2008 14:31:34 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

 kill INDUCE_IO_ERROR

All the error injection is already enabled through ifdef DEBUG, so kill
the never set second cpp symbol to activate it without the rest of the
debugging infrastructure.


Signed-off-by: Christoph Hellwig <hch@lst.de>



Date:  Fri Jul 25 14:30:56 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31771a
fs/xfs/xfs_mount.c - 1.439 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.439&r2=text&tr2=1.438&f=h
fs/xfs/xfs_error.c - 1.64 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.64&r2=text&tr2=1.63&f=h
fs/xfs/xfs_error.h - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
