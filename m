Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 20:55:09 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0A4t0qw030229
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 20:55:02 -0800
Subject: TAKE 959978 - growing an XFS filesystem by more than 2TB is broken
Message-Id: <20070110045401.3041E58CF82A@chook.melbourne.sgi.com>
Date: Wed, 10 Jan 2007 15:54:01 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

Make growfs work for amounts greater than 2TB

The free block modification code has a 32bit interface, limiting
the size the filesystem can be grown even on 64 bit machines.
On 32 bit machines, there are other 32bit variables in transaction
structures and interfaces that need to be expanded to allow this
to work.

Date:  Wed Jan 10 15:53:25 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  hch@infradead.org

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:27894a
fs/xfs/xfs_mount.h - 1.231 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.231&r2=text&tr2=1.230&f=h
	- Update xfs_mod_sb_t to 64bit deltas.

fs/xfs/xfs_mount.c - 1.390 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.390&r2=text&tr2=1.389&f=h
	- Modify the core superblock modification code to handle 64 bit
	  deltas so as to allow single modifications of greater than 2TB.

fs/xfs/xfs_trans.c - 1.177 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.c.diff?r1=text&tr1=1.177&r2=text&tr2=1.176&f=h
	- Superblock modification deltas changed to 64 bit types to allow
	  single modifications of greater than 32 bits on 32 bit platforms.

fs/xfs/xfs_trans.h - 1.143 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans.h.diff?r1=text&tr1=1.143&r2=text&tr2=1.142&f=h
	- Transaction deltas converted to explicit 64bit types.

fs/xfs/xfs_bmap.c - 1.361 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_bmap.c.diff?r1=text&tr1=1.361&r2=text&tr2=1.360&f=h
	- Change free block modifications to use 64 bit type casts.
