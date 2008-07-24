Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 01:24:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O8OQXj001143
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 01:24:27 -0700
Subject: TAKE 981498 -  remove shouting-indirection macros  from xfs_trans.h
Message-Id: <20080724082535.694A758C4C3F@chook.melbourne.sgi.com>
Date: Thu, 24 Jul 2008 18:25:35 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

remove shouting-indirection macros  from xfs_trans.h

compile-tested, fairly easy to inspect with:

quilt diff --diff="diff -iu"

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Jul 24 18:24:36 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  esandeen,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31758a
fs/xfs/xfsidbg.c - 1.355 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.355&r2=text&tr2=1.354&f=h
fs/xfs/xfs_trans_item.c - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_item.c.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
fs/xfs/xfs_trans.c - 1.187 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.187&r2=text&tr2=1.186&f=h
fs/xfs/xfs_trans.h - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
fs/xfs/xfs_bmap.c - 1.397 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.397&r2=text&tr2=1.396&f=h
fs/xfs/xfs_trans_buf.c - 1.131 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_buf.c.diff?r1=text&tr1=1.131&r2=text&tr2=1.130&f=h
