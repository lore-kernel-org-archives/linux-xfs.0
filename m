Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 09:28:19 -0700 (PDT)
Received: from redback.melbourne.sgi.com (redback.melbourne.sgi.com [134.14.55.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JGSCuw012194
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 09:28:15 -0700
Date: Wed, 19 Sep 2007 12:27:54 +1000
From: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Message-Id: <200709190227.l8J2Rss2003570@redback.melbourne.sgi.com>
Subject: TAKE 970705 - simplify vn_revalidate
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

simplify vn_revalidate

No need to allocate a bhv_vattr_t on stack and call xfs_getattr to
update a few fields in the Linux inode from the XFS inode, just
do it directly.

And yes, this function is in dire need of a better name and prototype,
I'll do in a separate patch, though.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Wed Sep 19 12:24:22 AEST 2007
Workarea:  redback.melbourne.sgi.com:/home/lachlan/isms/2.6.x-hch
Inspected by:  Christoph Hellwig <hch@lst.de>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:29713a
fs/xfs/linux-2.6/xfs_ioctl.c - 1.154 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ioctl.c.diff?r1=text&tr1=1.154&r2=text&tr2=1.153&f=h
	- simplify vn_revalidate

fs/xfs/linux-2.6/xfs_vnode.c - 1.152 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.c.diff?r1=text&tr1=1.152&r2=text&tr2=1.151&f=h
	- simplify vn_revalidate

fs/xfs/linux-2.6/xfs_vnode.h - 1.142 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_vnode.h.diff?r1=text&tr1=1.142&r2=text&tr2=1.141&f=h
	- simplify vn_revalidate

fs/xfs/linux-2.6/xfs_iops.c - 1.264 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.264&r2=text&tr2=1.263&f=h
	- simplify vn_revalidate

fs/xfs/linux-2.6/xfs_ksyms.c - 1.72 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.72&r2=text&tr2=1.71&f=h
	- simplify vn_revalidate
