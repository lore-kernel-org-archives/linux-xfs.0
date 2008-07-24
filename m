Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 01:15:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O8FJEY031297
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:15:20 -0700
Subject: TAKE 981498 - remove INT_GET and friends 
Message-Id: <20080724081628.6EB3558C4C3F@chook.melbourne.sgi.com>
Date: Thu, 24 Jul 2008 18:16:28 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove INT_GET and friends

Thanks to hch's endian work, INT_GET etc are no longer used,
and may as well be removed.  INT_SET is still used in
the acl code, though.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Jul 24 18:15:32 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  esandeen,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31756a
fs/xfs/xfs_arch.h - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_arch.h.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
