Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 17:40:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1Q1e97r022713
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 17:40:11 -0800
Subject: PARTIAL TAKE 976035 - cleanup vnode use in dmapi calls
Message-Id: <20080226014031.B82C858C4C0F@chook.melbourne.sgi.com>
Date: Tue, 26 Feb 2008 12:40:31 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup vnode use in dmapi calls

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Tue Feb 26 12:39:47 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  lachlan
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30545a
fs/xfs/xfs_vnodeops.c - 1.740 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.740&r2=text&tr2=1.739&f=h
fs/xfs/xfs_vfsops.c - 1.555 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.555&r2=text&tr2=1.554&f=h
fs/xfs/xfs_mount.h - 1.258 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.258&r2=text&tr2=1.257&f=h
fs/xfs/xfs_bmap.c - 1.385 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.385&r2=text&tr2=1.384&f=h
fs/xfs/xfs_rename.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
fs/xfs/linux-2.6/xfs_lrw.c - 1.275 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_lrw.c.diff?r1=text&tr1=1.275&r2=text&tr2=1.274&f=h
fs/xfs/linux-2.6/xfs_file.c - 1.164 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_file.c.diff?r1=text&tr1=1.164&r2=text&tr2=1.163&f=h
fs/xfs/dmapi/xfs_dm.c - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- cleanup vnode use in dmapi calls
