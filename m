Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Apr 2008 01:08:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3988QZI027220
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2008 01:08:28 -0700
Subject: PARTIAL TAKE 976035 - cleanup - remove bhv_vname_t
Message-Id: <20080409080859.D7ABB58C4C0F@chook.melbourne.sgi.com>
Date: Wed,  9 Apr 2008 18:08:59 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

remove bhv_vname_t and xfs_rename code


Date:  Wed Apr  9 18:06:28 AEST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30804a
fs/xfs/xfs_vnodeops.c - 1.747 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.747&r2=text&tr2=1.746&f=h
fs/xfs/xfs_mount.h - 1.261 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.261&r2=text&tr2=1.260&f=h
fs/xfs/xfs_types.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_types.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/xfs_utils.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_utils.h - 1.41 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.h.diff?r1=text&tr1=1.41&r2=text&tr2=1.40&f=h
fs/xfs/xfs_rename.c - 1.82 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_rename.c.diff?r1=text&tr1=1.82&r2=text&tr2=1.81&f=h
fs/xfs/xfs_dir2.h - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.h.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
fs/xfs/xfs_dir2.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dir2.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.148 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.148&r2=text&tr2=1.147&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.283 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.283&r2=text&tr2=1.282&f=h
fs/xfs/linux-2.6/xfs_export.c - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
fs/xfs/dmapi/xfs_dm.c - 1.68 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.68&r2=text&tr2=1.67&f=h
fs/xfs/xfs_vnodeops.h - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- remove bhv_vname_t and xfs_rename code




Modid:  linux-melb:dmapi:30804b
fs/dmapi/dmapi_event.c - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/dmapi_event.c.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
fs/dmapi/dmapi_kern.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/fs/dmapi/dmapi_kern.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
	- remove bhv_vname_t and xfs_rename code
