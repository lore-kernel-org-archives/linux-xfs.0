Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 01 Oct 2007 20:26:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l923Qis7006699
	for <xfs@oss.sgi.com>; Mon, 1 Oct 2007 20:26:48 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - kill probe_* sysctl leftovers
Message-Id: <20071002032640.577F230CD1E8@linuxbuild.melbourne.sgi.com>
Date: Tue,  2 Oct 2007 13:26:40 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

kill probe_* sysctl leftovers

After my recent changes the probe_* sysctls are unused because we do
a proper request_module now if we actually know that we need the quota
or dmapi module.  Kill the leftovers that have no function anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Oct  2 13:26:11 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29817a
fs/xfs/linux-2.6/xfs_globals.c - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_globals.c.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- kill probe_* sysctl leftovers.

fs/xfs/linux-2.6/xfs_linux.h - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_linux.h.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- kill probe_* sysctl leftovers.

fs/xfs/linux-2.6/xfs_sysctl.c - 1.43 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.c.diff?r1=text&tr1=1.43&r2=text&tr2=1.42&f=h
	- kill probe_* sysctl leftovers.

fs/xfs/linux-2.6/xfs_sysctl.h - 1.28 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_sysctl.h.diff?r1=text&tr1=1.28&r2=text&tr2=1.27&f=h
	- kill probe_* sysctl leftovers.
