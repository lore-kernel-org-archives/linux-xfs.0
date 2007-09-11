Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Sep 2007 21:45:41 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8B4jZ4p016838
	for <xfs@oss.sgi.com>; Mon, 10 Sep 2007 21:45:37 -0700
Date: Tue, 11 Sep 2007 14:48:19 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709110448.l8B4mJ5o013478@redback.melbourne.sgi.com>
Subject: TAKE 970336 - cleanup fid types mess
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

cleanup fid types mess

Currently XFs has three different fid types: struct fid, struct xfs_fid
and struct xfs_fid2 with hte latter two beeing identicaly and the first
one beeing the same size but an unstructured array with the same size.

This patch consolidates all this to alway uuse struct xfs_fid.

This patch is required for an upcoming patch series from me that revamps
the nfs exporting code and introduces a Linux-wide struct fid.


Note: the patch is ontop of Eric's inode/vnode tracing cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Sep 11 14:45:10 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-fixes
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29651a
fs/xfs/xfs_vnodeops.c - 1.718 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.718&r2=text&tr2=1.717&f=h
	- cleanup fid types mess

fs/xfs/xfs_fs.h - 1.35 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fs.h.diff?r1=text&tr1=1.35&r2=text&tr2=1.34&f=h
	- cleanup fid types mess

fs/xfs/xfs_vfsops.c - 1.538 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.538&r2=text&tr2=1.537&f=h
	- cleanup fid types mess

fs/xfs/linux-2.6/xfs_ioctl.c - 1.153 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.153&r2=text&tr2=1.152&f=h
	- cleanup fid types mess

fs/xfs/linux-2.6/xfs_export.c - 1.17 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.c.diff?r1=text&tr1=1.17&r2=text&tr2=1.16&f=h
	- cleanup fid types mess

fs/xfs/linux-2.6/xfs_export.h - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_export.h.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- cleanup fid types mess

fs/xfs/dmapi/xfs_dm_fsops.c - 1.13 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm_fsops.c.diff?r1=text&tr1=1.13&r2=text&tr2=1.12&f=h
	- cleanup fid types mess

fs/xfs/dmapi/xfs_dm.c - 1.53 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.53&r2=text&tr2=1.52&f=h
	- cleanup fid types mess

fs/xfs/xfs_vnodeops.h - 1.2 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.h.diff?r1=text&tr1=1.2&r2=text&tr2=1.1&f=h
	- cleanup fid types mess

fs/xfs/xfs_vfsops.h - 1.3 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.h.diff?r1=text&tr1=1.3&r2=text&tr2=1.2&f=h
	- cleanup fid types mess
