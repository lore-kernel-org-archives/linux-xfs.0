Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 23:14:02 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L7DtPA027219
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 23:13:58 -0800
Subject: PARTIAL TAKE 971186 - keep i_nlink updated and use proper accessors
Message-Id: <20080121071410.E5FCE58C4C10@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 18:14:10 +1100 (EST)
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

keep i_nlink updated and use proper accessors

To get the read-only bind mounts in -mm to work correctly with XFS we
need to call the drop_nlink and inc_nlink helpers to monitor the link
count.  Add calls to these to xfs_bumplink and xfs_droplink and stop
copying over di_nlink to i_nlink in xfs_validate_fields and vn_revalidate.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Date:  Mon Jan 21 18:13:29 AEDT 2008
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>
Author:  lachlan

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:30392a
fs/xfs/xfs_utils.c - 1.79 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_utils.c.diff?r1=text&tr1=1.79&r2=text&tr2=1.78&f=h
fs/xfs/linux-2.6/xfs_vnode.c - 1.155 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.155&r2=text&tr2=1.154&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.275 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.275&r2=text&tr2=1.274&f=h
	- keep i_nlink updated and use proper accessors
