Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 05:03:26 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NC3K4p020901
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 05:03:23 -0700
Subject: PARTIAL TAKE 968563 - superblock endianess annotations
Message-Id: <20070823120316.6FDBD58C38F1@chook.melbourne.sgi.com>
Date: Thu, 23 Aug 2007 22:03:16 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

superblock endianess annotations

Creates a new xfs_dsb_t that is __be annotated and keeps xfs_sb_t for
the incore one.  xfs_xlatesb is renamed to xfs_sb_to_disk and only
handles the incore -> disk conversion.  A new helper xfs_sb_from_disk
handles the other direction and doesn't need the slightly hacky
table-driven approach because we only ever read the full sb from disk.

The handling of shared r/o filesystems has been buggy on little endian
system and fixing this required shuffling around of some code in that
area.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Thu Aug 23 22:02:37 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29477a
fs/xfs/xfsidbg.c - 1.322 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfsidbg.c.diff?r1=text&tr1=1.322&r2=text&tr2=1.321&f=h
	- Add superblock endian notations.

fs/xfs/xfs_sb.h - 1.69 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_sb.h.diff?r1=text&tr1=1.69&r2=text&tr2=1.68&f=h
	- Add superblock endian notations.

fs/xfs/xfs_log_recover.c - 1.322 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.322&r2=text&tr2=1.321&f=h
	- Add superblock endian notations.

fs/xfs/xfs_mount.h - 1.239 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.239&r2=text&tr2=1.238&f=h
	- Add superblock endian notations.

fs/xfs/xfs_mount.c - 1.402 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.402&r2=text&tr2=1.401&f=h
	- Add superblock endian notations.

fs/xfs/xfs_trans.c - 1.182 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.182&r2=text&tr2=1.181&f=h
	- Add superblock endian notations.

fs/xfs/xfs_fsops.c - 1.128 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.128&r2=text&tr2=1.127&f=h
	- Add superblock endian notations.

fs/xfs/linux-2.6/xfs_ksyms.c - 1.62 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.62&r2=text&tr2=1.61&f=h
	- Add superblock endian notations.
