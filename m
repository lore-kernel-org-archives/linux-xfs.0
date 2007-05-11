Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 21:01:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4B41ZfB003462
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 21:01:37 -0700
Subject: PARTIAL TAKE 957886 - xfs_growfs should refuse to grow fs past 16Tb on a 32 bit system
Message-Id: <20070511040131.C7E7A58CA530@chook.melbourne.sgi.com>
Date: Fri, 11 May 2007 14:01:31 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Don't grow filesystems past the size they can index.

When growing a filesystem we don't check to see if the new size
overflows the page cache index range, so we can do silly things
like grow a filesystem page 16TB on a 32bit. Check new filesystem
sizes against the limits the kernel can support.

Signed-Off-By: Nathan Scott <nscott@aconex.com>

Date:  Fri May 11 14:00:21 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  dgc

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:28563a
fs/xfs/xfs_rtalloc.c - 1.107 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rtalloc.c.diff?r1=text&tr1=1.107&r2=text&tr2=1.106&f=h
	- Check new rt volume size against the maximum the system can support.

fs/xfs/xfs_mount.h - 1.235 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.235&r2=text&tr2=1.234&f=h
	- Factor maximum supported filesystem size checks to allow other
	  callers to use it.

fs/xfs/xfs_mount.c - 1.394 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.394&r2=text&tr2=1.393&f=h
	- Factor maximum supported filesystem size checks to allow other
	  callers to use it.

fs/xfs/xfs_fsops.c - 1.123 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.123&r2=text&tr2=1.122&f=h
	- Check new volume size against the maximum the system can support.
