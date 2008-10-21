Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 20 Oct 2008 23:31:19 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9L6VGbP008931
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 23:31:16 -0700
Subject: TAKE 987246 - kill struct xfs_mount_args
Message-Id: <20081021063256.BE0FA1EDD8C@chapter11.melbourne.sgi.com>
Date: Tue, 21 Oct 2008 17:32:56 +1100 (EST)
From: donaldd@sgi.com (Donald Douwsma)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, sgi.bugs.xfs@engr.sgi.com

No need to parse the mount option into a structure before applying it
to struct xfs_mount.

The content of xfs_start_flags gets merged into xfs_parseargs.  Calls
inbetween don't care and can use mount members instead of the args
struct.

This patch uncovered that the mount option for shared filesystems wasn't
ever exposed on Linux.  The code to handle it is #if 0'ed in this patch
pending a decision on this feature.  I'll send a writeup about it to
the list soon.


Signed-off-by: Christoph Hellwig <hch@lst.de>


Date:  Tue Oct 21 17:32:14 EST 2008
Workarea:  chapter11.melbourne.sgi.com:/scratch/donaldd/isms/2.6.x-xfs
Inspected by:  hch,david@fromorbit.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:32371a
fs/xfs/xfs_vfsops.c - 1.581 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.581&r2=text&tr2=1.580&f=h
	- kill struct xfs_mount_args 

fs/xfs/xfs_clnt.h - 1.61 - deleted
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_clnt.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- kill struct xfs_mount_args 

fs/xfs/xfs_mount.h - 1.284 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.h.diff?r1=text&tr1=1.284&r2=text&tr2=1.283&f=h
	- kill struct xfs_mount_args 

fs/xfs/xfs_qmops.c - 1.19 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_qmops.c.diff?r1=text&tr1=1.19&r2=text&tr2=1.18&f=h
	- kill struct xfs_mount_args 

fs/xfs/xfs_dmops.c - 1.14 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_dmops.c.diff?r1=text&tr1=1.14&r2=text&tr2=1.13&f=h
	- kill struct xfs_mount_args 

fs/xfs/quota/xfs_qm_bhv.c - 1.30 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm_bhv.c.diff?r1=text&tr1=1.30&r2=text&tr2=1.29&f=h
	- kill struct xfs_mount_args 

fs/xfs/quota/xfs_qm.c - 1.77 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/quota/xfs_qm.c.diff?r1=text&tr1=1.77&r2=text&tr2=1.76&f=h
	- kill struct xfs_mount_args 

fs/xfs/linux-2.6/xfs_super.c - 1.464 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_super.c.diff?r1=text&tr1=1.464&r2=text&tr2=1.463&f=h
	- kill struct xfs_mount_args 

fs/xfs/linux-2.6/xfs_ksyms.c - 1.95 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/linux-2.6/xfs_ksyms.c.diff?r1=text&tr1=1.95&r2=text&tr2=1.94&f=h
	- kill struct xfs_mount_args 

fs/xfs/dmapi/xfs_dm.c - 1.80 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/dmapi/xfs_dm.c.diff?r1=text&tr1=1.80&r2=text&tr2=1.79&f=h
	- kill struct xfs_mount_args 
