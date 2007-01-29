Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Jan 2007 05:50:15 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0TDo7qw007883
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 05:50:08 -0800
Received: from lab41.emea.sgi.com (lab41.emea.sgi.com [144.253.75.41])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id l0TDOWDW019749
	for <xfs@oss.sgi.com>; Mon, 29 Jan 2007 07:24:33 -0600
Subject: TAKE 957348 - Re-initialize the per-cpu superblock counters after recovery.
Message-Id: <20070129134125.3CC0557B6F@lab41.emea.sgi.com>
Date: Mon, 29 Jan 2007 13:41:25 +0000 (GMT)
From: lachlan@lab41.emea.sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Re-initialize the per-cpu superblock counters after recovery.

After filesystem recovery the superblock is re-read to bring in
any changes.  If the per-cpu superblock counters are not re-initialized
from the superblock then the next time the per-cpu counters are
disabled they might overwrite the global counter with a bogus value.

Date:  Tue Jan 30 00:18:02 AEDT 2007
Workarea:  vpn-emea-sw-emea-160-31.emea.sgi.com:/home/lachlan/isms/2.6.x-xfs
Inspected by:  dgc
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27999a
fs/xfs/xfs_log_recover.c - 1.315 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.315&r2=text&tr2=1.314&f=h
fs/xfs/xfs_mount.h - 1.234 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.234&r2=text&tr2=1.233&f=h
fs/xfs/xfs_mount.c - 1.392 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.392&r2=text&tr2=1.391&f=h
	- Re-initialize the per-cpu superblock counters after recovery.
