Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 18:04:31 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T14RqT003702
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 18:04:27 -0700
Subject: TAKE 981498 - sanitize xfs_initialize_vnode
Message-Id: <20080729010537.6142C58C4C3F@chook.melbourne.sgi.com>
Date: Tue, 29 Jul 2008 11:05:37 +1000 (EST)
From: xaiki@sgi.com (Niv Sardi-Altivanik)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

sanitize xfs_initialize_vnode

Sanitize setting up the Linux indode.

Setting up the xfs_inode <-> inode link is opencoded in xfs_iget_core
now because that's the only place it needs to be done,
xfs_initialize_vnode is renamed to xfs_setup_inode and loses all
superflous paramaters.  The check for I_NEW is removed because it always
is true and the di_mode check moves into xfs_iget_core because it's only
needed there.

xfs_set_inodeops and xfs_revalidate_inode are merged into
xfs_setup_inode and the whole things is moved into xfs_iops.c where it
belongs.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Jul 29 11:03:57 AEST 2008
Workarea:  itchy.melbourne.sgi.com:/i386/home/xaiki/Wrk/ptools/xfs-2.6
Inspected by:  hch,xaiki

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:31782a
fs/xfs/xfs_iget.c - 1.243 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_iget.c.diff?r1=text&tr1=1.243&r2=text&tr2=1.242&f=h
fs/xfs/xfs_inode.c - 1.514 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_inode.c.diff?r1=text&tr1=1.514&r2=text&tr2=1.513&f=h
fs/xfs/linux-2.6/xfs_super.h - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.h.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
fs/xfs/linux-2.6/xfs_super.c - 1.443 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.443&r2=text&tr2=1.442&f=h
fs/xfs/linux-2.6/xfs_iops.c - 1.296 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.c.diff?r1=text&tr1=1.296&r2=text&tr2=1.295&f=h
fs/xfs/linux-2.6/xfs_iops.h - 1.36 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_iops.h.diff?r1=text&tr1=1.36&r2=text&tr2=1.35&f=h
fs/xfs/linux-2.6/xfs_ksyms.c - 1.88 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.88&r2=text&tr2=1.87&f=h
