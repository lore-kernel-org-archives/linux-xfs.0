Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 23:07:43 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L77Xwx026071
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 23:07:37 -0800
Subject: PARTIAL TAKE 971186 - stop updating inode->i_blocks
Message-Id: <20080121070746.E4F9558C4C10@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 18:07:46 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

stop updating inode->i_blocks

The VFS doesn't use i_blocks, it's only used by generic_fillattr and
the generic quota code which XFS doesn't use.  In XFS there is one use
to check whether we have an inline or out of line sumlink, but we can
replace that with a check of the XFS_IFINLINE inode flag.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Jan 21 18:07:03 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30391a
fs/xfs/xfs_vnodeops.c - 1.730 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.730&r2=text&tr2=1.729&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.406 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.406&r2=text&tr2=1.405&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.274 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.274&r2=text&tr2=1.273&f=h
fs/xfs/dmapi/xfs_dm.c - 1.63 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.63&r2=text&tr2=1.62&f=h
	- stop updating inode->i_blocks
