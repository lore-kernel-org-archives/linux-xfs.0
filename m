Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 21:33:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m394WxDu015005
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 21:33:01 -0700
Subject: PARTIAL TAKE 976035 - replace remaining __FUNCTION__ occurrences
Message-Id: <20080409043333.19F9158C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 14:33:32 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

replace remaining __FUNCTION__ occurrences

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>


Date:  Wed Apr  9 14:33:03 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  harvey.harrison@gmail.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30775a
fs/xfs/xfs_log.c - 1.354 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log.c.diff?r1=text&tr1=1.354&r2=text&tr2=1.353&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_trans_ail.c - 1.87 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_ail.c.diff?r1=text&tr1=1.87&r2=text&tr2=1.86&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_log_recover.c - 1.337 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.337&r2=text&tr2=1.336&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_bmap_btree.c - 1.169 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap_btree.c.diff?r1=text&tr1=1.169&r2=text&tr2=1.168&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_alloc.c - 1.190 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.c.diff?r1=text&tr1=1.190&r2=text&tr2=1.189&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_bmap.h - 1.103 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.h.diff?r1=text&tr1=1.103&r2=text&tr2=1.102&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_bmap.c - 1.388 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.388&r2=text&tr2=1.387&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/linux-2.6/xfs_vnode.h - 1.147 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.147&r2=text&tr2=1.146&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/linux-2.6/xfs_super.c - 1.412 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.412&r2=text&tr2=1.411&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/linux-2.6/xfs_buf.c - 1.253 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_buf.c.diff?r1=text&tr1=1.253&r2=text&tr2=1.252&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/linux-2.6/kmem.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/kmem.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- __FUNCTION__ is gcc-specific, use __func__

fs/xfs/xfs_filestream.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_filestream.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- __FUNCTION__ is gcc-specific, use __func__
