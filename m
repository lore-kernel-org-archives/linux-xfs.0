Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Nov 2007 19:30:42 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAU3UVgh030367
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2007 19:30:35 -0800
Subject: PARTIAL TAKE 971186 - remove CFORK macros
Message-Id: <20071130033035.AFC5C58C4C0F@chook.melbourne.sgi.com>
Date: Fri, 30 Nov 2007 14:30:35 +1100 (EST)
From: tes@sgi.com (Tim Shimmin)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Remove CFORK macros and use code directly in IFORK and DFORK macros.

Currently XFS_IFORK_* and XFS_DFORK* are implemented by means of
XFS_CFORK* macros.  But given that XFS_IFORK_* operates on an
xfs_inode that embedds and xfs_icdinode_core and XFS_DFORK_* operates
on an xfs_dinode that embedds a xfs_dinode_core one will have to do
endian swapping while the other doesn't.  Instead of having the current
mess with the CFORK macros that have byteswapping and non-byteswapping
version (which are inconsistantly named while we're at it) just define
each family of the macros to stand by itself and simplify the whole
matter.

A few direct references to the CFORK variants were cleaned up to
use IFORK or DFORK to make this possible.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Fri Nov 30 14:28:54 AEDT 2007
Workarea:  chook.melbourne.sgi.com:/build/tes/2.6.x-xfs-quilt
Inspected by:  hch@lst.de

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb

Modid:  xfs-linux-melb:xfs-kern:30163a
fs/xfs/xfs_itable.c - 1.160 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_itable.c.diff?r1=text&tr1=1.160&r2=text&tr2=1.159&f=h
fs/xfs/xfs_inode.c - 1.488 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.488&r2=text&tr2=1.487&f=h
fs/xfs/xfs_inode.h - 1.239 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.h.diff?r1=text&tr1=1.239&r2=text&tr2=1.238&f=h
fs/xfs/xfs_dinode.h - 1.84 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dinode.h.diff?r1=text&tr1=1.84&r2=text&tr2=1.83&f=h
fs/xfs/dmapi/xfs_dm.c - 1.60 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.60&r2=text&tr2=1.59&f=h
	- Remove CFORK macros and use code directly in IFORK and DFORK macros.
