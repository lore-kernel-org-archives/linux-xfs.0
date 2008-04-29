Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 21:09:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3T49YSs014042
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 21:09:38 -0700
Subject: PARTIAL TAKE 980021 - xfs noattr2 mount option doesn't work
Message-Id: <20080429041012.4FB1B58C4C15@chook.melbourne.sgi.com>
Date: Tue, 29 Apr 2008 14:10:12 +1000 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Fix up noattr2 so that it will properly update the versionnum and features2 fields.

Previously, mounting with noattr2 failed to achieve anything because
although it cleared the attr2 mount flag, it would set it again as soon as
it processed the superblock fields.
The fix now has an explicit noattr2 flag and uses it later to fix up the
versionnum and features2 fields.

Date:  Tue Apr 29 14:07:41 AEST 2008
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31003a
fs/xfs/xfs_sb.h - 1.73 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.73&r2=text&tr2=1.72&f=h
	- define xfs_sb_version_removeattr2

fs/xfs/xfs_vfsops.c - 1.563 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.563&r2=text&tr2=1.562&f=h
	- don't turn on attr2 from sb if we are mounted with noattr2.

fs/xfs/xfs_clnt.h - 1.58 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_clnt.h.diff?r1=text&tr1=1.58&r2=text&tr2=1.57&f=h
	- Define XFSMNT_NOATTR2.

fs/xfs/xfs_mount.h - 1.265 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.265&r2=text&tr2=1.264&f=h
	- define XFS_MOUNT_NOATTR2

fs/xfs/xfs_mount.c - 1.430 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.430&r2=text&tr2=1.429&f=h
	- If we have attr2 in sb and have mounted with XFS_MOUNT_NOATTR2 then
	  remove attr2 from sb.

fs/xfs/linux-2.6/xfs_super.c - 1.415 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.415&r2=text&tr2=1.414&f=h
	- Add in flag XFSMNT_NOATTR2.
