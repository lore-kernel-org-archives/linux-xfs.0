Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:32:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3WkK4027004
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:32:48 -0700
Subject: PARTIAL TAKE 976035 - fix non-smp xfs build
Message-Id: <20080428033323.0403858C4C15@chook.melbourne.sgi.com>
Date: Mon, 28 Apr 2008 13:33:22 +1000 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

fix non-smp xfs build

xfs_reserve_blocks() calls xfs_icsb_sync_counters_locked(),
which is not defined if !CONFIG_SMP/!HAVE_PERCPU_SB

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Date:  Mon Apr 28 13:32:33 AEST 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-clean
Inspected by:  sandeen@sandeen.net
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30991a
fs/xfs/xfs_mount.h - 1.264 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.264&r2=text&tr2=1.263&f=h
	- fix non-smp xfs build
