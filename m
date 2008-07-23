Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:30:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7U1K4010314
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:30:02 -0700
Subject: TAKE 981498 - Move attr log alloc size calculator to another function.
Message-Id: <20080723073106.BF71C58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:31:06 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Move attr log alloc size calculator to another function.

We will need that to be able to calculate the size of log we need for
a specific attr (for Create+EA). The local flag is needed so that we
can fail if we run into ENOSPC when trying to alloc blocks.

Signed-off-by: Niv Sardi <xaiki@sgi.com>


Date:  Wed Jul 23 17:30:19 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,tes,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31727a
fs/xfs/xfs_attr.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
fs/xfs/xfs_attr.h - 1.45 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_attr.h.diff?r1=text&tr1=1.45&r2=text&tr2=1.44&f=h
