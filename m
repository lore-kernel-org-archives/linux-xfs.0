Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 27 Jul 2006 23:56:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6S6uBDW027603
	for <linux-xfs@oss.sgi.com>; Thu, 27 Jul 2006 23:56:23 -0700
Subject: TAKE 953819 - bulkstat vs debug kernels
Message-Id: <20060728065532.7419B58C38C1@chook.melbourne.sgi.com>
Date: Fri, 28 Jul 2006 16:55:32 +1000 (EST)
From: nathans@sgi.com (Nathan Scott)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Remove last bulkstat false-positives with debug kernels.

Date:  Fri Jul 28 16:53:21 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26628a
xfs_ialloc.c - 1.192 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_ialloc.c.diff?r1=text&tr1=1.192&r2=text&tr2=1.191&f=h
xfs_itable.c - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
xfs_iget.c - 1.217 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.217&r2=text&tr2=1.216&f=h
xfs_inode.c - 1.450 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.450&r2=text&tr2=1.449&f=h
xfs_inode.h - 1.215 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.215&r2=text&tr2=1.214&f=h
dmapi/xfs_dm.c - 1.18 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.18&r2=text&tr2=1.17&f=h


Ensure bulkstat from an invalid inode number gets caught always with EINVAL.

Date:  Fri Jul 28 16:55:15 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/nathans/xfs-linux
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-kern/xfs-linux-melb


Modid:  xfs-linux-melb:xfs-kern:26629a
xfs_inode.c - 1.451 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.451&r2=text&tr2=1.450&f=h
