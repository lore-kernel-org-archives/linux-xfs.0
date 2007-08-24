Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 05:00:23 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7OC0E4p013827
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 05:00:20 -0700
Subject: PARTIAL TAKE 969608 - kill the vfs_fsid and vfs_altfsid members in struct bhv_vfs
Message-Id: <20070824120009.931A058C38F1@chook.melbourne.sgi.com>
Date: Fri, 24 Aug 2007 22:00:09 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

kill the vfs_fsid and vfs_altfsid members in struct bhv_vfs

vfs_altfsid was just a pointer to mp->m_fixedfsid so we can trivially
replace it with the latter.  vfs_fsid also was identicaly to m_fixedfsid
through rather obsfucated ways so we can kill it aswell and simply it's
only user.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Fri Aug 24 21:59:32 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29506a
fs/xfs/xfs_mount.c - 1.406 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.406&r2=text&tr2=1.405&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/xfs_error.c - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.c.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/xfs_error.h - 1.48 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.48&r2=text&tr2=1.47&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/linux-2.6/xfs_ioctl.c - 1.151 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.151&r2=text&tr2=1.150&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/linux-2.6/xfs_vfs.h - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vfs.h.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/dmapi/xfs_dm_fsops.c - 1.12 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.12&r2=text&tr2=1.11&f=h
	- remove vfs_fsid and vfs_altfsid.

fs/xfs/dmapi/xfs_dm.c - 1.50 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.50&r2=text&tr2=1.49&f=h
	- remove vfs_fsid and vfs_altfsid.
