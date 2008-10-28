Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 23:09:19 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S69D35020990
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2008 23:09:13 -0700
Subject: TAKE 988919 - remove restricted chown parameter from xfs linux
Message-Id: <20081028055052.3CCD058AE1E9@chook.melbourne.sgi.com>
Date: Tue, 28 Oct 2008 16:50:52 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

remove restricted chown parameter from xfs linux

On Linux all filesystems are supposed to be operating under
Posix' restricted chown. Restricted chown means it restricts
chown to the owner unless you have CAP_FOWNER.

NOTE: that 2 files outside of fs/xfs have been modified too
for this change.

Signed-off-by: Tim Shimmin <tes@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <david@fromorbit.com>

Date:  Tue Oct 28 16:49:18 EST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32413a
fs/xfs/xfs_vnodeops.c - 1.784 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.784&r2=text&tr2=1.783&f=h
fs/xfs/linux-2.6/xfs_ioctl.c - 1.175 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.175&r2=text&tr2=1.174&f=h
fs/xfs/linux-2.6/xfs_globals.c - 1.76 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.76&r2=text&tr2=1.75&f=h
fs/xfs/linux-2.6/xfs_linux.h - 1.172 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.172&r2=text&tr2=1.171&f=h
fs/xfs/linux-2.6/xfs_sysctl.c - 1.47 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.47&r2=text&tr2=1.46&f=h
fs/xfs/linux-2.6/xfs_sysctl.h - 1.32 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.32&r2=text&tr2=1.31&f=h
	- remove restricted chown parameter from xfs linux


Modid:  2.6.x-xfs-melb:linux:32413b
Documentation/filesystems/xfs.txt - 1.22 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/Documentation/filesystems/xfs.txt.diff?r1=text&tr1=1.22&r2=text&tr2=1.21&f=h
kernel/sysctl_check.c - 1.5 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/linux-2.6-xfs/kernel/sysctl_check.c.diff?r1=text&tr1=1.5&r2=text&tr2=1.4&f=h
	- remove restricted chown parameter from xfs linux
