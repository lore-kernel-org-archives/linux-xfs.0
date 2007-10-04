Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 23:27:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l946QvWJ022238
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 23:27:00 -0700
From: donaldd@sgi.com
Subject: PARTIAL TAKE 971186 - Refactor xfs_mountfs
Message-Id: <20071004062652.557B2307DB15@linuxbuild.melbourne.sgi.com>
Date: Thu,  4 Oct 2007 16:26:52 +1000 (EST)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Refactor xfs_mountfs

Refactoring xfs_mountfs() to call sub-functions for logical
chunks can help save a bit of stack, and can make it easier to
read this long function.

The mount path is one of the longest common callchains, easily
getting to within a few bytes of the end of a 4k stack when
over lvm, quotas are enabled, and quotacheck must be done.

With this change on top of the other stack-related changes
I've sent, I can get xfs to survive a normal xfsqa run on
4k stacks over lvm.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>


Date:  Thu Oct  4 16:26:05 AEST 2007
Workarea:  linuxbuild.melbourne.sgi.com:/home/donaldd/isms/2.6.x-xfs
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29834a
fs/xfs/xfs_mount.c - 1.415 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.415&r2=text&tr2=1.414&f=h
	- Refactor xfs_mountfs
