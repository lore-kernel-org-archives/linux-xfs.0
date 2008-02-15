Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 23:16:15 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1F7G3rG008454
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 23:16:09 -0800
Subject: PARTIAL TAKE 970925 - Don't block pdflush when writing back inodes
Message-Id: <20080215071624.5616558C4C11@chook.melbourne.sgi.com>
Date: Fri, 15 Feb 2008 18:16:24 +1100 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Don't block pdflush when writing back inodes

When pdflush is writing back inodes, it can get stuck on inode cluster
buffers that are currently under I/O. This occurs when we write data to
multiple inodes in the same inode cluster at the same time.

Effectively, delayed allocation marks the inode dirty during the data
writeback. Hence if the inode cluster was flushed during the writeback
of the first inode, the writeback of the second inode will block waiting
for the inode cluster write to complete before writing it again for the
newly dirtied inode.

Basically, we want to avoid this from happening so we don't block
pdflush and slow down all of writeback. Hence we introduce a
non-blocking async inode flush flag that pdflush uses. If this flag is
set, we use non-blocking operations (e.g. try locks) whereever we can
to avoid blocking or extra I/O being issued.


Date:  Fri Feb 15 18:15:54 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs
Inspected by:  lachlan@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30501a
fs/xfs/xfs_vnodeops.c - 1.734 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.734&r2=text&tr2=1.733&f=h
	- make xfs_inode_flush() specify non-blocking inode flushes
	  and kill dead FLUSH_LOG code.

fs/xfs/xfs_itable.c - 1.161 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.161&r2=text&tr2=1.160&f=h
	- Added new buffer flag parameter to xfs_itobp().

fs/xfs/xfs_log_recover.c - 1.334 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_log_recover.c.diff?r1=text&tr1=1.334&r2=text&tr2=1.333&f=h
	- Added new buffer flag parameter to xfs_itobp().

fs/xfs/xfs_inode.c - 1.492 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.492&r2=text&tr2=1.491&f=h
	- introduce new non-blocking inode flush options into the writeout
	  code. If we specify a non-blocking flush, try as hard as possible
	  not to get stuck anywhere and return EAGAIN instead.

fs/xfs/xfs_inode.h - 1.242 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.242&r2=text&tr2=1.241&f=h
	- Added new buffer flag parameter to xfs_itobp().

fs/xfs/xfs_trans_buf.c - 1.129 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_trans_buf.c.diff?r1=text&tr1=1.129&r2=text&tr2=1.128&f=h
	- Added trylock support to xfs_trans_read_buf() for non-blocking
	  access to buffers.

fs/xfs/linux-2.6/xfs_vnode.h - 1.144 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.144&r2=text&tr2=1.143&f=h
	- FLUSH_INODE flag is no longer needed when calling xfs_inode_flush().
	  FLUSH_LOG flag is no longer used.

fs/xfs/linux-2.6/xfs_super.c - 1.409 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.409&r2=text&tr2=1.408&f=h
	- FLUSH_INODE flag is no longer needed when calling xfs_inode_flush().
