Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Aug 2006 17:14:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7I0DdDW026794
	for <linux-xfs@oss.sgi.com>; Thu, 17 Aug 2006 17:13:50 -0700
Subject: TAKE 954580 - sparse checks for AIL locking
Message-Id: <20060818001240.215B958C8A48@chook.melbourne.sgi.com>
Date: Fri, 18 Aug 2006 10:12:40 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Add lock annotations to xfs_trans_update_ail and xfs_trans_delete_ail

xfs_trans_update_ail and xfs_trans_delete_ail get called with the AIL lock
held, and release it.  Add lock annotations to these two functions so that
sparse can check callers for lock pairing, and so that sparse will not
complain about these functions since they intentionally use locks in this
manner.

Signed-off-by: Josh Triplett <josh@freedesktop.org>


Date:  Fri Aug 18 10:12:23 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  josh@freedesktop.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26807a
xfs_trans_priv.h - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_priv.h.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
xfs_trans_ail.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
linux-2.4/xfs_linux.h - 1.162 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.4/xfs_linux.h.diff?r1=text&tr1=1.162&r2=text&tr2=1.161&f=h
	- Add lock annotations to xfs_trans_update_ail and xfs_trans_delete_ail
