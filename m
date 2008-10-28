Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 21:47:55 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S4lbt2013997
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 21:47:37 -0700
Subject: TAKE 988918 - kill sys_cred
Message-Id: <20081028044723.DF87058AE1E9@chook.melbourne.sgi.com>
Date: Tue, 28 Oct 2008 15:47:23 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill sys_cred

capable_cred has been unused for a while so we can kill it and sys_cred.
That also means the cred argument to xfs_setattr and
xfs_change_file_space can be removed now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Oct 28 15:45:57 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb

Modid:  xfs-linux-melb:xfs-kern:32412a
fs/xfs/xfs_vnodeops.c - 1.783 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.783&r2=text&tr2=1.782&f=h
fs/xfs/xfs_acl.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_acl.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.174 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.174&r2=text&tr2=1.173&f=h
fs/xfs/linux-2.6/xfs_globals.h - 1.21 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.h.diff?r1=text&tr1=1.21&r2=text&tr2=1.20&f=h
fs/xfs/linux-2.6/xfs_globals.c - 1.75 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.75&r2=text&tr2=1.74&f=h
fs/xfs/linux-2.6/xfs_cred.h - 1.26 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_cred.h.diff?r1=text&tr1=1.26&r2=text&tr2=1.25&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.303 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.303&r2=text&tr2=1.302&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.96 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.96&r2=text&tr2=1.95&f=h
fs/xfs/dmapi/xfs_dm.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/xfs_vnodeops.h - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- kill sys_cred
