Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:04:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N74SeE001816
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:04:30 -0700
Subject: TAKE 981498 - Kill shouty XFS_ITOV() macro 
Message-Id: <20080723070534.DD9EC58C4C3F@chook.melbourne.sgi.com>
Date: Wed, 23 Jul 2008 17:05:34 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Kill shouty XFS_ITOV() macro

Replace XFS_ITOV() with the new VFS_I() inline.

Signed-off-by: Dave Chinner <david@fromorbit.com>

Date:  Wed Jul 23 17:03:24 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  dgc,hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31724a
fs/xfs/xfs_vnodeops.c - 1.767 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.767&r2=text&tr2=1.766&f=h
fs/xfs/xfs_itable.c - 1.166 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.166&r2=text&tr2=1.165&f=h
fs/xfs/xfs_vfsops.c - 1.572 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.572&r2=text&tr2=1.571&f=h
fs/xfs/xfs_dfrag.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dfrag.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/xfs_inode.c - 1.508 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.508&r2=text&tr2=1.507&f=h
fs/xfs/xfs_inode.h - 1.249 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.249&r2=text&tr2=1.248&f=h
fs/xfs/xfs_utils.h - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
fs/xfs/xfs_bmap.c - 1.396 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.396&r2=text&tr2=1.395&f=h
fs/xfs/quota/xfs_dquot.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_dquot.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.171 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.171&r2=text&tr2=1.170&f=h
fs/xfs/linux-2.6/xfs_linux.h - 1.168 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.168&r2=text&tr2=1.167&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.437 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.437&r2=text&tr2=1.436&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.295 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.295&r2=text&tr2=1.294&f=h
fs/xfs/dmapi/xfs_dm.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
