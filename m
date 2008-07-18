Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Jul 2008 23:30:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6I6U0KK009311
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2008 23:30:03 -0700
Subject: TAKE 984565 - simplify xfs_setattr with iattr directly
Message-Id: <20080718063104.0BCDF58C4C3F@chook.melbourne.sgi.com>
Date: Fri, 18 Jul 2008 16:31:04 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Now that xfs_setattr is only used for attributes set from ->setattr it
can be switched to take struct iattr directly and thus simplify the
implementation greatly.  Also rename the ATTR_ flags to XFS_ATTR_ to
not conflict with the ATTR_ flags used by the VFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Jul 18 16:29:44 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31678a
fs/xfs/xfs_vnodeops.c - 1.764 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.764&r2=text&tr2=1.763&f=h
fs/xfs/xfs_dmapi.h - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmapi.h.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
fs/xfs/xfs_acl.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.169 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.169&r2=text&tr2=1.168&f=h
fs/xfs/linux-2.6/xfs_vnode.h - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.292 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.292&r2=text&tr2=1.291&f=h
fs/xfs/dmapi/xfs_dm.c - 1.74 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.74&r2=text&tr2=1.73&f=h
fs/xfs/xfs_vnodeops.h - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
