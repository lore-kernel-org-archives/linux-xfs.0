Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 21 Oct 2008 22:22:16 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9M5MC1t024185
	for <xfs@oss.sgi.com>; Tue, 21 Oct 2008 22:22:12 -0700
Subject: TAKE 957103 - Checkin mainline change: use proper mnt_want_write calls for handle ioctl
Message-Id: <20081022052349.E73FA1EDDE7@chapter11.melbourne.sgi.com>
Date: Wed, 22 Oct 2008 16:23:49 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Since 2.6.26 all writes to filesystems need to be enclosed by a
mnt_want_write / mnt_drop_write pair instead of checking for IS_RDONLY.

XFs was updated for this in mainline but the changes to xfs_ioctl.c
were never megred back into the CVS tree.

Mainline commit 42a74f206b914db13ee1f5ae932dcd91a77c8579

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>

Date:  Wed Oct 22 16:20:31 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  haveblue@us.ibm.com,hch

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32381a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.173 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.173&r2=text&tr2=1.172&f=h
	- use proper mnt_want_write calls for handle ioctl
