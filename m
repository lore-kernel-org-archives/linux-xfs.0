Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:10:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N7ANuj002945
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:10:26 -0700
Subject: TAKE 981498 - XFS: Kill xfs_vtoi()
Message-Id: <20080723071129.2579258C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:11:29 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

XFS: Kill xfs_vtoi()

xfs_vtoi() is redundant and only unsed in small sections
of code. Replace them with widely used XFS_I() inline and
kill xfs_vtoi().

Signed-off-by: Dave Chinner <david@fromorbit.com>


Date:  Wed Jul 23 17:10:41 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  dgc,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31725a
fs/xfs/xfs_acl.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
fs/xfs/xfs_inode.h - 1.250 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.250&r2=text&tr2=1.249&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
fs/xfs/linux-2.6/xfs_aops.c - 1.163 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_aops.c.diff?r1=text&tr1=1.163&r2=text&tr2=1.162&f=h
