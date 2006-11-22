Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Dec 2006 16:47:00 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB70kmaG023128
	for <xfs@oss.sgi.com>; Wed, 6 Dec 2006 16:46:51 -0800
Subject: TAKE 958469 - Quiet mounts on XFS aren't
Message-Id: <20061122070118.9C5FB58CF865@chook.melbourne.sgi.com>
Date: Wed, 22 Nov 2006 18:01:18 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Make quiet mounts quiet

The XFS quiet mount logic was inverted making quiet
mounts noisy and vice versa. Fix it.

Date:  Wed Nov 22 18:00:45 AEDT 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net,tes@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27520a
fs/xfs/xfs_error.h - 1.46 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_error.h.diff?r1=text&tr1=1.46&r2=text&tr2=1.45&f=h
	- Fix xfs_fs_mount_cmn_err() quiet flag logic inversion.
